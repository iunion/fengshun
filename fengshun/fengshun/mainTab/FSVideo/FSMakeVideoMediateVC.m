//
//  FSNewVideoMediateVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMakeVideoMediateVC.h"
#import "FSVideoMediateSheetVC.h"
#import "FSMeetingPersonnelItem.h"
#import "FSVideoInviteLitigantVC.h"
#import "FSVideoMediateDetailVC.h"
#import "FSVideoMediateListVC.h"
#import "VideoCallController.h"
#import "FSMeetingDataEnum.h"
#import "FSVideoStartTool.h"

#define FS_VIDEOPAGE_TEXTFONT UI_FONT_16

@interface FSMakeVideoMediateVC ()
{
    BOOL isTimePast;
}
@property (nonatomic, strong) UIView *BottomBgView;

@property (nonatomic, strong) BMTableViewSection *m_MainSection;
@property (nonatomic, strong) BMTextItem *m_TitleItem;
@property (nonatomic, strong) BMTableViewItem *m_TypeItem;
@property (nonatomic, strong) BMTableViewItem *m_TimeTypeItem;
@property (nonatomic, strong) BMDateTimeItem *m_ChooseTimeItem;
@property (nonatomic, strong) BMPickerItem *m_TimeLengthItem;

@property (nonatomic, strong) BMTableViewSection *m_ContentSection;
@property (nonatomic, strong) BMLongTextItem *m_ContentItem;

@property (nonatomic, strong) BMTableViewSection *m_PersonSection;

@property (nonatomic, assign) BOOL m_IsStartImmediately;
@property (nonatomic, strong) NSMutableArray *m_AttendedList; // 参与人员列表

@property (nonatomic, strong) FSMeetingDetailModel *m_DetailModel;

@end

@implementation FSMakeVideoMediateVC

+ (instancetype)makevideoMediateVCWithModel:(FSMakeVideoMediateMode)mode
                                       data:(FSMeetingDetailModel *)data
{
    FSMakeVideoMediateVC *vc = [FSMakeVideoMediateVC new];
    vc.makeMode = mode;
    vc.m_CreateModel = [FSMeetingDetailModel new];

    if (FSMakeVideoMediateMode_Edit == mode && data)
    {
        vc.m_CreateModel.meetingId = data.meetingId;
        vc.m_CreateModel.roomId = data.roomId;
        vc.m_CreateModel.creatorId = data.creatorId;
    }
    
    if (data && (mode == FSMakeVideoMediateMode_Edit || mode == FSMakeVideoMediateMode_ReSend))
    {
        vc.m_CreateModel.meetingContent = data.meetingContent;
        vc.m_CreateModel.meetingName = data.meetingName;
        vc.m_CreateModel.meetingStatus = data.meetingStatus;
        vc.m_CreateModel.meetingType = data.meetingType;
        vc.m_CreateModel.startTime = data.startTime;
        vc.m_CreateModel.endTime = data.endTime;
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:data.startTime*0.001];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:data.endTime*0.001];
        NSInteger minute = [startDate bm_minutesBeforeDate:endDate ];
        NSInteger hour = [startDate bm_hoursBeforeDate:endDate];
        if (minute%60 == 0) {
            vc.m_CreateModel.orderHour = [NSString stringWithFormat:@"%@", @(hour)];
        } else {
            vc.m_CreateModel.orderHour = [NSString stringWithFormat:@"%@.5", @(hour)];
        }
        
        vc.m_AttendedList = [NSMutableArray array];
        for (FSMeetingPersonnelModel *model in data.meetingPersonnelResponseDTO)
        {
            FSMeetingPersonnelModel *newPerson = [FSMeetingPersonnelModel new];
            newPerson.userName = model.userName;
            newPerson.mobilePhone = model.mobilePhone;
            newPerson.meetingIdentityTypeEnums = model.meetingIdentityTypeEnums;
            newPerson.selectState = 1;

            if ([newPerson isMediatorPerson])
            {
                [vc.m_AttendedList insertObject:newPerson atIndex:0];
            }
            else
            {
                [vc.m_AttendedList addObject:newPerson];
            }
            if (mode == FSMakeVideoMediateMode_ReSend) {
                newPerson.personnelId = 0;
            } else {
                newPerson.personnelId = model.personnelId;
            }
        }
    }

    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.m_TableView.bounces = YES;

    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_IsStartImmediately = YES;
    NSString *title = @"新建视频调解";
    if (self.makeMode == FSMakeVideoMediateMode_ReSend) {
        title = @"再次发起视频调解";
    } else if (self.makeMode == FSMakeVideoMediateMode_Edit)  {
        title = @"编辑视频调解";
    }

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:title barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    [self buildUI];
}

