//
//  FSCollectionModel.h
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSCollectionModel : NSObject

/*
 collectionId = 190;
 commentCount = 9;
 coverThumbUrl = "<null>";
 createTime = 1536819513000;
 detailId = 4;
 filedId = "<null>";
 guidingCase = "<null>";
 jumpAddress = "<null>";
 previewUrl = "<null>";
 readCount = "<null>";
 source = "版块51";
 title = "发我";
 */

// 收藏类型
@property (nonatomic, assign) FSCollectionType m_CollectionType;

// 收藏id
@property (nonatomic, strong) NSString *m_CollectionId;
// 缩略图url
@property (nonatomic, strong) NSString *m_CoverThumbUrl;
// 帖子/法规/案例/文书/课程id
@property (nonatomic, strong) NSString *m_DetailId;
// 文书的文件id
@property (nonatomic, strong) NSString *m_FiledId;
// 指导性案例
@property (nonatomic, strong) NSString *m_GuidingCase;
// 文书预览地址
@property (nonatomic, strong) NSString *m_PreviewUrl;
// 阅读数
@property (nonatomic, assign) NSUInteger m_ReadCount;
// 来源
@property (nonatomic, strong) NSString *m_Source;
// 发贴时间
@property (nonatomic, assign) NSTimeInterval m_CreateTime;
// 帖子评论数
@property (nonatomic, assign) NSUInteger m_CommentCount;
// 帖子标题
@property (nonatomic, strong) NSString *m_Title;
// 跳转地址
@property (nonatomic, strong) NSString *m_JumpAddress;

+ (instancetype)collectionModelWithDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

