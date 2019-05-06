//
//  BMAddressPickerView.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/3/29.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMAddressPickerView.h"
#import "BMAddressModel.h"
#import "BMSingleLineView.h"
#import "BMAddressChooseView.h"
#import "BMAddressTableCell.h"
#import "MBProgressHUD.h"

#import "BMApiStatusView.h"

enum EWLocationPickViewTableViewType: NSUInteger {
    provinces, ///省份
    city,      ///城市
    area,      ///地区
};

@interface BMAddressPickerView ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    BMApiStatusViewDelegate
>
{
    NSArray *hotCityArray;
}

@property (nonatomic, strong) MBProgressHUD *progressHUD;

// 数据

// 省份
@property (nonatomic, strong) NSMutableArray *provinceArray;
//@property (nonatomic, strong) BMProvinceAddressModel *provinceModel;
// 城市
//@property (nonatomic, strong) BMCityAddressModel *cityModel;
// 地区
//@property (nonatomic, strong) BMAddressModel *locationModel;

// 已选地址
@property (nonatomic, strong) BMChooseAddressModel *chooseAddress;
@property (nonatomic, assign) NSUInteger currentLevel;

// UI

// title
@property (nonatomic, strong) UIView *titleBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) BMSingleLineView *titleUnderLine;

// 热门城市
@property (nonatomic, strong) UIView *hotBgView;
@property (nonatomic, strong) UILabel *hotTitleLabel;
@property (nonatomic, strong) NSMutableArray *hotBtnArray;

// 已选城市地区
@property (nonatomic, strong) BMAddressChooseView *addressChooseView;
// 城市地区列表
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSMutableArray *tableViews;

// 错误遮盖页面
//@property (nonatomic, strong) UIView *statusBgView;
@property (nonatomic, strong) BMApiStatusView *apiStatusView;
@property (nonatomic, assign) NSUInteger apiLevel;

@end

@implementation BMAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
        [self makeView];
    }
    
    return self;
}

- (void)initialize
{
    hotCityArray = @[@"北京", @"上海", @"广州", @"深圳", @"杭州", @"南京", @"苏州", @"天津", @"武汉", @"长沙", @"重庆", @"成都"];
    
    self.tableViews = [NSMutableArray arrayWithCapacity:3];
    
    self.chooseAddress = [[BMChooseAddressModel alloc] init];
    
    self.currentLevel = 0;
}

- (void)makeView
{
    self.backgroundColor = [UIColor whiteColor];
    
    // MBProgressHUD显示等待框
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self];
    self.progressHUD.animationType = MBProgressHUDAnimationFade;
    [self addSubview:self.progressHUD];

    // 标题
    self.titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 44.0f)];
    [self addSubview:self.titleBgView];
    self.titleBgView.backgroundColor = [UIColor whiteColor];
    self.titleBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0, self.bm_width-15.0f, 44.0f)];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.titleLabel.text = @"城市地区";
    [self.titleBgView addSubview:self.titleLabel];
    
    self.closeBtn = [UIButton bm_buttonWithFrame:CGRectMake(self.bm_width-50.0f, 2.0f, 40.0f, 40.0f) imageName:@"navigationbar_close_icon"];
    self.closeBtn.bm_imageRect = CGRectMake(5.0f, 5.0f, 30.0f, 30.0f);
    [self.closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBgView addSubview:self.closeBtn];
    
    // 已选地址
    self.addressChooseView = [[BMAddressChooseView alloc] initWithFrame:CGRectMake(0, self.titleBgView.bm_height, self.bm_width, 40.0f)];
    [self addSubview:self.addressChooseView];
    
    BMWeakSelf
    self.addressChooseView.addressClicked = ^(BMChooseAddressModel * _Nonnull chooseAddress, NSUInteger level) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.currentLevel = level;
            weakSelf.contentView.contentOffset = CGPointMake(UI_SCREEN_WIDTH*level, 0);
        }];
    };
    
    // 待选地址列表
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.addressChooseView.bm_bottom, self.bm_width, self.bm_height - self.addressChooseView.bm_bottom)];
    contentView.pagingEnabled = YES;
    contentView.bounces = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    BMApiStatusView *apiStatusView = [[BMApiStatusView alloc] initWithView:self.contentView delegate:self];
    self.apiStatusView = apiStatusView;
}

