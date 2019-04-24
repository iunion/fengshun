//
//  FSSetPositionVC.m
//  fengshun
//
//  Created by jiang deng on 2019/4/17.
//  Copyright © 2019 FS. All rights reserved.
//

#import "FSSetPositionVC.h"
#import "AppDelegate.h"

#import "BMAlignedImageView.h"

#import "TTGTagCollectionView.h"
#import "BMDatePicker.h"

#import "FSEditorAbilityVC.h"
#import "FSEditorVC.h"
#import "FSSetCompanyVC.h"

#import "TZImagePickerController.h"


#define ImageScale      (180.0f/320.0f)

@interface FSSetPositionVC ()
<
    TZImagePickerControllerDelegate,
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource,
    FSEditorDelegate,
    FSEditorAbilityDelegate
>

@property (nonatomic, strong) BMTableViewSection *m_WorkSection;
@property (nonatomic, strong) BMTableViewItem *m_OrganizationItem;
@property (nonatomic, strong) BMTableViewItem *m_JobItem;
@property (nonatomic, strong) BMTextItem *m_WorkingLifeItem;
@property (nonatomic, strong) BMTableViewItem *m_AbilityItem;

@property (nonatomic, strong) BMDatePicker *m_WorkPickerView;

@property (nonatomic, assign) NSUInteger m_EmploymentTime;

@property (nonatomic, weak) TTGTagCollectionView *m_AbilityCollectionView;
@property (nonatomic, strong) NSMutableArray *m_AbilityViewArray;

@property (nonatomic, strong) BMAlignedImageView *m_MaterialImageView;
@property (nonatomic, strong) UIButton *m_MaterialImageDeleteBtn;

@property (nonatomic, strong) UIButton *m_CheckBtn;
@end

@implementation FSSetPositionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;
    
    [self bm_setNavigationWithTitle:@"身份认证" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    [self interfaceSettings];
    
    [self freshViews];
}

