//
//  FSImageFileModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

#define TOOLVIEW_HEIGHT 59.0f

@interface FSImageFileModel : FSSuperModel

@property (nonatomic, copy)NSString *m_fileName;
@property (nonatomic, copy)NSString *m_creatTime;
@property (nonatomic, copy)NSString *m_imageUrlKey;
@property (nonatomic, strong)UIImage *m_image;

@property (nonatomic, readonly)NSString *m_OrigianlImageUrlKey;
@property (nonatomic, strong)UIImage *m_OriginalImage;


+ (instancetype)imageFileWithSelectInfo:(NSDictionary *)info andImage:(UIImage *)image;

// 获取与更新本地保存的文件列表
+ (NSArray <FSImageFileModel *> *)localImageFileList;

+ (void)asynRefreshLocalImageFileWithList:(NSArray <FSImageFileModel *> *)imageList;

+ (void)shareImagefileModels:(NSArray <FSImageFileModel *> *)models atViewController:(UIViewController *)vc;

- (UIImage *)previewImage;
@end
