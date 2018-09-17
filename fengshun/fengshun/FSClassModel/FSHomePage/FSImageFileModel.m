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
    FSImageFileModel *model = [[self alloc]init];
    model.m_imageUrlKey = urlKey;
    model.m_fileName = fileName;
    model.m_creatTime = [[NSDate date] bm_stringWithFormat:@"yyyy-MM-dd\nHH:mm"];
    model.m_image = image;
    model.m_isLocalSaved = NO;
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
@end
