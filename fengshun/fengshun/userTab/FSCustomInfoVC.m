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
#import "FSEditorAbilityVC.h"
#import "FSEditorVC.h"


@interface FSCustomInfoVC ()
<
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource,
    FSEditorDelegate,
    FSAuthenticationDelegate,
    FSEditorAbilityDelegate
>

@property (nonatomic, strong) BMTableViewSection *m_BaseSection;
@property (nonatomic, strong) BMTableViewItem *m_AvatarItem;
@property (nonatomic, strong) BMTableViewItem *m_NikeNameItem;
@property (nonatomic, strong) BMTableViewItem *m_RealNameItem;

@property (nonatomic, strong) BMTableViewSection *m_WorkSection;
@property (nonatomic, strong) BMTableViewItem *m_OrganizationItem;
@property (nonatomic, strong) BMTableViewItem *m_JobItem;
@property (nonatomic, strong) BMTextItem *m_WorkingLifeItem;

@property (nonatomic, strong) BMTableViewSection *m_AbilitySection;
@property (nonatomic, strong) BMTableViewItem *m_AbilityItem;

@property (nonatomic, strong) BMTableViewSection *m_SignatureSection;
@property (nonatomic, strong) BMTableViewItem *m_SignatureItem;

@property (nonatomic, strong) NSURLSessionDataTask *m_UserInfoTask;

@property (nonatomic, weak) TTGTagCollectionView *m_AbilityCollectionView;
@property (nonatomic, strong) NSMutableArray *m_AbilityViewArray;

@property (nonatomic, strong) BMSingleLineView *m_UnderLineView;

@property (nonatomic, strong) BMDatePicker *m_PickerView;

@property (nonatomic, strong) NSURLSessionDataTask *m_UpdateTask;

