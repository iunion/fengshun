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
#import "FSVideoStartTool.h"

@interface FSVideoMediateListVC ()
{
    BOOL loginAndCreate;
}

@property (nonatomic, strong) NSString *meetingTypeEnums;
@property (nonatomic, strong) NSString *meetingStatusEnums;
@property (nonatomic, strong) FSHeaderCommonSelectorView *headSelector;
@property (nonatomic, strong) UIView *BottomBgView;
@property (nonatomic, strong) FSMeetingDetailModel *deleteModel;

@end

@implementation FSVideoMediateListVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

    if ([FSUserInfoModel isLogin]) {
        [self loadApiData];
    } else {
        [self showEmptyViewWithType:[self getNoDataEmptyViewType] customImageName:[self getNoDataEmptyViewCustomImageName] customMessage:[self getNoDataEmptyViewCustomMessage] customView:[self getNoDataEmptyViewCustomView]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadApiData) name:FSMakeVideoMediateSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadApiData) name:FSVideoMediateChangedNotification object:nil];
}

-(void)buildUI
{
    self.BottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48 - UI_HOME_INDICATOR_HEIGHT, self.view.bm_width, 48 + UI_HOME_INDICATOR_HEIGHT)];
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
    if (![FSUserInfoModel isLogin])
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
    FSMakeVideoMediateVC *vc = [FSMakeVideoMediateVC makevideoMediateVCWithModel:FSMakeVideoMediateMode_Create data:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)needCertification
{
    if ([FSUserInfoModel isCertification]) {
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
        if ([FSUserInfoModel isCertification]) {
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"UITableViewCellEditingStyle = %@", @(editingStyle));
    self.deleteModel = self.m_DataArray[indexPath.row];
    [self deleteAction];
}

- (void)deleteAction
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self sendDeleteRequest];
    }];
    [vc addAction:action];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [vc addAction:action2];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)sendDeleteRequest
{
    BMWeakSelf
    
    [FSVideoStartTool deleteMeetingWithMeetingId:self.deleteModel.meetingId progressHUD:self.m_ProgressHUD completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *resDic = responseObject;
        NSInteger statusCode = [resDic bm_intForKey:@"code"];
        if (statusCode == 1000)
        {
            [weakSelf.m_ProgressHUD showAnimated:YES withText:@"删除成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            [weakSelf loadApiData];
            weakSelf.deleteModel = nil;
        }
    }];
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

@end
