//
//  FSAppMacros.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSAppMacros_h
#define FSAppMacros_h

#define FSAPP_APPNAME       @"ftls"

#define FSTABLE_EACHLOAD_COUNT          20

#define FSPHONENUMBER_LENGTH            11

#define FSPASSWORD_MINLENGTH            8
#define FSPASSWORD_MAXLENGTH            16


#pragma mark -
#pragma mark - Func

// 使用内存检测
#define LEAKS_ENABLED           1


#pragma mark -
#pragma mark 通知

// 刷新网页
#define freshWebViewNotification                @"freshWebViewNotification"

// 用户数据更新
#define userInfoChangedNotification             @"userInfoChangedNotification"

// 帖子更新
#define freshTopicNotification                  @"freshTopicNotification"

// 帖子删除
#define deleteTopicNotification                 @"deleteTopicNotification"

// 刷新收藏状态
#define refreshCollectionNotification           @"refreshCollectionNotification"



#endif /* FSAppMacros_h */
