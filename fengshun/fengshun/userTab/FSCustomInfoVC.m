//
//  FSCustomInfoVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/5.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCustomInfoVC.h"
#import "AppDelegate.h"

#import "TTGTagCollectionView.h"
#import "BMDatePicker.h"

#import "FSAuthenticationVC.h"
#import "FSSetPositionVC.h"
#import "FSEditorAbilityVC.h"
#import "FSEditorVC.h"

#import "TZImagePickerController.h"
#import "FSAddressPickerVC.h"

#import "FSSetCompanyVC.h"
#import "FSSetProfessionalVC.h"


@interface FSCustomInfoVC ()
<
    TZImagePickerControllerDelegate,
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource,
    FSEditorDelegate,
    FSAuthenticationDelegate,
    FSEditorAbilityDelegate,
    FSAddressPickerVCDelegate,
    FSSetTableViewVCDelegate
>

@property (nonatomic, strong) BMTableViewSection *m_BaseSection;
@property (nonatomic, strong) BMTableViewItem *m_AvatarItem;
@property (nonatomic, strong) BMTableViewItem *m_NikeNameItem;
@property (nonatomic, strong) BMTextItem *m_SexItem;
@property (nonatomic, strong) BMTextItem *m_BirthdayItem;
@property (nonatomic, strong) BMTableViewItem *m_SignatureItem;

@property (nonatomic, strong) BMTableViewSection *m_CertificationSection;
@property (nonatomic, strong) BMTableViewItem *m_RealNameItem;
@property (nonatomic, strong) BMTableViewItem *m_RealIdentityItem;

@property (nonatomic, strong) BMTableViewSection *m_WorkSection;
@property (nonatomic, strong) BMTableViewItem *m_OrganizationItem;
@property (nonatomic, strong) BMTableViewItem *m_JobItem;
@property (nonatomic, strong) BMTextItem *m_WorkingLifeItem;
@property (nonatomic, strong) BMTableViewItem *m_WorkAreaItem;
@property (nonatomic, strong) BMTableViewItem *m_AbilityItem;

@property (nonatomic, strong) BMTableViewSection *m_WorkExperienceSection;
@property (nonatomic, strong) BMTableViewItem *m_ProfessionalQualificationItem;
@property (nonatomic, strong) BMTableViewItem *m_WorkExperienceItem;

@property (nonatomic, strong) NSURLSessionDataTask *m_UserInfoTask;

@property (nonatomic, weak) TTGTagCollectionView *m_AbilityCollectionView;
@property (nonatomic, strong) NSMutableArray *m_AbilityViewArray;

@property (nonatomic, strong) BMSingleLineView *m_UnderLineView;

@property (nonatomic, strong) BMDatePicker *m_SexPickerView;
@property (nonatomic, strong) BMDatePicker *m_BirthPickerView;
@property (nonatomic, strong) BMDatePicker *m_WorkPickerView;

@property (nonatomic, strong) NSURLSessionDataTask *m_UpdateTask;

// 存储传递数据
@property (nonatomic, strong) NSString *m_Sex;
@property (nonatomic, assign) NSTimeInterval m_Birthday;
@property (nonatomic, assign) NSUInteger m_EmploymentTime;
@property (nonatomic, strong) NSString *m_WorkArea;
@property (nonatomic, strong) NSString *m_ProfessionalQualification;

@property (nonatomic, assign) FSUpdateUserInfoOperaType m_OperaType;
@property (nonatomic, strong) NSString *m_AvatarUrl;

@end

@implementation FSCustomInfoVC

- (void)dealloc
{
    [_m_UserInfoTask cancel];
    _m_UserInfoTask = nil;

    [_m_UpdateTask cancel];
    _m_UpdateTask = nil;
}

- (BMFreshViewType)getFreshViewType
{
    return BMFreshViewType_Head;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;

    [self bm_setNavigationWithTitle:@"个人信息" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self interfaceSettings];
}

