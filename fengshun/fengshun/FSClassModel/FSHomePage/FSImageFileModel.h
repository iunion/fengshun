//
//  FSImageFileModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"
#import "SDImageCache.h"

#define TOOLVIEW_HEIGHT 59.0f

@interface FSImageFileModel : FSSuperModel

@property (class, nonatomic, readonly)SDImageCache *m_imageSotre;

@property (class, nonatomic, strong)NSMutableArray <FSImageFileModel *>*m_allLocalImageFiles;

@property (nonatomic, copy)NSString *m_fileName;
@property (nonatomic, copy)NSString *m_creatTime;
@property (nonatomic, copy)NSString *m_imageUrlKey;
@property (nonatomic, strong)UIImage *m_image;

@property (nonatomic, readonly)NSString *m_OrigianlImageUrlKey;
@property (nonatomic, strong)UIImage *m_OriginalImage;

// 1.1.3变更
@property (nonatomic, copy)NSString *m_OCRText;


+ (instancetype)imageFileWithSelectInfo:(NSDictionary *)info andImage:(UIImage *)image;

+ (void)asynRefreshLocalImageFilesInfoWithDeleteImageFiles:(NSArray<FSImageFileModel *> *)deleteFiles;

+ (void)shareImagefileModels:(NSArray <FSImageFileModel *> *)models atViewController:(UIViewController *)vc;

- (UIImage *)previewImage;
@end
