//
//  FSUserMainVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/30.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSUserMainVC.h"
#import "FSUserInfo.h"
#import "UIView+BMBadge.h"
#import "UIImageView+WebCache.h"

#import "FSNoIdentityAuthVC.h"
#import "FSMyTopicVC.h"
#import "FSMyCommentVC.h"
#import "FSMyCollectionTabVC.h"

#import "FSSetupVC.h"
#import "FSCustomInfoVC.h"
#import "FSAuthenticationVC.h"

#import "FSServiceVC.h"
#import "FSMoreViewVC.h"


@interface FSUserMainVC ()
<
    FSMoreViewVCDelegate
>

@property (strong, nonatomic) UIView *m_TopView;

@property (strong, nonatomic) IBOutlet UIView *m_HeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *m_HeaderBgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *m_AvatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *m_NameLabel;
@property (weak, nonatomic) IBOutlet UIControl *m_ApproveBtn;
@property (weak, nonatomic) IBOutlet UILabel *m_ApproveLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_StatusLabel;

@property (weak, nonatomic) IBOutlet UIControl *m_LoginBtn;

@property (nonatomic, strong) BMTableViewSection *m_UserSection;
@property (nonatomic, strong) BMTableViewSection *m_AppSection;

//@property (nonatomic, strong) BMTableViewItem *m_Articles;
@property (nonatomic, strong) BMTableViewItem *m_TopicItem;
@property (nonatomic, strong) BMTableViewItem *m_CommentItem;
@property (nonatomic, strong) BMTableViewItem *m_CollectItem;

@property (nonatomic, strong) BMTableViewItem *m_HelpItem;
@property (nonatomic, strong) BMTableViewItem *m_ServiceItem;
@property (nonatomic, strong) BMTableViewItem *m_ShareItem;

@end

@implementation FSUserMainVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:userInfoChangedNotification object:nil];
}

- (BMFreshViewType)getFreshViewType
{
    return BMFreshViewType_NONE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.view.backgroundColor = FS_VIEW_BGCOLOR;

    self.m_TableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_TAB_BAR_HEIGHT);

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -400, self.m_TableView.bm_width, 400.0f)];
//    [self.m_TableView addSubview:view];
//    view.backgroundColor = UI_COLOR_BL1;
//    self.m_TopView = view;

    self.bm_NavigationBarBgTintColor = UI_COLOR_BL1;
    self.bm_NavigationItemTintColor = [UIColor whiteColor];
    self.bm_NavigationShadowHidden = YES;

    self.bm_NavigationBarEffect = [[UIVisualEffect alloc] init];
    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_setup_icon" leftToucheEvent:@selector(setUpAction:) rightItemTitle:nil rightItemImage:@"navigationbar_message_icon" rightToucheEvent:@selector(messageAction:)];
    
    [self interfaceSettings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshViews) name:userInfoChangedNotification object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bm_NavigationBarStyle = UIBarStyleBlack;
    [self bm_setNeedsUpdateNavigationBarStyle];
    
    [self checkUnreadMessage];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    [self bm_setNeedsUpdateNavigationBarStyle];
}

