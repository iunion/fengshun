//
//  FSVideoMediateDetailVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateDetailVC.h"
#import "FSEditVideoMediateView.h"
#import "FSVideoAttendListVC.h"
#import "VideoCallController.h"
#import "FSVideoStartTool.h"
#import "FSVideoHistoryListVC.h"
#import "FSVideoMessageListVC.h"
#import "FSVideoMediateSheetVC.h"
#import "FSVideoInviteLitigantVC.h"
#import "FSMakeVideoMediateVC.h"

@interface FSVideoMediateDetailVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) FSMeetingDetailModel *m_DetailModel;

@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) FSEditVideoMediateImageView *personView;

@end

@implementation FSVideoMediateDetailVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)viewDidLoad {
    _m_FreshViewType = BMFreshViewType_NONE;
    [super viewDidLoad];

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"视频详情" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self loadApiData];
}

-(void)buildBottom
{
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bm_height - 48 - UI_HOME_INDICATOR_HEIGHT, self.view.bm_width, 48 + UI_HOME_INDICATOR_HEIGHT)];
    bottomBgView.backgroundColor = UI_COLOR_BL1;
    [self.view addSubview:bottomBgView];
    
    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.view.bm_width, 48)
                                              title:@"进入视频"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(bottomButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:bottom];
    self.bottomBtn = bottom;
    
    self.m_TableView.frame = CGRectMake(0, 0, self.view.bm_width, bottomBgView.bm_top);
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getMeetingDetailWithId:self.m_MeetingId];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)data
{
    if ([data bm_isNotEmptyDictionary])
    {
        self.m_showEmptyView = NO;

        if (self.bottomBtn == nil) {
            [self buildBottom];
        }
        self.m_DetailModel = [FSMeetingDetailModel modelWithParams:data];
        
        return YES;
    }
    
    return NO;
}

