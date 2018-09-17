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
#import "FSAlertVC.h"


@interface
FSSendTopicVC ()
<
TZImagePickerControllerDelegate
>
//相关的id
@property (nonatomic, assign) NSInteger m_RelateId;
//是否是编辑帖子
@property (nonatomic, assign) BOOL m_IsEdited;

@property (nonatomic, strong) UITextField *m_TitleTextField;

@end

@implementation FSSendTopicVC


- (instancetype)initWithIsEdited:(BOOL)isEdited relateId:(NSInteger )relateId{
    if (self = [super init])
    {
        self.m_RelateId = relateId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom image button
    self.enabledToolbarItems = @[ ZSSRichTextEditorToolbarNone ];

    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.f, 28.0f)];
    [myButton setImage:[UIImage imageNamed:@"community_add_pic"] forState:UIControlStateNormal];
    [myButton addTarget:self
                  action:@selector(didTapCustomToolbarButton)
        forControlEvents:UIControlEventTouchUpInside];
    [self addCustomToolbarItemWithButton:myButton];
    self.placeholder        = @"请写下你的分享...";
    self.shouldShowKeyboard = NO;


    self.view.backgroundColor       = [UIColor whiteColor];
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    [self bm_setNavigationWithTitle:@"热门推荐" barTintColor:nil leftItemTitle:nil leftItemImage:[UIImage imageNamed:@"community_return_black"] leftToucheEvent:@selector(popViewController) rightItemTitle:@"发送" rightItemImage:nil rightToucheEvent:@selector(pulishTopicAction)];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    self.m_TitleTextField             = [[UITextField alloc] initWithFrame:CGRectMake(25.f, 0, UI_SCREEN_WIDTH - 50.f, 50.f)];
    self.m_TitleTextField.font        = [UIFont systemFontOfSize:16.f];
    self.m_TitleTextField.textColor   = UI_COLOR_B1;
    self.m_TitleTextField.placeholder = @"添加标题";
    [self.view addSubview:self.m_TitleTextField];

    UIView *singleLine         = [[UIView alloc] initWithFrame:CGRectMake(self.m_TitleTextField.bm_left, self.m_TitleTextField.bm_bottom, self.m_TitleTextField.bm_width, 1)];
    singleLine.backgroundColor = UI_COLOR_B9;
    [self.view addSubview:singleLine];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)popViewController
{
    if ([self.m_TitleTextField.text bm_isNotEmpty] || [[self getHTML] bm_isNotEmpty])
    {
        [FSAlertVC showAlertWithTitle:@"退出编辑" message:@"您确定放弃当前编辑内容？" cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (!cancelled)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)pulishTopicAction
{
    BMLog(@"%@", [self getHTML]);
    if (![self.m_TitleTextField.text bm_isNotEmpty] || ![[self getHTML] bm_isNotEmpty])
    {
        return;
    }
    [FSApiRequest sendPostsWithTitle:self.m_TitleTextField.text content:[self getHTML] forumId:self.m_RelateId isEdited:self.m_IsEdited success:^(id  _Nullable responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nullable error) {
        
    }] ;
}


- (void)didTapCustomToolbarButton
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
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
    imagePickerVc.allowPickingGif           = NO;
    //imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    imagePickerVc.sortAscendingByModificationDate = NO;
    // 设置竖屏下的裁剪尺寸
    //imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
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
    if (![photos bm_isNotEmpty]) {
        return;
    }
    UIImage *img = photos[0];
    [FSApiRequest uploadImg:UIImageJPEGRepresentation(img, .8) success:^(id  _Nullable responseObject) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@",FS_URL_SERVER,FS_FILE_Adress,[responseObject bm_stringTrimForKey:@"fileId"]];
        [self insertImage:url alt:@"123"];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
