//
//  FSApiRequest+Community.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSApiRequest+Community.h"

@implementation FSApiRequest (Community)

+ (NSMutableURLRequest *)getPlateList{
    NSString *urlStr = [NSString stringWithFormat:@"%@storm/communityForum/fourmList", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

+ (NSMutableURLRequest *)getPlateRecommendPostList{
    NSString *urlStr = [NSString stringWithFormat:@"%@storm/communityForum/recommendList", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

+ (NSMutableURLRequest *)editPostsWithTitle:(NSString *)title content:(NSString *)content postId:(NSInteger)postId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@storm/postInfo/editPost", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setApiString:title forKey:@"title"];
    [parameters bm_setApiString:content forKey:@"content"];
    [parameters bm_setInteger:postId forKey:@"postId"];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

+ (NSMutableURLRequest *)sendPostsWithTitle:(NSString *)title content:(NSString *)content forumId:(NSInteger)forumId{
    NSString *urlStr = [NSString stringWithFormat:@"%@storm/postInfo/addPost", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setApiString:title forKey:@"title"];
    [parameters bm_setApiString:content forKey:@"content"];
    [parameters bm_setInteger:forumId forKey:@"forumId"];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

+ (NSMutableURLRequest *)getPostCommentListWithDetailId:(NSInteger)detailId maxId:(NSInteger)maxId pageSize:(NSInteger)pageSize{
    NSString *urlStr = [NSString stringWithFormat:@"%@storm/postInfo/postComment", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:detailId forKey:@"detailId"];
    [parameters bm_setInteger:maxId forKey:@"maxId"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

@end
