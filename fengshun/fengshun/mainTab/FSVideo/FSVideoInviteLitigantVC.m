//
//  FSInviteLitigantVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoInviteLitigantVC.h"
#import "FSVideoMediateSheetVC.h"
#import "FSVideoMediateModel.h"

#define FS_VIDEOPAGE_TEXTFONT UI_FONT_16

@interface FSVideoInviteLitigantVC ()
@property (nonatomic, strong) NSMutableArray *m_InviteList; // 参与人员列表
@property (nonatomic, strong) NSMutableArray *m_CorrectList; // 经受住了检验的人员列表
@end

@implementation FSVideoInviteLitigantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = FS_VIEW_BGCOLOR;

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"邀请当事人" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"完成" rightItemImage:nil rightToucheEvent:@selector(doneAction)];

    [self buildUI];
}

-(void)buildUI
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 24+44)];
    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = UI_FONT_14;
    [btn addTarget:self action:@selector(addLitigantAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.bm_width, 0.5)];
    line.backgroundColor = UI_COLOR_B6;
    [btn addSubview:line];
    self.m_TableView.tableFooterView = footer;
    self.m_TableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0.01)];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"+  添加当事人"
                                                                             attributes:@{NSForegroundColorAttributeName:UI_COLOR_BL1,
                                                                                          NSFontAttributeName:UI_FONT_14
                                                                                          }];
    [attr addAttribute:NSFontAttributeName value:UI_BOLDFONT_18 range:NSMakeRange(0, 1)];
    [btn setAttributedTitle:attr forState:UIControlStateNormal];
    
    [self interfaceSettings];
}

-(BOOL)needKeyboardEvent
{
    return YES;
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_TableView.bounces = YES;

    // 新页面默认申请人、被申请人
    if (_m_InviteList == nil) {
        _m_InviteList = [NSMutableArray array];
        if (self.meetingId == 0 && self.existingLitigantList.count)
        {
            [_m_InviteList addObjectsFromArray:self.existingLitigantList];
        }
        else
        {
            [self addApplicantLitigant];
            if (self.meetingId == 0) {
                [self addRespondentLitigant];
            }
        }
    }
    
    [self freshViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BMTableViewSection *)sectionWithModel:(FSMeetingPersonnelModel *)model
{
    BMTableViewSection *section = [BMTableViewSection new];
    section.headerHeight = 24.0f;
    section.footerHeight = 0.0f;

    BMTextItem *nameItem = [BMTextItem itemWithTitle:@"姓名" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:nil selectionHandler:nil];
    nameItem.textColor = UI_COLOR_B1;
    nameItem.textFieldTextColor = UI_COLOR_B1;
    nameItem.textFieldPlaceholderColor = UI_COLOR_B10;
    nameItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    nameItem.textFieldTextFont = FS_VIDEOPAGE_TEXTFONT;
    nameItem.textFieldAlignment = NSTextAlignmentRight;
    nameItem.charactersLimit = 5;
    nameItem.value = model.userName;
    nameItem.placeholder = @"请输入姓名";
    nameItem.cellHeight = 50.0f;
    nameItem.onChange = ^(BMInputItem * _Nonnull item) {
        model.userName = item.value;
    };

    BMTextItem *phoneItem = [BMTextItem itemWithTitle:@"手机号" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:nil selectionHandler:nil];
    phoneItem.textColor = UI_COLOR_B1;
    phoneItem.value = model.mobilePhone;
    phoneItem.textFieldTextColor = UI_COLOR_B1;
    phoneItem.textFieldPlaceholderColor = UI_COLOR_B10;
    phoneItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    phoneItem.textFieldTextFont = FS_VIDEOPAGE_TEXTFONT;
    phoneItem.textFieldAlignment = NSTextAlignmentRight;
    phoneItem.keyboardType = UIKeyboardTypeNumberPad;
    phoneItem.placeholder = @"请输入手机号";
    phoneItem.cellHeight = 50.0f;
    phoneItem.charactersLimit = 11;
    phoneItem.onChange = ^(BMInputItem * _Nonnull item) {
        model.mobilePhone = item.value;
    };

    BMWeakSelf
    BMTableViewItem *identifyItem = [BMTableViewItem itemWithTitle:@"身份" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:nil selectionHandler:nil];
    
    __weak typeof(BMTableViewItem *) weakIdentifyItem = identifyItem;
    identifyItem.selectionHandler = ^(id  _Nonnull item) {
        // 选择类型
        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:[FSMeetingDataEnum meetingIdentityChineseArrayContainMediator:NO]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:sheetVC animated:YES completion:nil];
        
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            BMImageTextView *accessoryView = (BMImageTextView *)weakIdentifyItem.accessoryView;
            accessoryView.text = title;
            model.meetingIdentityTypeEnums = [FSMeetingDataEnum meetingIdentityChineseToEnglish:title];
        };
    };
    
    identifyItem.textColor = UI_COLOR_B1;
    identifyItem.detailTextColor = UI_COLOR_B1;
    identifyItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    identifyItem.detailTextFont = FS_VIDEOPAGE_TEXTFONT;
    identifyItem.cellHeight = 50.0f;
    identifyItem.isShowHighlightBg = NO;
    BMImageTextView *imageTextView = [[BMImageTextView alloc] initWithText:[FSMeetingDataEnum meetingIdentityEnglishToChinese:model.meetingIdentityTypeEnums]];
    imageTextView.textColor = UI_COLOR_B1;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    identifyItem.accessoryView = imageTextView;
    
    [section addItem:nameItem];
    [section addItem:phoneItem];
    [section addItem:identifyItem];
    
    return section;
}