@property (nonatomic, assign) NSUInteger m_EmploymentTime;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    BMWeakSelf

    BMDatePicker *datePicker = [[BMDatePicker alloc] initWithPickerStyle:PickerStyle_Year completeBlock:nil];
    datePicker.maxLimitDate = [NSDate date];
    datePicker.showDoneBtn = NO;
    self.m_PickerView = datePicker;

    self.m_BaseSection = [BMTableViewSection section];
    self.m_WorkSection = [BMTableViewSection section];
    self.m_AbilitySection = [BMTableViewSection section];
    self.m_SignatureSection = [BMTableViewSection section];

    self.m_AvatarItem = [BMTableViewItem itemWithTitle:@"头像" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_AvatarItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AvatarItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AvatarItem.cellHeight = 70.0f;
    
    self.m_NikeNameItem = [BMTableViewItem itemWithTitle:@"昵称" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_NikeNameItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_NikeNameItem.highlightBgColor = UI_COLOR_BL1;
    self.m_NikeNameItem.cellHeight = 50.0f;

    self.m_RealNameItem = [BMTableViewItem itemWithTitle:@"实名认证" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
    }];
    self.m_RealNameItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_RealNameItem.highlightBgColor = UI_COLOR_BL1;
    self.m_RealNameItem.cellHeight = 50.0f;

    self.m_BaseSection.headerHeight = 10.0f;
    self.m_BaseSection.footerHeight = 0.0f;
    [self.m_BaseSection addItem:self.m_AvatarItem];
    [self.m_BaseSection addItem:self.m_NikeNameItem];
    [self.m_BaseSection addItem:self.m_RealNameItem];

    self.m_OrganizationItem = [BMTableViewItem itemWithTitle:@"所属单位" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_OrganizationItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_OrganizationItem.highlightBgColor = UI_COLOR_BL1;
    self.m_OrganizationItem.cellHeight = 50.0f;

    self.m_JobItem = [BMTableViewItem itemWithTitle:@"职位" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_JobItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_JobItem.highlightBgColor = UI_COLOR_BL1;
    self.m_JobItem.cellHeight = 50.0f;

    self.m_WorkingLifeItem = [BMTextItem itemWithTitle:@"工作年限" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_WorkingLifeItem.hideInputView = YES;
    self.m_WorkingLifeItem.editable = YES;
    self.m_WorkingLifeItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_WorkingLifeItem.highlightBgColor = UI_COLOR_BL1;
    self.m_WorkingLifeItem.cellHeight = 50.0f;
    self.m_WorkingLifeItem.inputView = self.m_PickerView;
    self.m_WorkingLifeItem.onEndEditing = ^(BMInputItem *item) {
        //NSLog(@"onEndEditing: %@", @(weakSelf.m_PickerView.pickerDate.bm_year));
        weakSelf.m_EmploymentTime = weakSelf.m_PickerView.pickerDate.bm_year;
        
        FSUserInfoModle *userInfo = [FSUserInfoModle userInfo];
        if (weakSelf.m_EmploymentTime != userInfo.m_UserBaseInfo.m_EmploymentTime)
        {
            [weakSelf sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_WorkTime changeValue:@(weakSelf.m_EmploymentTime)];
        }
    };

    self.m_WorkSection.headerHeight = 10.0f;
    self.m_WorkSection.footerHeight = 0.0f;
    [self.m_WorkSection addItem:self.m_OrganizationItem];
    [self.m_WorkSection addItem:self.m_JobItem];
    [self.m_WorkSection addItem:self.m_WorkingLifeItem];

    self.m_AbilityItem = [BMTableViewItem itemWithTitle:@"擅长领域" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_AbilityItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AbilityItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AbilityItem.cellHeight = 50.0f;

    self.m_AbilitySection.headerHeight = 0.0f;
    self.m_AbilitySection.footerHeight = 0.0f;
    [self.m_AbilitySection addItem:self.m_AbilityItem];

    self.m_SignatureItem = [BMTableViewItem itemWithTitle:@"个人签名" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_SignatureItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_SignatureItem.highlightBgColor = UI_COLOR_BL1;
    self.m_SignatureItem.cellHeight = 50.0f;

    self.m_SignatureSection.headerHeight = 0.0f;
    [self.m_SignatureSection addItem:self.m_SignatureItem];
    
    [self.m_TableManager addSection:self.m_BaseSection];
    [self.m_TableManager addSection:self.m_WorkSection];
    [self.m_TableManager addSection:self.m_AbilitySection];
    [self.m_TableManager addSection:self.m_SignatureSection];
    
    [self freshViews];
    
    [self loadApiData];
}

- (void)freshViews
{
    FSUserInfoModle *userInfo = [FSUserInfoModle userInfo];
    
    BMWeakSelf
    
    BMImageTextView *imageTextView = [[BMImageTextView alloc] initWithAttributedText:nil image:nil];
    imageTextView.imageSize = CGSizeMake(60.0f, 60.0f);
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.circleImage = YES;
    imageTextView.showTableCellAccessoryArrow = YES;
    imageTextView.imageUrl = userInfo.m_UserBaseInfo.m_AvatarUrl;
    imageTextView.placeholderImageName = @"default_avatariconlarge";
    self.m_AvatarItem.accessoryView = imageTextView;
    
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
    
    if ([userInfo.m_UserBaseInfo.m_RealName bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_RealName;
        self.m_RealNameItem.selectionHandler = nil;
        imageTextView.showTableCellAccessoryArrow = NO;
        self.m_RealNameItem.enabled = NO;
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
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_RealNameItem.accessoryView = imageTextView;

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
    self.m_OrganizationItem.accessoryView = imageTextView;
    self.m_OrganizationItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Organization minWordCount:0 maxnWordCount:100 text:userInfo.m_UserBaseInfo.m_Organization placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };

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
    self.m_JobItem.accessoryView = imageTextView;
    self.m_JobItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Job minWordCount:0 maxnWordCount:50 text:userInfo.m_UserBaseInfo.m_Job placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };

    if (userInfo.m_UserBaseInfo.m_EmploymentTime > 1950)
    {
        if (userInfo.m_UserBaseInfo.m_WorkingLife > 0)
        {
            text = [NSString stringWithFormat:@"%@年", @(userInfo.m_UserBaseInfo.m_WorkingLife)];
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
        self.m_UnderLineView.needGap = YES;
        [view addSubview:self.m_UnderLineView];

        self.m_AbilityItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
        self.m_AbilitySection.footerView = view;
        self.m_AbilitySection.footerHeight = view.bm_height;
    }
    else
    {
        text = @"请选择";
        self.m_AbilityItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorLeftInset;
        self.m_AbilitySection.footerView = nil;
        self.m_AbilitySection.footerHeight = 0.0f;
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_AbilityItem.accessoryView = imageTextView;
    self.m_AbilityItem.selectionHandler = ^(id item) {
        if (GetAppDelegate.m_Globle_UserAbilityInfo)
        {
            FSEditorAbilityVC *editorVC = [[FSEditorAbilityVC alloc] init];
            editorVC.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:editorVC animated:YES];
        }
        else
        {
            
        }
    };

    if ([userInfo.m_UserBaseInfo.m_Signature bm_isNotEmpty])
    {
        text = @"修改";
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 0, UI_SCREEN_WIDTH-50.0f, 60.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UI_COLOR_B4;
        label.numberOfLines = 0;
        label.font = UI_FONT_12;
        label.text = userInfo.m_UserBaseInfo.m_Signature;
        //label.text = @"一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下一句话表达下";
        CGSize size = [label sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH-50.0f, 1000)];
        label.bm_height = size.height;
        [view addSubview:label];
        view.bm_height = label.bm_height + 8.0f;

        self.m_SignatureSection.footerView = view;
        self.m_SignatureSection.footerHeight = view.bm_height;
    }
    else
    {
        text = @"一句话表达下";
        self.m_SignatureSection.footerView = nil;
        self.m_SignatureSection.footerHeight = 0.0f;
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

    [self.m_TableView reloadData];
}

- (void)makeAbilityViewWithArray:(NSArray *)abilityArray
{
    self.m_AbilityViewArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *ability in abilityArray)
    {
        CGFloat width = [ability bm_widthToFitHeight:20 withFont:[UIFont systemFontOfSize:12.0f]] + 12.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 26.0f)];
        label.backgroundColor = [UIColor bm_colorWithHex:0xF0F0F0];
        label.font = [UIFont systemFontOfSize:10.0f];
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
    FSUserInfoModle *userInfo = [FSUserInfoModle userInfo];
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


#pragma mark -
#pragma mark send request

// 更新用户信息
- (void)sendUpdateUserInfoWithOperaType:(FSUpdateUserInfoOperaType)operaType changeValue:(id)value
{
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
#if DEBUG
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
    
#if DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"更新返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        NSDictionary *dataDic = [resDic bm_dictionaryForKey:@"data"];
        if ([dataDic bm_isNotEmptyDictionary])
        {
            NSUInteger workingLife = [dataDic bm_uintForKey:@"workingLife"];
        
            FSUserInfoModle *userInfo = [FSUserInfoModle userInfo];
            userInfo.m_UserBaseInfo.m_EmploymentTime = self.m_EmploymentTime;
            userInfo.m_UserBaseInfo.m_WorkingLife = workingLife;

            [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
            GetAppDelegate.m_UserInfo = userInfo;

            [self freshViews];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];

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
    FSUserInfoModle *userInfo = [FSUserInfoModle userInfo];

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
            
        default:
            break;
    }
    
    [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
    GetAppDelegate.m_UserInfo = userInfo;
    
    [self freshViews];

    [[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];
}

@end