- (void)setUpAction:(id)sender
{
    FSSetupVC *vc = [[FSSetupVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageAction:(id)sender
{
    if ([FSUserInfoModel isLogin])
    {
        [FSPushVCManager showMessageVC:self andShowNotificationTab:NO];
    }
    else
    {
        [self showLogin];
    }
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_UserSection = [BMTableViewSection section];
    
    BMWeakSelf
//    self.m_Articles = [BMTableViewItem itemWithTitle:@"我的专栏" imageName:@"user_topicicon" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
//
//        if ([FSUserInfoModel isLogin])
//        {
//            FSNoIdentityAuthVC *noIdentityAuthVC = [[FSNoIdentityAuthVC alloc] init];
//            noIdentityAuthVC.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:noIdentityAuthVC animated:YES];
//        }
//        else
//        {
//            [weakSelf showLogin];
//        }
//    }];
//    self.m_Articles.imageH = 16.0f;
//    self.m_Articles.imageW = 16.0f;
//    self.m_Articles.textFont = FS_CELLTITLE_TEXTFONT;
//    self.m_Articles.highlightBgColor = UI_COLOR_BL1;
//    self.m_Articles.cellHeight = 50.0f;
    
    self.m_TopicItem = [BMTableViewItem itemWithTitle:@"我的帖子" imageName:@"user_topicicon" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        if ([FSUserInfoModel isLogin])
        {
            FSMyTopicVC *myTopicVC = [[FSMyTopicVC alloc] init];
            myTopicVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:myTopicVC animated:YES];
        }
        else
        {
            [weakSelf showLogin];
        }
    }];
    self.m_TopicItem.imageH = 16.0f;
    self.m_TopicItem.imageW = 16.0f;
    self.m_TopicItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_TopicItem.highlightBgColor = UI_COLOR_BL1;
    self.m_TopicItem.cellHeight = 50.0f;

    self.m_CommentItem = [BMTableViewItem itemWithTitle:@"我的评论" imageName:@"user_commenticon" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        if ([FSUserInfoModel isLogin])
        {
            FSMyCommentVC *myCommentVC = [[FSMyCommentVC alloc] init];
            myCommentVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:myCommentVC animated:YES];
        }
        else
        {
            [weakSelf showLogin];
        }
    }];
    self.m_CommentItem.imageH = 16.0f;
    self.m_CommentItem.imageW = 16.0f;
    self.m_CommentItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_CommentItem.highlightBgColor = UI_COLOR_BL1;
    self.m_CommentItem.cellHeight = 50.0f;

    self.m_CollectItem = [BMTableViewItem itemWithTitle:@"我的收藏" imageName:@"user_collecticon" underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        if ([FSUserInfoModel isLogin])
        {
            FSMyCollectionTabVC *myCollectionTabVC = [[FSMyCollectionTabVC alloc] init];
            myCollectionTabVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:myCollectionTabVC animated:YES];
        }
        else
        {
            [weakSelf showLogin];
        }
    }];
    self.m_CollectItem.imageH = 16.0f;
    self.m_CollectItem.imageW = 16.0f;
    self.m_CollectItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_CollectItem.highlightBgColor = UI_COLOR_BL1;
    self.m_CollectItem.cellHeight = 50.0f;

//    [self.m_UserSection addItem:self.m_Articles];
    [self.m_UserSection addItem:self.m_TopicItem];
    [self.m_UserSection addItem:self.m_CommentItem];
    [self.m_UserSection addItem:self.m_CollectItem];

    self.m_AppSection = [BMTableViewSection section];
    
    self.m_HelpItem = [BMTableViewItem itemWithTitle:@"帮助中心" imageName:@"user_helpicon" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        [FSPushVCManager showWebView:weakSelf url:[NSString stringWithFormat:@"%@/help", FS_H5_SERVER] title:nil];
    }];
    self.m_HelpItem.imageH = 16.0f;
    self.m_HelpItem.imageW = 16.0f;
    self.m_HelpItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_HelpItem.highlightBgColor = UI_COLOR_BL1;
    self.m_HelpItem.cellHeight = 50.0f;

    self.m_ServiceItem = [BMTableViewItem itemWithTitle:@"联系客服" imageName:@"user_serviceicon" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        FSServiceVC *serviceVC = [[FSServiceVC alloc] initWithNibName:@"FSServiceVC" bundle:nil];
        serviceVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:serviceVC animated:YES];
    }];
    self.m_ServiceItem.imageH = 16.0f;
    self.m_ServiceItem.imageW = 16.0f;
    self.m_ServiceItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_ServiceItem.highlightBgColor = UI_COLOR_BL1;
    self.m_ServiceItem.cellHeight = 50.0f;
    
    self.m_ShareItem = [BMTableViewItem itemWithTitle:@"分享APP" imageName:@"user_shareicon" underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        [weakSelf toShare];
    }];
    self.m_ShareItem.imageH = 16.0f;
    self.m_ShareItem.imageW = 16.0f;
    self.m_ShareItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_ShareItem.highlightBgColor = UI_COLOR_BL1;
    self.m_ShareItem.cellHeight = 50.0f;
    
    //[self.m_AppSection addItem:self.m_HelpItem];
    [self.m_AppSection addItem:self.m_ServiceItem];
    [self.m_AppSection addItem:self.m_ShareItem];

    self.m_UserSection.headerHeight = 0.0f;
    self.m_UserSection.footerHeight = 0.0f;
    self.m_AppSection.headerHeight = 10.0f;
    
    [self.m_TableManager addSection:self.m_UserSection];
    [self.m_TableManager addSection:self.m_AppSection];

    // headerView
    self.m_HeaderBgImageView.backgroundColor = UI_COLOR_BL1;
    
    //[self.m_AvatarImageView bm_circleView];
    self.m_NameLabel.textColor = [UIColor whiteColor];
    self.m_NameLabel.font = FS_TITLE_TEXTFONT;
    self.m_StatusLabel.textColor = [UIColor whiteColor];
    self.m_StatusLabel.font = FS_DETAIL_LARGETEXTFONT;

    self.m_ApproveLabel.textColor = [UIColor whiteColor];
    self.m_ApproveLabel.font = FS_BUTTON_SMALLTEXTFONT;
    self.m_ApproveLabel.textAlignment = NSTextAlignmentCenter;
    [self.m_ApproveLabel bm_roundedRect:4.0f];

    self.m_LoginBtn.exclusiveTouch = YES;
    self.m_LoginBtn.userInteractionEnabled = YES;
    self.m_ApproveBtn.exclusiveTouch = YES;
    self.m_ApproveBtn.userInteractionEnabled = YES;
    [self.m_LoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.m_ApproveBtn addTarget:self action:@selector(approveAction:) forControlEvents:UIControlEventTouchUpInside];

    self.m_TableView.tableHeaderView = self.m_HeaderView;
    
    [self freshViews];
    [self.m_TableView reloadData];
}

