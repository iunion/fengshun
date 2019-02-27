//
//  FSOCRSearchResultVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/17.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSOCRSearchResultVC.h"
#import "TZImagePickerController.h"
#import "FSOCRManager.h"
#import "FSSearchResultModel.h"
#import "FSSearchResultView.h"
#import "FSLawCell.h"
#import "FSCaseCell.h"
#import "TOCropViewController.h"
#import "BMNavigationController.h"
#import "FSSimpleCameraViewController.h"

@interface
FSOCRSearchResultVC ()
<
    TZImagePickerControllerDelegate,
    TOCropViewControllerDelegate,
    UINavigationControllerDelegate,
    FSSimpleCameraControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *m_toolButtons;
@property (nonatomic, assign) BOOL m_notFirstSelected;

@property (nonatomic, strong) NSArray *m_keywords;
@property (nonatomic, strong) FSLawSearchResultModel *m_lawSearchResultModel;
@property (nonatomic, strong) FSCaseSearchResultModel *m_caseSearchResultModel;
@property (nonatomic, assign, readonly) NSInteger m_totalCount;
@property (nonatomic, assign) NSUInteger loadPage;
@property (nonatomic, strong) UIImage *m_orignalImage;
@property (nonatomic, assign) BOOL m_notEmptyViewAction;
@property (nonatomic, strong) FSSimpleCameraViewController *camera;

@end

@implementation FSOCRSearchResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];

    [self presentToCameraWithAnimated:NO];
}


- (void)setupUI
{
    self.m_LoadDataType = FSAPILoadDataType_Page;
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationLeftItemTintColor:UI_COLOR_B1];
    NSString *title = _m_ocrSearchType ? @"法规检索" : @"案例检索";
    [self bm_setNavigationWithTitle:title barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    for (UIButton *toolButton in _m_toolButtons)
    {
        [toolButton bm_roundedRect:16 borderWidth:0.5 borderColor:UI_COLOR_BL1];
    }
    self.m_TableView.estimatedRowHeight = 180;
    self.m_TableView.tableFooterView = [UIView new];
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    CGFloat topGap = UI_NAVIGATION_BAR_HEIGHT + UI_STATUS_BAR_HEIGHT + 75;
    self.m_TableView.frame = CGRectMake(0, 75, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - topGap);
    if (_m_ocrSearchType)
    {
        [self.m_TableView registerNib:[UINib nibWithNibName:@"FSLawCell" bundle:nil] forCellReuseIdentifier:@"FSLawCell"];
    }
    else
    {
        [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCaseCell" bundle:nil] forCellReuseIdentifier:@"FSCaseCell"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toolButtonAction:(UIButton *)sender
{
    if (sender.tag)
    {
        // 调整图片区域
        [self presentToImageCrop];
    }
    else
    {
        [self presentToCameraWithAnimated:YES];
    }
}

- (void)presentToImageCrop
{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:_m_orignalImage];
    cropController.delegate = self;
    [self presentViewController:cropController animated:YES completion:nil];
}
#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    BMNavigationController *nav = (BMNavigationController *)self.navigationController;
    [nav resetPushAnimation];

    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    if ([image bm_isNotEmpty])
    {
        _m_imageView.image = image;
        [self getOCRTextWithImage:image];
    }
}
#pragma mark - 打开相机

- (void)presentToCameraWithAnimated:(BOOL)animated
{
    if (animated)
    {
        self.m_notFirstSelected = YES;
    }

    if (!_camera) {
        self.camera = [[FSSimpleCameraViewController alloc] init];
        _camera.delegate = self;
    }
    
    [self presentViewController:_camera animated:animated completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

- (void)fs_cameraCancelTakePicture:(FSSimpleCameraViewController *)cameraController
{
    BMNavigationController *nav = (BMNavigationController *)self.navigationController;
    [nav resetPushAnimation];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!_m_notFirstSelected)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)imagePickerController:(UIViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        self.m_orignalImage = image;
        [self pickerVC:picker presentToCropVCWithImage:image];
    }
    else
    {
        if (!_m_notFirstSelected)
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    
    
}

- (void)pickerVC:(UIViewController *)picker presentToCropVCWithImage:(UIImage *)orignalImage
{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:orignalImage];
    BMWeakSelf
        [cropController setOnDidCropToRect:^(UIImage *_Nonnull image, CGRect cropRect, NSInteger angle) {
            [weakSelf dismissViewControllerAnimated:NO
                                         completion:^{
                                             [weakSelf getOCRTextWithImage:image];
                                         }];
        }];
    [cropController setOnDidFinishCancelled:^(BOOL isFinished) {

        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [picker presentViewController:cropController animated:YES completion:nil];
}



#pragma mark - TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_m_ocrSearchType)
    {
        FSLawResultModel *model = _m_lawSearchResultModel.m_resultDataArray[indexPath.row];
        [FSPushVCManager viewController:self pushToLawDetailWithId:model.m_lawsId keywords:_m_lawSearchResultModel.m_keywordsStr];
    }
    else
    {
        FSCaseResultModel *model = _m_caseSearchResultModel.m_resultDataArray[indexPath.row];
        [FSPushVCManager viewController:self pushToCaseDetailWithId:model.m_caseId isGuide:model.m_isGuidingCase keywords:_m_caseSearchResultModel.m_keywordsStr];
    }
}

- (NSInteger)m_totalCount
{
    if (_m_ocrSearchType)
    {
        return _m_lawSearchResultModel.m_totalCount;
    }
    else
    {
        return _m_caseSearchResultModel.m_totalCount;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = FS_VIEW_BGCOLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.view.bm_width - 32, SEARCH_HEADER_HEIGHT)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UI_COLOR_B4;
    label.text = [NSString stringWithFormat:@"共%ld条", (long)self.m_totalCount];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_m_lawSearchResultModel bm_isNotEmpty] || [_m_caseSearchResultModel bm_isNotEmpty])
    {
        return SEARCH_HEADER_HEIGHT;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_m_ocrSearchType)
    {
        return _m_lawSearchResultModel.m_resultDataArray.count;
    }
    else
    {
        return _m_caseSearchResultModel.m_resultDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_m_ocrSearchType)
    {
        FSLawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLawCell"];

        FSLawResultModel *model = _m_lawSearchResultModel.m_resultDataArray[indexPath.row];
        [cell setLawResultModel:model attributed:YES];
        return cell;
    }
    else
    {
        FSCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCaseCell"];

        FSCaseResultModel *model = _m_caseSearchResultModel.m_resultDataArray[indexPath.row];
        [cell setCaseResultModel:model attributed:YES];
        return cell;
    }
}