-(BOOL)needKeyboardEvent
{
    return YES;
}

-(void)buildUI
{
    self.BottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48 - UI_HOME_INDICATOR_HEIGHT, self.view.bm_width, 48 + UI_HOME_INDICATOR_HEIGHT)];
    self.BottomBgView.backgroundColor = UI_COLOR_BL1;
    [self.view addSubview:self.BottomBgView];

    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.view.bm_width, 48)
                                              title:@"确定"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(bottomButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.BottomBgView addSubview:bottom];
    
    self.m_TableView.frame = CGRectMake(0, 0, self.view.bm_width, self.BottomBgView.bm_top);
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 24+44)];
    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = UI_FONT_14;
    [btn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    self.m_TableView.tableFooterView = footer;
    self.m_TableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0.01)];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"+  邀请当事人"
                                                                             attributes:@{NSForegroundColorAttributeName:UI_COLOR_BL1,
                                                                                          NSFontAttributeName:UI_FONT_14
                                                                                          }];
    [attr addAttribute:NSFontAttributeName value:UI_BOLDFONT_18 range:NSMakeRange(0, 1)];
    [btn setAttributedTitle:attr forState:UIControlStateNormal];
    
    [self interfaceSettings];
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    [self.m_TableManager registerClass:@"FSMeetingPersonnelItem" forCellWithReuseIdentifier:@"FSVideoMediatePersonalCell"];
    
    self.m_MainSection = [BMTableViewSection section];
    self.m_ContentSection = [BMTableViewSection section];
    self.m_PersonSection = [BMTableViewSection section];
    
    BMWeakSelf

    self.m_TitleItem = [BMTextItem itemWithTitle:@"名称" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:nil selectionHandler:nil];
    self.m_TitleItem.textColor = UI_COLOR_B1;
    self.m_TitleItem.textFieldTextColor = UI_COLOR_B1;
    self.m_TitleItem.textFieldPlaceholderColor = UI_COLOR_B10;
    self.m_TitleItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_TitleItem.textFieldTextFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_TitleItem.textFieldAlignment = NSTextAlignmentRight;
    self.m_TitleItem.placeholder = @"请输入名称";
    self.m_TitleItem.cellHeight = 50.0f;
    self.m_TitleItem.charactersLimit = 20;
    self.m_TitleItem.onChange = ^(BMInputItem * _Nonnull item) {
        weakSelf.m_CreateModel.meetingName = item.value;
    };

    self.m_TypeItem = [BMTableViewItem itemWithTitle:@"类型" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:nil selectionHandler:^(BMTableViewItem * _Nonnull item) {
        // 选择类型
        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:[FSMeetingDataEnum meetingTypeChineseArrayContainAll:NO]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:sheetVC animated:YES completion:nil];
        
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            BMImageTextView *accessoryView = (BMImageTextView *)weakSelf.m_TypeItem.accessoryView;
            accessoryView.text = title;
            weakSelf.m_CreateModel.meetingType = [FSMeetingDataEnum meetingTypeChineseToEnglish:title];
        };
    }];
    self.m_TypeItem.textColor = UI_COLOR_B1;
    self.m_TypeItem.detailTextColor = UI_COLOR_B1;
    self.m_TypeItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_TypeItem.detailTextFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_TypeItem.cellHeight = 50.0f;
    self.m_TypeItem.isShowHighlightBg = NO;
    BMImageTextView *imageTextView = [[BMImageTextView alloc] initWithText:@"调解"];
    imageTextView.textColor = UI_COLOR_B1;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_TypeItem.accessoryView = imageTextView;

    self.m_TimeTypeItem = [BMTableViewItem itemWithTitle:@"时间" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:nil selectionHandler:^(BMTableViewItem * _Nonnull item) {
        // 时间  立即开始还是预约时间
        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:@[@"立即开始",@"预约时间"]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:sheetVC animated:YES completion:nil];
        
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            BMImageTextView *accessoryView = (BMImageTextView *)weakSelf.m_TimeTypeItem.accessoryView;
            accessoryView.text = title;
            weakSelf.m_IsStartImmediately = !index;
            
            if (index == 0) {
                weakSelf.m_CreateModel.startTime = 0;
            } else {
                weakSelf.m_CreateModel.startTime = [weakSelf.m_ChooseTimeItem.pickerDate timeIntervalSince1970] * 1000;
            }
            
            [weakSelf freshViews];
        };
    }];
        
    self.m_TimeTypeItem.textColor = UI_COLOR_B1;
    self.m_TimeTypeItem.detailTextColor = UI_COLOR_B1;
    self.m_TimeTypeItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_TimeTypeItem.detailTextFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_TimeTypeItem.cellHeight = 50.0f;
    self.m_TimeTypeItem.isShowHighlightBg = NO;
    imageTextView = [[BMImageTextView alloc] initWithText:@"立即开始"];
    imageTextView.textColor = UI_COLOR_B1;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_TimeTypeItem.accessoryView = imageTextView;

    self.m_ChooseTimeItem = [BMDateTimeItem itemWithTitle:@"选择时间" placeholder:@"请选择"];
    self.m_ChooseTimeItem.textColor = UI_COLOR_B1;
    self.m_ChooseTimeItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_ChooseTimeItem.pickerStyle = PickerStyle_YearMonthDayHourMinute;
    self.m_ChooseTimeItem.pickerTextAlignment = NSTextAlignmentRight;
    self.m_ChooseTimeItem.pickerValueColor = UI_COLOR_B1;
    self.m_ChooseTimeItem.pickerValueFont = FS_CELLTITLE_TEXTFONT;
    self.m_ChooseTimeItem.pickerPlaceholderColor = UI_COLOR_B10;
    self.m_ChooseTimeItem.accessoryView = [BMTableViewItem DefaultAccessoryView];
    self.m_ChooseTimeItem.showDoneBtn = NO;
    self.m_ChooseTimeItem.isShowHighlightBg = NO;
    self.m_ChooseTimeItem.formatPickerText = ^NSString * _Nullable(BMDateTimeItem * _Nonnull item) {
        return [item.pickerDate bm_stringByFormatter:@"yyyy-MM-dd HH:mm"];
    };
    self.m_ChooseTimeItem.onChange = ^(BMDateTimeItem * _Nonnull item) {
        weakSelf.m_CreateModel.startTime = [item.pickerDate timeIntervalSince1970] * 1000;
    };

    NSArray *timeArray = @[@"0.5小时",@"1小时", @"1.5小时", @"2小时", @"2.5小时", @"3小时", @"3.5小时", @"4小时"];
    self.m_TimeLengthItem = [BMPickerItem itemWithTitle:@"时长" placeholder:@"请选择" components:@[timeArray]];
    self.m_TimeLengthItem.pickerSelectedRowInComponent = @[@(1)];
    self.m_TimeLengthItem.textColor = UI_COLOR_B1;
    self.m_TimeLengthItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_TimeLengthItem.pickerValueColor = UI_COLOR_B1;
    self.m_TimeLengthItem.pickerValueFont = FS_CELLTITLE_TEXTFONT;
    self.m_TimeLengthItem.pickerPlaceholderColor = UI_COLOR_B10;
    self.m_TimeLengthItem.cellHeight = 50.0f;
    self.m_TimeLengthItem.isShowHighlightBg = NO;
    self.m_TimeLengthItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    self.m_TimeLengthItem.accessoryView = [BMTableViewItem DefaultAccessoryView];
    self.m_TimeLengthItem.formatPickerText = ^NSString * _Nullable(BMPickerItem * _Nonnull item) {
        return [item.values componentsJoinedByString:@""];
    };
    self.m_TimeLengthItem.onChange = ^(BMPickerItem * _Nonnull item) {
        NSString *value = item.values.firstObject;
        weakSelf.m_CreateModel.orderHour = [value substringToIndex:value.length-2];
    };

    self.m_ContentItem = [BMLongTextItem itemWithTitle:@"内容" value:nil placeholder:@"请输入内容"];
    self.m_ContentItem.cellHeight = 128;
    self.m_ContentItem.textViewLeftGap = -6;
    self.m_ContentItem.textViewBorderColor = [UIColor whiteColor];
    self.m_ContentItem.textFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_ContentItem.textViewFont = FS_VIDEOPAGE_TEXTFONT;
    self.m_ContentItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    self.m_ContentItem.charactersLimit = 100;
    self.m_ContentItem.onChange = ^(BMInputItem * _Nonnull item) {
        weakSelf.m_CreateModel.meetingContent = item.value;
    };
    
    self.m_MainSection.headerHeight = 8;
    self.m_MainSection.footerHeight = 0;
    self.m_ContentSection.headerHeight = 8;
    self.m_ContentSection.footerHeight = 0;
    self.m_PersonSection.headerHeight = 24;
    self.m_PersonSection.footerHeight = 0;

    [self.m_MainSection addItem:self.m_TitleItem];
    [self.m_MainSection addItem:self.m_TypeItem];
    [self.m_MainSection addItem:self.m_TimeTypeItem];
    if (!self.m_IsStartImmediately) {
        [self.m_MainSection addItem:self.m_ChooseTimeItem];
    }
    [self.m_MainSection addItem:self.m_TimeLengthItem];
    [self.m_ContentSection addItem:self.m_ContentItem];

    [self.m_TableManager addSection:self.m_MainSection];
    [self.m_TableManager addSection:self.m_ContentSection];
    [self.m_TableManager addSection:self.m_PersonSection];
    
    [self setOriginData];
    
    [self freshViews];
}

