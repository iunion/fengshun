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

@interface
FSCommunityVC ()
<
    FSScrollPageViewDelegate,
    FSScrollPageViewDataSource,
    TZImagePickerControllerDelegate
>

@property (nonatomic, strong) FSScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *   m_ScrollPageView;

@end

@implementation FSCommunityVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"ScrollPageView";
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    [self setupUI];
}

- (void)setupUI
{
    self.m_SegmentBar = [FSScrollPageSegment attachedSegmentWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44) showUnderLine:YES showTopline:YES moveLineFrame:CGRectZero isEqualDivide:YES showGapline:YES];

    [self.view addSubview:_m_SegmentBar];
    _m_SegmentBar.backgroundColor = [UIColor whiteColor];
    self.m_ScrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 44) titleColor:UI_COLOR_B1 selectTitleColor:UI_COLOR_B1 scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    [self.view addSubview:self.m_ScrollPageView];
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


#pragma mark - FSScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return 3;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return @"红";
            break;
        case 1:
            return @"黄";
            break;
        case 2:
            return @"蓝";
            break;

        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT)];
    switch (index)
    {
        case 0:
        {
            view.backgroundColor = [UIColor redColor];
            UIButton *btn1       = [[UIButton alloc] initWithFrame:CGRectMake(120, 300, 80, 40)];
            [btn1 addTarget:self action:@selector(photo:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            btn1.backgroundColor = [UIColor whiteColor];
        }
        break;

        case 1:
            view.backgroundColor = [UIColor yellowColor];
            break;

        case 2:
            view.backgroundColor = [UIColor blueColor];
            break;
    }

    return view;
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
    imagePickerVc.sortAscendingByModificationDate = NO;
    // 设置竖屏下的裁剪尺寸
    //    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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
