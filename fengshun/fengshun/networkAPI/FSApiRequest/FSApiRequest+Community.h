//
//  FSApiRequest+Community.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSApiRequest.h"

@interface FSApiRequest (Community)


/**
 获取板块推荐列表

 @return NSMutableURLRequest
 */
+ (nullable NSMutableURLRequest *)getPlateRecommendPostList;

/**
 获取板块列表

 @return NSMutableURLRequest
 */
+ (nullable NSMutableURLRequest *)getPlateList;

/**
 编辑帖子

 @param title 标题
 @param content 内容
 @param postId 帖子Id
 @return NSMutableURLRequest
 */
+ (nullable NSMutableURLRequest *)editPostsWithTitle:(NSString *)title content:(NSString *)content postId:(NSInteger )postId;

/**
 发帖

 @param title 标题
 @param content 内容
 @param forumId 版块ID
 @return NSMutableURLRequest
 */
+ (nullable NSMutableURLRequest *)sendPostsWithTitle:(NSString *)title content:(NSString *)content forumId:(NSInteger )forumId;

/**
 帖子评论列表

 @param detailId 帖子ID/课程ID
 @param maxId 上次请求返回中的maxId，最大的Id
 @param pageSize 每页的数量
 @return NSMutableURLRequest
 */
+ (nullable NSMutableURLRequest *)getPostCommentListWithDetailId:(NSInteger )detailId maxId:(NSInteger)maxId pageSize:(NSInteger )pageSize;

@end
