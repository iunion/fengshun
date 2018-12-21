//
//  FSCommunitySecVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunitySecVC.h"

#import "FSCommunityHeaderView.h"

#import "FSComTopicListVC.h"

#import "FSScrollPageView.h"

#import "FSApiRequest.h"
//#import "FSTopicListVC.h"

#import "FSCommunityModel.h"

#import "FSPushVCManager.h"
#import "FSAuthenticationVC.h"

#import "FSAlertView.h"


@interface FSCommunitySecVC ()
<
    FSScrollPageViewDataSource,
    FSScrollPageViewDelegate,
    FSCommunityHeaderViewDelegate,
    FSAuthenticationDelegate,
    FSBaseComTopicScrollTopDelegate
>
{
    CGRect initialHeaderFrame;
    CGFloat defaultHeaderViewHeight;
}

@property (nonatomic, assign) NSUInteger m_PageIndex;

// 能否滑动，默认YES;
@property (nonatomic, assign) BOOL m_CanScroll;

// 板块id
@property (nonatomic, assign) NSInteger m_FourmId;
@property (nonatomic, strong) NSString *m_FourmName;

@property (nonatomic, strong) UIView *m_TableHeaderView;

@property (nonatomic, strong) UIActivityIndicatorView *m_ActivityIndicatorView;
@property (nonatomic, assign) BOOL m_CanFreshDate;

// headerView
@property (nonatomic, strong) FSCommunityHeaderView *m_HeaderView;
@property (nonatomic, strong) FSScrollPageSegment *  m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *     m_ScrollPageView;
@property (nonatomic, strong) UIButton *m_PulishBtn;
@property (nonatomic, strong) NSMutableArray *       m_dataArray;
@property (nonatomic, strong) NSMutableArray *       m_vcArray;

@property (nonatomic, strong) FSForumModel *m_ForumModel;

@end

@implementation FSCommunitySecVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:userInfoChangedNotification object:nil];
}

- (instancetype)initWithFourmId:(NSInteger)fourmId fourmName:(NSString *)fourmName
{
    if (self = [super init])
    {
        self.m_FourmId = fourmId;
        self.m_FourmName = fourmName;
    }
    return self;
}

- (void)viewDidLoad
{
    self.m_TableViewStyle = BMFreshViewType_NONE;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.m_PageIndex = 0;
    
    self.m_TableView.m_MultiResponse = YES;
    self.m_CanScroll = YES;
    
    self.m_showEmptyView = NO;

    [self bm_setNavigationWithTitle:self.m_FourmName?self.m_FourmName:@"" barTintColor:nil leftDicArray:@[ [self bm_makeBarButtonDictionaryWithTitle:@"   " image:@"community_white_back" toucheEvent:@"popViewController" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5] ] rightDicArray:nil];
    self.bm_NavigationBarAlpha = 0.0f;
    self.bm_NavigationTitleAlpha = 0.0f;
    self.bm_NavigationTitleTintColor = [UIColor clearColor];
    self.bm_NavigationItemTintColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    [self bm_setNeedsUpdateNavigationBar];
    [self bm_setNeedsUpdateNavigationBarAlpha];
    [self bm_setNeedsUpdateNavigationTitleAlpha];
    [self bm_setNeedsUpdateNavigationTitleTintColor];
    [self bm_setNeedsUpdateNavigationItemTintColor];

    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_dataArray          = [NSMutableArray arrayWithCapacity:0];
    self.m_vcArray            = [NSMutableArray array];

    self.m_TableView.frame = CGRectMake(0, -(UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);

    [self createUI];
    [self loadApiData];
    [self getHeaderInfoMsg];
    
    // 登录状态改变刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeaderInfoMsg) name:userInfoChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bm_NavigationBarStyle = UIBarStyleBlack;
    [self bm_setNeedsUpdateNavigationBarStyle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    [self bm_setNeedsUpdateNavigationBarStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

- (void)createUI
{
    self.m_ActivityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    self.m_ActivityIndicatorView.frame= CGRectMake(UI_SCREEN_WIDTH - 60, 0, 30, 30);
    self.m_ActivityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.m_ActivityIndicatorView];
    
    self.m_TableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, ComTopicHeaderImageHeight+ComTopicHeaderImageGap+ComTopicSegmentBarHeight)];
    self.m_TableHeaderView.backgroundColor = [UIColor clearColor];
    
    self.m_HeaderView = (FSCommunityHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"FSCommunityHeaderView" owner:self options:nil].firstObject;
    self.m_HeaderView.delegate = self;
    [self.m_TableHeaderView addSubview:_m_HeaderView];
    self.m_HeaderView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, ComTopicHeaderImageHeight);

    // 切换视图
    self.m_SegmentBar = [[FSScrollPageSegment alloc] initWithFrame:CGRectMake(0, self.m_HeaderView.bm_bottom + ComTopicHeaderImageGap, UI_SCREEN_WIDTH, ComTopicSegmentBarHeight) titles:nil titleColor:nil selectTitleColor:nil showUnderLine:YES moveLineFrame:CGRectZero isEqualDivide:YES fresh:YES];
    [self.m_TableHeaderView addSubview:_m_SegmentBar];
    self.m_SegmentBar.backgroundColor = [UIColor whiteColor];
    self.m_SegmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    // 内容视图
    self.m_ScrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, _m_SegmentBar.bm_bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - UI_HOME_INDICATOR_HEIGHT - ComTopicSegmentBarHeight) titleColor:UI_COLOR_B1 selectTitleColor:UI_COLOR_BL1 scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    //[self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate   = self;
    [self.m_ScrollPageView setM_MoveLineColor:UI_COLOR_BL1];
    [self.m_ScrollPageView reloadPage];
    [self.m_ScrollPageView scrollPageWithIndex:0];

    if (self.navigationController.interactivePopGestureRecognizer)
    {
        [self.m_ScrollPageView.m_ScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }

    self.m_PulishBtn = [UIButton bm_buttonWithFrame:CGRectMake(UI_SCREEN_WIDTH - 52 - 20, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT- UI_HOME_INDICATOR_HEIGHT- 20.f - 52.f, 52.f, 52.f) image:[UIImage imageNamed:@"community_comment"]];
    [self.m_PulishBtn addTarget:self action:@selector(pulishTopicAction) forControlEvents:UIControlEventTouchUpInside];
    self.m_PulishBtn.layer.masksToBounds = NO;
    self.m_PulishBtn.layer.shadowOffset = CGSizeZero;
    self.m_PulishBtn.layer.shadowRadius = 20;
    self.m_PulishBtn.layer.shadowOpacity = 0.3;
    self.m_PulishBtn.layer.shadowColor = [UIColor blueColor].CGColor;
    [self.view addSubview:self.m_PulishBtn];
    
    // 下拉放大
    [self stretchHeaderForTableView];
    
    self.m_TableView.tableFooterView = self.m_ScrollPageView;

}


