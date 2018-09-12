//
//  FSMainVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMainVC.h"
#import "AppDelegate.h"
#import "FSSearchViewController.h"
#import "FSMainHeaderView.h"
#import "FSCourseTableCell.h"

#import "FSHomePageModel.h"
#import "FSMainToolCell.h"
#import "FSMainToolCell.h"
#import "FSTopicListCell.h"
#import "FSApiRequest.h"
#import "UIView+BMBadge.h"

#define SECTION_HEDER_HEIGHT 44.0f

@interface
FSMainVC () <
    FSBannerViewDelegate,
    FSMainHeaderDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource>

@property (nonatomic, strong) FSMainHeaderView *                    m_headerView;
@property (nonatomic, strong) NSArray<FSBannerModel *> *            m_banners;
@property (nonatomic, strong) NSArray<FSHomePageToolModel *> *      m_tools;
@property (nonatomic, strong) NSArray<FSCourseRecommendModel *> *   m_courses;
@property (nonatomic, strong) NSArray<FSForumModel *> *m_topics;
@property (nonatomic, strong) NSArray *                             m_caseHotkeys;
@property (nonatomic, strong) NSArray *                             m_lawTopics;

@end

@implementation FSMainVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkUnreadMessage];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupUI];
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCourseTableCell" bundle:nil] forCellReuseIdentifier:@"FSCourseTableCell"];
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSTopicListCell" bundle:nil] forCellReuseIdentifier:@"FSTopicListCell"];
    [self loadApiData];
    [self moreNetWorking];
}
- (void)setupUI
{
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    [self bm_setNavigationWithTitle:@"主页" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:[UIImage imageNamed:@"home_message"] rightToucheEvent:@selector(popMessageVC:)];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self setBm_NavigationBarAlpha:0];

    self.edgesForExtendedLayout                   = UIRectEdgeTop;
    self.m_TableView.showsVerticalScrollIndicator = NO;
    self.m_TableView.bm_showEmptyView             = NO;
    self.m_TableView.frame                        = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_TAB_BAR_HEIGHT);
    self.m_TableView.separatorStyle               = UITableViewCellSeparatorStyleSingleLine;

    self.m_headerView = [[FSMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bm_width, HEADER_CONST_HEIGHT + 190) andDelegate:self];

    _m_headerView.m_toolCollectionView.delegate   = self;
    _m_headerView.m_toolCollectionView.dataSource = self;

    self.m_TableView.tableHeaderView     = _m_headerView;
    self.m_TableView.sectionHeaderHeight = SECTION_HEDER_HEIGHT;
    self.m_TableView.sectionFooterHeight = 10;
    self.m_TableView.estimatedRowHeight  = COURSE_CELL_HEGHT;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - banner, header, scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY   = scrollView.contentOffset.y;
    CGFloat maxOffset = (261.0 / 667 * UI_SCREEN_HEIGHT - 97) / 2;
    if (offsetY <= 0)
    {
        self.bm_NavigationBarAlpha = 0;
        [self bm_setNeedsUpdateNavigationBarAlpha];
    }
    else if (offsetY >= maxOffset)
    {
        self.bm_NavigationBarAlpha = 1.0;
        [self bm_setNeedsUpdateNavigationBarAlpha];
    }
    else
    {
        self.bm_NavigationBarAlpha = offsetY / maxOffset;
        [self bm_setNeedsUpdateNavigationBarAlpha];
    }
}
- (void)bannerView:(UIView *)bannerView didScrollToIndex:(NSUInteger)index
{
    _m_headerView.m_pageControl.currentPage = index;
}
- (void)AIButtonCliked
{
    // 智能咨询
    
}
#pragma mark - view push
- (void)jumpWithImageJumpModel:(FSImageJump *)imageJump
{
    if ([imageJump isKindOfClass:[FSHomePageToolModel class]]) {
        [self pushWithToolModel:(FSHomePageToolModel *)imageJump];
    }
}
- (void)pushWithToolModel:(FSHomePageToolModel *)tool
{
    switch (tool.m_toolType) {
        // 案例检索
        case FSHomePageTooltype_CaseSearching:
            [FSPushVCManager homePage:self pushToCaseSearchWithHotKeys:self.m_caseHotkeys];
            break;
        // 法规检索
        case FSHomePageTooltype_StatuteSearching:
            [FSPushVCManager homePage:self pushToLawSearchWithTopics:self.m_lawTopics];
            break;
        // 文书范本
        case FSHomePageTooltype_Document:
            [FSPushVCManager homePagePushToTextSplitVC:self];
            break;
        default:
            break;
    }
}
- (void)popMessageVC:(id)sender
{
}
#pragma mark - tableViewDataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? _m_topics.count : _m_courses.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        return COURSE_CELL_HEGHT;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        FSTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSTopicListCell"];
        return cell;
    }
    FSCourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCourseTableCell"];

    cell.m_course = _m_courses[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *icon    = [[UIImageView alloc] initWithFrame:CGRectMake(16, 24, 24, 22)];
    icon.contentMode     = UIViewContentModeLeft;
    icon.image = [UIImage imageNamed:section?@"home_topics":@"home_courses"];
    [view addSubview:icon];

    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(50, 24, 120, 20)];
    titleLabel.font      = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = UI_COLOR_B1;
    titleLabel.text      = section ? @"精华帖子" : @"热门推荐";
    [view addSubview:titleLabel];