- (void)freshView
{
    self.apiLevel = 1;
    if (self.getList)
    {
        self.getList(1, @"0");
    }
}

- (void)close:(UIButton *)btn
{
    if (self.backOnClickClose)
    {
        self.backOnClickClose();
    }
}

- (NSUInteger)getMaxLevel
{
    NSUInteger maxLevel = 1;
    
    if ([self.chooseAddress.province.name bm_isNotEmpty])
    {
        maxLevel = 2;
        if ([self.chooseAddress.city.name bm_isNotEmpty])
        {
            maxLevel = 3;
        }
    }

    return maxLevel;
}

- (void)addTableView
{
    UITableView *tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, self.contentView.bm_height)];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    
    [tabbleView registerNib:[UINib nibWithNibName:@"BMAddressTableCell" bundle:nil] forCellReuseIdentifier:@"BMAddressTableCell"];

    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    //tabbleView.backgroundColor = [UIColor bm_randomColor];
    
    [self.contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];

    self.contentView.contentSize = (CGSize){self.tableViews.count * UI_SCREEN_WIDTH, 0};
    
    [self.progressHUD bm_bringToFront];
}

- (void)changeProvinceArray:(NSMutableArray *)provinceArray
{
    self.provinceArray = provinceArray;
}

- (void)setProvinceArray:(NSMutableArray *)provinceArray
{
    _provinceArray = provinceArray;
    
    [self.contentView bm_removeAllSubviewsWithClass:[UITableView class]];
    [self.tableViews removeAllObjects];
    
    [self addTableView];
    
    self.currentLevel = 0;
    [self.addressChooseView setChooseAddress:self.chooseAddress level:self.currentLevel];
    
    UITableView *taleView = self.tableViews[0];
    [taleView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)changeCityArray:(NSMutableArray *)cityArray
{
    self.chooseAddress.province.cityArray = cityArray;
    
    NSUInteger maxLevel = [self getMaxLevel];
    if (maxLevel > self.tableViews.count)
    {
        [self addTableView];
    }
    
    self.currentLevel = 1;
    [self.addressChooseView setChooseAddress:self.chooseAddress level:self.currentLevel];
    
    UITableView *taleView = self.tableViews[1];
    [taleView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointMake(UI_SCREEN_WIDTH, 0);
    }];
}

- (void)changeAreaArray:(NSMutableArray *)areaArray
{
    self.chooseAddress.city.areaArray = areaArray;
    
    NSUInteger maxLevel = [self getMaxLevel];
    if (maxLevel > self.tableViews.count)
    {
        [self addTableView];
    }
    
    self.currentLevel = 2;
    [self.addressChooseView setChooseAddress:self.chooseAddress level:self.currentLevel];
    
    UITableView *taleView = self.tableViews[2];
    [taleView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointMake(UI_SCREEN_WIDTH*2, 0);
    }];
}

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.contentView)
    {
        return;
    }
    
    NSUInteger level = scrollView.contentOffset.x / UI_SCREEN_WIDTH;
    
    [self.addressChooseView setChooseAddress:self.chooseAddress level:level];
    self.currentLevel = level;
}


#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.tableViews indexOfObject:tableView] == 0)
    {
        return self.provinceArray.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        return self.chooseAddress.province.cityArray.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        return self.chooseAddress.city.areaArray.count;
    }
    
    return self.provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMAddressTableCell" forIndexPath:indexPath];
    
    BMAddressModel *item;
    // 省级别
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        item = self.provinceArray[indexPath.row];
    }
    // 市级别
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        item = self.chooseAddress.province.cityArray[indexPath.row];
    }
    // 县级别
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        item = self.chooseAddress.city.areaArray[indexPath.row];
    }
    
    [cell drawCellWithModel:item];
    
    return cell;
}