- (BOOL)needKeyboardEvent
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 130.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIView *imageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10.0f, UI_SCREEN_WIDTH, (UI_SCREEN_WIDTH-30.0f)*ImageScale+30.0f)];
    imageBgView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:imageBgView];

    UILabel *label1 = [UILabel bm_labelWithFrame:CGRectMake(0, 0, 0, 0) text:@"+" fontSize:50.0f color:UI_COLOR_BL1 alignment:NSTextAlignmentCenter lines:1];
    [imageBgView addSubview:label1];
    [label1 sizeToFit];
    [label1 bm_centerInSuperViewWithTopOffset:-30.0f];

    UILabel *label2 = [UILabel bm_labelWithFrame:CGRectMake(0, 0, 0, 0) text:@"上传工作证明材料" fontSize:16.0f color:UI_COLOR_B2 alignment:NSTextAlignmentCenter lines:1];
    [imageBgView addSubview:label2];
    [label2 sizeToFit];
    [label2 bm_centerInSuperViewWithTopOffset:10.0f];
    UILabel *label3 = [UILabel bm_labelWithFrame:CGRectMake(0, 0, 0, 0) text:@"(名片、工牌、在职证明)" fontSize:15.0f color:UI_COLOR_B4 alignment:NSTextAlignmentCenter lines:1];
    [imageBgView addSubview:label3];
    [label3 sizeToFit];
    [label3 bm_centerInSuperViewWithTopOffset:30.0f];

    BMAlignedImageView *imageView = [[BMAlignedImageView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, UI_SCREEN_WIDTH-30.0f, (UI_SCREEN_WIDTH-30.0f)*ImageScale)];
    self.m_MaterialImageView = imageView;
    self.m_MaterialImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.m_MaterialImageView.horizontallyAlignment = BMImageViewHorizontallyAlignmentCenter;
    self.m_MaterialImageView.verticallyAlignment = BMImageViewVerticallyAlignmentCenter;
    [imageView bm_roundedRect:4.0f borderWidth:1.0f borderColor:UI_DEFAULT_LINECOLOR];
    [imageBgView addSubview:imageView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(imageBgView.bm_width-48.0f, 0, 48.0f, 48.0f);
    [closeBtn setImage:[UIImage imageNamed:@"user_photoclose"] forState:UIControlStateNormal];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(-15.0f, 15.0f, 0, 0);
    [imageBgView addSubview:closeBtn];
    self.m_MaterialImageDeleteBtn = closeBtn;
    closeBtn.hidden = YES;
    [closeBtn addTarget:self action:@selector(removeMaterialImageClick:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPhoto:)];
    [imageBgView addGestureRecognizer:tapGesture];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.m_TableView.bm_width-90.0f, 44);
    btn.backgroundColor = UI_COLOR_BL1;
    btn.backgroundColor = UI_COLOR_B3;
    btn.titleLabel.font = FS_BUTTON_LARGETEXTFONT;
    btn.exclusiveTouch = YES;
    [btn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交申请" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [footerView addSubview:btn];
    self.m_CheckBtn = btn;
    self.m_CheckBtn.enabled = NO;
    [btn bm_centerHorizontallyInSuperViewWithTop:imageBgView.bm_bottom+24.0f];
    [btn bm_roundedRect:4.0f];

    footerView.bm_height = btn.bm_bottom+50.0f;
    
    self.m_TableView.tableFooterView = footerView;
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    BMWeakSelf
    
    self.m_WorkSection = [BMTableViewSection section];
    
    // 单位信息
    self.m_OrganizationItem = [BMTableViewItem itemWithTitle:@"所属单位" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_OrganizationItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_OrganizationItem.highlightBgColor = UI_COLOR_BL1;
    self.m_OrganizationItem.cellHeight = 50.0f;
    
    // 职位
    self.m_JobItem = [BMTableViewItem itemWithTitle:@"职位" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_JobItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_JobItem.highlightBgColor = UI_COLOR_BL1;
    self.m_JobItem.cellHeight = 50.0f;
    
    // 工作年限
    BMDatePicker *datePicker = [[BMDatePicker alloc] initWithPickerStyle:PickerStyle_Year completeBlock:nil];
    datePicker.maxLimitDate = [NSDate date];
    datePicker.showDoneBtn = NO;
    self.m_WorkPickerView = datePicker;
    
    self.m_WorkingLifeItem = [BMTextItem itemWithTitle:@"工作年限" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_WorkingLifeItem.hideInputView = YES;
    self.m_WorkingLifeItem.editable = YES;
    self.m_WorkingLifeItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_WorkingLifeItem.highlightBgColor = UI_COLOR_BL1;
    self.m_WorkingLifeItem.cellHeight = 50.0f;
    self.m_WorkingLifeItem.inputView = self.m_WorkPickerView;
    self.m_WorkingLifeItem.onEndEditing = ^(BMInputItem *item) {
        //NSLog(@"onEndEditing: %@", @(weakSelf.m_PickerView.pickerDate.bm_year));
        weakSelf.m_EmploymentTime = weakSelf.m_WorkPickerView.pickerDate.bm_year;
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        if (weakSelf.m_EmploymentTime != userInfo.m_UserBaseInfo.m_EmploymentTime)
        {
            //[weakSelf sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_WorkTime changeValue:@(weakSelf.m_EmploymentTime)];
        }
    };

    // 擅长领域
    self.m_AbilityItem = [BMTableViewItem itemWithTitle:@"擅长领域" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:nil];
    self.m_AbilityItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AbilityItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AbilityItem.cellHeight = 50.0f;
    
    self.m_WorkSection.headerHeight = 10.0f;
    self.m_WorkSection.footerHeight = 0.0f;
    [self.m_WorkSection addItem:self.m_OrganizationItem];
    [self.m_WorkSection addItem:self.m_JobItem];
    [self.m_WorkSection addItem:self.m_WorkingLifeItem];
    [self.m_WorkSection addItem:self.m_AbilityItem];
    
    [self.m_TableManager addSection:self.m_WorkSection];

    [self makeFooterView];
}

- (void)freshViews
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    
    BMWeakSelf
    
    NSString *text = nil;
    // 所属单位
    if ([userInfo.m_UserBaseInfo.m_Organization bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_Organization;
    }
    else
    {
        text = @"请填写";
    }
    BMImageTextView *imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    imageTextView.maxWidth = self.m_TableView.bm_width - 120.0f;
    self.m_OrganizationItem.accessoryView = imageTextView;
    self.m_OrganizationItem.selectionHandler = ^(id item) {
//        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Organization minWordCount:0 maxnWordCount:100 text:userInfo.m_UserBaseInfo.m_Organization placeholderText:nil];
//        editorVC.delegate = weakSelf;
//        [weakSelf.navigationController pushViewController:editorVC animated:YES];
        
        FSSetCompanyVC *setCompanyVC = [[FSSetCompanyVC alloc] init];
        [weakSelf.navigationController pushViewController:setCompanyVC animated:YES];
    };
    
    // 职位
    if ([userInfo.m_UserBaseInfo.m_Job bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_Job;
    }
    else
    {
        text = @"请填写";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    imageTextView.maxWidth = self.m_TableView.bm_width - 120.0f;
    self.m_JobItem.accessoryView = imageTextView;
    self.m_JobItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Job minWordCount:0 maxnWordCount:50 text:userInfo.m_UserBaseInfo.m_Job placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };
    
    // 工作年限
    if (userInfo.m_UserBaseInfo.m_EmploymentTime > 1950)
    {
        if (userInfo.m_UserBaseInfo.m_WorkingLife > 0)
        {
            text = [NSString stringWithFormat:@"%@年", @(userInfo.m_UserBaseInfo.m_WorkingLife)];
            [self.m_WorkPickerView scrollToDate:[NSDate bm_dateWithYear:userInfo.m_UserBaseInfo.m_EmploymentTime month:1 day:1] animated:YES];
        }
        else
        {
            text = @"1年内";
        }
    }
    else
    {
        text = @"请选择";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_WorkingLifeItem.accessoryView = imageTextView;

    // 擅长领域
    if ([userInfo.m_UserBaseInfo.m_Ability bm_isNotEmpty])
    {
        text = @"修改";
        
        //NSArray *tags = @[@"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索", @"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索"];
        //[self makeAbilityViewWithArray:tags];
        [self makeAbilityViewWithArray:userInfo.m_UserBaseInfo.m_AbilityArray];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
        view.backgroundColor = [UIColor whiteColor];
        
        TTGTagCollectionView *collectionView = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(15.0f, 0, UI_SCREEN_WIDTH-30.0f, 60.0f)];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.horizontalSpacing = 12.0f;
        collectionView.verticalSpacing = 6.0f;
        collectionView.bm_height = collectionView.contentSize.height;
        [view addSubview:collectionView];
        view.bm_height = collectionView.bm_height + 8.0f;
        self.m_AbilityCollectionView = collectionView;
        [self.m_AbilityCollectionView reload];
        
//        CGRect frame = CGRectMake(15.0f, view.bm_height-1, UI_SCREEN_WIDTH-15.0f, 1);
//        BMSingleLineView *underLineView = [[BMSingleLineView alloc] initWithFrame:frame];
//        underLineView.lineColor = FS_LINECOLOR;
//        underLineView.needGap = YES;
//        [view addSubview:underLineView];
        
        self.m_AbilityItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
        self.m_WorkSection.footerView = view;
        self.m_WorkSection.footerHeight = view.bm_height;
    }
    else
    {
        text = @"请选择";
        self.m_AbilityItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorLeftInset;
        self.m_WorkSection.footerView = nil;
        self.m_WorkSection.footerHeight = 0.0f;
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_AbilityItem.accessoryView = imageTextView;
    self.m_AbilityItem.selectionHandler = ^(id item) {
        if (GetAppDelegate.m_Globle_UserAbilityInfo)
        {
            [weakSelf editAbility];
        }
        else
        {
            [GetAppDelegate getUserAbilityInfoWithVc:weakSelf];
        }
    };

    [self checkDataWithUserInfo:userInfo];
    
    [self.m_TableView reloadData];
}

- (void)editAbility
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    
    FSEditorAbilityVC *editorVC = [[FSEditorAbilityVC alloc] initWithAbilityArray:userInfo.m_UserBaseInfo.m_AbilityArray];
    editorVC.delegate = self;
    [self.navigationController pushViewController:editorVC animated:YES];
}

- (void)makeAbilityViewWithArray:(NSArray *)abilityArray
{
    self.m_AbilityViewArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *ability in abilityArray)
    {
        CGFloat width = [ability bm_widthToFitHeight:20 withFont:[UIFont systemFontOfSize:13.0f]] + 12.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 26.0f)];
        label.backgroundColor = [UIColor bm_colorWithHex:0xF0F0F0];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = ability;
        [label bm_roundedRect:4.0f];
        [self.m_AbilityViewArray addObject:label];
    }
}

- (void)checkDataWithUserInfo:(FSUserInfoModel *)userInfo
{
    BOOL check = YES;
    
    // 所属单位
    if (![userInfo.m_UserBaseInfo.m_Organization bm_isNotEmpty])
    {
        check = NO;
    }
    // 职位
    else if (![userInfo.m_UserBaseInfo.m_Job bm_isNotEmpty])
    {
        check = NO;
    }
    // 材料图片
    else if (self.m_MaterialImageView.image == nil)
    {
        check = NO;
    }
    
    self.m_CheckBtn.enabled = check;
    if (check)
    {
        self.m_CheckBtn.backgroundColor = UI_COLOR_BL1;
    }
    else
    {
        self.m_CheckBtn.backgroundColor = UI_COLOR_B3;
    }
}


#pragma mark - 点击事件

- (void)removeMaterialImageClick:(UIButton *)btn
{
    self.m_MaterialImageView.image = nil;
    
    self.m_MaterialImageDeleteBtn.hidden = YES;
    self.m_CheckBtn.enabled = NO;
    self.m_CheckBtn.backgroundColor = UI_COLOR_B3;
}

- (void)checkClick:(UIButton *)btn
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    // 所属单位
    if (![userInfo.m_UserBaseInfo.m_Organization bm_isNotEmpty])
    {
        return;
    }
    // 职位
    else if (![userInfo.m_UserBaseInfo.m_Job bm_isNotEmpty])
    {
        return;
    }
    // 材料图片
    else if (self.m_MaterialImageView.image == nil)
    {
        return;
    }

}

