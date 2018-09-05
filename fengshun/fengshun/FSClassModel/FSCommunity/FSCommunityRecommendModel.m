//
//  FSCommunityModel.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityRecommendModel.h"

@implementation FSCommunityRecommendModel
//pageIndex = 1;
//pageSize = 10;
//startRow = 0;
//totalPages = 1;
//totalRows = 10;
+ (FSCommunityRecommendModel *)recommendModelWithDic:(NSDictionary *)dic
{
    FSCommunityRecommendModel *model = [FSCommunityRecommendModel new];
    if ([dic bm_isNotEmptyDictionary])
    {
        model.m_EndRow          = [dic bm_intForKey:@"endRow"];
        model.m_HasNextPage     = [dic bm_boolForKey:@"hasNextPage"];
        model.m_HasPreviousPage = [dic bm_boolForKey:@"hasPreviousPage"];
        model.m_LastPage        = [dic bm_intForKey:@"lastPage"];
        model.m_PageIndex       = [dic bm_intForKey:@"pageIndex"];
        model.m_PageSize        = [dic bm_intForKey:@"pageSize"];
        model.m_StartRow        = [dic bm_intForKey:@"startRow"];
        model.m_TotalPages      = [dic bm_intForKey:@"totalPages"];
        model.m_TotalRows       = [dic bm_intForKey:@"totalRows"];
        if ([[dic bm_arrayForKey:@"list"] bm_isNotEmpty])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *param in [dic bm_arrayForKey:@"list"])
            {
                FSCommunityRecommendListModel *aModel = [FSCommunityRecommendListModel new];
                aModel.m_CommentCount                 = [param bm_intForKey:@"commentCount"];
                aModel.m_ForumName                    = [param bm_stringForKey:@"forumName"];
                aModel.m_NickName                     = [param bm_stringForKey:@"nickName"];
                aModel.m_PostsCreateTime              = [param bm_intForKey:@"postsCreateTime"];
                aModel.m_PostsFlag                    = [param bm_stringForKey:@"postsFlag"];
                aModel.m_PostsLastReplyTime           = [param bm_intForKey:@"postsLastReplyTime"];
                aModel.m_PostsTitle                   = [param bm_stringForKey:@"postsTitle"];
                [list addObject:aModel];
            }
            model.m_List = list.mutableCopy;
        }
    }
    return model;
}

@end

@implementation FSCommunityRecommendListModel


@end


@implementation FSCommunityPlateBaseModel

+ (FSCommunityPlateBaseModel *)plateBaseModelWithDic:(NSDictionary *)dic
{
    FSCommunityPlateBaseModel *model = [FSCommunityPlateBaseModel new];
    model.m_PageIndex                = [dic bm_intForKey:@"pageIndex"];
    model.m_PageSize                 = [dic bm_intForKey:@"pageSize"];
    model.m_TotalPages               = [dic bm_intForKey:@"totalPages"];
    if ([[dic bm_arrayForKey:@"list"] bm_isNotEmpty])
    {
        model.m_List = [FSCommunityPlateModel plateModelWithArr:[dic bm_arrayForKey:@"list"]];
    }
    return model;
}

@end


@implementation FSCommunityPlateModel

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
                FSCommunityPlateModel *aModel = [FSCommunityPlateModel new];
                aModel.m_name                 = [param bm_stringForKey:@"name"];
                if ([[param bm_arrayForKey:@"list"] bm_isNotEmpty])
                {
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSDictionary *dic in [param bm_arrayForKey:@"list"])
                    {
                        FSCommunityPlateListModel *listModel = [FSCommunityPlateListModel new];
                        listModel.m_AttentionCount           = [dic bm_intForKey:@"attentionCount"];
                        listModel.m_Description              = [dic bm_stringForKey:@"description"];
                        listModel.m_ForumNameFirst           = [dic bm_stringForKey:@"forumNameFirst"];
                        listModel.m_ForumNameSecond          = [dic bm_stringForKey:@"forumNameSecond"];
                        listModel.m_IconUrl                  = [dic bm_stringForKey:@"iconUrl"];
                        listModel.m_Id                       = [dic bm_intForKey:@"id"];
                        listModel.m_PostsCount               = [dic bm_intForKey:@"postsCount"];
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

@implementation FSCommunityPlateListModel

@end
