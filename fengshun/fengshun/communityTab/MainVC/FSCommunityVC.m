//
//  FSCommunityVC.m
//  fengshun
//
//  Created by Aiwei on 2018/8/27.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCommunityVC.h"

#import "AppDelegate.h"

#import "BMScrollPageView.h"
#import "FSRecommendListVC.h"
#import "FSForumListVC.h"


@interface FSCommunityVC ()
<
    BMScrollPageViewDelegate,
    BMScrollPageViewDataSource
>

@property (nonatomic, strong) BMScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) BMScrollPageView *m_ScrollPageView;

@property (nonatomic, strong) FSRecommendListVC *m_RecommendVC;
@property (nonatomic, strong) FSForumListVC *m_ForumVC;

@end

@implementation FSCommunityVC

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationShadowHidden   = NO;
    self.bm_NavigationShadowColor    = [UIColor bm_colorWithHex:0xD8D8D8];

    [self bm_setNavigationWithTitle:@"社区" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    [self setupUI];
}


#pragma mark - UI

- (void)setupUI
{
    // 切换视图
    self.m_SegmentBar = [[BMScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [self.view addSubview:_m_SegmentBar];
    self.m_SegmentBar.backgroundColor = [UIColor whiteColor];
    self.m_SegmentBar.showMore = NO;
    self.m_SegmentBar.equalDivide = YES;
    self.m_SegmentBar.moveLineColor = UI_COLOR_BL1;
    self.m_SegmentBar.showBottomLine = NO;
    self.m_SegmentBar.titleColor = UI_COLOR_B1;
    self.m_SegmentBar.titleSelectedColor = UI_COLOR_BL1;

    // 内容视图
    self.m_ScrollPageView = [[BMScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - 44)  withScrollPageSegment:self.m_SegmentBar];
    [self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate = self;

    [self.m_ScrollPageView reloadPages];
    [self.m_ScrollPageView scrollPageWithIndex:0];
    
    if (self.navigationController.interactivePopGestureRecognizer)
    {
        [self.m_ScrollPageView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BMScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(BMScrollPageView *)scrollPageView
{
    return 2;
}

- (NSString *)scrollPageView:(BMScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return @"推荐";
            break;

        case 1:
            return @"版块";
            break;

        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(BMScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        self.m_RecommendVC = [[FSRecommendListVC alloc] init];
        return self.m_RecommendVC.view;
    }
    else if (index == 1)
    {
        BMWeakSelf;
        self.m_ForumVC = [[FSForumListVC alloc] init];
        self.m_ForumVC.m_ShowLoginBlock = ^{
            [weakSelf showLogin];
        };
        return self.m_ForumVC.view;
    }
    return nil;
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
