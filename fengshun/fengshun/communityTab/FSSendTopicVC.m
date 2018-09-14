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

@interface
FSSendTopicVC ()
<
TZImagePickerControllerDelegate
>
@end

@implementation FSSendTopicVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom image button
    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarNone];
    
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50, 28.0f)];
    [myButton setTitle:@" " forState:UIControlStateNormal];
    [myButton addTarget:self
                 action:@selector(didTapCustomToolbarButton)
       forControlEvents:UIControlEventTouchUpInside];
    [self addCustomToolbarItemWithButton:myButton];
    
    // Custom image button
    ZSSBarButtonItem *item = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSinsertkeyword.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapCustomToolbarButton)];
    [self addCustomToolbarItem:item];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    imagePickerVc.allowPickingGif = NO;
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