-(void)setM_DetailModel:(FSMeetingDetailModel *)model
{
    _m_DetailModel = model;
    [self.m_TableView bm_removeAllSubviews];

    UIBarButtonItem *rButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"video_more_btn"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = rButtonItem;

    if (model == nil) { return; }
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.startTime*0.001];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:model.endTime*0.001];

    UIView *contenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    contenView.backgroundColor = [UIColor clearColor];

    UILabel *leftlabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 150, 24)];
    leftlabel.backgroundColor = [UIColor clearColor];
    leftlabel.text = [NSString stringWithFormat:@"ID：%@",@(model.meetingId)];
    leftlabel.textColor = UI_COLOR_B4;
    leftlabel.font = UI_FONT_12;
    [contenView addSubview:leftlabel];

    UILabel *rightlabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 150 - 16, 0, 150, 24)];
    rightlabel.backgroundColor = [UIColor clearColor];
    rightlabel.text = [startDate bm_stringWithFormat:@"yyyy-MM-dd"];
    rightlabel.textAlignment = NSTextAlignmentRight;
    rightlabel.textColor = UI_COLOR_B4;
    rightlabel.font = UI_FONT_12;
    [contenView addSubview:rightlabel];

    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 74 - 16, 11, 74, 30)];
    status.textAlignment = NSTextAlignmentCenter;
    status.font = UI_FONT_16;
    status.textColor = UI_COLOR_B4;
    status.backgroundColor = [UIColor bm_colorWithHex:0xF0F0F0];
    status.text = [FSMeetingDataEnum meetingStatusEnglishToChinese:model.meetingStatus];
    [status bm_roundedRect:15];
    self.statusLabel = status;
    FSEditVideoMediateCustomerView *statusView = [[FSEditVideoMediateCustomerView alloc] initWithFrame:CGRectMake(0, leftlabel.bm_bottom, contenView.bm_width, 0)];
    statusView.titleLabel.text = @"状态";
    statusView.titleLabel.textColor = UI_COLOR_B10;
    statusView.customerView = status;
    [contenView addSubview:statusView];
    [statusView setEditEnabled:NO];

    FSEditVideoMediateTextView *nameView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, statusView.bm_bottom, contenView.bm_width, 0)];
    nameView.titleLabel.text = @"名称";
    nameView.titleLabel.textColor = UI_COLOR_B10;
    nameView.desLabel.text = model.meetingName;
    [contenView addSubview:nameView];
    [nameView setEditEnabled:NO];
    
    FSEditVideoMediateTextView *typeView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, nameView.bm_bottom, contenView.bm_width, 0)];
    typeView.titleLabel.text = @"类型";
    typeView.titleLabel.textColor = UI_COLOR_B10;
    typeView.desLabel.text = [FSMeetingDataEnum meetingTypeEnglishToChinese:model.meetingType];
    [contenView addSubview:typeView];
    [typeView setEditEnabled:NO];
    
    FSEditVideoMediateTextView *timeView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, typeView.bm_bottom, contenView.bm_width, 0)];
    timeView.titleLabel.text = @"时间";
    timeView.titleLabel.textColor = UI_COLOR_B10;

    if ([startDate bm_isSameDayAsDate:endDate]) {
        timeView.desLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[startDate bm_stringWithFormat:@"M月d日 HH:mm"],[endDate bm_stringWithFormat:@"HH:mm"]];
    } else {
        timeView.desLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[startDate bm_stringWithFormat:@"M月d日 HH:mm"],[endDate bm_stringWithFormat:@"M月d日 HH:mm"]];
    }
    
    [contenView addSubview:timeView];
    [timeView setEditEnabled:NO];

    self.personView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, timeView.bm_bottom, contenView.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    self.personView.titleLabel.text = @"参与人员";
    self.personView.titleLabel.textColor = UI_COLOR_B10;
    self.personView.line.hidden = YES;
    self.personView.desLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.personView.desLabel.text = [model getMeetingPersonnelNameListWithShowCount:3];
    [contenView addSubview:self.personView];
    [self.personView setEditEnabled:NO];
    BMWeakSelf
    self.personView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        FSVideoAttendListVC *vc = [FSVideoAttendListVC alloc];
        // 没有结束的会议可以邀请更多人
        if (![weakSelf.m_DetailModel.meetingStatus isEqualToString:[FSMeetingDataEnum meetingStatusEndEnglish]]) {
            vc.meetingId = weakSelf.m_DetailModel.meetingId;
        }
        vc.m_AttendList = weakSelf.m_DetailModel.meetingPersonnelResponseDTO;
        vc.inviteComplete = ^(NSArray *litigantList) {
            if (litigantList.count) {
                if ([litigantList bm_isNotEmpty]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.m_DetailModel.meetingPersonnelResponseDTO];
                    [array addObjectsFromArray:litigantList];
                    weakSelf.m_DetailModel.meetingPersonnelResponseDTO = [NSArray arrayWithArray:array];
                    weakSelf.personView.desLabel.text = [weakSelf.m_DetailModel getMeetingPersonnelNameListWithShowCount:3];
                }
            }
        };

        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    FSEditVideoMediateContentView *content = [[FSEditVideoMediateContentView alloc] initWithFrame:CGRectMake(0, self.personView.bm_bottom + 9, contenView.bm_width, 0)];
    content.titleLabel.text = @"内容";
    content.titleLabel.textColor = UI_COLOR_B10;
    content.contentText.text = model.meetingContent;;
    content.line.hidden = YES;
    [contenView addSubview:content];
    [content setEditEnabled:NO];
    
//    FSEditVideoMediateImageView *shareView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, content.bm_bottom + 9, contenView.bm_width, 0) imageName:@"video_share"];
//    shareView.titleLabel.text = @"地址";
//    shareView.titleLabel.textColor = UI_COLOR_B10;
//    shareView.desLabel.text = model.meetingInvite;
//    shareView.line.hidden = YES;
//    [shareView setEditEnabled:NO];
//    [contenView addSubview:shareView];
//    shareView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
//        NSLog(@"分享");
//    };

    UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, content.bm_bottom + 9, UI_SCREEN_WIDTH, 58)];
    lastView.backgroundColor = [UIColor whiteColor];
    [contenView addSubview:lastView];
    
    UIButton *leftBtn = [self buttonWithFrame:CGRectMake(60, 12, 112, 34) Title:@"视频回放" image:@"video_history_icon"];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [lastView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(videoHistoryAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightBtn = [self buttonWithFrame:CGRectMake(UI_SCREEN_WIDTH - 112 - 60, 12, 112, 34) Title:@"消息记录" image:@"video_message_icon"];
    [lastView addSubview:rightBtn];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(2, -8, 0, 0)];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [rightBtn addTarget:self action:@selector(messageListAction) forControlEvents:UIControlEventTouchUpInside];


    contenView.bm_height = lastView.bm_bottom + 15;
    [self.m_TableView addSubview:contenView];
    self.m_TableView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, contenView.bm_height);
    
    [self bringSomeViewToFront];
}

