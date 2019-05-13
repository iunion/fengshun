//
//  FSFileScanImagePreviewVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/14.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSFileScanImagePreviewVC.h"
#import "FSImageFileModel.h"
#import "BMScrollPageView.h"
#import "MBProgressHUD.h"
#import "TOCropViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import "FSMoreViewVC.h"

@interface
FSFileScanImagePreviewVC ()
<
    BMScrollPageViewDelegate,
    BMScrollPageViewDataSource,
    TOCropViewControllerDelegate,
    FSMoreViewVCDelegate
>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *m_toolButtons;
@property (weak, nonatomic) IBOutlet UILabel *  m_pageContolLabel;
@property (weak, nonatomic) IBOutlet UIView *m_toolView;
@property (nonatomic, strong) BMScrollPageView *m_scrollPageView;

@property (nonatomic, strong)UIButton *editFileNameButton;

@property (nonatomic, readonly)NSMutableArray <FSImageFileModel *> *m_allImageFiles;
@property (nonatomic, strong)FSImageFileModel *m_selectedImageFile;

@end

@implementation FSFileScanImagePreviewVC

- (NSMutableArray<FSImageFileModel *> *)m_allImageFiles
{
    return FSImageFileModel.m_allLocalImageFiles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_selectedImageFile = [self.m_allImageFiles objectAtIndex:_m_selectedIndex];
    [self setupUI];
}
- (void)setupUI
{
    _m_toolView.layer.shadowOffset = CGSizeMake(0, -3);
    _m_toolView.layer.shadowOpacity = 0.19;
    _m_toolView.layer.shadowColor = UI_COLOR_B2.CGColor;
    
    [_m_pageContolLabel bm_roundedRect:13.5];
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor  = UI_COLOR_B6;
    [self bm_setNavigationLeftItemTintColor:UI_COLOR_B1];
    
    UILabel *titleView = (UILabel *)[self bm_getNavigationBarTitleLabel];
    self.editFileNameButton = [[UIButton alloc]initWithFrame:titleView.bounds];
    [_editFileNameButton addTarget:self action:@selector(editFileName) forControlEvents:UIControlEventTouchUpInside];
    _editFileNameButton.titleLabel.font = titleView.font;
    [_editFileNameButton setTitle:_m_selectedImageFile.m_fileName forState:UIControlStateNormal];
    [_editFileNameButton setTitleColor:titleView.textColor forState:UIControlStateNormal];
    
    [self bm_setNavigationWithTitleView:_editFileNameButton barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"更多" rightItemImage:nil rightToucheEvent:@selector(moreAction:)];
    [self bm_setNavigationRightItemTintColor:UI_COLOR_BL1];
    [self bm_setNeedsUpdateNavigationBar];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    
    for (UIButton *toolButton in _m_toolButtons)
    {
        [toolButton bm_roundedRect:15 borderWidth:0.5 borderColor:UI_COLOR_BL1];
        if (UI_SCREEN_WIDTH <  375) {
            toolButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        }
    }
    
    // 内容视图
    self.m_scrollPageView = [[BMScrollPageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - TOOLVIEW_HEIGHT) withScrollPageSegment:nil];
    [self.view insertSubview:_m_scrollPageView belowSubview:_m_pageContolLabel];
    _m_scrollPageView.backgroundColor = [UIColor blackColor];
    _m_scrollPageView.datasource = self;
    _m_scrollPageView.delegate   = self;

    if (self.navigationController.interactivePopGestureRecognizer)
    {
        [self.m_scrollPageView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }

    [self refreshUIIfNeedReload:YES];
}
- (void)editFileName
{
    if (![_m_selectedImageFile bm_isNotEmpty]) {
        return;
    }
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [av addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.m_selectedImageFile.m_fileName;
    }];
    [av addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak typeof(av) weakAv = av;
    [av addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [weakAv.textFields firstObject];
        self.m_selectedImageFile.m_fileName = tf.text;
        [self syncDataAndUIWithRemoveItem:nil];
        [self refreshUIIfNeedReload:NO];
    }]];
    [self presentViewController:av animated:YES completion:nil];
}

