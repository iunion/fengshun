//
//  FSPreviewFileTool.h
//  fengshun
//
//  Created by best2wa on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FSFileModel : NSObject

// 文件名
@property (nonatomic, copy) NSString *m_FileName;
// 本地文件路径
@property (nonatomic, copy) NSString *m_LocalPath;
// 网络资源地址
@property (nonatomic, copy) NSString *m_FileUrl;

@end

@interface FSPreviewFileTool : NSObject

// 网络资源
+ (void)previewFileWithNetworkResourse:(FSFileModel *)fileModel inViewController:(UIViewController *)controller;

// 本地资源
+ (void)previewFileWithLocalPath:(FSFileModel *)fileModel inViewController:(UIViewController *)controller;

@end
