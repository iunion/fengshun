//
//  FSImageFileModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSImageFileModel.h"
#import "MBProgressHUD.h"

@implementation FSImageFileModel

+ (NSString *)p_imageFileListPath
{
    return [[NSString bm_documentsPath] stringByAppendingPathComponent:@"fileScan_image.plist"];
}
+ (SDImageCache *)p_imageCache
{
    return [[SDImageCache alloc] initWithNamespace:@"scan_file_localimage"];
}
+ (instancetype)imageFileWithSelectInfo:(NSDictionary *)info andImage:(UIImage *)image
{
    NSDate *currentDate = [NSDate date];
    NSString *timeStamp = [@((long)currentDate.timeIntervalSince1970) stringValue];
    NSString *urlKey = [info bm_stringForKey:@"PHImageFileURLKey"];
    if (![urlKey bm_isNotEmpty]) {
        urlKey = [NSString stringWithFormat:@"FSFileScan://imageSelected/IMG%@.png",timeStamp];
    }
    NSString *realUrlKey = [urlKey stringByAppendingPathComponent:timeStamp];
    NSString *fileName = [currentDate bm_stringWithFormat:@"yyyy-MM-dd HH:mm:ss扫描"];
    return [self creatImageFileWithUrlKey:realUrlKey fileName:fileName andImage:image];
}
+ (instancetype)creatImageFileWithUrlKey:(NSString *)urlKey fileName:(NSString *)fileName andImage:(UIImage *)image
{
    FSImageFileModel *model = [[self alloc] init];
    model.m_imageUrlKey     = urlKey;
    model.m_fileName        = fileName;
    model.m_creatTime       = [[NSDate date] bm_stringWithFormat:@"yyyy-MM-dd\nHH:mm"];
    model.m_OriginalImage   = image;
    return model;
}