- (void)setOriginData
{
    if (self.makeMode == FSMakeVideoMediateMode_Edit || self.makeMode == FSMakeVideoMediateMode_ReSend)
    {
        self.m_TitleItem.value = self.m_CreateModel.meetingName;
        
        BMImageTextView *accessoryView = (BMImageTextView *)self.m_TypeItem.accessoryView;
        accessoryView.text = [FSMeetingDataEnum meetingTypeEnglishToChinese:self.m_CreateModel.meetingType];


        if (self.makeMode == FSMakeVideoMediateMode_Edit) {
            self.m_IsStartImmediately = NO;
            BMImageTextView *accessoryView2 = (BMImageTextView *)self.m_TimeTypeItem.accessoryView;
            accessoryView2.text = @"预约时间";
            self.m_ChooseTimeItem.pickerDate = [NSDate dateWithTimeIntervalSince1970:self.m_CreateModel.startTime*0.001];
            self.m_ChooseTimeItem.minLimitDate = self.m_ChooseTimeItem.pickerDate;
        }
        
        if ([self.m_CreateModel.orderHour bm_isNotEmpty]) {
            NSString *value = [NSString stringWithFormat:@"%@小时", self.m_CreateModel.orderHour];
            self.m_TimeLengthItem.values = @[value];
        }

        self.m_ContentItem.value = self.m_CreateModel.meetingContent;
    }
    else
    {
        self.m_CreateModel.meetingType = [FSMeetingDataEnum meetingTypeMediateEnglish];
        self.m_CreateModel.orderHour = @"1";
        NSString *value = [NSString stringWithFormat:@"%@小时", self.m_CreateModel.orderHour];
        self.m_TimeLengthItem.values = @[value];
    }
}