- (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *)title image:(NSString *)imageName
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn bm_roundedDashRect:17.0f borderWidth:2.0f borderColor:UI_COLOR_BL1];
    btn.backgroundColor = [UIColor bm_colorWithHex:0xE5ECFD];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UI_COLOR_BL1 forState:UIControlStateNormal];
    btn.titleLabel.font = UI_FONT_14;
    return btn;
}

- (void)moreAction
{
    BMWeakSelf
    FSVideoMediateSheetVC *sheetVC;
    if ([_m_DetailModel.meetingStatus isEqualToString:[FSMeetingDataEnum meetingStatusNoStartEnglish]])
    {
        // 未开始 支持所有操作
        sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:@[@"添加人员", @"编辑", @"再次发起", @"删除"]];
        BMWeakType(sheetVC)
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            if (index == 0) {
                [weakSelf inviteAction];
            } else if (index == 1) {
                [weakSelf editAction];
            } else if (index == 2) {
                [weakSelf resendAction];
            } else {
                weaksheetVC.m_ActionSheetDismissBlock = ^{
                    [weakSelf deleteAction];
                };
            }
        };
    }
    else if ([_m_DetailModel.meetingStatus isEqualToString:[FSMeetingDataEnum meetingStatusUnderwayEnglish]])
    {
        // 进行中 不能编辑不能删除
        sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:@[@"添加人员", @"再次发起"]];
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            if (index == 0) {
                [weakSelf inviteAction];
            } else {
                [weakSelf resendAction];
            }
        };
    }
    else
    {
        // 结束后不能添加人员不能编辑  可以删除
        sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:@[@"再次发起", @"删除"]];
        BMWeakType(sheetVC)
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            if (index == 0) {
                [weakSelf resendAction];
            } else {
                weaksheetVC.m_ActionSheetDismissBlock = ^{
                    [weakSelf deleteAction];
                };
            }
        };
    }
    
    if (sheetVC) {
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
    }
}

