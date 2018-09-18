//
//  FSImageFileModel.m
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSImageFileModel.h"

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
    NSString *timeStamp = [@((long)[NSDate date].timeIntervalSince1970) stringValue];
    NSString *urlKey = [info bm_stringForKey:@"PHImageFileURLKey"];
    NSString *realUrlKey = [urlKey stringByAppendingPathComponent:timeStamp];
    return [self creatImageFileWithUrlKey:realUrlKey fileName:[urlKey lastPathComponent] andImage:image];
}
+ (instancetype)creatImageFileWithUrlKey:(NSString *)urlKey fileName:(NSString *)fileName andImage:(UIImage *)image
{
    FSImageFileModel *model = [[self alloc] init];
    model.m_imageUrlKey     = urlKey;
    model.m_fileName        = fileName;
    model.m_creatTime       = [[NSDate date] bm_stringWithFormat:@"yyyy-MM-dd\nHH:mm"];
    model.m_image           = image;
    model.m_isLocalSaved    = NO;
    return model;
}
+ (instancetype)imageFileWithOriginalImageFile:(FSImageFileModel *)originalImageFile andCropImage:(UIImage *)image
{
    NSString *urlKey    = [originalImageFile.m_imageUrlKey stringByDeletingLastPathComponent];
    NSString *timeStamp = [@((long)[NSDate date].timeIntervalSince1970) stringValue];
    NSString *realUrlKey = [urlKey stringByAppendingPathComponent:timeStamp];
    NSString *extension  = [originalImageFile.m_fileName pathExtension];
    NSString *name       = [originalImageFile.m_fileName stringByDeletingPathExtension];
    NSString *fileName   = [[NSString stringWithFormat:@"%@-截取", name] stringByAppendingPathExtension:extension];
    return [self creatImageFileWithUrlKey:realUrlKey fileName:fileName andImage:image];
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

    model.m_isLocalSaved = YES;
    model.m_image        = [[self p_imageCache] imageFromCacheForKey:model.m_imageUrlKey];
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
        if ([model.m_imageUrlKey bm_isNotEmpty] && model.m_image)
        {
            NSString *fileName  = [model.m_fileName bm_isNotEmpty] ? model.m_fileName : @"";
            NSString *creatTime = [model.m_creatTime bm_isNotEmpty] ? model.m_creatTime : @"";
            [[self p_imageCache] storeImage:model.m_image forKey:model.m_imageUrlKey completion:nil];
            [images addObject:@{ @"fileUrlKey" : model.m_imageUrlKey,
                                 @"creatTime" : creatTime,
                                 @"fileName" : fileName,
                                 }];
        }
    }
    NSArray *imageArray = [images copy];
    [imageArray writeToFile:[self p_imageFileListPath] atomically:NO];
}
+ (BOOL)convertPDFWithImages:(NSArray<UIImage *>*)images fileName:(NSString *)fileName{
    
    if (!images || images.count == 0) return NO;
    
    // pdf文件存储路径
    NSString *pdfPath = nil;
    
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
    
    return result;
}
@end