-(void)freshViews
{
    [super freshViews];

    if (self.m_IsStartImmediately)
    {
        if ([self.m_MainSection.items containsObject:self.m_ChooseTimeItem])
        {
            [self.m_MainSection removeItem:self.m_ChooseTimeItem];
        }
    }
    else
    {
        if (![self.m_MainSection.items containsObject:self.m_ChooseTimeItem])
        {
            if (self.m_ChooseTimeItem.pickerDate == nil) {
                NSTimeInterval timeInterval = [self latestFiveExactlyTime];
                self.m_ChooseTimeItem.minLimitDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                self.m_ChooseTimeItem.pickerDate = self.m_ChooseTimeItem.minLimitDate;
                self.m_CreateModel.startTime = timeInterval * 1000;
            }
            [self.m_MainSection insertItem:self.m_ChooseTimeItem atIndex:3];
        }
    }

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.m_TableView.bm_width-28, 24)];
    label.text = [self selectedLitigantCount];
    label.textColor = UI_COLOR_B4;
    label.font = UI_FONT_12;
    [view addSubview:label];
    self.m_PersonSection.headerView = view;
    
    [self.m_PersonSection removeAllItems];
    BMWeakSelf
    for (FSMeetingPersonnelModel *model in self.m_AttendedList)
    {
        FSMeetingPersonnelItem *item = [FSMeetingPersonnelItem item];
        item.personModel = model;
        item.personnelSelectionHandler = ^(FSMeetingPersonnelModel *personModel) {
            [weakSelf freshViews];
        };
        [self.m_PersonSection addItem:item];
    }
    
    [self.m_TableView reloadData];
}

