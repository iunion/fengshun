//
//  FSSendPostViewController.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSendTopicVC.h"
#import "TZImagePickerController.h"
#import "FSApiRequest.h"
#import "ZSSBarButtonItem.h"
#import "AppDelegate.h"
#import "FSApiRequest.h"
#import "FSAlertView.h"
#import "TOCropViewController.h"

#define Topic_MaxTextCount  32

@interface FSSendTopicVC ()
<
    TZImagePickerControllerDelegate
>

//相关的id
@property (nonatomic, assign) NSInteger m_RelateId;
//是否是编辑帖子
@property (nonatomic, assign) BOOL m_IsEdited;

@property (nonatomic, strong) UITextField *m_TitleTextField;

@property (nonatomic, strong) UILabel *m_PlaceHolderLab;

@end

@implementation FSSendTopicVC

- (void)dealloc
{
    
}

- (instancetype)initWithIsEdited:(BOOL)isEdited relateId:(NSInteger)relateId
{
    if (self = [super init])
    {
        self.m_RelateId = relateId;
        self.m_IsEdited = isEdited;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom image button
    
    [self createUI];
    
    // 是编辑帖子的话 获取帖子内容
    if (self.m_IsEdited)
    {
        [self getTopicDetail];
    }
}

- (void)createUI
{
    self.enabledToolbarItems = @[ ZSSRichTextEditorToolbarNone ];
    UIButton *myButton       = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.f, 28.0f)];
    [myButton setImage:[UIImage imageNamed:@"community_add_pic"] forState:UIControlStateNormal];
    [myButton addTarget:self
                 action:@selector(didTapCustomToolbarButton)
       forControlEvents:UIControlEventTouchUpInside];
    [self addCustomToolbarItemWithButton:myButton];
    
    self.placeholder        = @"请写下你的分享...";
    self.shouldShowKeyboard = NO;
    
    self.view.backgroundColor       = [UIColor whiteColor];
    
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    [self bm_setNavigationWithTitle:@"发帖" barTintColor:nil leftItemTitle:nil leftItemImage:[UIImage imageNamed:@"community_return_black"] leftToucheEvent:@selector(popViewController) rightItemTitle:@"发送" rightItemImage:nil rightToucheEvent:@selector(pulishTopicAction)];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];
    
    self.m_TitleTextField             = [[UITextField alloc] initWithFrame:CGRectMake(25.f, 0, UI_SCREEN_WIDTH - 100.f, 50.f)];
    self.m_TitleTextField.font        = [UIFont systemFontOfSize:16.f];
    self.m_TitleTextField.textColor   = UI_COLOR_B1;
    self.m_TitleTextField.placeholder = @"添加标题";
    [self.m_TitleTextField addTarget:self action:@selector(titleTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.m_TitleTextField];
    
    self.m_PlaceHolderLab = [[UILabel alloc]initWithFrame:CGRectMake(self.m_TitleTextField.bm_right, 0, 50.f, 50.f)];
    self.m_PlaceHolderLab.text = [NSString stringWithFormat:@"%@个字", @(Topic_MaxTextCount)];
    self.m_PlaceHolderLab.font = [UIFont systemFontOfSize:12.f];
    self.m_PlaceHolderLab.textAlignment = NSTextAlignmentRight;
    self.m_PlaceHolderLab.textColor = UI_COLOR_B1;
    [self.view addSubview:_m_PlaceHolderLab];
    
    BMSingleLineView *singleLine = [[BMSingleLineView alloc] initWithFrame:CGRectMake(self.m_TitleTextField.bm_left, self.m_TitleTextField.bm_bottom - 1, self.m_TitleTextField.bm_width + 50, 1)];
    singleLine.isDash            = YES;
    singleLine.lineLength        = 3.f;
    singleLine.lineSpacing       = 3.f;
    singleLine.lineColor         = [UIColor bm_colorWithHex:0x333333];
    [self.view addSubview:singleLine];
    
    [self bringSomeViewToFront];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self begainEditor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (void)titleTextChange:(UITextField *)sender
{
    if (sender != self.m_TitleTextField)
    {
        return;
    }
    
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"])
    {
        //判断markedTextRange是不是为Nil，如果为Nil的话就说明你现在没有未选中的字符，
        //可以计算文字长度。否则此时计算出来的字符长度可能不正确
        UITextRange *selectedRange = [sender markedTextRange];
        //获取高亮部分(感觉输入中文的时候才有)
        UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (self.m_TitleTextField.text.length > Topic_MaxTextCount)
            {
                self.m_TitleTextField.text = [self.m_TitleTextField.text substringToIndex:Topic_MaxTextCount];
            }
            self.m_PlaceHolderLab.text = [NSString stringWithFormat:@"%@个字", @(Topic_MaxTextCount - self.m_TitleTextField.text.length)];
        }
    }
    else
    {
        if (self.m_TitleTextField.text.length > Topic_MaxTextCount)
        {
            self.m_TitleTextField.text = [self.m_TitleTextField.text substringToIndex:Topic_MaxTextCount];
        }
        self.m_PlaceHolderLab.text = [NSString stringWithFormat:@"%@个字", @(Topic_MaxTextCount - self.m_TitleTextField.text.length)];
    }
}

