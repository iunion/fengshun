//
//  FSCommunityModel.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityRecommendModel.h"

@implementation FSCommunityRecommendModel

+ (NSArray *)recommendModelWithArr:(NSArray *)dataArray{
    NSMutableArray *data = [NSMutableArray array];
    if ([dataArray bm_isNotEmpty])
    {
        for (id object in dataArray)
        {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *param = object;
                FSCommunityRecommendModel *aModel = [FSCommunityRecommendModel new];
                aModel.m_CommentCount = [param bm_intForKey:@"commentCount"];
                aModel.m_ForumName = [param bm_stringForKey:@"forumName"];
                aModel.m_NickName = [param bm_stringForKey:@"nickName"];
                aModel.m_PostsCreateTime = [param bm_intForKey:@"postsCreateTime"];
                aModel.m_PostsFlag = [param bm_stringForKey:@"postsFlag"];
                aModel.m_PostsLastReplyTime = [param bm_intForKey:@"postsLastReplyTime"];
                aModel.m_PostsTitle = [param bm_stringForKey:@"postsLastReplyTime"];
                [data addObject:aModel];
            }
        }
    }
    return data;
}

@end


@implementation FSCommunityPlateModel

+ (NSArray *)plateModelWithArr:(NSArray *)dataArray{
    NSMutableArray *data = [NSMutableArray array];
    if ([dataArray bm_isNotEmpty])
    {
        for (id object in dataArray)
        {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *param = object;
                FSCommunityPlateModel *aModel = [FSCommunityPlateModel new];
                aModel.m_AttentionCount = [param bm_intForKey:@"attentionCount"];
                aModel.m_Description = [param bm_stringForKey:@"description"];
                aModel.m_ForumNameFirst = [param bm_stringForKey:@"forumNameFirst"];
                aModel.m_ForumNameSecond = [param bm_stringForKey:@"forumNameSecond"];
                aModel.m_IconUrl = [param bm_stringForKey:@"iconUrl"];
                aModel.m_Id = [param bm_intForKey:@"id"];
                aModel.m_PostsCount = [param bm_intForKey:@"postsCount"];
                [data addObject:aModel];
            }
        }
    }
    return data;
}

@end