- (NSMutableArray *)m_AttendedList
{
    if (_m_AttendedList == nil) {
        _m_AttendedList = [NSMutableArray array];
        [_m_AttendedList addObject:[FSMeetingPersonnelModel userModel]];
    }
    
    return _m_AttendedList;
}

- (NSArray *)litigantListWithoutMediator
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (FSMeetingPersonnelModel *model in self.m_AttendedList)
    {
        if ([model isMediatorPerson] || model.selectState == 0) {
            continue;
        }
        
        FSMeetingPersonnelModel *newPerson = [FSMeetingPersonnelModel new];
        newPerson.userName = model.userName;
        newPerson.mobilePhone = model.mobilePhone;
        newPerson.meetingIdentityTypeEnums = model.meetingIdentityTypeEnums;
        newPerson.personnelId = model.personnelId;
        newPerson.selectState = model.selectState;
        [temp addObject:newPerson];
    }

    return [NSArray arrayWithArray:temp];
}

- (NSString *)selectedLitigantCount {
    NSInteger count = 0;
    for (FSMeetingPersonnelModel *model in self.m_AttendedList)
    {
        if (model.isMediatorPerson || model.selectState == 1) {
            count ++;
        }
    }
    return [NSString stringWithFormat:@"参与人员：%@人",@(count)];
}

- (void)updateAttendedLitWithoutMediator:(NSArray *)list
{
//    for (NSInteger index = self.m_AttendedList.count-1; index >= 0; index--) {
//        FSMeetingPersonnelModel *model = self.m_AttendedList[index];
//        if (![model isMediatorPerson]) {
//            [self.m_AttendedList removeObject:model];
//        }
//    }
    
    [self.m_AttendedList addObjectsFromArray:list];
    [self freshViews];
}

- (void)inviteAction
{
    if ([self litigantListWithoutMediator].count  >= FSMEETING_PERSON_MAX_COUNT-1)
    {
        [self.m_ProgressHUD showAnimated:YES withText:FSMEETING_PERSON_MAXCOUNT_TIP delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    
    FSVideoInviteLitigantVC *vc = [FSVideoInviteLitigantVC new];
    vc.existingLitigantList = [self litigantListWithoutMediator];
    BMWeakSelf
    vc.inviteComplete = ^(NSArray *litigantList) {
        [weakSelf updateAttendedLitWithoutMediator:litigantList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bottomButtonClickAction
{
    if (_m_IsStartImmediately)
    {
        // 立即开始 设置为下一个能被5分钟整除的时间
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        NSString *string = [NSString stringWithFormat:@"%0.0lf",timeInterval];
        long long longTimeInterval = [string longLongValue];
        longTimeInterval += 10; // 立即开始时间延后十秒
        self.m_CreateModel.startTime = longTimeInterval * 1000;
    }
    else
    {
        if (self.m_CreateModel.startTime == 0) {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请选择时间" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
        if (self.m_CreateModel.startTime < timeInterval) {
            isTimePast = YES;
            timeInterval = [self latestFiveExactlyTime];
            self.m_CreateModel.startTime = timeInterval * 1000;
        }
    }
    
    // 去掉小数点
    NSString *numStr = [NSString stringWithFormat:@"%0.0lf",self.m_CreateModel.startTime];
    self.m_CreateModel.startTime = [numStr doubleValue];

    self.m_CreateModel.meetingPersonnelResponseDTO = self.m_AttendedList;
    [self sendSaveMeetingRequest];
}

// 最近的5分钟正点
- (NSTimeInterval)latestFiveExactlyTime
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *string = [NSString stringWithFormat:@"%0.0lf",timeInterval];
    long long longTimeInterval = [string longLongValue];
    NSTimeInterval remainder = longTimeInterval%(5*60);
    longTimeInterval -= remainder;
    longTimeInterval += 5*60;
    return longTimeInterval;
}

- (void)sendSaveMeetingRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request;
    if (FSMakeVideoMediateMode_Edit == self.makeMode) {
        request = [FSApiRequest editMeetingWithInfo:[self.m_CreateModel formToParametersWithPersonnelId:YES]];
    } else {
        request = [FSApiRequest saveMeetingWithInfo:[self.m_CreateModel formToParametersWithPersonnelId:NO]];
    }
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
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [self saveRequestFinished:response responseDic:responseObject];
            }
        }];
        [task resume];
    }
}