#pragma mark - 图片选择

- (void)getPhoto:(UITapGestureRecognizer *)tap
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.allowTakePicture = YES;
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.showSelectBtn = NO;
    
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    BMLog(@"用户点击了取消");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (![photos bm_isNotEmpty])
    {
        return;
    }
    
    UIImage *image = photos[0];
    
    self.m_MaterialImageView.image = image;
    
    self.m_MaterialImageDeleteBtn.hidden = NO;
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    [self checkDataWithUserInfo:userInfo];

    return;
    
    [self.m_ProgressHUD showAnimated:YES showBackground:NO];
    
    BMWeakSelf
    [FSApiRequest uploadImg:UIImageJPEGRepresentation(image, 0.8f) success:^(id responseObject) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@", FS_URL_SERVER, FS_FILE_ADDRESS, [responseObject bm_stringTrimForKey:@"fileId"]];

        [weakSelf.m_ProgressHUD hideAnimated:NO];
        //[weakSelf sendUpdateUserInfoWithOperaType:FSUpdateUserInfo_AvatarImageUrl changeValue:url];

    } failure:^(NSError * _Nullable error) {

        [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"资料上传失败" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }];
}



#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index
{
    UIView *view = self.m_AbilityViewArray[index];
    return view.frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index
{
}


#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView
{
    return self.m_AbilityViewArray.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index
{
    return self.m_AbilityViewArray[index];
}


#pragma mark -
#pragma mark FSEditorAbilityDelegate

- (void)editorAbilityFinished:(FSEditorAbilityVC *)vc ability:(NSString *)ability;
{
    [self freshViews];
}


#pragma mark -
#pragma mark FSEditorDelegate

- (void)editorFinishedWithOperaType:(FSUpdateUserInfoOperaType)operaType value:(NSString *)value
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    
    switch (operaType)
    {
        case FSUpdateUserInfo_NickName:
            userInfo.m_UserBaseInfo.m_NickName = value;
            break;
            
        case FSUpdateUserInfo_Organization:
            userInfo.m_UserBaseInfo.m_Organization = value;
            break;
            
        case FSUpdateUserInfo_Job:
            userInfo.m_UserBaseInfo.m_Job = value;
            break;
            
        case FSUpdateUserInfo_Signature:
            userInfo.m_UserBaseInfo.m_Signature = value;
            break;
            
        default:
            break;
    }
    
    [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
    GetAppDelegate.m_UserInfo = userInfo;
    
    [self freshViews];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];
}

@end