#pragma mark - networking

- (BMEmptyViewType)getNoDataEmptyViewType
{
    return BMEmptyViewType_OcrSearch;
}
#pragma mark - 第一步,识别出文字
- (void)getOCRTextWithImage:(UIImage *)image
{
    [self hideEmptyView];
    _m_imageView.image = image;
    [self.m_ProgressHUD showAnimated:YES showBackground:NO];
    [[FSOCRManager manager] ocr_getTextWithImage:image
        succeed:^(NSString *text) {
            if ([text bm_isNotEmpty])
            {
                [self getkeywordsWithOCRText:text];
            }
            else
            {
                //                [self.m_ProgressHUD showAnimated:YES withText:@"图片无文字" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                [self noTextForSearch];
            }
        }
        failed:^(NSError *error) {
            //            [self.m_ProgressHUD showAnimated:YES withText:@"文字识别出错" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            [self noTextForSearch];
        }];
}
- (void)noTextForSearch
{
    self.m_lawSearchResultModel = nil;
    self.m_caseSearchResultModel = nil;
    [self loadDataResponseFinished:nil responseDic:@{ @"code": @"1000" }];
}
#pragma mark - 第二步,根据文字提取关键字
- (void)getkeywordsWithOCRText:(NSString *)ocrText
{
    if (_m_ocrSearchType)
    {
        [FSApiRequest getLawsKeywordsWithText:ocrText
            success:^(id _Nullable responseObject) {
                NSDictionary *data = responseObject;
                NSArray *keywords = [data bm_arrayForKey:@"keywords"];
                [self searchWithKeywords:keywords];
            }
            failure:^(NSError *_Nullable error) {
                //                [self.m_ProgressHUD showAnimated:YES withText:@"关键字解析出错" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                [self noTextForSearch];
            }];
    }
    else
    {
        [FSApiRequest getCaseKeywordsWithText:ocrText
            success:^(id _Nullable responseObject) {
                NSDictionary *data = responseObject;
                NSArray *keywords = [data bm_arrayForKey:@"keywords"];
                [self searchWithKeywords:keywords];
            }
            failure:^(NSError *_Nullable error) {
                [self noTextForSearch];
                //                [self.m_ProgressHUD showAnimated:YES withText:@"关键字解析出错" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }];
    }
}

#pragma mark - 第三步,根据关键字,搜索
- (void)searchWithKeywords:(NSArray *)keywords
{
    self.m_keywords = keywords;
    self.m_lawSearchResultModel = nil;
    self.m_caseSearchResultModel = nil;
    self.m_notEmptyViewAction = YES;
    [self loadApiData];
}
- (void)loadApiData
{
    if (_m_notEmptyViewAction)
    {
        self.loadPage = 0;
        [super loadApiData];
    }
    else
    {
        // 空白页触发的刷新事件,在这儿是重新选图片
        [self presentToCameraWithAnimated:YES];
    }
}
- (BOOL)canLoadApiData
{
    if (_m_ocrSearchType)
    {
        return [_m_lawSearchResultModel bm_isNotEmpty] ? _m_lawSearchResultModel.m_isMore : YES;
    }
    else
    {
        return [_m_caseSearchResultModel bm_isNotEmpty] ? _m_caseSearchResultModel.m_isMore : YES;
    }
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    if (_m_ocrSearchType)
    {
        return [FSApiRequest searchLawsWithKeywords:_m_keywords start:self.loadPage size:self.m_CountPerPage filters:@[]];
    }
    else
    {
        return [FSApiRequest searchCaseWithKeywords:_m_keywords start:self.loadPage size:self.m_CountPerPage filters:@[]];
    }
}

- (void)handleCaseSearchResult:(NSDictionary *)responseObject
{
    FSCaseSearchResultModel *result = [FSCaseSearchResultModel modelWithParams:responseObject];
    if (!_m_caseSearchResultModel)
    {
        self.m_caseSearchResultModel = result;
    }
    else
    {
        _m_caseSearchResultModel.m_resultDataArray = [_m_caseSearchResultModel.m_resultDataArray arrayByAddingObjectsFromArray:result.m_resultDataArray];
    }
    self.m_caseSearchResultModel.m_isMore = result.m_isMore;
    self.m_DataArray = [_m_caseSearchResultModel.m_resultDataArray mutableCopy];
    [self.m_TableView reloadData];
}

- (void)handleLawSearchResult:(NSDictionary *)responseObject
{
    FSLawSearchResultModel *result = [FSLawSearchResultModel modelWithParams:responseObject];
    if (!_m_lawSearchResultModel)
    {
        self.m_lawSearchResultModel = result;
    }
    else
    {
        _m_lawSearchResultModel.m_resultDataArray = [_m_lawSearchResultModel.m_resultDataArray arrayByAddingObjectsFromArray:result.m_resultDataArray];
    }
    self.m_lawSearchResultModel.m_isMore = result.m_isMore;
    self.m_DataArray = [_m_lawSearchResultModel.m_resultDataArray mutableCopy];
    [self.m_TableView reloadData];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)responseObject
{
    if (_m_ocrSearchType)
    {
        [self handleLawSearchResult:responseObject];
    }
    else
    {
        [self handleCaseSearchResult:responseObject];
    }
    // 可能会出现空白页,配置此属性,正确引导空白页的事件
    self.m_notEmptyViewAction = NO;
    return YES;
}

- (BOOL)checkLoadFinish:(NSDictionary *)requestDic
{
    if (_m_ocrSearchType)
    {
        if (_m_lawSearchResultModel.m_isMore)
        {
            self.loadPage += 1;
        }
        return !_m_lawSearchResultModel.m_isMore;
    }
    else
    {
        if (_m_caseSearchResultModel.m_isMore)
        {
            self.loadPage += 1;
        }
        return !_m_caseSearchResultModel.m_isMore;
    }
}

@end
