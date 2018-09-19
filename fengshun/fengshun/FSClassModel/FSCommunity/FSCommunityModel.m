//
//  FSCommunityModel.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityModel.h"


@implementation FSTopicModel

+ (instancetype)topicWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }

    NSString *topicId = [dic bm_stringTrimForKey:@"id"];
    if (![topicId bm_isNotEmpty])
    {
        topicId = [dic bm_stringTrimForKey:@"postsId"];
    }
    if (![topicId bm_isNotEmpty])
    {
        return nil;
    }

    FSTopicModel *topic = [[FSTopicModel alloc] init];
    [topic updateWithServerDic:dic];

    if ([topic.m_Id bm_isNotEmpty])
    {
        return topic;
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

    // id不存在不修改

    NSString *topicId = [dic bm_stringTrimForKey:@"id"];
    if (![topicId bm_isNotEmpty])
    {
        topicId = [dic bm_stringTrimForKey:@"postsId"];
    }
    if (![topicId bm_isNotEmpty])
    {
        return;
    }
    self.m_Id = topicId;

    // 版块Id
    // m_ForumId;
    // 版块icon
    self.m_IconUrl = [dic bm_stringTrimForKey:@"iconUrl"];
    if (![self.m_IconUrl bm_isNotEmpty])
    {
        self.m_IconUrl = [dic bm_stringTrimForKey:@"forumIconUrl"];
    }
    // 板块id
    self.m_ForumId = [dic bm_stringForKey:@"forumId"];
    // 版块名称
    self.m_ForumName = [dic bm_stringTrimForKey:@"forumName"];
    // 帖子标题
    self.m_Title = [dic bm_stringTrimForKey:@"postsTitle"];
    if (![self.m_Title bm_isNotEmpty])
    {
        self.m_Title = [dic bm_stringTrimForKey:@"title"];
    }
    // 发贴时间
    self.m_CreateTime = [dic bm_doubleForKey:@"postsCreateTime"] / 1000;
    if (self.m_CreateTime == 0)
    {
        self.m_CreateTime = [dic bm_doubleForKey:@"createTime"] / 1000;
    }
    // 最后回贴时间
    self.m_LastReplyTime = [dic bm_doubleForKey:@"postsLastReplyTime"] / 1000;
    // 帖子评论数
    self.m_CommentCount = [dic bm_uintForKey:@"commentCount"];
    // 跳转地址
    self.m_JumpAddress = [dic bm_stringForKey:@"jumpAddress"];
    // 用户Id
    //self.m_UserId;
    // 用户昵称
    self.m_NickName = [dic bm_stringForKey:@"nickName"];

    // 是否置顶
    self.m_TopFlag = [dic bm_boolForKey:@"topFlag"];
}

+ (NSArray *)communityRecommendListModelArr:(NSArray *)arr
{
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
    if ([arr bm_isNotEmpty])
    {
        for (NSDictionary *dic in arr)
        {
            FSTopicModel *model = [FSTopicModel topicWithServerDic:dic];
            if (model)
            {
                [data addObject:model];
            }
        }
    }
    return data;
}

@end


@implementation FSCommunityForumModel

+ (NSArray *)plateModelWithArr:(NSArray *)dataArray
{
    NSMutableArray *data = [NSMutableArray array];
    if ([dataArray bm_isNotEmpty])
    {
        for (id object in dataArray)
        {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *         param  = object;
                FSCommunityForumModel *aModel = [FSCommunityForumModel new];
                aModel.m_Name                 = [param bm_stringForKey:@"name"];
                aModel.m_IconUrl              = [param bm_stringForKey:@"iconUrl"];
                if ([[param bm_arrayForKey:@"list"] bm_isNotEmpty])
                {
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSDictionary *dic in [param bm_arrayForKey:@"list"])
                    {
                        FSForumModel *listModel = [FSForumModel new];
                        [listModel updateForumModel:dic];
                        if (listModel)
                        {
                            [arr addObject:listModel];
                        }
                    }
                    aModel.m_List = arr.mutableCopy;
                }
                [data addObject:aModel];
            }
        }
    }
    return data;
}

@end

@implementation FSForumModel

+ (instancetype)forumModelWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    FSForumModel *model = [FSForumModel new];
    [model updateForumModel:dic];
    return model;
}

- (void)updateForumModel:(NSDictionary *)data
{
    if (![data bm_isNotEmptyDictionary])
    {
        return;
    }
    // id不存在不修改
    if (![[data bm_stringForKey:@"id"] bm_isNotEmpty])
    {
        return;
    }
    //关注数
    self.m_AttentionCount = [data bm_intForKey:@"attentionCount"];
    //描述
    self.m_Description = [data bm_stringForKey:@"description"];
    // 第一板块名称
    self.m_ForumNameFirst = [data bm_stringForKey:@"forumNameFirst"];
    // 第二季名称
    self.m_ForumNameSecond = [data bm_stringForKey:@"forumNameSecond"];
    // 第一板块图片
    self.m_IconUrlFirst = [data bm_stringForKey:@"iconUrlFirst"];
    self.m_IconUrlSecond = [data bm_stringForKey:@"iconUrlSecond"];
    self.m_IconUrl = [data bm_stringForKey:@"iconUrl"];
    self.m_BackUrl = [data bm_stringForKey:@"backUrl"];
    // 板块id
    self.m_Id = [data bm_intForKey:@"id"];
    // 发帖数
    self.m_PostsCount = [data bm_intForKey:@"postsCount"];
    // 是否关注
    self.m_AttentionFlag   = [data bm_boolForKey:@"attentionFlag"];
}

@end

@implementation FSTopicTypeModel

+ (instancetype)topicTypeModelWithDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary]) {
        return nil;
    }
    FSTopicTypeModel *model = [FSTopicTypeModel new];
    // 类型名： 最新回复
    model.m_PostListName = [dic bm_stringTrimForKey:@"postListName"];
    // 类型请求type
    model.m_PostListType = [dic bm_stringTrimForKey:@"postListType"];
    // 是否活跃
    model.m_IsActive = [dic bm_boolForKey:@"isActive"];
    return model;
}

@end

@implementation FSTopicDetailModel

+ (instancetype)topicDetailModelWithDic:(NSDictionary *)dic
{
    if ([dic bm_isNotEmptyDictionary])
    {
        FSTopicDetailModel *model = [FSTopicDetailModel new];
        model.m_IsCollection = [dic bm_boolForKey:@"collection"];
        model.m_Content = [dic bm_stringForKey:@"content"];
        model.m_CreateTime = [dic bm_intForKey:@"createTime"]/1000;
        model.m_HeadPortraitUrl = [dic bm_stringForKey:@"headPortraitUrl"];
        model.m_NickName = [dic bm_stringForKey:@"nickName"];
        model.m_ReadCount = [dic bm_intForKey:@"readCount"];
        model.m_IsReport = [dic bm_boolForKey:@"report"];
        model.m_Title = [dic bm_stringForKey:@"title"];
        model.m_UserId = [dic bm_stringForKey:@"userId"];
        return model;
    }
    return nil;
}

@end