- (BOOL)needKeyboardEvent
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    BMWeakSelf

    self.m_BaseSection = [BMTableViewSection section];
    self.m_CertificationSection = [BMTableViewSection section];
    self.m_WorkSection = [BMTableViewSection section];
    self.m_WorkExperienceSection = [BMTableViewSection section];

    
    // 头像
    self.m_AvatarItem = [BMTableViewItem itemWithTitle:@"头像" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        [weakSelf openPhoto];
    }];
    self.m_AvatarItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AvatarItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AvatarItem.cellHeight = 70.0f;
    
    // 昵称
    self.m_NikeNameItem = [BMTableViewItem itemWithTitle:@"昵称" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_NikeNameItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_NikeNameItem.highlightBgColor = UI_COLOR_BL1;
    self.m_NikeNameItem.cellHeight = 50.0f;

    // 性别
    BMDatePicker *datePicker = [[BMDatePicker alloc] initWithPickerStyle:PickerStyle_Sex completeBlock:nil];
    datePicker.pickerCurrentItemColor = [UIColor bm_colorWithHex:UI_NAVIGATION_BGCOLOR_VALU];
    datePicker.showFormateLabel = NO;
    datePicker.showYearLabel = NO;
    datePicker.showDoneBtn = NO;
    self.m_SexPickerView = datePicker;

    self.m_SexItem = [BMTextItem itemWithTitle:@"性别" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_SexItem.hideInputView = YES;
    self.m_SexItem.editable = YES;
    self.m_SexItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_SexItem.highlightBgColor = UI_COLOR_BL1;
    self.m_SexItem.cellHeight = 50.0f;
    self.m_SexItem.inputView = self.m_SexPickerView;
    self.m_SexItem.onEndEditing = ^(BMInputItem *item) {
        NSLog(@"onEndEditing: %@", weakSelf.m_SexPickerView.pickerSex);
        
        weakSelf.m_Sex = weakSelf.m_SexPickerView.pickerSex;
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        if (![weakSelf.m_Sex isEqualToString:userInfo.m_UserBaseInfo.m_Sex])
        {
            [weakSelf sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_Sex changeValue:weakSelf.m_Sex];
        }
    };

    // 生日
    datePicker = [[BMDatePicker alloc] initWithPickerStyle:PickerStyle_MonthDayYear completeBlock:nil];
    datePicker.maxLimitDate = [NSDate date];
    datePicker.pickerCurrentItemColor = [UIColor bm_colorWithHex:UI_NAVIGATION_BGCOLOR_VALU];
    datePicker.pickerLabelColor = [UIColor bm_colorWithHex:UI_NAVIGATION_BGCOLOR_VALU];
    datePicker.pickerLabelTitleArray = nil;
    datePicker.showChineseMonth = YES;
    datePicker.showDoneBtn = NO;
    //datePicker.showFormateLabel = NO;
    self.m_BirthPickerView = datePicker;

    self.m_BirthdayItem = [BMTextItem itemWithTitle:@"生日" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_BirthdayItem.hideInputView = YES;
    self.m_BirthdayItem.editable = YES;
    self.m_BirthdayItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_BirthdayItem.highlightBgColor = UI_COLOR_BL1;
    self.m_BirthdayItem.cellHeight = 50.0f;
    self.m_BirthdayItem.inputView = self.m_BirthPickerView;
    self.m_BirthdayItem.onEndEditing = ^(BMInputItem *item) {
        NSLog(@"onEndEditing: %@", [weakSelf.m_BirthPickerView.pickerDate bm_stringWithDefaultFormat]);
        
        weakSelf.m_Birthday = [weakSelf.m_BirthPickerView.pickerDate timeIntervalSince1970];
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        if (weakSelf.m_Birthday != userInfo.m_UserBaseInfo.m_Birthday)
        {
            [weakSelf sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_Birthday changeValue:[NSDate bm_stringFromTs:weakSelf.m_Birthday formatter:@"yyyy-MM-dd"]];
        }
    };

    // 个人签名
    self.m_SignatureItem = [BMTableViewItem itemWithTitle:@"个人签名" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_SignatureItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_SignatureItem.highlightBgColor = UI_COLOR_BL1;
    self.m_SignatureItem.cellHeight = 50.0f;
    
    self.m_BaseSection.headerHeight = 10.0f;
    self.m_BaseSection.footerHeight = 0.0f;
    [self.m_BaseSection addItem:self.m_AvatarItem];
    [self.m_BaseSection addItem:self.m_NikeNameItem];
    [self.m_BaseSection addItem:self.m_SexItem];
    [self.m_BaseSection addItem:self.m_BirthdayItem];
    [self.m_BaseSection addItem:self.m_SignatureItem];

    
    // 实名认证
    self.m_RealNameItem = [BMTableViewItem itemWithTitle:@"实名认证" imageName:@"user_notpasscertification" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
    }];
    self.m_RealNameItem.imageH = 20.0f;
    self.m_RealNameItem.imageW = 49.0f;
    self.m_RealNameItem.imageAtback = YES;
    self.m_RealNameItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_RealNameItem.highlightBgColor = UI_COLOR_BL1;
    self.m_RealNameItem.cellHeight = 50.0f;
    
    // 身份认证
    self.m_RealIdentityItem = [BMTableViewItem itemWithTitle:@"身份认证" imageName:@"user_notpasscertification" underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
    }];
    self.m_RealIdentityItem.imageH = 20.0f;
    self.m_RealIdentityItem.imageW = 49.0f;
    self.m_RealIdentityItem.imageAtback = YES;
    self.m_RealIdentityItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_RealIdentityItem.highlightBgColor = UI_COLOR_BL1;
    self.m_RealIdentityItem.cellHeight = 50.0f;
    
    self.m_CertificationSection.headerHeight = 10.0f;
    [self.m_CertificationSection addItem:self.m_RealNameItem];
    [self.m_CertificationSection addItem:self.m_RealIdentityItem];

    
    // 单位信息
    self.m_OrganizationItem = [BMTableViewItem itemWithTitle:@"所属单位" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_OrganizationItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_OrganizationItem.highlightBgColor = UI_COLOR_BL1;
    self.m_OrganizationItem.cellHeight = 50.0f;

    // 职位
    self.m_JobItem = [BMTableViewItem itemWithTitle:@"职位" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_JobItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_JobItem.highlightBgColor = UI_COLOR_BL1;
    self.m_JobItem.cellHeight = 50.0f;

    // 工作年限
    datePicker = [[BMDatePicker alloc] initWithPickerStyle:PickerStyle_Year completeBlock:nil];
    datePicker.pickerCurrentItemColor = [UIColor bm_colorWithHex:UI_NAVIGATION_BGCOLOR_VALU];
    datePicker.pickerLabelColor = [UIColor bm_colorWithHex:UI_NAVIGATION_BGCOLOR_VALU];
    datePicker.maxLimitDate = [NSDate date];
    datePicker.showDoneBtn = NO;
    datePicker.showFormateLabel = NO;
    self.m_WorkPickerView = datePicker;
    
    self.m_WorkingLifeItem = [BMTextItem itemWithTitle:@"工作年限" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_WorkingLifeItem.hideInputView = YES;
    self.m_WorkingLifeItem.editable = YES;
    self.m_WorkingLifeItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_WorkingLifeItem.highlightBgColor = UI_COLOR_BL1;
    self.m_WorkingLifeItem.cellHeight = 50.0f;
    self.m_WorkingLifeItem.inputView = self.m_WorkPickerView;
    self.m_WorkingLifeItem.onEndEditing = ^(BMInputItem *item) {
        //NSLog(@"onEndEditing: %@", @(weakSelf.m_PickerView.pickerDate.bm_year));
        weakSelf.m_EmploymentTime = weakSelf.m_WorkPickerView.pickerDate.bm_year;
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        if (weakSelf.m_EmploymentTime != userInfo.m_UserBaseInfo.m_EmploymentTime)
        {
            [weakSelf sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_WorkTime changeValue:@(weakSelf.m_EmploymentTime)];
        }
    };

    // 工作区域
    self.m_WorkAreaItem = [BMTableViewItem itemWithTitle:@"工作区域" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        FSAddressPickerVC *vc = [[FSAddressPickerVC alloc] init];
        vc.delegate = weakSelf;
        
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        weakSelf.modalPresentationStyle = UIModalPresentationCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [weakSelf presentViewController:vc animated:YES completion:^{
            
        }];
    }];
    self.m_WorkAreaItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_WorkAreaItem.highlightBgColor = UI_COLOR_BL1;
    self.m_WorkAreaItem.cellHeight = 50.0f;

    // 擅长领域
    self.m_AbilityItem = [BMTableViewItem itemWithTitle:@"擅长领域" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_AbilityItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AbilityItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AbilityItem.cellHeight = 50.0f;
    
    self.m_WorkSection.headerHeight = 10.0f;
    self.m_WorkSection.footerHeight = 0.0f;
    [self.m_WorkSection addItem:self.m_OrganizationItem];
    [self.m_WorkSection addItem:self.m_JobItem];
    [self.m_WorkSection addItem:self.m_WorkingLifeItem];
    [self.m_WorkSection addItem:self.m_WorkAreaItem];
    [self.m_WorkSection addItem:self.m_AbilityItem];


    // 专业职务
    self.m_ProfessionalQualificationItem = [BMTableViewItem itemWithTitle:@"专业任职" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_ProfessionalQualificationItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_ProfessionalQualificationItem.highlightBgColor = UI_COLOR_BL1;
    self.m_ProfessionalQualificationItem.cellHeight = 50.0f;

    // 工作经历
    self.m_WorkExperienceItem = [BMTableViewItem itemWithTitle:@"工作经历" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_WorkExperienceItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_WorkExperienceItem.highlightBgColor = UI_COLOR_BL1;
    self.m_WorkExperienceItem.cellHeight = 50.0f;

    self.m_WorkExperienceSection.headerHeight = 0.0f;
    self.m_WorkExperienceSection.footerHeight = 0.0f;
    [self.m_WorkExperienceSection addItem:self.m_ProfessionalQualificationItem];
    [self.m_WorkExperienceSection addItem:self.m_WorkExperienceItem];

    [self.m_TableManager addSection:self.m_BaseSection];
    [self.m_TableManager addSection:self.m_CertificationSection];
    [self.m_TableManager addSection:self.m_WorkSection];
    [self.m_TableManager addSection:self.m_WorkExperienceSection];
    
    [self freshViews];
    
    [self loadApiData];
}

- (void)freshViews
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    
    BMWeakSelf
    
    // 头像
    BMImageTextView *imageTextView = [[BMImageTextView alloc] initWithAttributedText:nil image:nil];
    imageTextView.imageSize = CGSizeMake(60.0f, 60.0f);
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    //imageTextView.circleImage = YES;
    imageTextView.showTableCellAccessoryArrow = YES;
    imageTextView.imageUrl = userInfo.m_UserBaseInfo.m_AvatarUrl;
    imageTextView.placeholderImageName = @"default_avatariconlarge";
    imageTextView.afterSetimage = ^UIImage * _Nullable(BMImageTextView * _Nonnull imageTextView, UIImage * _Nullable image, CGSize imageSize) {
        UIImage *newImage = [image bm_bezierPathClipWithCornerRadius:image.size.width];
        newImage = [newImage bm_imageScalingToSize:imageSize];
        
        if (userInfo.m_UserBaseInfo.m_IsIdAuth)
        {
            UIImage *maskImage = [UIImage imageNamed:@"user_passcertification_icon"];
            CGRect rect = CGRectMake(newImage.size.width-18.0f, newImage.size.height-18.0f, 18.0f, 18.0f);
            newImage = [newImage imageWithWaterMask:maskImage inRect:rect];
        }
        
        return newImage;
    };
    
    self.m_AvatarItem.accessoryView = imageTextView;
    
    // 昵称
    NSString *text = nil;
    if ([userInfo.m_UserBaseInfo.m_NickName bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_NickName;
    }
    else
    {
        text = @"请填写";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_NikeNameItem.accessoryView = imageTextView;
    self.m_NikeNameItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_NickName minWordCount:0 maxnWordCount:8 text:userInfo.m_UserBaseInfo.m_NickName placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };

    // 性别
    if ([userInfo.m_UserBaseInfo.m_Sex bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_Sex;
        [self.m_SexPickerView scrollToSex:userInfo.m_UserBaseInfo.m_Sex animated:YES];
    }
    else
    {
        text = @"请选择";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_SexItem.accessoryView = imageTextView;

    // 生日
    if (userInfo.m_UserBaseInfo.m_Birthday != 0)
    {
        text = [NSDate bm_stringFromTs:userInfo.m_UserBaseInfo.m_Birthday formatter:@"yyyy-MM-dd"];
        [self.m_BirthPickerView scrollToDate:[NSDate dateWithTimeIntervalSince1970:userInfo.m_UserBaseInfo.m_Birthday] animated:YES];
    }
    else
    {
        text = @"请选择";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_BirthdayItem.accessoryView = imageTextView;

    // 个人签名
    if ([userInfo.m_UserBaseInfo.m_Signature bm_isNotEmpty])
    {
        text = @"修改";
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0, UI_SCREEN_WIDTH-40.0f, 60.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UI_COLOR_B4;
        label.numberOfLines = 0;
        label.font = UI_FONT_14;
        label.text = userInfo.m_UserBaseInfo.m_Signature;
        //label.text = @"一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下";
        CGSize size = [label sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH-40.0f, 1000)];
        label.bm_height = size.height;
        [view addSubview:label];
        view.bm_height = label.bm_height + 20.0f;
        
        self.m_BaseSection.footerView = view;
        self.m_BaseSection.footerHeight = view.bm_height;
    }
    else
    {
        text = @"一句话表达下";
        self.m_BaseSection.footerView = nil;
        self.m_BaseSection.footerHeight = 0.0f;
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    
    self.m_SignatureItem.accessoryView = imageTextView;
    self.m_SignatureItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Signature minWordCount:0 maxnWordCount:100 text:userInfo.m_UserBaseInfo.m_Signature placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };

    
    // 实名认证
    BMImageTextViewAccessoryArrowType accessoryArrowType = BMImageTextViewAccessoryArrowType_Show;
    if ([userInfo.m_UserBaseInfo.m_RealName bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_RealName;
        self.m_RealNameItem.selectionHandler = nil;
        self.m_RealNameItem.enabled = NO;
        accessoryArrowType = BMImageTextViewAccessoryArrowType_HideInplace;
        self.m_RealNameItem.image = [UIImage imageNamed:@"user_passcertification"];
    }
    else
    {
        text = @"未认证";
        self.m_RealNameItem.selectionHandler = ^(id item) {
            FSAuthenticationVC *vc = [[FSAuthenticationVC alloc] init];
            vc.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        self.m_RealNameItem.enabled = YES;
        self.m_RealNameItem.image = [UIImage imageNamed:@"user_notpasscertification"];
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text ];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.accessoryArrowType = accessoryArrowType;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_RealNameItem.accessoryView = imageTextView;
    
    // 身份认证
    accessoryArrowType = BMImageTextViewAccessoryArrowType_HideInplace;//BMImageTextViewAccessoryArrowType_Show;
    if (userInfo.m_UserBaseInfo.m_IsIdAuth && [userInfo.m_UserBaseInfo.m_Job bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_Job;
        self.m_RealIdentityItem.selectionHandler = nil;
        self.m_RealIdentityItem.enabled = NO;
        //accessoryArrowType = BMImageTextViewAccessoryArrowType_HideInplace;
        self.m_RealIdentityItem.image = [UIImage imageNamed:@"user_passcertification"];
    }
    else
    {
        text = @"未认证";
        self.m_RealIdentityItem.selectionHandler = nil;
//        self.m_RealIdentityItem.selectionHandler = ^(id item) {
//            FSSetPositionVC *vc = [[FSSetPositionVC alloc] init];
//            //vc.delegate = weakSelf;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        };
//        self.m_RealIdentityItem.enabled = YES;
        self.m_RealIdentityItem.enabled = NO;
        self.m_RealIdentityItem.image = [UIImage imageNamed:@"user_notpasscertification"];
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.accessoryArrowType = accessoryArrowType;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_RealIdentityItem.accessoryView = imageTextView;

    
    // 所属单位
    if ([userInfo.m_UserBaseInfo.m_Organization bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_Organization;
    }
    else
    {
        text = @"请填写";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    imageTextView.maxWidth = self.m_TableView.bm_width - 120.0f;
    self.m_OrganizationItem.accessoryView = imageTextView;
    self.m_OrganizationItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Organization minWordCount:0 maxnWordCount:100 text:userInfo.m_UserBaseInfo.m_Organization placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
        
        //FSSetCompanyVC *setCompanyVC = [[FSSetCompanyVC alloc] init];
        //[weakSelf.navigationController pushViewController:setCompanyVC animated:YES];
    };

    // 职位
    if ([userInfo.m_UserBaseInfo.m_Job bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_Job;
    }
    else
    {
        text = @"请填写";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    imageTextView.maxWidth = self.m_TableView.bm_width - 120.0f;
    self.m_JobItem.accessoryView = imageTextView;
    self.m_JobItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Job minWordCount:0 maxnWordCount:50 text:userInfo.m_UserBaseInfo.m_Job placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };
    
    // 工作年限
    if (userInfo.m_UserBaseInfo.m_EmploymentTime > 1950)
    {
        if (userInfo.m_UserBaseInfo.m_WorkingLife > 0)
        {
            text = [NSString stringWithFormat:@"%@年", @(userInfo.m_UserBaseInfo.m_WorkingLife)];
            [self.m_WorkPickerView scrollToDate:[NSDate bm_dateWithYear:userInfo.m_UserBaseInfo.m_EmploymentTime month:1 day:1] animated:YES];
        }
        else
        {
            text = @"1年内";
        }
    }
    else
    {
        text = @"请选择";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_WorkingLifeItem.accessoryView = imageTextView;

    // 工作区域
    if ([userInfo.m_UserBaseInfo.m_WorkArea bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_WorkArea;
    }
    else
    {
        text = @"请选择";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    imageTextView.maxWidth = self.m_TableView.bm_width - 120.0f;
    self.m_WorkAreaItem.accessoryView = imageTextView;
    
    // 擅长领域
    if ([userInfo.m_UserBaseInfo.m_Ability bm_isNotEmpty])
    {
        text = @"修改";
        
        //NSArray *tags = @[@"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索", @"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索"];
        //[self makeAbilityViewWithArray:tags];
        [self makeAbilityViewWithArray:userInfo.m_UserBaseInfo.m_AbilityArray];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
        view.backgroundColor = [UIColor whiteColor];
        
        TTGTagCollectionView *collectionView = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(15.0f, 0, UI_SCREEN_WIDTH-30.0f, 60.0f)];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.horizontalSpacing = 12.0f;
        collectionView.verticalSpacing = 6.0f;
        collectionView.bm_height = collectionView.contentSize.height;
        [view addSubview:collectionView];
        view.bm_height = collectionView.bm_height + 8.0f;
        self.m_AbilityCollectionView = collectionView;
        [self.m_AbilityCollectionView reload];
        
        CGRect frame = CGRectMake(15.0f, view.bm_height-1, UI_SCREEN_WIDTH-15.0f, 1);
        self.m_UnderLineView = [[BMSingleLineView alloc] initWithFrame:frame];
        self.m_UnderLineView.lineColor = FS_LINECOLOR;
        self.m_UnderLineView.needGap = YES;
        [view addSubview:self.m_UnderLineView];

        self.m_AbilityItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
        self.m_WorkSection.footerView = view;
        self.m_WorkSection.footerHeight = view.bm_height;
    }
    else
    {
        text = @"请选择";
        self.m_AbilityItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorLeftInset;
        self.m_WorkSection.footerView = nil;
        self.m_WorkSection.footerHeight = 0.0f;
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_AbilityItem.accessoryView = imageTextView;
    self.m_AbilityItem.selectionHandler = ^(id item) {
        if (GetAppDelegate.m_Globle_UserAbilityInfo)
        {
            [weakSelf editAbility];
        }
        else
        {
            [GetAppDelegate getUserAbilityInfoWithVc:weakSelf];
        }
    };
    
    
    // 专业职务
    if ([userInfo.m_UserBaseInfo.m_ProfessionalQualification bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_ProfessionalQualification;
    }
    else
    {
        text = @"请填写";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_ProfessionalQualificationItem.accessoryView = imageTextView;
    self.m_ProfessionalQualificationItem.selectionHandler = ^(id item) {
        FSSetProfessionalVC *setProfessionalVC = [[FSSetProfessionalVC alloc] init];
        setProfessionalVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:setProfessionalVC animated:YES];
    };
    
    // 工作经历
    if ([userInfo.m_UserBaseInfo.m_WorkExperience bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_WorkExperience;
    }
    else
    {
        text = @"请填写";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_WorkExperienceItem.accessoryView = imageTextView;
    self.m_WorkExperienceItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_WorkExperience minWordCount:0 maxnWordCount:500 text:userInfo.m_UserBaseInfo.m_WorkExperience placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };
    
    [self.m_TableView reloadData];
}

- (void)editAbility
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    
    FSEditorAbilityVC *editorVC = [[FSEditorAbilityVC alloc] initWithAbilityArray:userInfo.m_UserBaseInfo.m_AbilityArray];
    editorVC.delegate = self;
    [self.navigationController pushViewController:editorVC animated:YES];
}

- (void)makeAbilityViewWithArray:(NSArray *)abilityArray
{
    self.m_AbilityViewArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *ability in abilityArray)
    {
        CGFloat width = [ability bm_widthToFitHeight:20 withFont:[UIFont systemFontOfSize:13.0f]] + 12.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 26.0f)];
        label.backgroundColor = [UIColor bm_colorWithHex:0xF0F0F0];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = ability;
        [label bm_roundedRect:4.0f];
        [self.m_AbilityViewArray addObject:label];
    }
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    NSMutableURLRequest *request = [FSApiRequest getUserInfo];
    return request;
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    [userInfo updateWithServerDic:requestDic isUpDateByUserInfoApi:YES];
    if (userInfo)
    {
        GetAppDelegate.m_UserInfo = userInfo;
        
        [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
        
        [self freshViews];
        
        return YES;
    }
    
    return NO;
}


#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index
{
    UIView *view = self.m_AbilityViewArray[index];
    return view.frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index
{
}


#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView
{
    return self.m_AbilityViewArray.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index
{
    return self.m_AbilityViewArray[index];
}


#pragma mark - 图片选择

- (void)openPhoto
{
    self.m_AvatarUrl = nil;

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];

    imagePickerVc.sortAscendingByModificationDate = NO;

    imagePickerVc.allowTakePicture = YES;

    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.showSelectBtn = NO;

    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    imagePickerVc.allowCrop = YES;
    // 设置竖屏下的裁剪尺寸
    // 200X200
//    CGFloat cropRectWidth = 200.0f/320.0f*UI_SCREEN_WIDTH;
//    CGFloat cropRectHeight = cropRectWidth;
    CGFloat cropRectWidth = UI_SCREEN_WIDTH;
    CGFloat cropRectHeight = cropRectWidth;

    imagePickerVc.cropRect = CGRectMake((UI_SCREEN_WIDTH-cropRectWidth)*0.5f, (UI_SCREEN_HEIGHT-cropRectHeight)*0.5f, cropRectWidth, cropRectHeight);
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    BMLog(@"用户点击了取消");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (![photos bm_isNotEmpty])
    {
        return;
    }

    UIImage *image = photos[0];
    
    [self.m_ProgressHUD showAnimated:YES showBackground:NO];

    BMWeakSelf
    [FSApiRequest uploadImg:UIImageJPEGRepresentation(image, 0.8f) success:^(id responseObject) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@", FS_URL_SERVER, FS_FILE_ADDRESS, [responseObject bm_stringTrimForKey:@"fileId"]];
        
        weakSelf.m_AvatarUrl = url;
        
        [weakSelf.m_ProgressHUD hideAnimated:NO];
        [weakSelf sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_AvatarImageUrl changeValue:url];

    } failure:^(NSError * _Nullable error) {
        
        [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"头像上传失败" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }];
}


#pragma mark -
#pragma mark send request

// 更新用户信息
- (void)sendUpdateUserInfoWithOperaType:(FSUpdateUserInfoOperaType)operaType changeValue:(id)value
{
    self.m_OperaType = operaType;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest updateUserInfoWithOperaType:operaType changeValue:(id)value];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_UpdateTask cancel];
        self.m_UpdateTask = nil;
        
        BMWeakSelf
        self.m_UpdateTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf updateRequestFailed:response error:error];
                
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf updateRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_UpdateTask resume];
    }
}

- (void)updateRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"更新返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];

        BOOL saveUserInfo = NO;
        switch (self.m_OperaType)
        {
            case FSUpdateUserInfo_WorkTime:
            {
                NSDictionary *dataDic = [resDic bm_dictionaryForKey:@"data"];
                if ([dataDic bm_isNotEmptyDictionary])
                {
                    NSUInteger workingLife = [dataDic bm_uintForKey:@"workingLife"];
                    
                    userInfo.m_UserBaseInfo.m_EmploymentTime = self.m_EmploymentTime;
                    userInfo.m_UserBaseInfo.m_WorkingLife = workingLife;
                    
                    saveUserInfo = YES;
                }
            }
                break;
                
            case FSUpdateUserInfo_AvatarImageUrl:
            {
                userInfo.m_UserBaseInfo.m_AvatarUrl = self.m_AvatarUrl;
                
                saveUserInfo = YES;
            }

            case FSUpdateUserInfo_Sex:
            {
                userInfo.m_UserBaseInfo.m_Sex = self.m_Sex;
                
                saveUserInfo = YES;
            }
                
            case FSUpdateUserInfo_Birthday:
            {
                userInfo.m_UserBaseInfo.m_Birthday = self.m_Birthday;
                
                saveUserInfo = YES;
            }
                
            case FSUpdateUserInfo_WorkArea:
            {
                userInfo.m_UserBaseInfo.m_WorkArea = self.m_WorkArea;
                
                saveUserInfo = YES;
            }

            case FSUpdateUserInfo_ProfessionalQualification:
            {
                userInfo.m_UserBaseInfo.m_ProfessionalQualification = self.m_ProfessionalQualification;
                
                saveUserInfo = YES;
            }

            default:
                break;
        }
        
        if (saveUserInfo)
        {
            [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
            GetAppDelegate.m_UserInfo = userInfo;
            
            [self freshViews];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];
            
            return;
        }
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

- (void)updateRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"更新失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}


#pragma mark -
#pragma mark FSEditorDelegate

- (void)editorFinishedWithOperaType:(FSUpdateUserInfoOperaType)operaType value:(NSString *)value
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];

    switch (operaType)
    {
        case FSUpdateUserInfo_NickName:
            userInfo.m_UserBaseInfo.m_NickName = value;
            break;
            
        case FSUpdateUserInfo_Organization:
            userInfo.m_UserBaseInfo.m_Organization = value;
            break;
            
        case FSUpdateUserInfo_Job:
            userInfo.m_UserBaseInfo.m_Job = value;
            break;
            
        case FSUpdateUserInfo_Signature:
            userInfo.m_UserBaseInfo.m_Signature = value;
            break;
            
        case FSUpdateUserInfo_WorkExperience:
            userInfo.m_UserBaseInfo.m_WorkExperience = value;
            break;
            
        default:
            break;
    }
    
    [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
    GetAppDelegate.m_UserInfo = userInfo;
    
    [self freshViews];

    //[[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];
}


#pragma mark -
#pragma mark FSEditorAbilityDelegate

- (void)editorAbilityFinished:(FSEditorAbilityVC *)vc ability:(NSString *)ability;
{
    [self freshViews];
}


#pragma mark -
#pragma mark FSAddressPickerVCDelegate

- (void)addressPickerPickAddressFinished:(NSString *)address
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    if (![address isEqualToString:userInfo.m_UserBaseInfo.m_WorkArea])
    {
        self.m_WorkArea = address;
        
        [self sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_WorkArea changeValue:self.m_WorkArea];
    }
}


#pragma mark -
#pragma mark FSSetTableViewVCDelegate

- (void)setProfessionalFinished:(NSString *)professionalQualifications
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    if (![professionalQualifications isEqualToString:userInfo.m_UserBaseInfo.m_ProfessionalQualification])
    {
        self.m_ProfessionalQualification = professionalQualifications;
        
        [self sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_ProfessionalQualification changeValue:self.m_ProfessionalQualification];
    }
}

@end