- (void)freshViews
{
    if ([FSUserInfoModel isLogin])
    {
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        
        BMWeakSelf
        [self.m_AvatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.m_UserBaseInfo.m_AvatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatariconlarge"] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error)
            {
                UIImage *newImage = [image bezierPathClipWithCornerRadius:image.size.width];
                newImage = [newImage imageScalingToSize:weakSelf.m_AvatarImageView.bm_size];

                if (userInfo.m_UserBaseInfo.m_IsIdAuth)
                {
                    UIImage *maskImage = [UIImage imageNamed:@"user_passcertification_icon"];
                    CGRect rect = CGRectMake(newImage.size.width-18.0f, newImage.size.height-18.0f, 18.0f, 18.0f);
                    newImage = [newImage imageWithWaterMask:maskImage inRect:rect];
                }
                weakSelf.m_AvatarImageView.image = newImage;
            }
            else
            {
                UIImage *defaultImage = [UIImage imageNamed:@"default_avatariconlarge"];
                UIImage *newImage = [defaultImage bezierPathClipWithCornerRadius:defaultImage.size.width];
                newImage = [newImage imageScalingToSize:weakSelf.m_AvatarImageView.bm_size];

                if (userInfo.m_UserBaseInfo.m_IsIdAuth)
                {
                    CGRect rect = CGRectMake(newImage.size.width-18.0f, newImage.size.height-18.0f, 18.0f, 18.0f);
                    newImage = [newImage imageWithWaterMask:[UIImage imageNamed:@"user_passcertification_icon"] inRect:rect];
                }
                weakSelf.m_AvatarImageView.image = newImage;
            }

        }];
        //self.m_AvatarImageView.image = [UIImage imageNamed:@"default_avatariconlarge"];
        
        if ([userInfo.m_UserBaseInfo.m_NickName bm_isNotEmpty])
        {
            self.m_NameLabel.text = userInfo.m_UserBaseInfo.m_NickName;
        }
        else
        {
            self.m_NameLabel.text = [userInfo.m_UserBaseInfo.m_PhoneNum bm_maskAtRang:NSMakeRange(3, 4) withMask:'*'];
        }
        self.m_StatusLabel.text = userInfo.m_UserBaseInfo.m_Job;
    }
    else
    {
        self.m_AvatarImageView.image = [UIImage imageNamed:@"default_avatariconlarge"];
        
        self.m_NameLabel.text = @"未登录";
        self.m_StatusLabel.text = @"点击登录/注册";
    }
    
    [self freshApprove];
    
    CGSize labelsize = [self.m_NameLabel sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH, MAXFLOAT)];
    CGFloat width = labelsize.width;
    CGFloat gap = 6.0f;
    if (width>140.0f)
    {
        width = 140.0f;
    }
    if (width>134.0f)
    {
        gap = 2.0f;
    }
    self.m_ApproveBtn.bm_left = self.m_NameLabel.bm_left + width + gap;
    self.m_LoginBtn.bm_width = self.m_NameLabel.bm_left + width - self.m_AvatarImageView.bm_left;
}

