//
//  FSMessage.m
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMessage.h"

@implementation FSCommentMessageModle

+ (instancetype)commentMessageModleWithServerDic:(NSDictionary *)dic
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
    
    FSCommentMessageModle *commentMessageModle = [[FSCommentMessageModle alloc] init];
    [commentMessageModle updateWithServerDic:dic];
    
    if ([commentMessageModle.m_MessageId bm_isNotEmpty])
    {
        return commentMessageModle;
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
    
    // 创建时间: createTime   "createTime": "2018-09-15T01:55:59.312Z",
    NSString *createTimeStr = [dic bm_stringTrimForKey:@"createTime"];
    NSDate *createTimeDate = [NSDate bm_dateFromString:createTimeStr withFormat:@"yyyy-MM-ddTHH:mm:ss.SSSZ"];
    self.m_CreateTime = [createTimeDate timeIntervalSince1970];
    
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
    if ([jumpType isEqualToString:@"H5"])
    {
        self.m_JumpType = FSJumpType_H5;
    }
    else
    {
        self.m_JumpType = FSJumpType_NONE;
    }
    
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

@implementation FSNoticeMessageModle

+ (instancetype)noticeMessageModleWithServerDic:(NSDictionary *)dic
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
    
    FSNoticeMessageModle *noticeMessageModle = [[FSNoticeMessageModle alloc] init];
    [noticeMessageModle updateWithServerDic:dic];
    
    if ([noticeMessageModle.m_NoticeId bm_isNotEmpty])
    {
        return noticeMessageModle;
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

    // 创建时间: createTime   "createTime": "2018-09-15T01:55:59.312Z",
    NSString *createTimeStr = [dic bm_stringTrimForKey:@"createTime"];
    NSDate *createTimeDate = [NSDate bm_dateFromString:createTimeStr withFormat:@"yyyy-MM-ddTHH:mm:ss.SSSZ"];
    self.m_CreateTime = [createTimeDate timeIntervalSince1970];

    // 跳转地址(H5为跳转URL、图文系列为系列ID): jumpAddress
    self.m_JumpAddress = [dic bm_stringTrimForKey:@"jumpAddress"];
    // 跳转类型（H5、图文系列COURSE_SERIES）: jumpType
    NSString *jumpType = [dic bm_stringTrimForKey:@"jumpType"];
    // H5
    if ([jumpType isEqualToString:@"H5"])
    {
        self.m_JumpType = FSJumpType_H5;
    }
    // 图文系列COURSE_SERIES
    else if ([jumpType isEqualToString:@"COURSE_SERIES"])
    {
        self.m_JumpType = FSJumpType_COURSE_SERIES;
    }
    else
    {
        self.m_JumpType = FSJumpType_NONE;
    }
}

@end