#pragma mark -
#pragma mark headerView

- (void)stretchHeaderForTableView
{
    initialHeaderFrame = self.m_TableHeaderView.frame;
    defaultHeaderViewHeight = initialHeaderFrame.size.height;
    
    UIView *emptyTableHeaderView = [[UIView alloc] initWithFrame:initialHeaderFrame];
    self.m_TableView.tableHeaderView = emptyTableHeaderView;
    
    [self.m_TableView addSubview:self.m_TableHeaderView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    self.m_CanFreshDate = NO;
    
    self.bm_NavigationTitleTintColor = [UIColor blackColor];
    [self bm_setNeedsUpdateNavigationTitleTintColor];

    // 子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = ComTopicHeaderImageHeight + ComTopicHeaderImageGap - (UI_STATUS_BAR_HEIGHT + UI_NAVIGATION_BAR_HEIGHT);
    
    if (scrollView.contentOffset.y >= tabOffsetY)
    {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (self.m_CanScroll)
        {
            [self comTopicScrollToTop:nil];
            
            self.m_CanScroll = NO;
            
            FSComTopicListVC *vc = self.m_vcArray[self.m_PageIndex];
            vc.m_CanScroll = YES;
            
            self.bm_NavigationBarAlpha = 1.0f;
            self.bm_NavigationTitleAlpha = 1.0f;
            self.bm_NavigationItemTintColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
            
            [self bm_setNeedsUpdateNavigationBarAlpha];
            [self bm_setNeedsUpdateNavigationTitleAlpha];
            [self bm_setNeedsUpdateNavigationItemTintColor];
        }
    }
    else
    {
        if (!self.m_CanScroll)
        {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
        
        CGFloat alpha = scrollView.contentOffset.y / tabOffsetY;
        self.bm_NavigationBarAlpha = alpha;
        self.bm_NavigationTitleAlpha = alpha;
        self.bm_NavigationItemTintColor = [UIColor colorWithWhite:1.0f-alpha alpha:1.0f];
        
        [self bm_setNeedsUpdateNavigationBarAlpha];
        [self bm_setNeedsUpdateNavigationTitleAlpha];
        [self bm_setNeedsUpdateNavigationItemTintColor];
    }
    
    // 控制头图拉伸
    CGRect frame = self.m_TableHeaderView.frame;
    frame.size.width = self.m_TableView.frame.size.width;
    self.m_TableHeaderView.frame = frame;
    
    if (scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        initialHeaderFrame.origin.y = offsetY * -1;
        initialHeaderFrame.size.height = defaultHeaderViewHeight + offsetY;
        self.m_TableHeaderView.frame = initialHeaderFrame;
        
        if (scrollView.contentOffset.y < 30.0f)
        {
            self.m_CanFreshDate = YES;
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDecelerating");
    
    if (self.m_CanFreshDate)
    {
        self.m_CanFreshDate = NO;
        [self.m_ActivityIndicatorView startAnimating];
        self.view.userInteractionEnabled = NO;
        
        FSComTopicListVC *vc = self.m_vcArray[self.m_PageIndex];
        [vc refreshVC];
    }
}

- (void)resizeView
{
    initialHeaderFrame.size.width = self.m_TableView.frame.size.width;
    self.m_TableHeaderView.frame = initialHeaderFrame;
}

// 下拉放大必须实现
- (void)viewDidLayoutSubviews
{
    [self resizeView];
}

- (void)finishedDataRequest
{
    [self.m_ActivityIndicatorView stopAnimating];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Action

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 发帖
- (void)pulishTopicAction
{
    if (![FSUserInfoModel isLogin])
    {
        [self showLogin];
        return;
    }
    BMWeakSelf
    if (![FSUserInfoModel userInfo].m_UserBaseInfo.m_IsRealName)
    {
        [FSAlertView showAlertWithTitle:@"温馨提示" message:@"认证后才能发帖" cancelTitle:@"取消" otherTitle:@"去认证" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                FSAuthenticationVC *vc = [[FSAuthenticationVC alloc] init];
                vc.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    [FSPushVCManager showSendPostWithPushVC:self isEdited:NO relatedId:self.m_FourmId callBack:^ {
        [weakSelf getHeaderInfoMsg];
        if (weakSelf.m_AttentionChangeBlock)
        {
            weakSelf.m_AttentionChangeBlock();
        }
        // 1.1 需求 发帖完成回到最新帖子刷新数据
        if (weakSelf.m_dataArray.count > 1)
        {
            [weakSelf.m_SegmentBar selectBtnAtIndex:1];
            [weakSelf.m_ScrollPageView scrollPageWithIndex:1];
            FSComTopicListVC *vc = weakSelf.m_vcArray[1];
            [vc refreshVC];
        }
    }];
}

//认证完成
- (void)authenticationFinished:(FSAuthenticationVC *)vc
{
    BMLog(@"认证完成");
}

#pragma mark - FSScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return self.m_dataArray.count;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    FSTopicTypeModel *model = self.m_dataArray[index];
    return model.m_PostListName;
}

- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    FSTopicTypeModel *model = self.m_dataArray[index];
    FSComTopicListVC *vc = [[FSComTopicListVC alloc] initWithTopicSortType:model.m_PostListType formId:self.m_FourmId];
    vc.scrollTopDelegate = self;
    [self.m_vcArray addObject:vc];
    return vc;
}

- (void)scrollPageViewChangeToIndex:(NSUInteger)index
{
    self.m_PageIndex = index;
    
    self.m_CanScroll = YES;
    
    for (FSComTopicListVC *vc in self.m_vcArray)
    {
        vc.m_CanScroll = NO;
        
        UIView *view = vc.view;
        UITableView *tableView = (UITableView *)[view bm_viewOfClass:[UITableView class]];
        if (tableView)
        {
            [tableView setContentOffset:CGPointZero animated:NO];
        }
    }
}


#pragma mark -
#pragma mark FSBaseComTopicScrollTopDelegate

- (void)comTopicScrollToTop:(UITableView *)tableView
{
    self.m_CanScroll = YES;
    
    for (FSComTopicListVC *vc in self.m_vcArray)
    {
        vc.m_CanScroll = NO;
    }
}


#pragma mark - 关注

- (void)followForumAction:(FSCommunityHeaderView *)aView
{
    if (![FSUserInfoModel isLogin])
    {
        [self showLogin];
        return ;
    }
    FSForumFollowState state = self.m_ForumModel.m_AttentionFlag;
    [FSApiRequest updateFourmAttentionStateWithFourmId:self.m_ForumModel.m_Id followStatus:!state success:^(id  _Nullable responseObject) {
        if (self.m_AttentionChangeBlock)
        {
            self.m_AttentionChangeBlock();
        }
        [self getHeaderInfoMsg];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - request

- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getTopicListWithType:@"" forumId:self.m_FourmId pageIndex:1 pageSize:10];
}

- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray
{
    if ([requestArray bm_isNotEmpty])
    {
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in requestArray)
        {
            FSTopicTypeModel *model = [FSTopicTypeModel topicTypeModelWithDic:dic];
            if (model)
            {
                [data addObject:model];
            }
        }
        [self.m_dataArray addObjectsFromArray:data];
        [self.m_ScrollPageView reloadPage];
        [self.m_ScrollPageView scrollPageWithIndex:0];
        return YES;
    }
    return NO;
}

- (void)getHeaderInfoMsg
{
    [FSApiRequest getTwoLevelFourmInfoWithId:self.m_FourmId success:^(id  _Nullable responseObject) {
        if ([responseObject bm_isNotEmptyDictionary])
        {
            FSForumModel *model = [FSForumModel forumModelWithServerDic:responseObject];
            self.m_ForumModel = model;
            [_m_HeaderView updateHeaderViewWith:model];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
