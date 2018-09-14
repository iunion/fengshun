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

@interface FSVideoMediateDetailVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) FSMeetingDetailModel *m_DetailModel;

@end

@implementation FSVideoMediateDetailVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)viewDidLoad {
    _m_FreshViewType = BMFreshViewType_NONE;
    [super viewDidLoad];

    [self bm_setNavigationWithTitle:@"视频详情" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self buildUI];
    
    [self sendMeetingDetailRequest];
}

-(void)buildUI
{
    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48, self.view.bm_width, 48)
                                              title:@"进入视频"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(bottomButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
    
    self.m_TableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48);
}

- (void)sendMeetingDetailRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest getMeetingDetailWithId:self.m_MeetingId];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif

                NSDictionary *resDic = responseObject;
                if (![resDic bm_isNotEmptyDictionary])
                {
                    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    return;
                }
                
                NSInteger statusCode = [resDic bm_intForKey:@"code"];
                if (statusCode == 1000)
                {
                    [self.m_ProgressHUD hideAnimated:NO];
                    NSDictionary *dataDic = [resDic bm_dictionaryForKey:@"data"];
                    if ([dataDic bm_isNotEmptyDictionary])
                    {
                        self.m_DetailModel = [FSMeetingDetailModel modelWithParams:dataDic];
                        return;
                    }
                }
                
                NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];

            }
        }];
        [task resume];
    }
}


-(void)setM_DetailModel:(FSMeetingDetailModel *)model
{
    _m_DetailModel = model;
    [self.m_TableView bm_removeAllSubviews];

    if (model == nil) {
        return;
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startTime/1000];

    UIView *contenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    contenView.backgroundColor = [UIColor clearColor];

    UILabel *leftlabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 150, 24)];
    leftlabel.backgroundColor = [UIColor clearColor];
    leftlabel.text = [NSString stringWithFormat:@"ID：%ld",model.meetingId];
    leftlabel.textColor = UI_COLOR_B4;
    leftlabel.font = UI_FONT_12;
    [contenView addSubview:leftlabel];

    UILabel *rightlabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 150 - 16, 0, 150, 24)];
    rightlabel.backgroundColor = [UIColor clearColor];
    rightlabel.text = [date bm_stringWithFormat:@"yyyy-MM-dd"];
    rightlabel.textAlignment = NSTextAlignmentRight;
    rightlabel.textColor = UI_COLOR_B4;
    rightlabel.font = UI_FONT_12;
    [contenView addSubview:rightlabel];

    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 74 - 16, 11, 74, 30)];
    status.textAlignment = NSTextAlignmentCenter;
    status.font = UI_FONT_16;
    status.textColor = UI_COLOR_B4;
    status.backgroundColor = [UIColor bm_colorWithHex:0xF0F0F0];
    status.text = [FSMeetingDataForm getValueForKey:model.meetingStatus type:FSMeetingDataType_AllMeetingStatus];
    [status bm_roundedRect:15];

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
    typeView.desLabel.text = [FSMeetingDataForm getValueForKey:model.meetingType type:FSMeetingDataType_AllMeetingType];
    [contenView addSubview:typeView];
    [typeView setEditEnabled:NO];
    
    FSEditVideoMediateTextView *timeView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, typeView.bm_bottom, contenView.bm_width, 0)];
    timeView.titleLabel.text = @"时间";
    timeView.titleLabel.textColor = UI_COLOR_B10;
    timeView.desLabel.text = [date bm_stringWithFormat:@"yyyy-MM-dd HH:mm"];
    [contenView addSubview:timeView];
    [timeView setEditEnabled:NO];
    

    FSEditVideoMediateImageView *personView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, timeView.bm_bottom, contenView.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    personView.titleLabel.text = @"参与人员";
    personView.titleLabel.textColor = UI_COLOR_B10;
    personView.line.hidden = YES;
    personView.desLabel.text = [model getMeetingPersonnelNameList];
    [contenView addSubview:personView];
    [personView setEditEnabled:NO];
    BMWeakSelf
    personView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        NSLog(@"参与人员列表");
        FSVideoAttendListVC *vc = [FSVideoAttendListVC alloc];
        vc.m_AttendList = self.m_DetailModel.meetingPersonnelResponseDTO;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    FSEditVideoMediateContentView *content = [[FSEditVideoMediateContentView alloc] initWithFrame:CGRectMake(0, personView.bm_bottom + 9, contenView.bm_width, 0)];
    content.titleLabel.text = @"内容";
    content.titleLabel.textColor = UI_COLOR_B10;
    content.contentText.text = model.meetingContent;;
    content.line.hidden = YES;
    [contenView addSubview:content];
    [content setEditEnabled:NO];
    
    FSEditVideoMediateImageView *shareView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, content.bm_bottom + 9, contenView.bm_width, 0) imageName:@"video_share"];
    shareView.titleLabel.text = @"地址";
    shareView.titleLabel.textColor = UI_COLOR_B10;
    shareView.desLabel.text = model.meetingInvite;
    shareView.line.hidden = YES;
    [shareView setEditEnabled:NO];
    [contenView addSubview:shareView];
    shareView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        NSLog(@"分享");
    };

    UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, shareView.bm_bottom + 9, UI_SCREEN_WIDTH, 58)];
    [contenView addSubview:lastView];

    contenView.bm_height = lastView.bm_bottom + 15;
    [self.m_TableView addSubview:contenView];
    self.m_TableView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, contenView.bm_height);
}

- (void)bottomButtonClickAction
{
    // 进入视频
}


#pragma mark -
#pragma mark Table Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    //    static NSString *taskCellIdentifier = @"VideoMediateListCell";
    //    VideoMediateListCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    //
    //    if (cell == nil)
    //    {
    //        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoMediateListCell" owner:self options:nil] lastObject];
    //    }
    //
    //    [cell setModel:self.m_DataArray[indexPath.row]];
    //
    //    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