// 退出
- (void)popViewController
{
    if ([self.m_TitleTextField.text bm_isNotEmpty] || [[self getHTML] bm_isNotEmpty])
    {
        BMWeakSelf;
        [FSAlertView showAlertWithTitle:@"退出编辑"
                                message:@"您确定放弃当前编辑内容？"
                            cancelTitle:@"取消"
                             otherTitle:@"确定"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 
                                 if (buttonIndex == 1)
                                 {
                                     [weakSelf backAction:nil];
                                 }
                             }];
    }
    else
    {
        [self backAction:nil];
    }
}

// 发帖按钮
- (void)pulishTopicAction
{
    if (![self.m_TitleTextField.text bm_isNotEmpty] || ![[self getHTML] bm_isNotEmpty])
    {
        [self.m_ProgressHUD showAnimated:YES withText:@"请输入完整信息" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    BMWeakSelf;
    [FSAlertView showAlertWithTitle:@"确认提交"
                            message:@"您确定发布当前帖子内容"
                        cancelTitle:@"取消"
                         otherTitle:@"确定"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             
                             if (buttonIndex == 1)
                             {
                                 [weakSelf sendTopic];
                             }
                         }];
}


- (void)didTapCustomToolbarButton
{
    TZImagePickerController *imagePickerVc  = [TZImagePickerController fs_defaultPickerWithImagesCount:1 delegate:self];
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.specialSingleSelected = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    BMLog(@"用户点击了取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (![photos bm_isNotEmpty])
    {
        return;
    }
    if ([photos bm_isNotEmpty])
    {
        [self pickerVC:picker presentToCropVCWithImage:photos[0]];
    }
}

- (void)pickerVC:(TZImagePickerController *)picker presentToCropVCWithImage:(UIImage *)orignalImage
{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:orignalImage];
    BMWeakSelf
    [cropController setOnDidCropToRect:^(UIImage * _Nonnull image, CGRect cropRect, NSInteger angle) {
        
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            [weakSelf uploadImg:UIImageJPEGRepresentation(image, 0.8)];
        }];
    }];
    [cropController setOnDidFinishCancelled:^(BOOL isFinished) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [picker presentViewController:cropController animated:YES completion:nil];

}

- (void)uploadImg:(NSData *)data
{
    [FSApiRequest uploadImg:data
                    success:^(id _Nullable responseObject) {

                        NSString *url = [NSString stringWithFormat:@"%@", [responseObject bm_stringTrimForKey:@"previewUrl"]];
                        [self insertImage:url alt:@""];
                    }
                    failure:^(NSError *_Nullable error){
                        [self.m_ProgressHUD showAnimated:YES withText:@"上传图片失败" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    }];
}

#pragma mark - Request

// 发帖
- (void)sendTopic
{
    BMWeakSelf
    [FSApiRequest sendPostsWithTitle:self.m_TitleTextField.text
                             content:[self getHTML]
                             forumId:self.m_RelateId
                            isEdited:self.m_IsEdited
                             success:^(id _Nullable responseObject) {
                                 
                                 if (weakSelf.sendPostsCallBack)
                                 {
                                     weakSelf.sendPostsCallBack();
                                 }
                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                             }
                             failure:^(NSError *_Nullable error){

                             }];
}

// 获取帖子详情
- (void)getTopicDetail
{
    BMWeakSelf
    [FSApiRequest getTopicDetail:self.m_RelateId success:^(id  _Nullable responseObject) {
        
        [weakSelf setHTML:[responseObject bm_stringForKey:@"content"]];
        weakSelf.m_TitleTextField.text = [responseObject bm_stringForKey:@"title"];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
