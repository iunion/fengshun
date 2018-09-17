//
//  FSInviteLitigantVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoInviteLitigantVC.h"
#import "FSVideoInviteLitigantCell.h"

@interface FSVideoInviteLitigantVC ()
@property (nonatomic, strong) NSMutableArray *m_InviteList; // 参与人员列表
@end

@implementation FSVideoInviteLitigantVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bm_setNavigationWithTitle:@"邀请当事人" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"完成" rightItemImage:nil rightToucheEvent:@selector(doneAction)];

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 24+44)];
    
    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = UI_FONT_14;
    [btn addTarget:self action:@selector(addLitigantAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.bm_width, 0.5)];
    line.backgroundColor = UI_COLOR_B6;
    [btn addSubview:line];

    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"+  添加当事人"
                                                                             attributes:@{NSForegroundColorAttributeName:UI_COLOR_BL1,
                                                                                          NSFontAttributeName:UI_FONT_14
                                                                                          }];
    [attr addAttribute:NSFontAttributeName value:UI_BOLDFONT_18 range:NSMakeRange(0, 1)];
    [btn setAttributedTitle:attr forState:UIControlStateNormal];
    self.m_TableView.tableFooterView = footer;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 新页面默认申请人、被申请人
    if (_m_InviteList == nil) {
        _m_InviteList = [NSMutableArray array];
        [self addApplicantLitigant];
        if (self.meetingId == 0) {
            [self addRespondentLitigant];
        }
    }
}

- (void)doneAction
{
    for (FSMeetingPersonnelModel *model in _m_InviteList) {
        if (model.userName == nil) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入姓名" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        if (model.mobilePhone == nil) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入手机号" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        
        if (![model.mobilePhone bm_isValidChinesePhoneNumber]) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入正确的手机号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        
        if (model.meetingIdentityTypeEnums == nil) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请选择身份" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        
        model.selectState = 1;
    }
    
    if (self.meetingId == 0) {
        if (self.inviteComplete && self.m_InviteList.count) {
            self.inviteComplete(self.m_InviteList);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self sendInviteRequest];
    }
}

// 添加申请人
- (void)addApplicantLitigant
{
    FSMeetingPersonnelModel *model = [FSMeetingPersonnelModel new];
    model.meetingIdentityTypeEnums = @"APPLICAT";
    [_m_InviteList addObject:model];
}

// 添加被申请人
- (void)addRespondentLitigant
{
    FSMeetingPersonnelModel *model = [FSMeetingPersonnelModel new];
    model.meetingIdentityTypeEnums = @"RESPONDENT";
    [_m_InviteList addObject:model];
}

- (void)addLitigantAction
{
    [self addApplicantLitigant];// 默认是申请人
    [self.m_TableView reloadData];
}

- (void)sendInviteRequest
{
    NSMutableArray *array = [NSMutableArray array];
    for (FSMeetingPersonnelModel *model in _m_InviteList) {
        [array addObject:[model formToParameters]];
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest inviteListPersonnelWithId:self.meetingId personList:array];
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
                    if (self.inviteComplete && self.m_InviteList.count) {
                        self.inviteComplete(self.m_InviteList);
                    }
                    [self.m_ProgressHUD hideAnimated:NO];
                    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:@"邀请成功！" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                
                NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
        }];
        [task resume];
    }
}

#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_InviteList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 176;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FSVideoInviteLitigantCell";
    
    FSVideoInviteLitigantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FSVideoInviteLitigantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        BMWeakSelf

        cell.deleteBlock = ^(FSVideoInviteLitigantCell *cell) {
            if ([weakSelf.m_InviteList containsObject:cell.m_Model]) {
                [weakSelf.m_InviteList removeObject:cell.m_Model];
                [weakSelf.m_TableView reloadData];
            }
        };
    }
    FSMeetingPersonnelModel *model = self.m_InviteList[indexPath.row];
    [cell setM_Model:model];

    return cell;
}

@end
