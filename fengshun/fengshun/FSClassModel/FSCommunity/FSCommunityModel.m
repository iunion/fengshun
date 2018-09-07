//
//  FSCommunityModel.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityModel.h"


@implementation FSCommunityTopicListModel

+ (NSArray *)communityRecommendListModelArr:(NSArray *)list
{
    NSMutableArray *data = [NSMutableArray array];
    for (id object in list)
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *             param  = object;
            FSCommunityTopicListModel *aModel = [FSCommunityTopicListModel new];
            aModel.m_Id                       = [param bm_stringForKey:@"id"];
            aModel.m_IconUrl                  = [param bm_stringForKey:@"iconUrl"];
            aModel.m_CommentCount             = [param bm_intForKey:@"commentCount"];
            aModel.m_ForumName                = [param bm_stringForKey:@"forumName"];
            aModel.m_NickName                 = [param bm_stringForKey:@"nickName"];
            aModel.m_PostsCreateTime          = [param bm_intForKey:@"postsCreateTime"];
            aModel.m_TopFlag                  = [param bm_boolForKey:@"topFlag"];
            aModel.m_PostsLastReplyTime       = [param bm_intForKey:@"postsLastReplyTime"];
            aModel.m_PostsTitle               = [param bm_stringForKey:@"postsTitle"];
            [data addObject:aModel];
        }
    }
    return data;
}

- (void)updateTopicModel:(NSDictionary *)data
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
    self.m_Id                 = [data bm_stringForKey:@"id"];
    self.m_IconUrl            = [data bm_stringForKey:@"iconUrl"];
    self.m_CommentCount       = [data bm_intForKey:@"commentCount"];
    self.m_ForumName          = [data bm_stringForKey:@"forumName"];
    self.m_NickName           = [data bm_stringForKey:@"nickName"];
    self.m_PostsCreateTime    = [data bm_intForKey:@"postsCreateTime"];
    self.m_TopFlag            = [data bm_boolForKey:@"topFlag"];
    self.m_PostsLastReplyTime = [data bm_intForKey:@"postsLastReplyTime"];
    self.m_PostsTitle         = [data bm_stringForKey:@"postsTitle"];
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
                        FSCommunityForumListModel *listModel = [FSCommunityForumListModel new];
                        listModel.m_AttentionCount           = [dic bm_intForKey:@"attentionCount"];
                        listModel.m_Description              = [dic bm_stringForKey:@"description"];
                        listModel.m_ForumNameFirst           = [dic bm_stringForKey:@"forumNameFirst"];
                        listModel.m_ForumNameSecond          = [dic bm_stringForKey:@"forumNameSecond"];
                        listModel.m_IconUrl                  = [dic bm_stringForKey:@"iconUrl"];
                        listModel.m_Id                       = [dic bm_intForKey:@"id"];
                        listModel.m_PostsCount               = [dic bm_intForKey:@"postsCount"];
                        listModel.m_AttentionFlag            = [dic bm_boolForKey:@"attentionFlag"];
                        [arr addObject:listModel];
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

@implementation FSCommunityForumListModel

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
    self.m_AttentionCount  = [data bm_intForKey:@"attentionCount"];
    self.m_Description     = [data bm_stringForKey:@"description"];
    self.m_ForumNameFirst  = [data bm_stringForKey:@"forumNameFirst"];
    self.m_ForumNameSecond = [data bm_stringForKey:@"forumNameSecond"];
    self.m_IconUrl         = [data bm_stringForKey:@"iconUrl"];
    self.m_Id              = [data bm_intForKey:@"id"];
    self.m_PostsCount      = [data bm_intForKey:@"postsCount"];
    self.m_AttentionFlag   = [data bm_boolForKey:@"attentionFlag"];
}

@end

@implementation FSCommunityDetailInfoModel
/*
 communityForumDTO =     {
     attentionCount = 20;
     attentionFlag = 1;
     description = "\U7248\U5757\U4ecb\U7ecd";
     forumNameFirst = "\U4e00\U7ea7\U540d\U79f0";
     forumNameSecond = "\U4e8c\U7ea7";
     iconUrlFirst = "kads.jpg";
     iconUrlSecond = "2.jpg";
     id = 5;
     postsCount = 50;
 };
 essenceDisplayFlag = 1;
 */
+ (FSCommunityDetailInfoModel *)infoModelWithDic:(NSDictionary *)dic{
    if (![[dic bm_stringForKey:@"id"] bm_isNotEmpty])
    {
        return nil;
    }
    FSCommunityDetailInfoModel *aModel = [FSCommunityDetailInfoModel new];
    aModel.m_AttentionCount            = [dic bm_intForKey:@"attentionCount"];
    aModel.m_AttentionFlag             = [dic bm_boolForKey:@"attentionFlag"];
    aModel.m_Description               = [dic bm_stringForKey:@"description"];
    aModel.m_ForumNameFirst            = [dic bm_stringForKey:@"forumNameFirst"];
    aModel.m_ForumNameSecond           = [dic bm_stringForKey:@"forumNameSecond"];
    aModel.m_IconUrlFirst              = [dic bm_stringForKey:@"iconUrlFirst"];
    aModel.m_IconUrlSecond             = [dic bm_stringForKey:@"iconUrlSecond"];
    aModel.m_Id                        = [dic bm_intForKey:@"id"];
    aModel.m_PostsCount                = [dic bm_intForKey:@"postsCount"];
    return aModel;
}

- (void)updateModel:(NSDictionary *)dic{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    // id不存在不修改
    if (![[dic bm_stringForKey:@"id"] bm_isNotEmpty])
    {
        return;
    }
    self.m_AttentionCount  = [dic bm_intForKey:@"attentionCount"];
    self.m_Description     = [dic bm_stringForKey:@"description"];
    self.m_ForumNameFirst  = [dic bm_stringForKey:@"forumNameFirst"];
    self.m_ForumNameSecond = [dic bm_stringForKey:@"forumNameSecond"];
    self.m_IconUrlFirst    = [dic bm_stringForKey:@"iconUrlFirst"];
    self.m_IconUrlSecond   = [dic bm_stringForKey:@"iconUrlSecond"];
    self.m_Id              = [dic bm_intForKey:@"id"];
    self.m_PostsCount      = [dic bm_intForKey:@"postsCount"];
    self.m_AttentionFlag   = [dic bm_boolForKey:@"attentionFlag"];
}

@end
