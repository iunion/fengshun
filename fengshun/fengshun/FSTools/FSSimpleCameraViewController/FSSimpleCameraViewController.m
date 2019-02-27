//
//  FSSimpleCameraViewController.m
//  fengshun
//
//  Created by Aiwei on 2019/2/26.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSSimpleCameraViewController.h"
#import "FSCameraGridView.h"
#import "TZImagePickerController.h"


#define kButtonViewHeight 165.0f
#define kScaleY  [UIScreen mainScreen].bounds.size.height / 667.0f
#define kContentFrame CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-kButtonViewHeight*kScaleY)
#define kButtonTitleFont [UIFont systemFontOfSize:19]
#define kButtonTitleColor [UIColor whiteColor]
#define kButtonSize CGSizeMake(60, 44)

@interface FSSimpleCameraViewController ()
<
    TZImagePickerControllerDelegate
>

@property(nonatomic, strong)FSCameraGridView *m_gridView;

@end

@implementation FSSimpleCameraViewController

@dynamic delegate;

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.showsCameraControls = NO;
        _m_gridView = [[FSCameraGridView alloc]initWithFrame:kContentFrame];
        self.cameraOverlayView = _m_gridView;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame  = CGRectMake(0, 0, kButtonSize.width, kButtonSize.height);
        [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = kButtonTitleFont;
        
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.frame  = CGRectMake(0, 0, 90, 90);
        [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"takePic"] forState:UIControlStateNormal];
        
        UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        albumBtn.frame  = CGRectMake(0, 0, kButtonSize.width, kButtonSize.height);
        [albumBtn addTarget:self action:@selector(goAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        [albumBtn setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
            albumBtn.titleLabel.font = kButtonTitleFont;
        
        CGFloat buttonViewHeight = kButtonViewHeight *kScaleY;
        CGFloat buttonViewStartY = UI_SCREEN_HEIGHT - buttonViewHeight;
        [self.view addSubview:[self containerViewWithFrame:CGRectMake(0, buttonViewStartY, UI_SCREEN_WIDTH/3, buttonViewHeight) andSubView:cancelBtn]];
        [self.view addSubview:[self containerViewWithFrame:CGRectMake(UI_SCREEN_WIDTH/3, buttonViewStartY, UI_SCREEN_WIDTH/3, buttonViewHeight) andSubView:startBtn]];
        [self.view addSubview:[self containerViewWithFrame:CGRectMake(UI_SCREEN_WIDTH/3*2, buttonViewStartY, UI_SCREEN_WIDTH/3, buttonViewHeight) andSubView:albumBtn]];
        
    }
    return self;
}
- (UIView *)containerViewWithFrame:(CGRect)frame andSubView:(UIView *)subView
{
    UIView *container = [[UIView alloc]initWithFrame:frame];
    container.backgroundColor = [UIColor clearColor];
    container.clipsToBounds = YES;
    [container addSubview:subView];
    subView.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
    return container;
}

#pragma mark - 相册选择图片代理
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    BMNavigationController *nav = (BMNavigationController *)self.navigationController;
    [nav resetPushAnimation];
    UIImage *image = [photos firstObject];
    if (image)
    {
        if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[infos firstObject]];
            if (info) {
                info[UIImagePickerControllerOriginalImage] = image;
            }
            else
            {
                info = [@{UIImagePickerControllerOriginalImage:image} mutableCopy];
            }
            [self.delegate imagePickerController:picker didFinishPickingMediaWithInfo:[info copy]];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Tool Button Action

// 拍照
- (void)start:(id)sender
{
    [self takePicture];
}
// 取消
- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(fs_cameraCancelTakePicture:)]) {
        [self.delegate fs_cameraCancelTakePicture:self];
    }
}
// 相册
- (void)goAlbum:(id)sender
{
    TZImagePickerController *imagePickerVc = [TZImagePickerController fs_defaultPickerWithImagesCount:1 delegate:self];
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.specialSingleSelected = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// UIImagePickerViewController本来就一直有内存泄露问题,覆写willDealloc屏蔽MLLeaksFinder对其的内存检查
- (BOOL)willDealloc
{
    return NO;
}

@end
