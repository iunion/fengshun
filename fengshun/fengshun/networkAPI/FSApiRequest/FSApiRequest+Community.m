//
//  FSApiRequest+Community.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSApiRequest.h"

@implementation FSApiRequest (Community)

// 获取推荐帖子列表
// http://123.206.193.140:8121/swagger-ui.html#/%E7%A4%BE%E5%8C%BA%E9%A6%96%E9%A1%B5/recommendListUsingPOST
+ (nullable NSMutableURLRequest *)getPlateRecommendPostListWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    NSString *           urlStr     = [NSString stringWithFormat:@"%@/storm/communityForum/recommendList", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}
// 获取板块列表列表
// http://123.206.193.140:8121/swagger-ui.html#/%E7%A4%BE%E5%8C%BA%E9%A6%96%E9%A1%B5/recommendListUsingPOST
+ (NSMutableURLRequest *)getForumListWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    NSString *           urlStr     = [NSString stringWithFormat:@"%@/storm/communityForum/forumList", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}
// 获取二级列表：最新回复、最新发帖、热门、精华
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/newReplyListUsingPOST
+ (NSMutableURLRequest *)getTopicListWithType:(NSString *)type forumId:(NSInteger)forumId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    NSString *           urlStr     = [NSString stringWithFormat:@"%@/storm/communityForum/forumPostList", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    [parameters bm_setInteger:forumId forKey:@"forumId"];
    if ([type bm_isNotEmpty]) {
        [parameters bm_setString:type forKey:@"postListType"];
    }
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 发送||编辑帖子
// http://123.206.193.140:8121/swagger-ui.html#/operations/帖子信息/addPostUsingPOST
// http://123.206.193.140:8121/swagger-ui.html#/operations/帖子信息/editPostUsingPOST
+ (XMRequest *)sendPostsWithTitle:(NSString *)title content:(NSString *)content forumId:(NSInteger)forumId isEdited:(BOOL)isEdited success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setApiString:title forKey:@"title"];
    [parameters bm_setApiString:content forKey:@"content"];
    if (isEdited)
    {
        [parameters bm_setInteger:forumId forKey:@"postId"];
    }
    else
    {
        [parameters bm_setInteger:forumId forKey:@"forumId"];
    }
    return [XMRequestManager rm_requestWithApi:isEdited ? @"/storm/postInfo/editPost" : @"/storm/postInfo/addPost" parameters:parameters success:successBlock failure:failureBlock];
}

// 关注
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/followOrUnFollowUsingPOST
+ (XMRequest *)updateFourmAttentionStateWithFourmId:(NSInteger)fourmId followStatus:(FSForumFollowState)followStatus success:(nullable XMSuccessBlock)successBlock failure:(nullable XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:fourmId forKey:@"id"];
    NSString *apiString = @"";
    if (followStatus == FSForumFollowState_Follow)
    {
        apiString = @"FOLLOW";
    }
    else
    {
        apiString = @"CANCEL_FOLLOW";
    }
    [parameters bm_setApiString:apiString forKey:@"followStatus"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/followOrUnFollow" parameters:parameters success:successBlock failure:failureBlock];
}

// 二级info信息
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/twoLevelForumInfoUsingPOST
+ (XMRequest *)getTwoLevelFourmInfoWithId:(NSInteger)topicId success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:topicId forKey:@"id"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/twoLevelForumInfo" parameters:parameters success:successBlock failure:failureBlock];
}

@end