#pragma mark - TableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 省级别
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        BMProvinceAddressModel *provinceItem = self.provinceArray[indexPath.row];
        
        if (self.chooseAddress.province == provinceItem)
        {
            return indexPath;
        }
        
        if (self.tableViews.count == 3)
        {
            self.chooseAddress.area = nil;

            UITableView *tableView = self.tableViews.lastObject;
            [tableView removeFromSuperview];
            [self.tableViews removeObject:tableView];
        }

        if (self.tableViews.count == 2)
        {
            self.chooseAddress.city = nil;
            
            UITableView *tableView = self.tableViews.lastObject;
            [tableView removeFromSuperview];
            [self.tableViews removeObject:tableView];
        }

        self.contentView.contentSize = (CGSize){self.tableViews.count * UI_SCREEN_WIDTH, 0};
        self.chooseAddress.province = provinceItem;
        
        self.apiLevel = 2;
        if (self.getList)
        {
            self.getList(2, provinceItem.code);
        }
    }
    // 市级别
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        BMCityAddressModel *cityItem = (BMCityAddressModel *)self.chooseAddress.province.cityArray[indexPath.row];
        
        if (self.chooseAddress.city == cityItem)
        {
            return indexPath;
        }
        
        self.chooseAddress.area = nil;
        self.chooseAddress.city = cityItem;
        
        if (self.getList)
        {
            self.apiLevel = 3;
            self.getList(3, cityItem.code);
        }
    }
    // 县级别
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        BMAddressModel *areaItem = self.chooseAddress.city.areaArray[indexPath.row];
        self.chooseAddress.area = areaItem;
        
        self.currentLevel = 2;
        [self.addressChooseView setChooseAddress:self.chooseAddress level:self.currentLevel];
        
        if (self.pickFinished)
        {
            NSString *addressString;
            if ([self.chooseAddress.city.name isEqualToString:@"市辖区"])
            {
                addressString = [NSString stringWithFormat:@"%@%@", self.chooseAddress.province.name, self.chooseAddress.area.name];
            }
            else
            {
                addressString = [NSString stringWithFormat:@"%@%@%@", self.chooseAddress.province.name, self.chooseAddress.city.name, self.chooseAddress.area.name];
            }
            self.pickFinished(self.chooseAddress, addressString);
        }
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMAddressModel *item;
    // 省级别
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        item = self.provinceArray[indexPath.row];
    }
    // 市级别
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        item = self.chooseAddress.province.cityArray[indexPath.row];
    }
    // 县级别
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        item = self.chooseAddress.city.areaArray[indexPath.row];
    }
    
    item.isSelected = YES;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMAddressModel *item;
    // 省级别
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        item = self.provinceArray[indexPath.row];
    }
    // 市级别
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        item = self.chooseAddress.province.cityArray[indexPath.row];
    }
    // 县级别
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        item = self.chooseAddress.city.areaArray[indexPath.row];
    }
    
    item.isSelected = NO;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showHUDWithAnimated:(BOOL)animated
{
    [self.progressHUD showAnimated:animated showBackground:NO];
}

- (void)hideHUDWithAnimated:(BOOL)animated
{
    [self.progressHUD hideAnimated:animated];
}

- (void)showHUDWithAnimated:(BOOL)animated detailText:(NSString *)text
{
    [self.progressHUD showAnimated:animated withDetailText:text delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

- (void)hideStatusView
{
    [self.apiStatusView hide];
}

- (void)showNetworkError
{
    [self.apiStatusView showWithStatus:BMApiStatus_NetworkError];
    self.apiStatusView.bm_left = UI_SCREEN_WIDTH*self.currentLevel;
}

- (void)showServerError
{
    [self.apiStatusView showWithStatus:BMApiStatus_ServerError];
    self.apiStatusView.bm_left = UI_SCREEN_WIDTH*self.currentLevel;
}

- (void)showUnknownError
{
    [self.apiStatusView showWithStatus:BMApiStatus_UnknownError];
    self.apiStatusView.bm_left = UI_SCREEN_WIDTH*self.currentLevel;
}

- (void)showNoData
{
    [self.apiStatusView showWithStatus:BMApiStatus_NoData];
    self.apiStatusView.bm_left = UI_SCREEN_WIDTH*self.currentLevel;
}


#pragma mark - BMApiStatusViewDelegate

- (void)apiStatusViewDidTap:(BMApiStatusView *)statusView
{
    if (self.getList)
    {
        switch (self.apiLevel)
        {
            case 1:
                self.getList(1, @"0");
                break;

            case 2:
                self.getList(2, self.chooseAddress.province.code);
                break;

            case 3:
                self.getList(3, self.chooseAddress.city.code);
                break;

            default:
                self.getList(1, @"0");
                break;
        }
    }
}

@end
