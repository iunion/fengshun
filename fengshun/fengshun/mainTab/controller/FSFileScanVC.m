//
//  FSFileScanVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSFileScanVC.h"
#import "TZImagePickerController.h"
#import "FSImageFileCell.h"
#import "FSFileScanImagePreviewVC.h"
#import "MBProgressHUD.h"
#import "UIScrollView+BMEmpty.h"
#import "TOCropViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>


@interface FSFileScanVC ()
<
    TZImagePickerControllerDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UIButton *m_imagePickButton;
@property (weak, nonatomic) IBOutlet UIView *m_toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toolViewHeight;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *m_toolButtons;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;

// 数据

@property (nonatomic, strong)NSMutableArray <FSImageFileModel *> *m_allImageFiles;
@property (nonatomic, strong)NSMutableArray <FSImageFileModel *> *m_selectedImageFiles;

@property (nonatomic, assign) BOOL m_editing;

@end

@implementation FSFileScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self configCollectionView];
    [self loadLocalData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshViewAndSetTitle:NO];
}
- (void)setupUI
{
    self.bm_NavigationShadowHidden  = NO;
    self.bm_NavigationShadowColor   = UI_COLOR_B6;
    [self bm_setNavigationLeftItemTintColor:UI_COLOR_B1];
    [self bm_setNavigationWithTitle:@"文件扫描" barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(leftAction:) rightItemTitle:@"选择" rightItemImage:nil rightToucheEvent:@selector(rightAction:)];
    [self bm_setNavigationRightItemTintColor:UI_COLOR_BL1];
    UIButton *rightButton = [self bm_getNavigationRightItemAtIndex:0];
    rightButton.hidden = YES;
    [self bm_setNeedsUpdateNavigationBar];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [_m_imagePickButton bm_roundedRect:20];
    _m_imagePickButton.layer.masksToBounds = NO;
    _m_imagePickButton.layer.shadowOffset = CGSizeMake(0, 5);//阴影的偏移量
    _m_imagePickButton.layer.shadowRadius = 15;
    _m_imagePickButton.layer.shadowOpacity = 0.5;                        //阴影的不透明度
    _m_imagePickButton.layer.shadowColor = [_m_imagePickButton backgroundColor].CGColor;
    
    _m_toolView.layer.shadowOffset = CGSizeMake(0, -3);
    _m_toolView.layer.shadowOpacity = 0.19;
    _m_toolView.layer.shadowColor = UI_COLOR_B2.CGColor;
    
    
    for (UIButton *toolButton in _m_toolButtons) {
        [toolButton bm_roundedRect:20 borderWidth:0.5 borderColor:UI_COLOR_BL1];
        if (UI_SCREEN_WIDTH <  375) {
            toolButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        }
    }
}
- (void)configCollectionView
{
    _m_collectionView.backgroundColor = FS_VIEW_BGCOLOR;
    _m_collectionView.delegate = self;
    _m_collectionView.dataSource = self;
    _m_collectionView.allowsMultipleSelection = YES;
    _m_collectionView.contentInset = UIEdgeInsetsMake(20, 15, 20, 15);
    [_m_collectionView registerNib:[UINib nibWithNibName:@"FSImageFileCell" bundle:nil] forCellWithReuseIdentifier:@"FSImageFileCell"];
}
- (void)loadLocalData
{
    NSArray *localFiles = [FSImageFileModel localImageFileList];
    if ([localFiles bm_isNotEmpty]) {
        self.m_allImageFiles = [localFiles mutableCopy];
    }
    else
    {
        self.m_allImageFiles = [NSMutableArray array];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  button action

-(void)leftAction:(UIBarButtonItem *)item
{
    if (!_m_editing) {
        [self backAction:item];
    }
    else
    {
        self.m_editing = NO;
    }
}
-(void)rightAction:(UIBarButtonItem *)item
{
    if (![_m_allImageFiles bm_isNotEmpty]) return;
    if (!_m_editing) {
        // 进入编辑状态
        self.m_editing = YES;
    }
    else
    {
        // 全选
        self.m_selectedImageFiles = [_m_allImageFiles mutableCopy];
        [self refreshViewAndSetTitle:YES];
    }
}
- (void)setM_editing:(BOOL)m_editing
{
    _m_editing   = m_editing;
    UIButton *rightItem = [self bm_getNavigationRightItemAtIndex:0];
    [rightItem setTitle:_m_editing?@"全选":@"选择" forState:UIControlStateNormal];
    if (_m_editing) {
        self.m_selectedImageFiles = [NSMutableArray array];
        [self refreshViewAndSetTitle:YES];
    }
    else
    {
        [self bm_setNavigationBarTitle:@"文件扫描"];
        [self refreshViewAndSetTitle:NO];
    }
    _m_toolView.hidden = !m_editing;
    _m_imagePickButton.hidden = m_editing;
    [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
        self.m_toolViewHeight.constant = m_editing?TOOLVIEW_HEIGHT:0;
        [self.view layoutIfNeeded];
    }];
}
- (void)refreshViewAndSetTitle:(BOOL)setTitle
{
    if (setTitle) {
        [self bm_setNavigationBarTitle:[NSString stringWithFormat:@"已选（%lu）",(unsigned long)_m_selectedImageFiles.count]];
    }
    [_m_collectionView reloadData];
    UIButton *rightButton = [self bm_getNavigationRightItemAtIndex:0];
    if ([_m_allImageFiles bm_isNotEmpty]) {
        [_m_collectionView hideEmptyView];
        rightButton.hidden = NO;
    }
    else
    {
        [_m_collectionView showEmptyViewWithType:BMEmptyViewType_Ocr];
        rightButton.hidden = YES &&!_m_editing;
    }
}
- (IBAction)pickImageFile:(id)sender
{
    TZImagePickerController *imagePickerVc  = [TZImagePickerController fs_defaultPickerWithImagesCount:1 delegate:self];
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.specialSingleSelected = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)deleteSelectedImages
{
    for (FSImageFileModel *model in _m_selectedImageFiles) {
        [_m_allImageFiles removeObject:model];
    }
    [_m_selectedImageFiles removeAllObjects];
    [self refreshViewAndSetTitle:YES];
    [FSImageFileModel asynRefreshLocalImageFileWithList:[_m_allImageFiles copy]];
}
- (void)saveImagesToLocal
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        for (FSImageFileModel *model in self.m_selectedImageFiles) {
            if ([model.previewImage bm_isNotEmpty]) {
                [PHAssetChangeRequest creationRequestForAssetFromImage:model.previewImage];
            }
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = success ? @"已保存到相册" :@"保存出错";
            [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        });
        
    }];
    
    
}
- (IBAction)toolButtonAction:(UIButton *)sender {
    if (![_m_selectedImageFiles bm_isNotEmpty]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"请选择图片" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    switch (sender.tag) {
            // 删除
        case 0:
            [self deleteSelectedImages];
            break;
            // 分享PDF
        case 1:
            if ([_m_selectedImageFiles bm_isNotEmpty])
            {
                [FSImageFileModel shareImagefileModels:_m_selectedImageFiles atViewController:self];
            }
            break;
            // 保存到相册
        case 2:
            [self saveImagesToLocal];
            break;
    }
    
}
#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if ([photos bm_isNotEmpty])
    {
        FSImageFileModel *model = [FSImageFileModel imageFileWithSelectInfo:[infos firstObject] andImage:photos[0]];
        [self pickerVC:picker presentToCropVCWithImageFile:model];
    }
    
}
- (void)pickerVC:(TZImagePickerController *)picker presentToCropVCWithImageFile:(FSImageFileModel *)model
{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:model.m_OriginalImage];
    BMWeakSelf
    [cropController setOnDidCropToRect:^(UIImage * _Nonnull image, CGRect cropRect, NSInteger angle) {
        model.m_image = image;
        [weakSelf.m_allImageFiles addObject:model];
        [FSImageFileModel asynRefreshLocalImageFileWithList:[weakSelf.m_allImageFiles copy]];
        [weakSelf refreshViewAndSetTitle:NO];
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            [weakSelf pushToPreviewVCWithSelectIndex:[weakSelf.m_allImageFiles indexOfObject:model]];
        }];
    }];
    [cropController setOnDidFinishCancelled:^(BOOL isFinished) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [picker presentViewController:cropController animated:YES completion:nil];
}
#pragma mark - collectionView delegate & dataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageFileModel *model = _m_allImageFiles[indexPath.row];
    if (_m_editing&&![_m_selectedImageFiles containsObject:model]) {
        [_m_selectedImageFiles addObject:model];
        [self refreshViewAndSetTitle:YES];
    }
    else
    {
        [self pushToPreviewVCWithSelectIndex:indexPath.row];
    }
}
- (void)pushToPreviewVCWithSelectIndex:(NSUInteger)selectIndex
{
    FSFileScanImagePreviewVC *preVC = [FSPushVCManager fileScanVC:self pushToImagePreviewWithSourceArray:_m_allImageFiles selectIndex:selectIndex];
    preVC.m_SourceDataChanged = ^{
        [self refreshViewAndSetTitle:NO];
    };
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageFileModel *model = _m_allImageFiles[indexPath.row];
    if (_m_editing&&[_m_selectedImageFiles containsObject:model]) {
        [_m_selectedImageFiles removeObject:model];
        [self refreshViewAndSetTitle:YES];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _m_allImageFiles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSImageFileCell" forIndexPath:indexPath];
    cell.m_editing = _m_editing;
    FSImageFileModel *model = _m_allImageFiles[indexPath.row];
    cell.m_imageFile = model;
    if (_m_editing && [_m_selectedImageFiles containsObject:model]) {
        
        cell.m_selectIndexLabel.text = [@([_m_selectedImageFiles indexOfObject:model]+1) stringValue];
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    else
    {
        cell.m_selectIndexLabel.text = @"0";
        cell.selected = NO;
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FSImageFileCell cellSize];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 14;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

@end
