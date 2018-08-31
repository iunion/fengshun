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

#import "BMVerifyField.h"
#import "TZImagePickerController.h"

@interface
FSMainVC ()
<
    FSBannerViewDelegate,
    FSMainHeaderDelegate,
    TZImagePickerControllerDelegate
>

@property (nonatomic, strong) FSMainHeaderView *m_headerView;

@end

@implementation FSMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //
    [self setupUI];
}
- (void)setupUI
{
    self.bm_NavigationItemTintColor = [UIColor blackColor];
    [self bm_setNavigationWithTitle:@"主页" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:[UIImage imageNamed:@"navigationbar_message_icon.png"] rightToucheEvent:@selector(popMessageVC:)];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    self.edgesForExtendedLayout                   = UIRectEdgeTop;
    self.m_TableView.backgroundColor              = [UIColor whiteColor];
    self.m_TableView.showsVerticalScrollIndicator = NO;
    self.m_TableView.frame                        = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT);
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self setBm_NavigationBarAlpha:0];
    self.m_headerView = [[FSMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 261.0 / 667 * UI_SCREEN_HEIGHT + 391) andDelegate:self];
    BMLog(@"+++++++++screen width:%f,screen height:%f", UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    self.m_TableView.tableHeaderView = _m_headerView;
    NSArray *dataArray               = @[
        @"http://pic01.babytreeimg.com/foto3/photos/2014/0211/68/2/4170109a41ca935610bf8_b.png",
        @"http://pic01.babytreeimg.com/foto3/photos/2014/0127/19/9/4170109a267ca641c41ebb_b.png",
        @"http://pic02.babytreeimg.com/foto3/photos/2014/0207/59/4/4170109a17eca86465f8a4_b.jpg",
    ];
    [_m_headerView reloadBannerWithUrlArray:dataArray];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - banner,header,scrollView delegate
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
- (void)headerButtonClikedAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            // 视频调解
            break;

        case 6:
            // 智能咨询

            break;
    }
}


- (void)photo:(id)sender
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    //    imagePickerVc.selectedAssets = _selectedAssets;// 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES;  // 在内部显示拍照按钮
    //    imagePickerVc.allowTakeVideo = YES;   // 在内部显示拍视频按
    //    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    //在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo         = NO;
    imagePickerVc.allowPickingImage         = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    //    imagePickerVc.allowPickingGif = NO;
    //    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    imagePickerVc.sortAscendingByModificationDate = YES;
    // 设置竖屏下的裁剪尺寸
    //    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - pop VC
- (void)popMessageVC:(id)sender
{
    
}
#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    
}




@end
