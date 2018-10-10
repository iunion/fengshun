//
//  FSCollectionModel.m
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionModel.h"

@implementation FSMyCollectionModel

+ (instancetype)collectionModelWithDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }

    // 收藏id
    NSString *collectionId = [dic bm_stringTrimForKey:@"collectionId"];
    if (![collectionId bm_isNotEmpty])
    {
        return nil;
    }

    FSMyCollectionModel *model = [[FSMyCollectionModel alloc] init];
    [model updateWithServerDic:dic];
    
    if ([model.m_CollectionId bm_isNotEmpty] && [model.m_DetailId bm_isNotEmpty])
    {
        return model;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }

    // 收藏id
    NSString *collectionId = [dic bm_stringTrimForKey:@"collectionId"];
    if (![collectionId bm_isNotEmpty])
    {
        return;
    }

    // 帖子/法规/案例/文书/课程id
    NSString *detailId = [dic bm_stringTrimForKey:@"detailId"];
    if (![detailId bm_isNotEmpty])
    {
        return;
    }

    self.m_CollectionId = collectionId;
    self.m_DetailId = detailId;

    // 文书的文件id: filedId
    self.m_FiledId = [dic bm_stringTrimForKey:@"filedId"];

    // 缩略图url: coverThumbUrl
    self.m_CoverThumbUrl = [dic bm_stringTrimForKey:@"coverThumbUrl"];
    // 指导性案例: guidingCase
    self.m_GuidingCase = [dic bm_boolForKey:@"guidingCase"];
    // 文书预览地址: previewUrl
    self.m_PreviewUrl = [dic bm_stringTrimForKey:@"previewUrl"];
    // 阅读数: readCount
    self.m_ReadCount = [dic bm_stringTrimForKey:@"readCount"];
    // 来源: source
    self.m_Source = [dic bm_stringTrimForKey:@"source"];
    // 发贴时间: createTime
    self.m_CreateTime = [dic bm_doubleForKey:@"createTime"]/1000;
    // 评论数: commentCount
    self.m_CommentCount = [dic bm_stringTrimForKey:@"commentCount"];
    // 标题: title
    self.m_Title = [dic bm_stringTrimForKey:@"title"];
    // 跳转地址: jumpAddress
    self.m_JumpAddress = [dic bm_stringTrimForKey:@"jumpAddress"];
    
    // type, 主要用来区分图文和图文系列
    // COURSE-课程,POSTS-帖子,STATUTE-法规,CASE-案例,DOCUMENT-文书范本,SPECIAL-图文列表
    self.m_type = [dic bm_stringTrimForKey:@"type"];
    if ([self.m_type isEqualToString:@"COURSE"] || [self.m_type isEqualToString:@"SPECIAL"])
    {
        self.m_CollectionType = FSCollectionType_COURSE;
    }
    
    if (self.m_CollectionType != FSCollectionType_COURSE)
    {
        CGSize size = [self.m_Title bm_sizeToFitWidth:UI_SCREEN_WIDTH-30.0f withFont:UI_FONT_18];
        self.m_TitleHeight = size.height;
    }
}

- (BOOL)m_isSerial
{
    return [_m_type isEqualToString:@"SPECIAL"];
}

//- (CGFloat)titleHeight
//{
//    CGSize size = [self.m_Title bm_sizeToFitWidth:UI_SCREEN_WIDTH-30.0f withFont:UI_FONT_18];
//
//    return size.height;
//}
//
//- (CGFloat)cellHeight
//{
//    CGFloat height = [self titleHeight];
//
//    return height+20+16+20+20;
//}

@end

@implementation FSMyCommentModel

+ (instancetype)myCommentModelWithDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    // 评论id: commentId
    NSString *commentId = [dic bm_stringTrimForKey:@"commentId"];
    if (![commentId bm_isNotEmpty])
    {
        return nil;
    }
    
    FSMyCommentModel *model = [[FSMyCommentModel alloc] init];
    [model updateWithServerDic:dic];
    
    if ([model.m_CommentId bm_isNotEmpty] && [model.m_DetailId bm_isNotEmpty])
    {
        return model;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    
    // 评论id: commentId
    NSString *commentId = [dic bm_stringTrimForKey:@"commentId"];
    if (![commentId bm_isNotEmpty])
    {
        return;
    }
    
    // 帖子id或课程id: detailId
    NSString *detailId = [dic bm_stringTrimForKey:@"detailId"];
    if (![detailId bm_isNotEmpty])
    {
        return;
    }
    
    self.m_CommentId = commentId;
    self.m_DetailId = detailId;
    
    // 评论内容: commentContent
    self.m_Content = [dic bm_stringTrimForKey:@"commentContent"];
    
    // 创建时间: createTime
    self.m_CreateTime = [dic bm_doubleForKey:@"createTime"]/1000;
    
    // 跳转地址: jumpAddress
    self.m_JumpAddress = [dic bm_stringTrimForKey:@"jumpAddress"];
    
    // 来源: source
    self.m_Source = [dic bm_stringTrimForKey:@"source"];
    
    // 类型（课程图文COURSE，帖子POSTS，评论COMMENT）: type
    NSString *type = [dic bm_stringTrimForKey:@"type"];
    if ([type isEqualToString:@"COURSE"])
    {
        self.m_CommentType = FSCommentType_COURSE;
    }
    else if ([type isEqualToString:@"POSTS"])
    {
        self.m_CommentType = FSCommentType_POSTS;
    }
    else if ([type isEqualToString:@"COMMENT"])
    {
        self.m_CommentType = FSCommentType_COMMENT;
    }
}

@end

@implementation FSMyTopicModel

+ (instancetype)myTopicModelWithDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    // 帖子id: postsId
    NSString *postsId = [dic bm_stringTrimForKey:@"postsId"];
    if (![postsId bm_isNotEmpty])
    {
        return nil;
    }
    
    FSMyTopicModel *model = [[FSMyTopicModel alloc] init];
    [model updateWithServerDic:dic];
    
    if ([model.m_TopicId bm_isNotEmpty])
    {
        return model;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    
    // 帖子id: postsId
    NSString *postsId = [dic bm_stringTrimForKey:@"postsId"];
    if (![postsId bm_isNotEmpty])
    {
        return;
    }
    
    self.m_TopicId = postsId;
    
    // 标题: title
    self.m_Title = [dic bm_stringTrimForKey:@"title"];
    
    // 创建时间: createTime
    self.m_CreateTime = [dic bm_doubleForKey:@"createTime"]/1000;

    // 描述: description
    self.m_Description = [dic bm_stringTrimForKey:@"description"];
    
    // 板块名称: forumName
    self.m_ForumName = [dic bm_stringTrimForKey:@"forumName"];
    
    // 评论数: commentCount
    self.m_CommentCount = [dic bm_uintForKey:@"commentCount"];
    
    // 跳转地址: jumpAddress
    self.m_JumpAddress = [dic bm_stringTrimForKey:@"jumpAddress"];
}

@end
