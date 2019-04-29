//
//  FSMessage.m
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMessage.h"

@implementation FSCommentMessageModel

+ (instancetype)commentMessageModelWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *messageId = [dic bm_stringTrimForKey:@"messageId"];
    if (![messageId bm_isNotEmpty])
    {
        return nil;
    }
    
    FSCommentMessageModel *commentMessageModel = [[FSCommentMessageModel alloc] init];
    [commentMessageModel updateWithServerDic:dic];
    
    if ([commentMessageModel.m_MessageId bm_isNotEmpty])
    {
        return commentMessageModel;
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

    // 消息id: messageId
    NSString *messageId = [dic bm_stringTrimForKey:@"messageId"];
    if (![messageId bm_isNotEmpty])
    {
        return;
    }
    
    // 关联图文/帖子id: detailId
    NSString *detailId = [dic bm_stringTrimForKey:@"detailId"];
    if (![detailId bm_isNotEmpty])
    {
        return;
    }
    
    self.m_MessageId = messageId;
    self.m_TargetId = detailId;
    
    // 消息类型（评论、其他）: messageType
    self.m_MessageType = [dic bm_stringTrimForKey:@"messageType"];
    
    // 标题: title
    self.m_Title = [dic bm_stringTrimForKey:@"title"];
    // 内容: content
    self.m_Content = [dic bm_stringTrimForKey:@"content"];
    
    // 创建时间: createTime
    self.m_CreateTime = [dic bm_doubleForKey:@"createTime"] / 1000;

    // 关联类型: detailType (课程图文COURSE、帖子POSTS、评论COMMENT)
    NSString *type = [dic bm_stringTrimForKey:@"detailType"];
    // 课程图文
    if ([type isEqualToString:@"COURSE"])
    {
        self.m_TargetType = FSCommentTargetType_COURSE;
    }
    // 帖子
    else if ([type isEqualToString:@"POSTS"])
    {
        self.m_TargetType = FSCommentTargetType_POSTS;
    }
    // 评论
    else if ([type isEqualToString:@"COMMENT"])
    {
        self.m_TargetType = FSCommentTargetType_COMMENT;
    }
    // 法规
    else if ([type isEqualToString:@"STATUTE"])
    {
        self.m_TargetType = FSCommentTargetType_STATUTE;
    }
    // 案例
    else if ([type isEqualToString:@"CASE"])
    {
        self.m_TargetType = FSCommentTargetType_CASE;
    }
    // 文书
    else if ([type isEqualToString:@"DOCUMENT"])
    {
        self.m_TargetType = FSCommentTargetType_DOCUMENT;
    }
    // 版块
    else if ([type isEqualToString:@"FORUM"])
    {
        self.m_TargetType = FSCommentTargetType_FORUM;
    }

    
    // 跳转地址(H5为跳转URL): jumpAddress
    self.m_JumpAddress = [dic bm_stringTrimForKey:@"jumpAddress"];
    // 跳转类型（H5）: jumpType
    NSString *jumpType = [dic bm_stringTrimForKey:@"jumpType"];
    // H5
    self.m_JumpType = [FSGlobalEnum jumpTypeWithString:jumpType];
    
    // 关联用户id: relationUserId
    self.m_RelationUserId = [dic bm_stringTrimForKey:@"relationUserId"];
    // 关联用户姓名: relationUserName
    self.m_RelationUserName = [dic bm_stringTrimForKey:@"relationUserName"];
    // 关联用户头像url: relationUserPortraitUrl
    self.m_RelationUserAvatarUrl = [dic bm_stringTrimForKey:@"relationUserPortraitUrl"];
    
    // 来源: source
    self.m_Source = [dic bm_stringTrimForKey:@"source"];
    
    // 是否已读: readFlag
    self.m_ReadFlag = [dic bm_boolForKey:@"readFlag"];
}

@end

@implementation FSNoticeMessageModel

+ (instancetype)noticeMessageModelWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *messageId = [dic bm_stringTrimForKey:@"noticeId"];
    if (![messageId bm_isNotEmpty])
    {
        return nil;
    }
    
    FSNoticeMessageModel *noticeMessageModel = [[self alloc] init];
    [noticeMessageModel updateWithServerDic:dic];
    
    if ([noticeMessageModel.m_NoticeId bm_isNotEmpty])
    {
        return noticeMessageModel;
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
 
    // 公告id: noticeId
    NSString *noticeId = [dic bm_stringTrimForKey:@"noticeId"];
    if (![noticeId bm_isNotEmpty])
    {
        return;
    }
    
    self.m_NoticeId = noticeId;
    
    // 标题: title
    self.m_Title = [dic bm_stringTrimForKey:@"title"];
    // 内容: content
    self.m_Content = [dic bm_stringTrimForKey:@"content"];

    // 创建时间: createTime
    self.m_CreateTime = [dic bm_doubleForKey:@"startTime"] / 1000;
    if (self.m_CreateTime <= 0)
    {
        self.m_CreateTime = [dic bm_doubleForKey:@"createTime"] / 1000;
    }

    // 跳转地址(H5为跳转URL、图文系列为系列ID): jumpAddress
    self.m_JumpAddress = [dic bm_stringTrimForKey:@"jumpAddress"];
    // 跳转类型（H5、图文系列COURSE_SERIES）: jumpType
    NSString *jumpType = [dic bm_stringTrimForKey:@"jumpType"];
    // H5
    self.m_JumpType = [FSGlobalEnum jumpTypeWithString:jumpType];
    
    // (v1.1添加)跳转视频详情,视频详情id
    self.m_RelationId = [dic bm_stringTrimForKey:@"relationId"];
}

@end

@implementation FSNoticeDetailModel

- (void)updateWithServerDic:(NSDictionary *)dic
{
    [super updateWithServerDic:dic];
    self.m_signature = @"枫调理顺运营部";
}

@end

@implementation FSCommentListModel

+ (FSCommentListModel *)commentModelWithDic:(NSDictionary *)dic
{
    FSCommentListModel *model = [FSCommentListModel new];
    if (![[dic bm_stringForKey:@"commentId"]bm_isNotEmpty])
    {
        return nil;
    }
    model.m_CommentContent = [dic bm_stringForKey:@"commentContent"];
    model.m_CommentId = [dic bm_stringForKey:@"commentId"];
    model.m_CreateTime = [dic bm_intForKey:@"createTime"]/1000;
    model.m_DetailId = [dic bm_stringForKey:@"detailId"];
    model.m_JumpAddress = [dic bm_stringForKey:@"jumpAddress"];
    model.m_Source = [dic bm_stringForKey:@"source"];
    model.m_Type = [dic bm_stringForKey:@"type"];
    
    return model;
}

@end
