//
//  FSFileScanVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSFileScanVC.h"
#import "FSImageFileCell.h"
#import "FSFileScanImagePreviewVC.h"
#import "MBProgressHUD.h"
#import "UIScrollView+BMEmpty.h"
#import "TOCropViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import "FSSimpleCameraViewController.h"


@interface FSFileScanVC ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UINavigationControllerDelegate,
    FSSimpleCameraControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIButton *m_imagePickButton;
@property (weak, nonatomic) IBOutlet UIView *m_toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toolViewHeight;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *m_toolButtons;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;

// 数据

@property (nonatomic, readonly)NSMutableArray <FSImageFileModel *> *m_allImageFiles;
@property (nonatomic, strong)NSMutableArray <FSImageFileModel *> *m_selectedImageFiles;

@property (nonatomic, assign) BOOL m_editing;

@property (nonatomic, strong) FSSimpleCameraViewController *camera;

@end

@implementation FSFileScanVC

- (NSMutableArray<FSImageFileModel *> *)m_allImageFiles
{
    return FSImageFileModel.m_allLocalImageFiles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self configCollectionView];
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
    [self bm_setNavigationWithTitle:@"文件扫描" barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(leftAction:) rightItemTitle:@"取消全选" rightItemImage:nil rightToucheEvent:@selector(rightAction:)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    FSImageFileModel.m_allLocalImageFiles = nil;
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
    if (![self.m_allImageFiles bm_isNotEmpty]) return;
    if (!_m_editing) {
        // 进入编辑状态
        self.m_editing = YES;
    }
    else
    {
        // 全选 & 取消全选
        BOOL selectedAll = item.tag;
        self.m_selectedImageFiles = selectedAll?[NSMutableArray array]:[self.m_allImageFiles mutableCopy];
        [self refreshViewAndSetTitle:YES];
    }
}
- (void)setM_editing:(BOOL)m_editing
{
    _m_editing   = m_editing;
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
    
    UIButton *rightItem = [self bm_getNavigationRightItemAtIndex:0];
    
    if (_m_editing) {
        BOOL selectedAll = _m_selectedImageFiles.count == self.m_allImageFiles.count;
        rightItem.tag = selectedAll;
        [rightItem setTitle:selectedAll?@"取消全选":@"全选" forState:UIControlStateNormal];
    }
    else
    {
        [rightItem setTitle:@"选择" forState:UIControlStateNormal];
    }
    
    
    
    if ([self.m_allImageFiles bm_isNotEmpty]) {
        [_m_collectionView hideEmptyView];
        rightItem.hidden = NO;
    }
    else
    {
        [_m_collectionView showEmptyViewWithType:BMEmptyViewType_Ocr];
        rightItem.hidden = YES;
    }
}
- (IBAction)pickImageFile:(id)sender
{
    if (!_camera) {
        self.camera = [[FSSimpleCameraViewController alloc] init];
        _camera.delegate = self;
    }
    
    [self presentViewController:_camera animated:YES completion:nil];
}

- (void)deleteSelectedImages
{
    for (FSImageFileModel *model in _m_selectedImageFiles) {
        [self.m_allImageFiles removeObject:model];
    }
    [FSImageFileModel asynRefreshLocalImageFilesInfoWithDeleteImageFiles:[_m_selectedImageFiles copy]];
    [_m_selectedImageFiles removeAllObjects];
    [self refreshViewAndSetTitle:YES];
    
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
#pragma mark - FSSimpleCameraDelegate
- (void)fs_cameraCancelTakePicture:(FSSimpleCameraViewController *)cameraController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image)
    {
        FSImageFileModel *model = [FSImageFileModel imageFileWithSelectInfo:info andImage:image];
        [self pickerVC:picker presentToCropVCWithImageFile:model];
    }
    
}
- (void)pickerVC:(UIViewController *)picker presentToCropVCWithImageFile:(FSImageFileModel *)model
{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:model.m_OriginalImage];
    BMWeakSelf
    [cropController setOnDidCropToRect:^(UIImage * _Nonnull image, CGRect cropRect, NSInteger angle) {
        model.m_image = image;
        [weakSelf.m_allImageFiles addObject:model];
        [FSImageFileModel asynRefreshLocalImageFilesInfoWithDeleteImageFiles:nil];
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
    FSImageFileModel *model = self.m_allImageFiles[indexPath.row];
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
    FSFileScanImagePreviewVC *preVC = [FSPushVCManager fileScanVC:self pushToImagePreviewWithSelectIndex:selectIndex];
    preVC.m_SourceDataChanged = ^{
        [self refreshViewAndSetTitle:NO];
    };
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageFileModel *model = self.m_allImageFiles[indexPath.row];
    if (_m_editing&&[_m_selectedImageFiles containsObject:model]) {
        [_m_selectedImageFiles removeObject:model];
        [self refreshViewAndSetTitle:YES];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.m_allImageFiles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSImageFileCell" forIndexPath:indexPath];
    cell.m_editing = _m_editing;
    FSImageFileModel *model = self.m_allImageFiles[indexPath.row];
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
