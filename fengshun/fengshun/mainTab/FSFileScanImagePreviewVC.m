//
//  FSFileScanImagePreviewVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/14.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSFileScanImagePreviewVC.h"
#import "FSImageFileModel.h"
#import "FSScrollPageView.h"
#import "MBProgressHUD.h"
#import "TOCropViewController.h"


@interface
FSFileScanImagePreviewVC ()
<
    FSScrollPageViewDelegate,
    FSScrollPageViewDataSource,
    TOCropViewControllerDelegate
>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *m_toolButtons;
@property (weak, nonatomic) IBOutlet UILabel *  m_pageContolLabel;
@property (nonatomic, strong) FSScrollPageView *m_scrollPageView;

@end

@implementation FSFileScanImagePreviewVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
}
- (void)setupUI
{
    [_m_pageContolLabel bm_roundedRect:13.5];
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor  = UI_COLOR_B6;
    [self bm_setNavigationLeftItemTintColor:UI_COLOR_B1];
    [self bm_setNavigationWithTitle:_m_selectedImageFile.m_fileName barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"更多" rightItemImage:nil rightToucheEvent:@selector(moreAction:)];
    [self bm_setNavigationRightItemTintColor:UI_COLOR_BL1];
    [self bm_setNeedsUpdateNavigationBar];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    for (UIButton *toolButton in _m_toolButtons)
    {
        [toolButton bm_roundedRect:15 borderWidth:0.5 borderColor:UI_COLOR_BL1];
    }
    
    // 内容视图
    self.m_scrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - TOOLVIEW_HEIGHT) titleColor:nil selectTitleColor:nil scrollPageSegment:nil isSubViewPageSegment:NO];
    [self.view insertSubview:_m_scrollPageView belowSubview:_m_pageContolLabel];
    _m_scrollPageView.backgroundColor = [UIColor blackColor];
    _m_scrollPageView.datasource = self;
    _m_scrollPageView.delegate   = self;

    [self refreshUIIfNeedReload:YES];
}
- (void)refreshUIIfNeedReload:(BOOL)needReload
{
    if (needReload)
    {
        [_m_scrollPageView reloadPage];
        if ([_m_allImageFiles bm_isNotEmpty])
        {
            [_m_scrollPageView scrollPageWithIndex:[_m_allImageFiles indexOfObject:_m_selectedImageFile]];
        }
    }
    NSUInteger index = [_m_allImageFiles bm_isNotEmpty] ? [_m_allImageFiles indexOfObject:_m_selectedImageFile] + 1 : 0;

    NSUInteger total        = _m_allImageFiles.count;
    _m_pageContolLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)index, (unsigned long)total];
    if (_m_selectedImageFile) {
        [self bm_setNavigationBarTitle:_m_selectedImageFile.m_fileName];
    }
    else
    {
        [self bm_setNavigationBarTitle:@"无图片"];
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
    self.m_selectedImageFile = [_m_allImageFiles objectAtIndex:index];
    [self refreshUIIfNeedReload:NO];
}
- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return _m_allImageFiles.count;
}


- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    FSImageFileModel *model = [_m_allImageFiles objectAtIndex:index];
    if ([model bm_isNotEmpty])
    {
        UIImageView *imageView  = [[UIImageView alloc] initWithImage:model.m_image];
        imageView.clipsToBounds = YES;
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        return imageView;
    }
    return nil;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
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
    NSInteger oriIndex = [_m_allImageFiles indexOfObject:_m_selectedImageFile];
    [_m_allImageFiles removeObject:_m_selectedImageFile];
    if ([_m_localImageFiles containsObject:_m_selectedImageFile])
    {
        [_m_localImageFiles removeObject:_m_selectedImageFile];
        [FSImageFileModel asynRefreshLocalImageFileWithList:[_m_localImageFiles copy]];
    }
    NSUInteger index         = (oriIndex - 1 < 0) ? 0 : oriIndex - 1;
    self.m_selectedImageFile = (_m_allImageFiles.count > index) ? _m_allImageFiles[index] : nil;
    [self refreshUIIfNeedReload:YES];
    if (_m_SourceDataChanged)
    {
        _m_SourceDataChanged();
    }
}
- (void)presentToImageCrop
{
    if (![_m_selectedImageFile bm_isNotEmpty])
    {
        return;
    }
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:_m_selectedImageFile.m_image];
    cropController.delegate = self;
    [self presentViewController:cropController animated:YES completion:nil];
}
#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    FSImageFileModel *imageFileModel = [FSImageFileModel imageFileWithOriginalImageFile:_m_selectedImageFile andCropImage:image];
    [_m_allImageFiles addObject:imageFileModel];
    self.m_selectedImageFile = imageFileModel;
    [self refreshUIIfNeedReload:YES];
    if (_m_SourceDataChanged) {
        _m_SourceDataChanged();
    }
     [cropViewController dismissViewControllerAnimated:YES completion:nil];
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
    if ([_m_selectedImageFile bm_isNotEmpty]) {
        [FSPushVCManager viewController:self pushToOCRResultVCWithImage:_m_selectedImageFile.m_image];
    }
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

            break;
        // 分享图片
        case 1:
            break;
        // 保存到相册
        case 2:
        {
            if (![_m_localImageFiles containsObject:_m_selectedImageFile]) {
                [_m_localImageFiles addObject:_m_selectedImageFile];
                [FSImageFileModel asynRefreshLocalImageFileWithList:[_m_localImageFiles copy]];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"已保存到本地" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
        }

            break;
        // 文字识别
        case 3:
            [self pushToOCRResult];
            break;
    }
    
}


@end
