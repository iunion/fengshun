//
//  FSPreviewFileTool.m
//  fengshun
//
//  Created by best2wa on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSPreviewFileTool.h"
#import <QuickLook/QuickLook.h>
#import "XMRequestManager.h"

@implementation FSFileModel

@end

@interface FSPreviewFileTool()
<
    UIDocumentInteractionControllerDelegate
>

@property (nonatomic, strong) UIDocumentInteractionController *docController;

@property (nonatomic, strong) FSFileModel *fileModel;

@property (nonatomic, strong) UIViewController *previewController;

@end

@implementation FSPreviewFileTool

+ (void)previewFileWithLocalPath:(FSFileModel *)fileModel inViewController:(UIViewController *)controller
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fileModel.m_LocalPath])
    {
        FSPreviewFileTool *manager = [[FSPreviewFileTool alloc]initWithFileURL:fileModel previewViewController:controller];
        [manager initDocController];
    }
    else
    {
        BMLog(@"file not exist");
    }
}

+ (void)previewFileWithNetworkResourse:(FSFileModel *)fileModel inViewController:(UIViewController *)controller
{
    FSPreviewFileTool *manager = [[FSPreviewFileTool alloc] initWithFileURL:fileModel previewViewController:controller];
    [manager downloadFile];
}

- (instancetype)initWithFileURL:(FSFileModel *)fileModel previewViewController:(UIViewController *)previewViewController
{
    if (self = [super init])
    {
        self.fileModel = fileModel;
        self.previewController = previewViewController;
    }
    return self;
}

- (void)initDocController
{
    if (![self.fileModel.m_LocalPath bm_isNotEmpty])
    {
        BMLog(@"date error");
        return;
    }
    
    NSURL *docUrl = [NSURL fileURLWithPath:self.fileModel.m_LocalPath];
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:docUrl];
    self.docController.delegate = self;
    self.docController.name = self.fileModel.m_FileName ?:@"";
    [self.docController presentPreviewAnimated:YES];
}

- (void)downloadFile
{
    // 下载
    if (![self.fileModel.m_FileUrl bm_isNotEmpty])
    {
        BMLog(@"url error");
        return;
    }
    
    NSString *savePath = [self getFilePath];
    [XMRequestManager rm_downloadWithURL:self.fileModel.m_FileUrl savePath:savePath success:^(id responseObject)
    {
        if (responseObject)
        {
            self.fileModel.m_LocalPath = savePath;
            [self initDocController];
        }
    } failure:^(NSError * _Nullable error) {
        BMLog(@"download failed");
    }];
}

- (NSString *)getFilePath
{
    // 获取文件路径
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSArray *arr = [self.fileModel.m_FileUrl componentsSeparatedByString:@"/"];
    NSString *name = arr.lastObject;
    if (![name bm_isNotEmpty])
    {
        name = @"aaaaa.png";
    }
    if (![self.fileModel.m_FileName bm_isNotEmpty])
    {
        self.fileModel.m_FileName = name;
    }
    NSString *fileName = [NSString stringWithFormat:@"tmp_%@", name];
    NSString *filePath= [tmpDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}


#pragma mark -  UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.previewController;
}

@end
