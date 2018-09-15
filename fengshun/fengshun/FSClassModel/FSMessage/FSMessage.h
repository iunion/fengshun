//
//  FSMessage.h
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, FSCommentTargetType)
{
    // 课程图文
    FSCommentTargetType_COURSE = 0,
    // 帖子
    FSCommentTargetType_POSTS,
    // 评论
    FSCommentTargetType_COMMENT,
    // 法规
    FSCommentTargetType_STATUTE,
    // 案例
    FSCommentTargetType_CASE,
    // 文书
    FSCommentTargetType_DOCUMENT,
    // 版块
    FSCommentTargetType_FORUM
};

typedef NS_OPTIONS(NSUInteger, FSJumpType)
{
    FSJumpType_NONE = 0,
    // H5
    FSJumpType_H5,
    // 图文系列COURSE_SERIES
    FSJumpType_COURSE_SERIES,
};


@interface FSCommentMessageModle : NSObject

// 消息id: messageId
@property (nonatomic, strong) NSString *m_MessageId;
// 消息类型（评论、其他）: messageType
@property (nonatomic, strong) NSString *m_MessageType;

// 标题: title
@property (nonatomic, strong) NSString *m_Title;
// 内容: content
@property (nonatomic, strong) NSString *m_Content;

// 创建时间: createTime   "createTime": "2018-09-15T01:55:59.312Z",
@property (nonatomic, assign) NSTimeInterval m_CreateTime;

// 关联图文/帖子id: detailId
@property (nonatomic, strong) NSString *m_TargetId;
// 关联类型: detailType (课程图文COURSE、帖子POSTS、评论COMMENT)
@property (nonatomic, assign) FSCommentTargetType m_TargetType;

// 跳转地址(H5为跳转URL): jumpAddress
@property (nonatomic, strong) NSString *m_JumpAddress;
// 跳转类型（H5）: jumpType
@property (nonatomic, assign) FSJumpType m_JumpType;

// 关联用户id: relationUserId
@property (nonatomic, strong) NSString *m_RelationUserId;
// 关联用户姓名: relationUserName
@property (nonatomic, strong) NSString *m_RelationUserName;
// 关联用户头像url: relationUserPortraitUrl
@property (nonatomic, strong) NSString *m_RelationUserAvatarUrl;

// 来源: source
@property (nonatomic, strong) NSString *m_Source;

// 是否已读: readFlag
@property (nonatomic, assign) BOOL m_ReadFlag;

+ (instancetype)commentMessageModleWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end


@interface FSNoticeMessageModle : NSObject

// 公告id: noticeId
@property (nonatomic, strong) NSString *m_NoticeId;

// 标题: title
@property (nonatomic, strong) NSString *m_Title;
// 内容: content
@property (nonatomic, strong) NSString *m_Content;

// 创建时间: createTime   "createTime": "2018-09-15T01:55:59.312Z",
@property (nonatomic, assign) NSTimeInterval m_CreateTime;

// 跳转地址(H5为跳转URL、图文系列为系列ID): jumpAddress
@property (nonatomic, strong) NSString *m_JumpAddress;
// 跳转类型（H5、图文系列COURSE_SERIES）: jumpType
@property (nonatomic, assign) FSJumpType m_JumpType;

+ (instancetype)noticeMessageModleWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end