- (void)saveRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
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
            FSMeetingDetailModel *mode = [FSMeetingDetailModel modelWithParams:dataDic];

            if (isTimePast) {
                NSString *tip = [NSString stringWithFormat:@"预约时间已过期，系统已调整到%@", [NSDate bm_stringFromTs:mode.startTime*0.001 formatter:@"HH:mm"]];
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:tip delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            if (FSMakeVideoMediateMode_Edit == self.makeMode) {
                [[NSNotificationCenter defaultCenter] postNotificationName:FSVideoMediateChangedNotification object:mode userInfo:nil];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:FSMakeVideoMediateSuccessNotification object:nil userInfo:nil];
            }

            if (_m_IsStartImmediately) {
                self.m_DetailModel = mode;
                self.view.userInteractionEnabled = NO;
                [self startMeeting];
            } else {
                if (FSMakeVideoMediateMode_Edit == self.makeMode) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:@"提交成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    [self backToVideoMediateList];
                }
            }
            
            return;
        }
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

- (void)backToVideoMediateList
{
    NSArray *listVC = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, 2)];
    [self.navigationController setViewControllers:listVC animated:YES];
}

#pragma mark -
#pragma mark  直接进入会议

- (void)startMeeting
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest startMeetingWithId:self.m_DetailModel.meetingId];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                [self backToVideoMediateList];
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                NSDictionary *resDic = responseObject;
                if (![resDic bm_isNotEmptyDictionary])
                {
                    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    [self backToVideoMediateList];

                    return;
                }
                
                NSInteger statusCode = [resDic bm_intForKey:@"code"];
                if (statusCode == 1000)
                {
                    [self joinRoom];
                    [[NSNotificationCenter defaultCenter] postNotificationName:FSVideoMediateChangedNotification object:nil userInfo:nil];
                    return;
                }
                
                NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                [self backToVideoMediateList];
            }
        }];
        [task resume];
    }
}

- (void)joinRoom
{
    FSMeetingPersonnelModel *model = [_m_DetailModel getMeetingMediator];
    BMWeakSelf
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableURLRequest *request = [FSApiRequest getJoinMeetingToken:model.inviteCode inviteName:model.userName];
        if (request)
        {
            [self.m_ProgressHUD showAnimated:YES showBackground:NO];
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error)
                {
                    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    [self backToVideoMediateList];
                }
                else
                {
#ifdef DEBUG
                    NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                    BMLog(@"%@ %@", response, responseStr);
#endif
                    NSDictionary *resDic = responseObject;
                    if (![resDic bm_isNotEmptyDictionary])
                    {
                        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                        [self backToVideoMediateList];
                        
                        return;
                    }
                    

                    NSInteger statusCode = [resDic bm_intForKey:@"code"];
                    if (statusCode == 1000)
                    {
                        NSDictionary *data = [resDic bm_dictionaryForKey:@"data"];
                        VideoCallController *vc = [VideoCallController VCWithRoomId:_m_DetailModel.roomId meetingId:_m_DetailModel.meetingId token:data[@"token"]];
                        BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:vc];
                        [weakSelf presentViewController:nav animated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:FSVideoMediateChangedNotification object:nil userInfo:nil];
                        [self backToVideoMediateList];
                        return;
                    }
                    
                    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES withText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    [self backToVideoMediateList];
                }
            }];
            [task resume];
        }
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
