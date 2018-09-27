//
//  FSTextSplitVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/11.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextSplitVC.h"
#import "FSTextCell.h"
#import "FSTextTypeCell.h"

#define LEFT_HEADER_HEIGHT 18.0f
#define LEFT_CELL_HEIGHT 50.0f

typedef void (^FSSelectedTextType)(NSInteger typeIndex);

@interface FSTextSplitTypeListManager : NSObject
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic, copy) FSSelectedTextType            selectedType;
@property (nonatomic, strong) NSArray<FSTextTypeModel *> *m_typeArray;

@end

@implementation FSTextSplitTypeListManager

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_typeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTextTypeCell * cell     = [tableView dequeueReusableCellWithIdentifier:@"FSTextTypeCell"];
    FSTextTypeModel *model    = _m_typeArray[indexPath.row];
    cell.m_typeNameLabel.text = model.m_typeName;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedType) {
        _selectedType(indexPath.row);
    }
}
@end

@interface
FSTextSplitVC ()

@property (nonatomic, strong) FSTableView *               m_textTypeListView;
@property (nonatomic, strong) FSTextSplitTypeListManager *m_typeListManager;
@property (nonatomic, strong) NSArray<FSTextTypeModel *> *m_typeArray;
@property (nonatomic, strong) FSTextTypeModel            *m_selectedType;
@end

@implementation FSTextSplitVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_typeListManager = [[FSTextSplitTypeListManager alloc]init];
    [self setupUI];
    [self setupListView];
    [self loadIndexPageData];
    
}
- (void)setupUI
{
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    self.bm_NavigationShadowHidden  = NO;
    self.bm_NavigationShadowColor   = UI_COLOR_B6;

    [self bm_setNavigationWithTitle:@"文书范本" barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"" rightItemImage:@"search_icon" rightToucheEvent:@selector(searchAction:)];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}
- (void)setupListView
{
    CGFloat leftWidth      = 90.0f;
    CGFloat scaleWidth     = leftWidth / 375 * self.view.bm_width;
    CGFloat realLeftWidth  = (scaleWidth >= leftWidth) ? scaleWidth : leftWidth;
    self.m_TableView.frame = CGRectMake(realLeftWidth, 0, self.view.bm_width - realLeftWidth, self.view.bm_height);

    self.m_TableView.backgroundColor              = [UIColor whiteColor];
    self.m_TableView.tableFooterView              = [UIView new];
    self.m_TableView.rowHeight           = 62;
    self.m_TableView.showsVerticalScrollIndicator = NO;
    self.m_TableView.bm_showEmptyView             = NO;

    self.m_TableView.separatorStyle     = UITableViewCellSeparatorStyleSingleLine;
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSTextCell" bundle:nil] forCellReuseIdentifier:@"FSTextCell"];

    self.m_textTypeListView              = [[FSTableView alloc] initWithFrame:CGRectMake(0, 0, realLeftWidth, self.view.bm_height) style:UITableViewStylePlain freshViewType:BMFreshViewType_NONE];
    [_m_textTypeListView registerNib:[UINib nibWithNibName:@"FSTextTypeCell" bundle:nil] forCellReuseIdentifier:@"FSTextTypeCell"];

    _m_textTypeListView.backgroundColor  = UI_COLOR_G2;
    [self.view addSubview:_m_textTypeListView];
    _m_textTypeListView.delegate   = _m_typeListManager;
    _m_textTypeListView.dataSource = _m_typeListManager;
    
    _m_textTypeListView.tableFooterView = [UIView new];
    _m_textTypeListView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, realLeftWidth, LEFT_HEADER_HEIGHT)];
    _m_textTypeListView.rowHeight       = LEFT_CELL_HEIGHT;
    BMWeakSelf
        _m_typeListManager.selectedType = ^(NSInteger typeIndex) {
            // 左边栏点击事件
            [weakSelf selectedTextTypeAtIndex:typeIndex];
    };
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchAction:(id)sender
{
    [FSPushVCManager pushToTextSearchVC:self];
}
#pragma mark - tableView
- (void)selectedTextTypeAtIndex:(NSInteger)index
{
    self.m_selectedType = _m_typeArray[index];
    if ([_m_selectedType.m_textList bm_isNotEmpty]) {
        [self.m_TableView reloadData];
    }
    else
    {
        [self loadApiData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_selectedType.m_textList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTextCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"FSTextCell"];
    FSListTextModel *model = _m_selectedType.m_textList[indexPath.row];
    [cell setTextModel:model colors:nil];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FSListTextModel *model = _m_selectedType.m_textList[indexPath.row];
    [FSPushVCManager pushToTextDetail:self url:model.m_previewUrl withFileId:model.m_fileId title:model.m_title];
}

#pragma mark - NetWorking

- (void)loadIndexPageData
{
    
    [FSApiRequest loadTextIndexPageDataSuccess:^(id _Nullable responseObject){
        NSDictionary *              data      = responseObject;
        NSArray *                   typeArray = [FSTextTypeModel modelsWithDataArray:[data bm_arrayForKey:@"documentHomeLeftMenuList"]];

        self.m_typeArray               = typeArray;
        _m_typeListManager.m_typeArray = typeArray;

        _m_textTypeListView.scrollEnabled = _m_typeArray.count * LEFT_CELL_HEIGHT +LEFT_HEADER_HEIGHT >= self.view.bm_height;
        [_m_textTypeListView reloadData];

        // 定位初始textList的Type
        if ([typeArray bm_isNotEmpty]) {
            [_m_textTypeListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self selectedTextTypeAtIndex:0];
        }

    }
    failure:^(NSError *_Nullable error){

    }];
}
- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest loadTextListWithTypeCode:_m_selectedType.m_typeCode];
}
- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *textList = [FSListTextModel modelsWithDataArray:[requestDic bm_arrayForKey:@"documentList"]];
    _m_selectedType.m_textList = textList;
    [self.m_TableView reloadData];
    return [super succeedLoadedRequestWithDic:requestDic];
}
@end




