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
@property (nonatomic, strong)NSMutableArray <FSImageFileModel *> *m_localImageFiles;
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
- (void)setupUI
{
    self.bm_NavigationShadowHidden  = NO;
    self.bm_NavigationShadowColor   = UI_COLOR_B6;
    [self bm_setNavigationLeftItemTintColor:UI_COLOR_B1];
    [self bm_setNavigationWithTitle:@"文件扫描" barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(leftAction:) rightItemTitle:@"选择" rightItemImage:nil rightToucheEvent:@selector(rightAction:)];
    [self bm_setNavigationRightItemTintColor:UI_COLOR_BL1];
    [self bm_setNeedsUpdateNavigationBar];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [_m_imagePickButton bm_roundedRect:20];
    for (UIButton *toolButton in _m_toolButtons) {
        [toolButton bm_roundedRect:20 borderWidth:0.5 borderColor:UI_COLOR_BL1];
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
        self.m_localImageFiles  = [localFiles mutableCopy];
        self.m_allImageFiles = [localFiles mutableCopy];
    }
    else
    {
        self.m_localImageFiles  = [NSMutableArray array];
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
        [self refreshView];
    }
}
- (void)setM_editing:(BOOL)m_editing
{
    _m_editing   = m_editing;
    UIButton *rightItem = [self bm_getNavigationRightItemAtIndex:0];
    [rightItem setTitle:_m_editing?@"全选":@"选择" forState:UIControlStateNormal];
    if (_m_editing) {
        self.m_selectedImageFiles = [NSMutableArray array];
        [self refreshView];
    }
    else
    {
        [self bm_setNavigationBarTitle:@"文件扫描"];
        [_m_collectionView reloadData];
    }
    _m_toolView.hidden = !m_editing;
    _m_imagePickButton.hidden = m_editing;
    [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
        self.m_toolViewHeight.constant = m_editing?TOOLVIEW_HEIGHT:0;
        [self.view layoutIfNeeded];
    }];
}
- (void)refreshView
{
    [self bm_setNavigationBarTitle:[NSString stringWithFormat:@"已选（%lu）",(unsigned long)_m_selectedImageFiles.count]];
    [_m_collectionView reloadData];
}
- (IBAction)pickImageFile:(id)sender
{
    TZImagePickerController *imagePickerVc  = [[TZImagePickerController alloc] initWithMaxImagesCount:0 delegate:self];
    imagePickerVc.allowTakePicture          = NO;  // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo         = NO;
    imagePickerVc.alwaysEnableDoneBtn       = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakeVideo            = NO;

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)deleteSelectedImages
{
    BOOL needSynLocal = NO;
    for (FSImageFileModel *model in _m_selectedImageFiles) {
        [_m_allImageFiles removeObject:model];
        if ([_m_localImageFiles containsObject:model]) {
            needSynLocal = YES;
            [_m_localImageFiles removeObject:model];
        }
    }
    [_m_selectedImageFiles removeAllObjects];
    [self refreshView];
    if (needSynLocal) {
        [FSImageFileModel asynRefreshLocalImageFileWithList:_m_localImageFiles];
    }
}
- (void)saveImagesToLocal
{
    for (FSImageFileModel *model in _m_selectedImageFiles) {
        if (![_m_localImageFiles containsObject:model]) {
            [_m_localImageFiles addObject:model];
        }
    }
    [FSImageFileModel asynRefreshLocalImageFileWithList:_m_localImageFiles];
}
- (IBAction)toolButtonAction:(UIButton *)sender {
    if (![_m_selectedImageFiles bm_isNotEmpty]) {
        return;
    }
    switch (sender.tag) {
            // 删除
        case 0:
            [self deleteSelectedImages];
            break;
            // 分享PDF
        case 1:
            break;
            // 保存到相册
        case 2:
            [self saveImagesToLocal];
            break;
    }
    
}
#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (![photos bm_isNotEmpty]||photos.count != infos.count) return;
    NSMutableArray *selectedImages = [NSMutableArray array];
    for (NSDictionary *info in infos) {
        FSImageFileModel *model = [FSImageFileModel imageFileWithSelectInfo:info andImage:photos[[infos indexOfObject:info]]];
        [selectedImages addObject:model];
    }
    self.m_allImageFiles = [[_m_allImageFiles arrayByAddingObjectsFromArray:selectedImages]mutableCopy];
    [_m_collectionView reloadData];
}
#pragma mark - collectionView delegate & dataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageFileModel *model = _m_allImageFiles[indexPath.row];
    if (_m_editing&&![_m_selectedImageFiles containsObject:model]) {
        [_m_selectedImageFiles addObject:model];
        [self refreshView];
    }
    else
    {
        FSFileScanImagePreviewVC *preVC = [FSPushVCManager fileScanVC:self pushToImagePreviewWithSourceArray:_m_allImageFiles localArray:_m_localImageFiles selectIndex:indexPath.row];
        preVC.m_SourceDataChanged = ^{
            [collectionView reloadData];
        };
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageFileModel *model = _m_allImageFiles[indexPath.row];
    if (_m_editing&&[_m_selectedImageFiles containsObject:model]) {
        [_m_selectedImageFiles removeObject:model];
        [self refreshView];
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
