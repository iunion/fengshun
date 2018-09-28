//
//  FSCollectionModel.h
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMTableViewManagerDefine.h"

NS_ASSUME_NONNULL_BEGIN

// 我的收藏
@interface FSMyCollectionModel : NSObject

@property (nonatomic, assign) BMTableViewCell_PositionType m_PositionType;

// 收藏类型
@property (nonatomic, assign) FSCollectionType m_CollectionType;

// 收藏id: collectionId
@property (nonatomic, strong) NSString *m_CollectionId;
// 缩略图url: coverThumbUrl
@property (nonatomic, strong) NSString *m_CoverThumbUrl;
// 帖子/法规/案例/文书/课程id: detailId
@property (nonatomic, strong) NSString *m_DetailId;
// 文书的文件id: filedId
@property (nonatomic, strong) NSString *m_FiledId;
// 指导性案例: guidingCase
@property (nonatomic, assign) BOOL m_GuidingCase;
// 文书预览地址: previewUrl
@property (nonatomic, strong) NSString *m_PreviewUrl;
// 阅读数: readCount
@property (nonatomic, assign) NSUInteger m_ReadCount;
// 来源: source
@property (nonatomic, strong) NSString *m_Source;
// 发贴时间: createTime
@property (nonatomic, assign) NSTimeInterval m_CreateTime;
// 评论数: commentCount
@property (nonatomic, assign) NSUInteger m_CommentCount;
// 标题: title
@property (nonatomic, strong) NSString *m_Title;
// 跳转地址: jumpAddress
@property (nonatomic, strong) NSString *m_JumpAddress;

+ (instancetype)collectionModelWithDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end

// 我的评论
@interface FSMyCommentModel : NSObject

@property (nonatomic, assign) BMTableViewCell_PositionType m_PositionType;

// 评论id: commentId
@property (nonatomic, strong) NSString *m_CommentId;

// 评论内容: commentContent
@property (nonatomic, strong) NSString *m_Content;

// 创建时间: createTime
@property (nonatomic, assign) NSTimeInterval m_CreateTime;

// 帖子id或课程id: detailId
@property (nonatomic, strong) NSString *m_DetailId;
// 跳转地址: jumpAddress
@property (nonatomic, strong) NSString *m_JumpAddress;

// 来源: source
@property (nonatomic, strong) NSString *m_Source;

// 类型（课程图文COURSE，帖子POSTS，评论COMMENT）: type
@property (nonatomic, assign) FSCommentType m_CommentType;

+ (instancetype)myCommentModelWithDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end


// 我的帖子
@interface FSMyTopicModel : NSObject

// 帖子id: postsId
@property (nonatomic, strong) NSString *m_TopicId;

// 标题: title
@property (nonatomic, strong) NSString *m_Title;

// 创建时间: createTime
@property (nonatomic, assign) NSTimeInterval m_CreateTime;

// 描述: description
@property (nonatomic, strong) NSString *m_Description;

// 板块名称: forumName
@property (nonatomic, strong) NSString *m_ForumName;

// 评论数: commentCount
@property (nonatomic, assign) NSUInteger m_CommentCount;

// 跳转地址: jumpAddress
@property (nonatomic, strong) NSString *m_JumpAddress;

+ (instancetype)myTopicModelWithDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