- (void)editAction
{
    FSMakeVideoMediateVC *vc = [FSMakeVideoMediateVC makevideoMediateVCWithModel:FSMakeVideoMediateMode_Edit
                                                                            data:self.m_DetailModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inviteAction
{
    if (self.m_DetailModel.meetingPersonnelResponseDTO.count >= FSMEETING_PERSON_MAX_COUNT) {
        [self.m_ProgressHUD showAnimated:YES withText:[NSString stringWithFormat:@"参会人员不能大于%@人(含调解员)",@(FSMEETING_PERSON_MAX_COUNT)] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    // 邀请
    FSVideoInviteLitigantVC *vc = [FSVideoInviteLitigantVC new];
    vc.meetingId = self.m_DetailModel.meetingId;
    vc.existingLitigantCount = self.m_DetailModel.meetingPersonnelResponseDTO.count;
    BMWeakSelf
    vc.inviteComplete = ^(NSArray *litigantList) {
        if ([litigantList bm_isNotEmpty]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.m_DetailModel.meetingPersonnelResponseDTO];
            [array addObjectsFromArray:litigantList];
            weakSelf.m_DetailModel.meetingPersonnelResponseDTO = [NSArray arrayWithArray:array];
            weakSelf.personView.desLabel.text = [weakSelf.m_DetailModel getMeetingPersonnelNameListWithShowCount:3];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resendAction
{
    FSMakeVideoMediateVC *vc = [FSMakeVideoMediateVC makevideoMediateVCWithModel:FSMakeVideoMediateMode_ReSend
                                                                            data:self.m_DetailModel];
    [self.navigationController pushViewController:vc animated:YES];    
}

- (void)deleteAction
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除视频记录吗？删除后，相关记录不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self sendDeleteRequest];
    }];
    [vc addAction:action];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [vc addAction:action2];

    [self presentViewController:vc animated:YES completion:nil];
}


// 进入视频会议
- (void)bottomButtonClickAction
{
    if ([_m_DetailModel.meetingStatus isEqualToString:[FSMeetingDataEnum meetingStatusNoStartEnglish]])
    {
        [self startMeeting];
    }
    else if ([_m_DetailModel.meetingStatus isEqualToString:[FSMeetingDataEnum meetingStatusEndEnglish]])
    {
        [self.m_ProgressHUD showAnimated:YES withText:@"视频已结束" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    else
    {
        [self joinRoom];
    }
}

- (void)sendDeleteRequest
{
    BMWeakSelf

    [FSVideoStartTool deleteMeetingWithMeetingId:self.m_MeetingId progressHUD:self.m_ProgressHUD completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *resDic = responseObject;
        NSInteger statusCode = [resDic bm_intForKey:@"code"];
        if (statusCode == 1000)
        {
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:@"删除成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            [[NSNotificationCenter defaultCenter] postNotificationName:FSVideoMediateChangedNotification object:nil userInfo:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return;
        }
    }];
}

- (void)startMeeting
{
    [FSVideoStartTool startMeetingWithMeetingId:self.m_MeetingId progressHUD:self.m_ProgressHUD completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *resDic = responseObject;
        NSInteger statusCode = [resDic bm_intForKey:@"code"];
        if (statusCode == 1000)
        {
            _m_DetailModel.meetingStatus = [FSMeetingDataEnum meetingStatusUnderwayEnglish];
            self.statusLabel.text = [FSMeetingDataEnum meetingStatusEnglishToChinese:_m_DetailModel.meetingStatus];
            [self.m_ProgressHUD hideAnimated:NO];
            [self joinRoom];
            [[NSNotificationCenter defaultCenter] postNotificationName:FSVideoMediateChangedNotification object:nil userInfo:nil];
        }
    }];
}

- (void)joinRoom
{
    FSMeetingPersonnelModel *model = [_m_DetailModel getMeetingMediator];
    BMWeakSelf
    [FSVideoStartTool getJoinMeetingToken:model.inviteCode name:model.userName progressHUD:self.m_ProgressHUD completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *resDic = responseObject;
        NSInteger statusCode = [resDic bm_intForKey:@"code"];
        if (statusCode == 1000)
        {
            NSDictionary *data = [resDic bm_dictionaryForKey:@"data"];
            VideoCallController *vc = [VideoCallController VCWithRoomId:_m_DetailModel.roomId meetingId:_m_DetailModel.meetingId token:data[@"token"]];
            vc.endMeetingBlock = ^{
                [weakSelf.m_ProgressHUD showAnimated:YES withText:@"视频已结束" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                weakSelf.m_DetailModel.meetingStatus = [FSMeetingDataEnum meetingStatusEndEnglish];
                weakSelf.statusLabel.text = [FSMeetingDataEnum meetingStatusEnglishToChinese:_m_DetailModel.meetingStatus];
            };
            vc.inviteBlock = ^(NSArray *litigantList) {
                if (litigantList.count) {
                    if ([litigantList bm_isNotEmpty]) {
                        NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.m_DetailModel.meetingPersonnelResponseDTO];
                        [array addObjectsFromArray:litigantList];
                        weakSelf.m_DetailModel.meetingPersonnelResponseDTO = [NSArray arrayWithArray:array];
                        weakSelf.personView.desLabel.text = [weakSelf.m_DetailModel getMeetingPersonnelNameListWithShowCount:3];
                    }
                }
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:FSMakeVideoMediateSuccessNotification object:nil userInfo:nil];
            BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:vc];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }
    }];
}

// 回放视频
- (void)videoHistoryAction
{
    FSVideoHistoryListVC *vc = [FSVideoHistoryListVC new];
    vc.meetingId = _m_DetailModel.meetingId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 进入消息记录
- (void)messageListAction
{
    FSVideoMessageListVC *vc = [FSVideoMessageListVC new];
    vc.roomId = _m_DetailModel.roomId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