-(void)freshViews
{
    [super freshViews];
    
    [self.m_TableManager removeAllSections];
    
    for (NSInteger index=0; index<self.m_InviteList.count; index++) {
        FSMeetingPersonnelModel *model = self.m_InviteList[index];
        BMTableViewSection *section = [self sectionWithModel:model];
        section.headerView = [self sectionHeaderViewWithIndex:index];
        [self.m_TableManager addSection:section];
    }
    
    [self.m_TableView reloadData];
}

- (UIView *)sectionHeaderViewWithIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bm_width, 24)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 24)];
    label.text = @"当事人信息";
    label.textColor = UI_COLOR_B4;
    label.font = UI_FONT_12;
    [view addSubview:label];
    
    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(UI_SCREEN_WIDTH - 40 - 4, 0, 40, 24) image:[UIImage imageNamed:@"video_delete_btn"]];
    btn.tag = index;
    [btn addTarget:self action:@selector(deleteFromSuperView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    return view;
}

- (void)deleteFromSuperView:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    if (tag < self.m_InviteList.count) {
        [self.m_InviteList removeObjectAtIndex:tag];
        [self freshViews];
    }
}

- (void)doneAction
{
    FSUserInfoModel *user = [FSUserInfoModel userInfo];

    NSMutableArray *correctArray = [NSMutableArray array];
    for (FSMeetingPersonnelModel *model in self.m_InviteList) {
        // 手机号和姓名可以同时为空
        if ((![model.userName bm_isNotEmpty]) && (![model.mobilePhone bm_isNotEmpty])) {
            continue;
        }
        if (![model.userName bm_isNotEmpty]) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入姓名" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }

        if (![model.mobilePhone bm_isNotEmpty]) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入手机号" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        
        if (![model.mobilePhone bm_isValidChinesePhoneNumber]) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入正确的手机号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        
        if ([model.mobilePhone isEqualToString:user.m_UserBaseInfo.m_PhoneNum]) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"参会手机号不能重复" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }

        [correctArray addObject:model];
    }
    
    if (correctArray.count == 0) {
        [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入当事人信息" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    
    // 手机号不能重复
    NSInteger correctCount = correctArray.count;
    if (correctCount > 1) {
        for (int i=0; i< correctCount; i++) {
            FSMeetingPersonnelModel *firstModel = correctArray[i];
            for (int j=i+1; j< correctCount; j++) {
                FSMeetingPersonnelModel *senconModel = correctArray[j];
                if ([firstModel.mobilePhone isEqualToString:senconModel.mobilePhone]) {
                    [self.m_ProgressHUD showAnimated:YES withDetailText:@"参会手机号不能重复" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    return;
                }
            }
        }
    }
    
    
    self.m_CorrectList = correctArray;
    if (self.meetingId == 0) {
        if (self.inviteComplete && self.m_CorrectList.count) {
            self.inviteComplete(self.m_CorrectList);
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
    model.meetingIdentityTypeEnums = [FSMeetingDataEnum meetingApplicatenglish];
    model.selectState = 1;
    [_m_InviteList addObject:model];
}

// 添加被申请人
- (void)addRespondentLitigant
{
    FSMeetingPersonnelModel *model = [FSMeetingPersonnelModel new];
    model.meetingIdentityTypeEnums = [FSMeetingDataEnum meetingRespondentenglish];
    model.selectState = 1;
    [_m_InviteList addObject:model];
}

- (void)addLitigantAction
{
    if (self.meetingId > 0)
    {
        if (self.m_InviteList.count + self.existingLitigantCount >= FSMEETING_PERSON_MAX_COUNT)
        {
            [self.m_ProgressHUD showAnimated:YES withText:[NSString stringWithFormat:@"参会人员不能大于%@人(含调解员)",@(FSMEETING_PERSON_MAX_COUNT)] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
    }
    else if (self.m_InviteList.count >= FSMEETING_PERSON_MAX_COUNT-1)
    {
        [self.m_ProgressHUD showAnimated:YES withText:[NSString stringWithFormat:@"参会人员不能大于%@人(含调解员)",@(FSMEETING_PERSON_MAX_COUNT)] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    [self addApplicantLitigant];// 默认是申请人
    [self freshViews];
}

- (void)sendInviteRequest
{
    NSMutableArray *array = [NSMutableArray array];
    for (FSMeetingPersonnelModel *model in self.m_CorrectList) {
        [array addObject:[model formToParametersWithPersonnelId:NO]];
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
                    if (self.inviteComplete && self.m_CorrectList.count) {
                        self.inviteComplete(self.m_CorrectList);
                    }
                    [self.m_ProgressHUD hideAnimated:NO];
                    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:@"邀请成功！" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    [[NSNotificationCenter defaultCenter] postNotificationName:FSVideoMediateChangedNotification object:nil userInfo:nil];
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

#pragma mark - 屏幕触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - scorllView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tracking) {
        [self.view endEditing:YES];
    }
}

@end

