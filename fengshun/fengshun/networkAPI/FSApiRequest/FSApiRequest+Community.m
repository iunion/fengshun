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
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/communityForum/recommendList", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 板块列表
+ (XMRequest *)getPlateListWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/forumList" parameters:parameters success:successBlock failure:failureBlock];
}
// 推荐帖子列表
+ (XMRequest *)getPlateRecommendPostListWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/recommendList" parameters:parameters success:successBlock failure:failureBlock];
}
// 发送||编辑帖子
+ (XMRequest *)sendPostsWithTitle:(NSString *)title content:(NSString *)content forumId:(NSInteger)forumId isEdited:(BOOL)isEdited success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setApiString:title forKey:@"title"];
    [parameters bm_setApiString:content forKey:@"content"];
    [parameters bm_setInteger:forumId forKey:@"forumId"];
    return [XMRequestManager rm_requestWithApi:isEdited ? @"/storm/postInfo/editPost" : @"/storm/postInfo/addPost" parameters:parameters success:successBlock failure:failureBlock];
}
// 关注
+ (XMRequest *)updateFourmAttentionStateWithFourmId:(NSInteger)fourmId success:(nullable XMSuccessBlock)successBlock failure:(nullable XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:fourmId forKey:@"id"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/followOrUnFollow" parameters:parameters success:successBlock failure:failureBlock];
}
// 二级info信息
+ (XMRequest *)getTwoLevelFourmInfoWithId:(NSInteger)topicId success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:topicId forKey:@"id"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/twoLevelForumInfo" parameters:parameters success:successBlock failure:failureBlock];
}
// 二级列表
+ (XMRequest *)getTwoLevelFourmListWithListType:(FSCommunityDetailListType)type topicIdId:(NSInteger)topicId PageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:topicId forKey:@"id"];
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    NSString *urlStr;
    switch (type)
    {
        case FSCommunityDetailListType_NewReply:
            urlStr = @"/storm/communityForum/newReplyList";
            break;
        case FSCommunityDetailListType_NewPulish:
            urlStr = @"/storm/communityForum/newPublishList";
            break;
        case FSCommunityDetailListType_Hot:
            urlStr = @"/storm/communityForum/hotList";
            break;
        case FSCommunityDetailListType_Essence:
            urlStr = @"/storm/communityForum/essenceList";
            break;
        default:
            urlStr = @"";
            break;
    }
    return [XMRequestManager rm_requestWithApi:urlStr parameters:parameters success:successBlock failure:failureBlock];
}

@end
