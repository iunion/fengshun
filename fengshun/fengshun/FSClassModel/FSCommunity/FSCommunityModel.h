//
//  FSCommunityModel.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSForumModel;

#pragma mark - 帖子模型
@interface FSTopicModel : NSObject

// 帖子id
@property (nonatomic, strong) NSString *m_Id;
// 版块Id
@property (nonatomic, strong) NSString *m_ForumId;
// 版块icon
@property (nonatomic, strong) NSString *m_IconUrl;
// 版块名称
@property (nonatomic, strong) NSString *m_ForumName;
// 帖子标题
@property (nonatomic, strong) NSString *m_Title;
// 发贴时间
@property (nonatomic, assign) NSTimeInterval m_CreateTime;
// 最后回贴时间
@property (nonatomic, assign) NSTimeInterval m_LastReplyTime;
// 帖子评论数
@property (nonatomic, assign) NSUInteger m_CommentCount;

// 用户Id
@property (nonatomic, strong) NSString *m_UserId;
// 用户昵称
@property (nonatomic, strong) NSString *m_NickName;

// 是否置顶
@property (nonatomic, assign) BOOL m_TopFlag;

+ (instancetype)topicWithServerDic:(NSDictionary *)dic;

+ (NSArray *)communityRecommendListModelArr:(NSArray *)arr;

- (void)updateWithServerDic:(NSDictionary *)dic;

@end

#pragma mark - 板块列表

@interface FSCommunityForumModel : NSObject
// section名称
@property (nonatomic, strong) NSString *m_Name;
// 板块图片
@property (nonatomic, strong) NSString *m_IconUrl;
// modelList
@property (nonatomic, strong) NSArray<FSForumModel *> *m_List;

+ (NSArray *)plateModelWithArr:(NSArray *)dataArray;

@end

@interface FSForumModel : NSObject
// 二级版块id
@property (nonatomic, assign) NSInteger m_Id;
// 一级图片
@property (nonatomic, strong) NSString *m_IconUrlFirst;
// 二级图片
@property (nonatomic, strong) NSString *m_IconUrlSecond;
// 一级版块名称
@property (nonatomic, strong) NSString *m_ForumNameFirst;
// 版块介绍
@property (nonatomic, strong) NSString *m_Description;
// 版块关注数量
@property (nonatomic, assign) NSInteger m_AttentionCount;
// 版块发贴数量
@property (nonatomic, assign) NSInteger m_PostsCount;
// 是否关注
@property (nonatomic, assign) BOOL m_AttentionFlag;
// 二级版块名称
@property (nonatomic, strong) NSString *m_ForumNameSecond;

+ (instancetype)forumModelWithServerDic:(NSDictionary *)dic;
// 刷新model
- (void)updateForumModel:(NSDictionary *)data;

@end


@interface FSTopicTypeModel : NSObject
// 是否活跃
@property (nonatomic , assign) BOOL m_IsActive;
// 帖子类型名称 （最新发布、最新回复）
@property (nonatomic , strong) NSString *m_PostListName;
// 帖子类型 请求type
@property (nonatomic , strong) NSString *m_PostListType;

+ (instancetype)topicTypeModelWithDic:(NSDictionary *)dic;

@end



