//
//  FSCommunityVC.m
//  fengshun
//
//  Created by Aiwei on 2018/8/27.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCommunityVC.h"
#import "FSScrollPageView.h"
#import "AppDelegate.h"
#import "TZImagePickerController.h"
#import "FSTableView.h"
#import "FSTopicListCell.h"
#import "FSForumListCell.h"
#import "FSApiRequest.h"
#import "FSCommunityModel.h"
#import "FSForumSectionHeaderView.h"
#import "UIImageView+WebCache.h"

static NSString *FSTopicListTableViewCellIdentifier = @"FSTopicListTableViewCellIdentifier";
static NSString *FSForumListTableViewCellIdentifier = @"FSForumListTableViewCellIdentifier";
static NSString *FSForumHeaderIdentifier            = @"FSForumHeaderIdentifier";

@interface
FSCommunityVC ()
<
    FSScrollPageViewDelegate,
    FSScrollPageViewDataSource,
    TZImagePickerControllerDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    FSTableViewDelegate
>

@property (nonatomic, strong) FSScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *   m_ScrollPageView;
@property (nonatomic, strong) FSTableView *        m_RecommendTableView;
@property (nonatomic, strong) FSTableView *        m_PlateTableView;
@property (nonatomic, strong) NSMutableArray *     m_TopicDataArray;
@property (nonatomic, strong) NSMutableArray *     m_forumDataArray;

@end

@implementation FSCommunityVC

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title                       = @"枫调理顺";
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationShadowHidden   = NO;
    self.bm_NavigationShadowColor    = [UIColor bm_colorWithHexString:@"D8D8D8"];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    //    NSDictionary *btnItem1 = [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"navigationbar_collect_icon" toucheEvent:@"collect" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0];
    //    NSDictionary *btnItem2 = [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"navigationbar_share_icon" toucheEvent:@"share" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:0];
    //
    //    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightDicArray:@[btnItem2, btnItem1]];

    [self setupUI];
    _m_TopicDataArray = [NSMutableArray array];
    _m_forumDataArray = [NSMutableArray array];
    [self getRecommendList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UI

- (void)setupUI
{
    // 切换视图
    self.m_SegmentBar = [[FSScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44) titles:nil titleColor:nil selectTitleColor:nil showUnderLine:NO moveLineFrame:CGRectZero isEqualDivide:YES fresh:YES];
    [self.view addSubview:_m_SegmentBar];
    [self.m_SegmentBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    _m_SegmentBar.backgroundColor = [UIColor whiteColor];

    // 内容视图
    self.m_ScrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 44) titleColor:UI_COLOR_B1 selectTitleColor:UI_COLOR_B1 scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    [self.view addSubview:self.m_ScrollPageView];
    [self.m_ScrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.m_SegmentBar.bm_bottom);
    }];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate   = self;
    [self.m_ScrollPageView setM_MoveLineColor:UI_COLOR_BL1];
    [self.m_ScrollPageView reloadPage];
    [self.m_ScrollPageView scrollPageWithIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy var

- (FSTableView *)m_RecommendTableView
{
    if (!_m_RecommendTableView)
    {
        _m_RecommendTableView                 = [[FSTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain freshViewType:BMFreshViewType_ALL];
        _m_RecommendTableView.delegate        = self;
        _m_RecommendTableView.dataSource      = self;
        _m_RecommendTableView.rowHeight       = 152;
        _m_RecommendTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _m_RecommendTableView.separatorInset  = UIEdgeInsetsMake(0, 20, 0, 20);
        UIView *headerView                    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _m_ScrollPageView.bm_width, 8)];
        headerView.backgroundColor            = [UIColor bm_colorWithHexString:@"f6f6f6"];
        _m_RecommendTableView.tableHeaderView = headerView;
        [_m_RecommendTableView registerNib:[UINib nibWithNibName:@"FSTopicListCell" bundle:nil] forCellReuseIdentifier:FSTopicListTableViewCellIdentifier];
    }
    return _m_RecommendTableView;
}