- (void)refreshUIIfNeedReload:(BOOL)needReload
{
    if (needReload)
    {
        [self.m_scrollPageView reloadPages];
        if ([self.m_allImageFiles bm_isNotEmpty])
        {
            [_m_scrollPageView scrollPageWithIndex:[self.m_allImageFiles indexOfObject:_m_selectedImageFile]];
        }
    }
    NSUInteger index = [self.m_allImageFiles bm_isNotEmpty] ? [self.m_allImageFiles indexOfObject:_m_selectedImageFile] + 1 : 0;

    NSUInteger total        = self.m_allImageFiles.count;
    _m_pageContolLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)index, (unsigned long)total];
    if (_m_selectedImageFile) {
        [self.editFileNameButton setTitle:_m_selectedImageFile.m_fileName forState:UIControlStateNormal];
    }
    else
    {
        [self.editFileNameButton setTitle:@"无图片" forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scrollPageView dataSource & delegate
- (void)scrollPageViewChangeToIndex:(NSUInteger)index
{
    self.m_selectedImageFile = [self.m_allImageFiles objectAtIndex:index];
    [self refreshUIIfNeedReload:NO];
}
- (NSUInteger)scrollPageViewNumberOfPages:(BMScrollPageView *)scrollPageView
{
    return self.m_allImageFiles.count;
}


- (id)scrollPageView:(BMScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    FSImageFileModel *model = [self.m_allImageFiles objectAtIndex:index];
    if ([model bm_isNotEmpty])
    {
        UIImageView *imageView  = [[UIImageView alloc] initWithImage:model.previewImage];
        imageView.clipsToBounds = YES;
        imageView.contentMode   = UIViewContentModeScaleAspectFit;
        return imageView;
    }
    return nil;
}

- (NSString *)scrollPageView:(BMScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    return @"";
}

#pragma mark - button action
- (void)removeAction
{
    if (![_m_selectedImageFile bm_isNotEmpty])
    {
        return;
    }
    NSInteger oriIndex = [self.m_allImageFiles indexOfObject:_m_selectedImageFile];
    [self.m_allImageFiles removeObject:_m_selectedImageFile];
    [self syncDataAndUIWithRemoveItem:_m_selectedImageFile];
    NSUInteger index         = (oriIndex - 1 < 0) ? 0 : oriIndex - 1;
    self.m_selectedImageFile = (self.m_allImageFiles.count > index) ? self.m_allImageFiles[index] : nil;
    [self refreshUIIfNeedReload:YES];
}
- (void)presentToImageCrop
{
    if (![_m_selectedImageFile bm_isNotEmpty])
    {
        return;
    }
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:_m_selectedImageFile.m_OriginalImage];
    cropController.delegate = self;
    [self presentViewController:cropController animated:YES completion:nil];
}
#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    _m_selectedImageFile.m_image = image;
    _m_selectedImageFile.m_OCRText = nil;
    [self syncDataAndUIWithRemoveItem:nil];
    [self refreshUIIfNeedReload:YES];
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)syncDataAndUIWithRemoveItem:(FSImageFileModel *)removeItem
{
    [FSImageFileModel asynRefreshLocalImageFilesInfoWithDeleteImageFiles:removeItem?@[removeItem]:nil];
    if (_m_SourceDataChanged)
    {
        _m_SourceDataChanged();
    }
}
- (void)moreAction:(id)sender
{
    // right item 事件
    UIAlertController *av = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"调整"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *_Nonnull action){
                                                        [self presentToImageCrop];
                                                    }];
    [av addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                        [self removeAction];
                                                    }];
    [av addAction:action2];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [av addAction:cancel];
    [self presentViewController:av animated:YES completion:nil];
}

- (void)pushToOCRResult
{
    [FSPushVCManager viewController:self pushToOCRResultVCWithImageFile:_m_selectedImageFile];
}
- (IBAction)toolButtonAction:(UIButton *)sender
{
    if (![_m_selectedImageFile bm_isNotEmpty])
    {
        return;
    }
    switch (sender.tag)
    {
        // 分享PDF
        case 0:
            
            [FSImageFileModel shareImagefileModels:@[_m_selectedImageFile] atViewController:self];
            break;
        // 分享图片
        case 1:
            [FSMoreViewVC showSingleShareAlertViewDelegate:self presentVC:self];
            break;
        // 保存到相册
        case 2:
        {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                if ([self.m_selectedImageFile.previewImage bm_isNotEmpty]) {
                    [PHAssetChangeRequest creationRequestForAssetFromImage:self.m_selectedImageFile.previewImage];
                }
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = success ? @"已保存到相册" :@"保存出错";
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                });
                
            }];
        }

            break;
        // 文字识别
        case 3:
            [self pushToOCRResult];
            break;
    }
    
}
// 分享按钮点击
- (void)moreViewClickWithType:(NSInteger)index
{
    [FSShareManager shareImageWithThumbImage:_m_selectedImageFile.previewImage shareImage:_m_selectedImageFile.previewImage platform:index currentVC:self delegate:nil];
}


@end