//    UIButton *moreButton       = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bm_width - 69, 0, 69, 70)];
//    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
//    [moreButton setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
//    [view addSubview:moreButton];
    
    return view;
}
#pragma mark - collectionViewDataSource & Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSHomePageToolModel *tool = _m_tools[indexPath.row];
    [self jumpWithImageJumpModel:tool];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _m_tools.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSMainToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSMainToolCell" forIndexPath:indexPath];
    cell.m_tool = _m_tools[indexPath.row];
    
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return MAIN_TOOLCELL_GAP_V;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    // 这儿是为了让plus每排也只能放3个
    return (UI_SCREEN_WIDTH > 375)?38:18;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MAIN_TOOLCELL_WIDTH, MAIN_TOOLCELL_HEIGHT);
}
#pragma mark - NetWorking & freshUI
- (void)moreNetWorking
{
    // 获取案例检索的搜索热词
    [FSApiRequest getCaseSearchHotkeysSuccess:^(id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        self.m_caseHotkeys = [data bm_arrayForKey:@"hotKeywords"];
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    // 获取法规检索的法规专题
    [FSApiRequest getLawTopicSuccess:^(id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        self.m_lawTopics = [data bm_arrayForKey:@"thematic"];
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}
- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest loadHomePageData];
}
- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)data
{
    NSArray *banners = [data bm_arrayForKey:@"broadcastPictures"];
    ;
    self.m_banners   = [FSBannerModel modelsWithDataArray:banners];
    NSArray *tools = [data bm_arrayForKey:@"tools"];
    ;
    self.m_tools       = [FSHomePageToolModel modelsWithDataArray:tools];
    NSArray *courses = [data bm_arrayForKey:@"hotRecommends"];
    self.m_courses     = [FSCourseRecommendModel modelsWithDataArray:courses];
    NSArray *topics  = [data bm_arrayForKey:@"bestPosts"];
    
    self.m_topics    = [FSTopicModel communityRecommendListModelArr:topics];
    
    [self freshUI];
    return [super succeedLoadedRequestWithDic:data];
}

- (void)freshUI
{
    // banner
    NSMutableArray *bannerUrls = [NSMutableArray array];
    for (FSBannerModel *banner in _m_banners)
    {
        if ([banner.m_imageUrl bm_isNotEmpty])
            [bannerUrls addObject:banner.m_imageUrl];
    }
    [_m_headerView reloadBannerWithUrlArray:[bannerUrls copy]];

    // 工具面板
    NSInteger toolLines = _m_tools.count / 3 + (_m_tools.count % 3 ? 1 : 0);
    CGFloat   boardConetHeight = MAIN_TOOLCELL_HEIGHT * toolLines + MAIN_TOOLCELL_GAP_V * (toolLines - 1);
    boardConetHeight = (boardConetHeight >= 190) ? boardConetHeight : 190;
    _m_headerView.m_toolHeightConstraint.constant = boardConetHeight;
    _m_headerView.frame = CGRectMake(0, 0, self.view.bm_width, HEADER_CONST_HEIGHT + boardConetHeight);
    [_m_headerView.m_toolCollectionView reloadData];
    [_m_headerView layoutIfNeeded];

    [self.m_TableView reloadData];
}
- (void)checkUnreadMessage
{
    [FSApiRequest getMessageUnReadFlagSuccess:^(id  _Nullable responseObject) {
        [self showRedBadge:YES];
    } failure:^(NSError * _Nullable error) {
        [self showRedBadge:NO];
    }];
}
- (void)showRedBadge:(BOOL)show
{
    UIButton *btn = [self bm_getNavigationRightItemAtIndex:0];
    [btn showRedDotBadge];
    if (!show) {
        [btn clearBadge];
    }
}
@end
