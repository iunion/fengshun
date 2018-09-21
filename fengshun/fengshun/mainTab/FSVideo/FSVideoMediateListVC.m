//
//  FSVideoMediateListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateListVC.h"
#import "FSHeaderCommonSelector.h"
#import "FSVideoMediateListCell.h"
#import "FSMakeVideoMediateVC.h"
#import "FSVideoMediateDetailVC.h"
#import "FSMeetingDataEnum.h"

@interface FSVideoMediateListVC ()
{
    BOOL loginAndCreate;
}

@property (nonatomic, strong) NSString *meetingTypeEnums;
@property (nonatomic, strong) NSString *meetingStatusEnums;
@property (nonatomic, strong) FSHeaderCommonSelectorView *headSelector;
@property (nonatomic, strong) UIView *BottomBgView;
@end

@implementation FSVideoMediateListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_LoadDataType = FSAPILoadDataType_Page;

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"视频调解" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    [self buildUI];

    self.meetingTypeEnums = [FSMeetingDataEnum meetingTypeAllEnglish];
    self.meetingStatusEnums = [FSMeetingDataEnum meetingStatusAllEnglish];

    if ([FSUserInfoModle isLogin]) {
        [self loadApiData];
    } else {
        [self showEmptyViewWithType:[self getNoDataEmptyViewType] customImageName:[self getNoDataEmptyViewCustomImageName] customMessage:[self getNoDataEmptyViewCustomMessage] customView:[self getNoDataEmptyViewCustomView]];
    }
}

-(void)buildUI
{
    self.BottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48, self.view.bm_width, 48)];
    self.BottomBgView.backgroundColor = UI_COLOR_BL1;
    [self.view addSubview:self.BottomBgView];

    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.view.bm_width, 48)
                                              title:@"发起视频调解"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(createVideoMediateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.BottomBgView addSubview:bottom];
    
    self.m_TableView.frame = CGRectMake(0, 0, self.view.bm_width, self.BottomBgView.bm_top);
}

-(void)buildHeadSelector
{
    FSHeaderCommonSelectorModel *left =
    [FSHeaderCommonSelectorModel modelWithTitle:@"类型"
                                           list:[FSMeetingDataEnum meetingTypeChineseArrayContainAll:YES]];

    FSHeaderCommonSelectorModel *right =
    [FSHeaderCommonSelectorModel modelWithTitle:@"状态"
                                           list:[FSMeetingDataEnum meetingStatusChineseArrayContainAll:YES]];
    BMWeakSelf
    FSHeaderCommonSelectorView *selector = [[FSHeaderCommonSelectorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bm_width, 42)
                                                                                        data:@[left, right]];
    selector.selectorBlock = ^(NSInteger index, NSString *selectedItem) {
        if (index == 0) {
            [weakSelf setValue:[FSMeetingDataEnum meetingTypeChineseToEnglish:selectedItem] forKey:@"meetingTypeEnums"];
        }  else {
            [weakSelf setValue:[FSMeetingDataEnum meetingStatusChineseToEnglish:selectedItem] forKey:@"meetingStatusEnums"];
        }
        [weakSelf loadApiData];
    };
    
    self.headSelector = selector;
    [self.view addSubview:selector];
    
    self.m_TableView.frame = CGRectMake(0, selector.bm_bottom, self.m_TableView.bm_width, self.m_TableView.bm_height - selector.bm_bottom);
}

- (void)createVideoMediateAction
{
    if (![FSUserInfoModle isLogin])
    {
        loginAndCreate = YES;
        [self showLogin];
        return;
    }
    
    [self checkCertification];
}

- (void)checkCertification
{
    if (![self needCertification])
    {
        [self makeVideoMediate];
    }
}

- (void)makeVideoMediate
{
    BMWeakSelf
    FSMakeVideoMediateVC *vc = [FSMakeVideoMediateVC makevideoMediateVCWithModel:FSMakeVideoMediateMode_Create
                                                                            data:nil
                                                                           block:nil];
    vc.successBlock = ^(FSMeetingDetailModel *model, BOOL startImmediately) {
        [weakSelf loadApiData];
        if (startImmediately) {
            // 立即开始 进入详情页面
            FSVideoMediateDetailVC *vc = [FSVideoMediateDetailVC new];
            vc.m_MeetingId = model.meetingId;
            vc.changedBlock = ^{
                [weakSelf loadApiData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)needCertification
{
    if ([FSUserInfoModle isCertification]) {
        return NO;
    }
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"实名认证" message:@"视频调解需要进行实名认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"立即认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushAuthentication];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [vc addAction:action2];
    [vc addAction:action];

    [self presentViewController:vc animated:YES completion:nil];

    return YES;
}

- (void)loginFinished
{
    [self loadApiData];
    
    if (loginAndCreate) {
        loginAndCreate = NO;
        if ([FSUserInfoModle isCertification]) {
            [self makeVideoMediate];
        } else {
            // 登上一个文件dismiss以后才能再present
            [self performSelector:@selector(checkCertification) withObject:nil afterDelay:0.5f];
        }
    }
}

- (void)authenticationFinished
{
    [self makeVideoMediate];
}


- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getMeetingListWithType:_meetingTypeEnums
                                         status:_meetingStatusEnums
                                      pageIndex:s_BakLoadedPage
                                       pageSize:self.m_CountPerPage];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)data
{
    NSLog(@"%@",data);
    NSArray *array = [FSMeetingDetailModel modelsWithDataArray:data[@"list"]];
    if (self.m_IsLoadNew) {
        [self.m_DataArray removeAllObjects];
    }
    if (array) {
        if (self.headSelector == nil) {
            [self buildHeadSelector];
        }
        [self.m_DataArray addObjectsFromArray:array];
    }
    
    [self.m_TableView reloadData];
    
    return YES;
}

#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"VideoMediateListCell";
    FSVideoMediateListCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[FSVideoMediateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellIdentifier];
    }
    
    [cell setModel:self.m_DataArray[indexPath.row]];
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSVideoMediateDetailVC *vc = [FSVideoMediateDetailVC new];
    BMWeakSelf
    vc.changedBlock = ^{
        [weakSelf loadApiData];
    };
    FSMeetingDetailModel *model = self.m_DataArray[indexPath.row];
    vc.m_MeetingId = model.meetingId;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BMEmptyViewType)getNoDataEmptyViewType
{
    return BMEmptyViewType_Video;
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    
    self.BottomBgView.bm_height = 48 + self.view.safeAreaInsets.bottom;
    self.BottomBgView.bm_bottom = self.view.bm_bottom;
    self.m_TableView.frame = CGRectMake(0, 0, self.view.bm_width, self.BottomBgView.bm_top);
}

@end
