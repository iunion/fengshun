//
//  FSCustomInfoVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/5.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCustomInfoVC.h"
#import "AppDelegate.h"

@interface FSCustomInfoVC ()

@property (nonatomic, strong) BMTableViewSection *m_BaseSection;
@property (nonatomic, strong) BMTableViewItem *m_AvatarItem;
@property (nonatomic, strong) BMTableViewItem *m_NikeNameItem;
@property (nonatomic, strong) BMTableViewItem *m_RealNameItem;

@property (nonatomic, strong) BMTableViewSection *m_WorkSection;
@property (nonatomic, strong) BMTableViewItem *m_OrganizationItem;
@property (nonatomic, strong) BMTableViewItem *m_JobItem;
@property (nonatomic, strong) BMTableViewItem *m_WorkingLifeItem;

@property (nonatomic, strong) BMTableViewSection *m_AbilitySection;
@property (nonatomic, strong) BMTableViewItem *m_AbilityItem;

@property (nonatomic, strong) BMTableViewSection *m_SignatureSection;
@property (nonatomic, strong) BMTableViewItem *m_SignatureItem;

@property (nonatomic, strong) NSURLSessionDataTask *m_UserInfoTask;

@end

@implementation FSCustomInfoVC

- (void)dealloc
{
    [_m_UserInfoTask cancel];
    _m_UserInfoTask = nil;
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
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_BaseSection = [BMTableViewSection section];
    self.m_WorkSection = [BMTableViewSection section];
    self.m_AbilitySection = [BMTableViewSection section];
    self.m_SignatureSection = [BMTableViewSection section];

    self.m_AvatarItem = [BMTableViewItem itemWithTitle:@"头像" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_AvatarItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AvatarItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AvatarItem.cellHeight = 70.0f;
    
    self.m_NikeNameItem = [BMTableViewItem itemWithTitle:@"昵称" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
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

    self.m_WorkingLifeItem = [BMTableViewItem itemWithTitle:@"工作年限" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_WorkingLifeItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_WorkingLifeItem.highlightBgColor = UI_COLOR_BL1;
    self.m_WorkingLifeItem.cellHeight = 50.0f;

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
    
    if ([userInfo.m_UserBaseInfo.m_RealName bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_RealName;
    }
    else
    {
        text = @"未认证";
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
    
    if (userInfo.m_UserBaseInfo.m_WorkingLife != 0)
    {
        text = [NSString stringWithFormat:@"%@年", @(userInfo.m_UserBaseInfo.m_WorkingLife)];
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
    }
    else
    {
        text = @"请选择";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_AbilityItem.accessoryView = imageTextView;

    if ([userInfo.m_UserBaseInfo.m_Signature bm_isNotEmpty])
    {
        text = @"修改";
    }
    else
    {
        text = @"一句话表达下";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_SignatureItem.accessoryView = imageTextView;

    [self.m_TableView reloadData];
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

@end