+ (NSArray<FSImageFileModel *> *)localImageFileList
{
    NSArray *images = [NSArray arrayWithContentsOfFile:[self p_imageFileListPath]];
    return [self modelsWithDataArray:images];
}
+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSImageFileModel *model = [[self alloc] init];
    model.m_imageUrlKey     = [params bm_stringForKey:@"fileUrlKey"];
    model.m_fileName        = [params bm_stringForKey:@"fileName"];
    model.m_creatTime       = [params bm_stringForKey:@"creatTime"];
    model.m_image        = [[self p_imageCache] imageFromCacheForKey:model.m_imageUrlKey];
    model.m_OriginalImage = [[self p_imageCache] imageFromCacheForKey:model.m_OrigianlImageUrlKey];
    return model;
}
+ (void)asynRefreshLocalImageFileWithList:(NSArray<FSImageFileModel *> *)imageList
{
    [[self p_imageCache] deleteOldFilesWithCompletionBlock:^{
        [self p_saveImagesToLocal:imageList];
    }];
    
}
+ (void)p_saveImagesToLocal:(NSArray<FSImageFileModel *> *)imageList
{
    NSMutableArray *images = [NSMutableArray array];
    for (FSImageFileModel *model in imageList)
    {
        if ([model.m_imageUrlKey bm_isNotEmpty] && model.previewImage)
        {
            NSString *fileName  = [model.m_fileName bm_isNotEmpty] ? model.m_fileName : @"";
            NSString *creatTime = [model.m_creatTime bm_isNotEmpty] ? model.m_creatTime : @"";
            [[self p_imageCache] storeImage:model.m_image forKey:model.m_imageUrlKey completion:nil];
            [[self p_imageCache] storeImage:model.m_OriginalImage forKey:model.m_OrigianlImageUrlKey completion:nil];
            [images addObject:@{ @"fileUrlKey" : model.m_imageUrlKey,
                                 @"creatTime" : creatTime,
                                 @"fileName" : fileName,
                                 }];
        }
    }
    NSArray *imageArray = [images copy];
    [imageArray writeToFile:[self p_imageFileListPath] atomically:NO];
}
+ (void)pdfPathWithImagefileModels:(NSArray <FSImageFileModel *> *)models completion:(void(^)(NSString *pdfPath))completion
{
    NSString *timeStamp = [@((long)[NSDate date].timeIntervalSince1970) stringValue];
    NSString *fileName = [[NSString stringWithFormat:@"PDF分享-%@",timeStamp] stringByAppendingPathExtension:@"pdf"];
    NSMutableArray *images = [NSMutableArray array];
    for (FSImageFileModel *model in models) {
        if ([model.previewImage bm_isNotEmpty]) {
            [images addObject:model.previewImage];
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *pdfPath = [self convertPDFWithImages:[images copy] fileName:fileName];
        if (completion) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(pdfPath);
            });
        }
    });
}
+ (void)shareImagefileModels:(NSArray<FSImageFileModel *> *)models atViewController:(UIViewController *)vc
{
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    [self pdfPathWithImagefileModels:models completion:^(NSString *pdfPath) {
        [MBProgressHUD hideHUDForView:vc.view animated:YES];
        if (![pdfPath bm_isNotEmpty]) {
            [MBProgressHUD showHUDAddedTo:vc.view animated:YES withText:@"生成PDF文件出错" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        NSArray *activityItems = @[[NSURL fileURLWithPath:pdfPath]];
        
        UIActivityViewController *activityViewController =    [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [vc presentViewController:activityViewController animated:YES completion:nil];
        
        [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            if([[NSFileManager defaultManager]fileExistsAtPath:pdfPath])
            {
                [[NSFileManager defaultManager]removeItemAtPath:pdfPath error:nil];
            }
        }];
    }];
    

}
+ (NSString *)convertPDFWithImages:(NSArray<UIImage *>*)images fileName:(NSString *)fileName{
    
    if (!images || images.count == 0) return nil;

    // pdf文件存储路径
     NSString *pdfPath      = [[NSString bm_temporaryPath] stringByAppendingPathComponent:fileName];
   
    
    BOOL result = UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, NULL);
    
    // pdf每一页的尺寸大小
    
    CGRect pdfBounds = UIGraphicsGetPDFContextBounds();
    CGFloat pdfWidth = pdfBounds.size.width;
    CGFloat pdfHeight = pdfBounds.size.height;
    
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        // 绘制PDF
        UIGraphicsBeginPDFPage();
        
        // 获取每张图片的实际长宽
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        //        CGRect imageBounds = CGRectMake(0, 0, imageW, imageH);
        //        NSLog(@"%@",NSStringFromCGRect(imageBounds));
        
        // 每张图片居中显示
        // 如果图片宽高都小于PDF宽高
        if (imageW <= pdfWidth && imageH <= pdfHeight) {
            
            CGFloat originX = (pdfWidth - imageW) * 0.5;
            CGFloat originY = (pdfHeight - imageH) * 0.5;
            [image drawInRect:CGRectMake(originX, originY, imageW, imageH)];
            
        }
        else{
            CGFloat w,h; // 先声明缩放之后的宽高
            //            图片宽高比大于PDF
            if ((imageW / imageH) > (pdfWidth / pdfHeight)){
                w = pdfWidth - 20;
                h = w * imageH / imageW;
                
            }else{
                //             图片高宽比大于PDF
                h = pdfHeight - 20;
                w = h * imageW / imageH;
            }
            [image drawInRect:CGRectMake((pdfWidth - w) * 0.5, (pdfHeight - h) * 0.5, w, h)];
        }
    }];
    
    UIGraphicsEndPDFContext();
    
    return result?pdfPath:nil;
}
- (NSString *)m_OrigianlImageUrlKey
{
    return [NSString stringWithFormat:@"originalkey-%@",_m_imageUrlKey];
}
- (UIImage *)previewImage
{
    return [_m_image bm_isNotEmpty]?_m_image :_m_OriginalImage;
}
@end
