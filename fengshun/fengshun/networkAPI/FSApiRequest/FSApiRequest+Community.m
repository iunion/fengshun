//
//  FSApiRequest+Community.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSApiRequest+Community.h"

@implementation FSApiRequest (Community)


+ (XMRequest *)getPlateListWithLimit:(NSInteger)limit pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize startRow:(NSInteger)startRow success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:limit forKey:@"limit"];
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    [parameters bm_setInteger:startRow forKey:@"startRow"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/fourmList" parameters:parameters success:successBlock failure:failureBlock];
}

+ (XMRequest *)getPlateRecommendPostListWithLimit:(NSInteger)limit pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize startRow:(NSInteger)startRow success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:limit forKey:@"limit"];
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    [parameters bm_setInteger:startRow forKey:@"startRow"];
    return [XMRequestManager rm_requestWithApi:@"/storm/communityForum/recommendList" parameters:parameters success:successBlock failure:failureBlock];
}

+ (XMRequest *)editPostsWithTitle:(NSString *)title content:(NSString *)content postId:(NSInteger)postId success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setApiString:title forKey:@"title"];
    [parameters bm_setApiString:content forKey:@"content"];
    [parameters bm_setInteger:postId forKey:@"postId"];
    return [XMRequestManager rm_requestWithApi:@"/storm/postInfo/editPost" parameters:parameters success:successBlock failure:failureBlock];
}

+ (XMRequest *)sendPostsWithTitle:(NSString *)title content:(NSString *)content forumId:(NSInteger)forumId success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setApiString:title forKey:@"title"];
    [parameters bm_setApiString:content forKey:@"content"];
    [parameters bm_setInteger:forumId forKey:@"forumId"];
    return [XMRequestManager rm_requestWithApi:@"/storm/postInfo/addPost" parameters:parameters success:successBlock failure:failureBlock];
}


+ (XMRequest *)getPostCommentListWithDetailId:(NSInteger)detailId maxId:(NSInteger)maxId pageSize:(NSInteger)pageSize success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:detailId forKey:@"detailId"];
    [parameters bm_setInteger:maxId forKey:@"maxId"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    return [XMRequestManager rm_requestWithApi:@"/storm/postInfo/postComment" parameters:parameters success:successBlock failure:failureBlock];
}

@end
