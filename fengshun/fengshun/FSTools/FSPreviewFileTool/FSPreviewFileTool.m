//
//  FSPreviewFileTool.m
//  fengshun
//
//  Created by best2wa on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSPreviewFileTool.h"
#import <QuickLook/QuickLook.h>

@implementation FSFileModel

@end



@interface FSPreviewFileTool()
<
 UIDocumentInteractionControllerDelegate
>

@property(nonatomic, strong) UIDocumentInteractionController *docController;

@property(nonatomic, strong) FSFileModel *fileModel;

@property (nonatomic, strong) UIViewController *previewController;

@end

@implementation FSPreviewFileTool

+ (void)previewFileWithLocalPath:(FSFileModel *)fileModel inViewController:(UIViewController *)controller
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fileModel.bm_localPath])
    {
        FSPreviewFileTool *manager = [[FSPreviewFileTool alloc]initWithFileURL:fileModel previewViewController:controller];
        [manager initDocController];
    }
    else
    {
        NSLog(@"file not exist");
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
    if (!self.fileModel || !self.fileModel.bm_localPath)
    {
        NSLog(@"date error");
        return;
    }
    NSURL *docUrl = [NSURL fileURLWithPath:self.fileModel.bm_localPath];
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:docUrl];
    self.docController.delegate = self;
    _docController.delegate = self;
    _docController.name = self.fileModel.bm_fileName ?:@"";
    BOOL flag = [_docController presentPreviewAnimated:YES];
    if (!flag)
    {
        
    }
    else
    {
        if (IOS_VERSION >= 11.0)
        {
//            QLPreviewController *vc = [_docController performSelector:@selector(previewController)];
//            [vc performSelector:@selector(setNavigationBarTintColor:) withObject:kBlueColor];
        }
    }
}


- (void)downloadFile
{
    // 下载
    if (![self.fileModel.bm_fileUrl bm_isNotEmpty]) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [self saveFileWithData:[NSData new]];
    });
}

-(void)saveFileWithData:(NSData *)data
{
    //获取文件路径
    NSString *filePath = [self getFilePath];
    NSError *error;
    if ([data writeToFile:filePath options:NSDataWritingFileProtectionNone error:&error])
    {
        self.fileModel.bm_localPath = filePath;
        [self initDocController];
    }
    else
    {
        NSLog(@"文件错误");
    }
}

- (NSString *)getFilePath
{
    // 获取文件路径
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSArray *arr = [self.fileModel.bm_fileUrl componentsSeparatedByString:@"/"];
    NSString *name = arr.lastObject;
    if (![name bm_isNotEmpty])
    {
        name = @"aaaaa.png";
    }
    if (![self.fileModel.bm_fileName bm_isNotEmpty])
    {
        self.fileModel.bm_fileName = name;
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
