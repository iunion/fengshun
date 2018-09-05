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

#import "FSSearchViewController.h"

@interface FSUserMainVC ()

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

@property (nonatomic, strong) BMTableViewItem *m_TopicItem;
@property (nonatomic, strong) BMTableViewItem *m_CommentItem;
@property (nonatomic, strong) BMTableViewItem *m_CollectItem;

@property (nonatomic, strong) BMTableViewItem *m_HelpItem;
@property (nonatomic, strong) BMTableViewItem *m_ServiceItem;
@property (nonatomic, strong) BMTableViewItem *m_ShareItem;

@end

@implementation FSUserMainVC

- (BMFreshViewType)getFreshViewType
{
    return BMFreshViewType_Head;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.view.backgroundColor = FS_VIEW_BGCOLOR;

    self.m_TableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT);

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -100, self.m_TableView.bm_width, 100.0f)];
    [self.m_TableView addSubview:view];
    view.backgroundColor = UI_COLOR_BL1;
    self.m_TopView = view;

    self.bm_NavigationBarEffect = [[UIVisualEffect alloc] init];
    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_setup_icon" leftToucheEvent:@selector(setUpAction:) rightItemTitle:nil rightItemImage:@"navigationbar_message_icon" rightToucheEvent:@selector(messageAction:)];
    
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

- (void)setUpAction:(id)sender
{
}

- (void)messageAction:(id)sender
{
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_UserSection = [BMTableViewSection section];
    
    BMWeakSelf
    self.m_TopicItem = [BMTableViewItem itemWithTitle:@"我的帖子" imageName:@"login_mobile" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        BMStrongSelf
        FSSearchViewController *searchViewController = [[FSSearchViewController alloc] initWithSearchKey:@"test"
                                                                                           hotSearchTags:@[@"婚姻继承", @"借贷纠纷",@"婚姻继承", @"借贷纠纷",@"婚姻继承", @"借贷纠纷",@"婚姻继承", @"借贷纠纷",@"婚姻继承", @"借贷纠纷"]
                                                                                           searchHandler:^(NSString *search) {
                                                                                               NSLog(@"search");
                                                                                           }];
        searchViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchViewController animated:YES];

        
    }];
    self.m_TopicItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_TopicItem.cellHeight = 54.0f;

    self.m_CommentItem = [BMTableViewItem itemWithTitle:@"我的评论" imageName:@"login_mobile" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_CommentItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_CommentItem.cellHeight = 54.0f;

    self.m_CollectItem = [BMTableViewItem itemWithTitle:@"我的收藏" imageName:@"login_mobile" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_CollectItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_CollectItem.cellHeight = 54.0f;

    [self.m_UserSection addItem:self.m_TopicItem];
    [self.m_UserSection addItem:self.m_CommentItem];
    [self.m_UserSection addItem:self.m_CollectItem];

    self.m_AppSection = [BMTableViewSection section];
    
    self.m_HelpItem = [BMTableViewItem itemWithTitle:@"帮助中心" imageName:@"login_mobile" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_HelpItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_HelpItem.cellHeight = 54.0f;

    self.m_ServiceItem = [BMTableViewItem itemWithTitle:@"联系客服" imageName:@"login_mobile" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_ServiceItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_ServiceItem.cellHeight = 54.0f;
    
    self.m_ShareItem = [BMTableViewItem itemWithTitle:@"分享APP" imageName:@"login_mobile" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_ShareItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_ShareItem.cellHeight = 54.0f;
    
    [self.m_AppSection addItem:self.m_HelpItem];
    [self.m_AppSection addItem:self.m_ServiceItem];
    [self.m_AppSection addItem:self.m_ShareItem];

    self.m_UserSection.footerHeight = 0.001f;
    self.m_AppSection.headerHeight = 18.0f;
    
    [self.m_TableManager addSection:self.m_UserSection];
    [self.m_TableManager addSection:self.m_AppSection];

    // headerView
    self.m_HeaderBgImageView.backgroundColor = UI_COLOR_BL1;
    
    [self.m_AvatarImageView bm_circleView];
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
    if ([FSUserInfoModle isLogin])
    {
        self.m_AvatarImageView.image = [UIImage imageNamed:@"default_avataricon"];
        
        self.m_NameLabel.text = @"未登录";
        self.m_StatusLabel.text = @"点击登录/注册";

        self.m_ApproveLabel.backgroundColor = UI_COLOR_G1;
        self.m_ApproveLabel.text = @"已认证";
        self.m_ApproveBtn.userInteractionEnabled = NO;
    }
    else
    {
        self.m_AvatarImageView.image = [UIImage imageNamed:@"default_avataricon"];
        
        self.m_NameLabel.text = @"未登录";
        self.m_StatusLabel.text = @"点击登录/注册";

        self.m_ApproveLabel.backgroundColor = UI_COLOR_R1;
        self.m_ApproveLabel.text = @"立即认证";
        self.m_ApproveBtn.userInteractionEnabled = YES;
    }
    
    UIButton *btn = [self bm_getNavigationRightItemAtIndex:0];
    btn.badgeFont = UI_FONT_9;
    btn.badgeBgColor = UI_COLOR_R1;
    btn.badgeTextColor = [UIColor whiteColor];
    btn.badgeBorderWidth = 0;
    [btn showNumberBadgeWithValue:2];
    
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
    self.m_LoginBtn.bm_width = self.m_NameLabel.bm_left + width;
}

- (void)loginAction:(id)sender
{
    NSLog(@"loginAction");
    
    [self showLogin];
}

- (void)approveAction:(id)sender
{
    NSLog(@"approveAction");
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.m_TopView bm_bringToFront];
    [self.m_TableView.bm_freshHeaderView bm_bringToFront];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat happenOffsetY = scrollView.contentInset.top;
    
    //NSLog(@"%@", @(offsetY));
    //NSLog(@"%@", @(happenOffsetY));
    
    CGFloat maxOffset = 40;

    CGFloat pullingPercent = (happenOffsetY + offsetY) / maxOffset;
    
    self.m_TableView.bm_freshHeaderView.hidden = YES;

    if (pullingPercent <= 0.0f)
    {
        self.bm_NavigationBarAlpha = 1.0f;
        self.m_TableView.bm_freshHeaderView.hidden = NO;
    }
    else if (pullingPercent <= 1.0f)
    {
        self.bm_NavigationBarAlpha = 1.0f - pullingPercent;
    }
    else
    {
        self.bm_NavigationBarAlpha = 0.0f;
    }
    [self bm_setNeedsUpdateNavigationBarAlpha];
}


@end