- (void)freshApprove
{
    if ([FSUserInfoModel isLogin])
    {
        self.m_ApproveLabel.hidden = NO;
        self.m_ApproveBtn.hidden = NO;
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        if (userInfo.m_UserBaseInfo.m_IsRealName)
        {
            self.m_ApproveLabel.backgroundColor = UI_COLOR_G1;
            self.m_ApproveLabel.text = @"已认证";
            self.m_ApproveBtn.userInteractionEnabled = NO;
        }
        else
        {
            self.m_ApproveLabel.backgroundColor = UI_COLOR_R1;
            self.m_ApproveLabel.text = @"立即认证";
            self.m_ApproveBtn.userInteractionEnabled = YES;
        }
    }
    else
    {
        self.m_ApproveLabel.hidden = YES;
        self.m_ApproveBtn.hidden = YES;
        self.m_ApproveBtn.userInteractionEnabled = NO;
    }
}

- (void)loginAction:(id)sender
{
    NSLog(@"loginAction");
    
    if ([FSUserInfoModel isLogin])
    {
        FSCustomInfoVC *vc = [[FSCustomInfoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self showLogin];
    }
}

- (void)approveAction:(id)sender
{
    NSLog(@"approveAction");
    
    FSAuthenticationVC *vc = [[FSAuthenticationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 分享

- (void)toShare
{
    [FSMoreViewVC showSingleShareAlertViewDelegate:self presentVC:self];
}

- (void)moreViewClickWithType:(NSInteger)index
{
    BMWeakSelf
    [self.m_ProgressHUD showAnimated:YES];
    [FSApiRequest getShareContent:@"1" type:@"PERSONNEL" success:^(id  _Nullable responseObject) {
        [weakSelf.m_ProgressHUD hideAnimated:YES];
        [FSShareManager shareWebUrlWithTitle:[responseObject bm_stringForKey:@"title"] descr:[responseObject bm_stringForKey:@"content"] thumImage:[responseObject bm_stringForKey:@"imgUrl"] webpageUrl:[responseObject bm_stringForKey:@"url"] platform:index currentVC:weakSelf delegate:nil];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.m_TopView bm_bringToFront];
//    [self.m_TableView.bm_freshHeaderView bm_bringToFront];
//
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat happenOffsetY = scrollView.contentInset.top;
//
//    //NSLog(@"%@", @(offsetY));
//    //NSLog(@"%@", @(happenOffsetY));
//
//    CGFloat maxOffset = 40;
//
//    CGFloat pullingPercent = (happenOffsetY + offsetY) / maxOffset;
//
//    self.m_TableView.bm_freshHeaderView.hidden = YES;
//
//    if (pullingPercent <= 0.0f)
//    {
//        self.bm_NavigationBarAlpha = 1.0f;
//        self.m_TableView.bm_freshHeaderView.hidden = NO;
//    }
//    else if (pullingPercent <= 1.0f)
//    {
//        self.bm_NavigationBarAlpha = 1.0f - pullingPercent;
//    }
//    else
//    {
//        self.bm_NavigationBarAlpha = 0.0f;
//    }
//    [self bm_setNeedsUpdateNavigationBarAlpha];
//}


#pragma mark -
#pragma mark FSLoginDelegate

- (void)loginFinished
{
    [self freshViews];
}

- (void)checkUnreadMessage
{
    if ([FSUserInfoModel isLogin])
    {
        [FSApiRequest getMessageUnReadFlagSuccess:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSNumber class]])
            {
                BOOL show = ((NSNumber *)responseObject).boolValue;
                [self showRedBadge:show];
            }
        } failure:^(NSError *error) {
        }];
    }
}

- (void)showRedBadge:(BOOL)show
{
    UIButton *btn = [self bm_getNavigationRightItemAtIndex:0];
    if (show)
    {
        btn.badgeBgColor = UI_COLOR_R1;
        btn.badgeBorderWidth = 0.0f;
        btn.badgeCenterOffset = CGPointMake(-9.0f, 13.0f);
        [btn showRedDotBadge];
    }
    else
    {
        [btn clearBadge];
    }
}

@end