- (FSTableView *)m_PlateTableView
{
    if (!_m_PlateTableView)
    {
        _m_PlateTableView                   = [[FSTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain freshViewType:BMFreshViewType_ALL];
        _m_PlateTableView.tableViewDelegate = self;
        _m_PlateTableView.delegate          = self;
        _m_PlateTableView.dataSource        = self;
        _m_PlateTableView.rowHeight         = 102;
        _m_PlateTableView.separatorInset    = UIEdgeInsetsMake(0, 20, 0, 20);
        _m_PlateTableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
        UIView *headerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _m_ScrollPageView.bm_width, 8)];
        headerView.backgroundColor          = [UIColor bm_colorWithHexString:@"f6f6f6"];
        _m_PlateTableView.tableHeaderView   = headerView;
        [_m_PlateTableView registerNib:[UINib nibWithNibName:@"FSForumListCell" bundle:nil] forCellReuseIdentifier:FSForumListTableViewCellIdentifier];
        //header复用注册
        [_m_PlateTableView registerNib:[UINib nibWithNibName:@"FSForumSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:FSForumHeaderIdentifier];
        [self getForumList];
    }
    return _m_PlateTableView;
}


#pragma mark - UITableViewDelegate、UITableViewDataSource
//关闭section悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.m_PlateTableView)
    {
        CGFloat sectionHeaderHeight = 50;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _m_RecommendTableView)
    {
        return 0;
    }
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _m_RecommendTableView)
    {
        return nil;
    }
    FSCommunityForumModel *   model             = _m_forumDataArray[section];
    FSForumSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FSForumHeaderIdentifier];
    [sectionHeaderView showWithFSCommunityForumModel:model];
    return sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _m_RecommendTableView)
    {
        return 1;
    }
    else
    {
        return _m_forumDataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _m_RecommendTableView)
    {
        return _m_TopicDataArray.count;
    }
    else if (tableView == _m_PlateTableView)
    {
        FSCommunityForumModel *model = _m_forumDataArray[section];
        return model.m_List.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _m_RecommendTableView)
    {
        FSTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:FSTopicListTableViewCellIdentifier];
        [cell showWithTopicModel:_m_TopicDataArray[indexPath.row]];
        return cell;
    }
    else if (tableView == _m_PlateTableView)
    {
        FSForumListCell *      cell  = [tableView dequeueReusableCellWithIdentifier:FSForumListTableViewCellIdentifier];
        FSCommunityForumModel *model = _m_forumDataArray[indexPath.section];
        [cell showWithFSCommunityForumListModel:model.m_List[indexPath.row]];
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - FSScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return 2;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return @"推荐";
            break;
        case 1:
            return @"板块";
            break;

        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    UIView *aView = [[UIView alloc] initWithFrame:scrollPageView.bounds];
    if (index == 0)
    {
        [aView addSubview:self.m_RecommendTableView];
    }
    else if (index == 1)
    {
        [aView addSubview:self.m_PlateTableView];
    }
    return aView;
}

#pragma mark - Request

- (void)getRecommendList
{
    [FSApiRequest getPlateRecommendPostListWithPageIndex:1 pageSize:20 success:^(id  _Nullable responseObject) {
        if ([responseObject bm_isNotEmptyDictionary])
        {
            [self->_m_TopicDataArray addObjectsFromArray:[FSCommunityTopicListModel communityRecommendListModelArr:[responseObject bm_arrayForKey:@"list"]]];
            [self->_m_RecommendTableView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    
}

- (void)getForumList
{
    [FSApiRequest getPlateListWithPageIndex:1 pageSize:20 success:^(id  _Nullable responseObject) {
        if ([responseObject bm_isNotEmptyDictionary])
        {
            [self->_m_forumDataArray addObjectsFromArray:[FSCommunityForumModel plateModelWithArr:[responseObject bm_arrayForKey:@"list"]]];
            [self->_m_PlateTableView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - FSTableViewDelegate

- (void)freshDataWithTableView:(FSTableView *)tableView
{
}

- (void)loadNextDataWithTableView:(FSTableView *)tableView
{
    
}

//#pragma mark - 图片选择例子
//- (void)photo:(id)sender
//{
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
//
//    //    imagePickerVc.selectedAssets = _selectedAssets;// 目前已经选中的图片数组
//    imagePickerVc.allowTakePicture = YES;  // 在内部显示拍照按钮
//    //    imagePickerVc.allowTakeVideo = YES;   // 在内部显示拍视频按
//    //    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
//
//    //在这里设置imagePickerVc的外观
//    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
//    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
//    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVc.allowPickingVideo         = NO;
//    imagePickerVc.allowPickingImage         = YES;
//    imagePickerVc.allowPickingOriginalPhoto = YES;
//    //imagePickerVc.allowPickingGif = NO;
//    //imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
//    imagePickerVc.sortAscendingByModificationDate = NO;
//    // 设置竖屏下的裁剪尺寸
//    //imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
//}
//#pragma mark - TZImagePickerControllerDelegate
///// 用户点击了取消
//- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
//{
//    BMLog(@"用户点击了取消");
//}
//
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
//{
//
//}


@end
