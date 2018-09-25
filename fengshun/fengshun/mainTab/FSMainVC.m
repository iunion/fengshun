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

#import "FSOCRManager.h"

#define SECTION_HEDER_HEIGHT 44.0f

@interface
FSMainVC ()
<
    FSBannerViewDelegate,
    FSMainHeaderDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource
>

@property (nonatomic, strong) FSMainHeaderView *                    m_headerView;
@property (nonatomic, strong) NSArray<FSBannerModel *> *            m_banners;
@property (nonatomic, strong) NSArray<FSHomePageToolModel *> *      m_tools;
@property (nonatomic, strong) NSArray<FSCourseRecommendModel *> *   m_courses;
@property (nonatomic, strong) NSArray<FSTopicModel *> *             m_topics;
@property (nonatomic, strong) NSArray *                             m_caseHotkeys;
//@property (nonatomic, strong) NSArray *                             m_lawTopics;

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

    self.m_ShowProgressHUD = NO;
    
    [self setupUI];
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCourseTableCell" bundle:nil] forCellReuseIdentifier:@"FSCourseTableCell"];
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSTopicListCell" bundle:nil] forCellReuseIdentifier:@"FSTopicListCell"];
    
    [self loadApiData];
    
}

- (void)setupUI
{
    self.m_TableView.bm_freshHeaderView.backgroundColor = [UIColor whiteColor];
    
//    self.bm_NavigationBarAlpha = 0;
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    [self bm_setNavigationWithTitle:@"主页" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:[UIImage imageNamed:@"home_message"] rightToucheEvent:@selector(popMessageVC:)];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];
    
//    self.bm_NavigationTitleAlpha = 0;
//    [self bm_setNeedsUpdateNavigationTitleAlpha];

    self.automaticallyAdjustsScrollViewInsets     = NO;
    self.edgesForExtendedLayout                   = UIRectEdgeTop;
    self.m_TableView.showsVerticalScrollIndicator = NO;
    self.m_TableView.bm_showEmptyView             = NO;
    self.m_TableView.frame                        = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_TAB_BAR_HEIGHT);
    //self.m_TableView.frame = CGRectMake(0, -(UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT);
    self.m_TableView.separatorStyle               = UITableViewCellSeparatorStyleSingleLine;

    self.m_headerView = [[FSMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bm_width, [FSMainHeaderView headerConstheight] + 190) andDelegate:self];

    _m_headerView.m_toolCollectionView.delegate   = self;
    _m_headerView.m_toolCollectionView.dataSource = self;

    self.m_TableView.tableHeaderView     = _m_headerView;
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
        self.bm_NavigationTitleAlpha = 0; //(offsetY == 0) ? 1.0 : 0;
        [self bm_setNeedsUpdateNavigationTitleAlpha];
    }
    else if (offsetY >= maxOffset)
    {
        self.bm_NavigationBarAlpha = 1.0;
        [self bm_setNeedsUpdateNavigationBarAlpha];
        self.bm_NavigationTitleAlpha = 1.0;
        [self bm_setNeedsUpdateNavigationTitleAlpha];
    }
    else
    {
        self.bm_NavigationBarAlpha = offsetY / maxOffset;
        [self bm_setNeedsUpdateNavigationBarAlpha];
        self.bm_NavigationTitleAlpha = offsetY / maxOffset;
        [self bm_setNeedsUpdateNavigationTitleAlpha];
    }
    
    NSLog(@"%@", @(offsetY));
}


#pragma mark -
#pragma mark FSBannerViewDelegate

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
    if ([imageJump isKindOfClass:[FSHomePageToolModel class]])
    {
        [self pushWithToolModel:(FSHomePageToolModel *)imageJump];
    }
}

- (void)pushWithToolModel:(FSHomePageToolModel *)tool
{
    switch (tool.m_toolType)
    {
#ifdef FSVIDEO_ON
        // 视频调解
        case FSHomePageTooltype_VideoMediation:
        {
            if ([FSUserInfoModle isLogin])
            {
                 [FSPushVCManager pushVideoMediateList:self.navigationController];
            }
            else
            {
                [self showLogin];
            }
          
        }
            break;
#endif
        // 案例检索
        case FSHomePageTooltype_CaseSearching:
        {
            [FSPushVCManager homePage:self pushToCaseSearchWithHotKeys:self.m_caseHotkeys];
        }
            break;
        // 法规检索
        case FSHomePageTooltype_StatuteSearching:
        {
            [FSPushVCManager pushToLawSearch:self];
        }
            break;
        // 文书范本
        case FSHomePageTooltype_Document:
        {
            [FSPushVCManager homePagePushToTextSplitVC:self];
        }
            break;
        // 文书扫描
        case FSHomePageTooltype_FileScanning:
        {
            if ([FSUserInfoModle isLogin])
            {
                [FSPushVCManager homePagePushToFileScanVC:self];
            }
            else
            {
                [self showLogin];
            }
           
        }
            break;
        //计算器
        case  FSHomePageTooltype_Calculator:
        {
            [FSPushVCManager showWebView:self url:[NSString stringWithFormat:@"%@/tooIndex",FS_H5_SERVER] title:@""];
        }
            break;
        default:
            break;
    }
}

- (void)popMessageVC:(id)sender
{
    if ([FSUserInfoModle isLogin])
    {
        [FSPushVCManager showMessageVC:self];
    }
    else
    {
        [self showLogin];
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        FSTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSTopicListCell"];
        [cell drawCellWithModle:_m_topics[indexPath.row]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0&&[_m_courses bm_isNotEmpty])
    {
        return SECTION_HEDER_HEIGHT;
    }
    else if (section == 1&&[_m_topics bm_isNotEmpty])
    {
        return SECTION_HEDER_HEIGHT;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *icon    = [[UIImageView alloc] initWithFrame:CGRectMake(16, 24, 24, 22)];
    icon.contentMode     = UIViewContentModeLeft;
    icon.image = [UIImage imageNamed:section?@"home_topics":@"home_courses"];
    [view addSubview:icon];

    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(45, 24, 120, 20)];
    titleLabel.font      = [UIFont boldSystemFontOfSize:19];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        return [FSTopicListCell cellHeight];
    }
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        FSTopicModel *model = _m_topics[indexPath.row];
        [FSPushVCManager showTopicDetail:self topicId:model.m_Id];
    }
    else
    {
        FSCourseModel *model = _m_courses[indexPath.row];
        [FSPushVCManager viewController:self pushToCourseDetailWithId:model.m_id];
    }
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
    
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    [self moreNetWorking];
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
    _m_headerView.frame = CGRectMake(0, 0, self.view.bm_width, [FSMainHeaderView headerConstheight] + boardConetHeight);
    [_m_headerView.m_toolCollectionView reloadData];
    [_m_headerView layoutIfNeeded];

    [self.m_TableView reloadData];
}

- (void)checkUnreadMessage
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

- (void)showRedBadge:(BOOL)show
{
    UIButton *btn = [self bm_getNavigationRightItemAtIndex:0];
    if (show)
    {
        btn.badgeBgColor = UI_COLOR_R1;
        btn.badgeBorderWidth = 0.0f;
        [btn showRedDotBadge];
    }
    else
    {
        [btn clearBadge];
    }
}

@end
