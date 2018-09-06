//
//  FSVCShow.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 跳转回调
typedef void (^PushVCCallBack)(id object);

@interface FSPushVCManager : NSObject
// 社区二级页面
+ (void)showCommunitySecVCPushVC:(UIViewController *)pushVC;

// 社区详情
+ (void)showPostDetailVCWithPushVC:(UIViewController *)pushVC url:(NSString *)url;

// 发帖
+ (void)showSendPostWithWithPushVC:(UIViewController *)pushVC callBack:(PushVCCallBack)callBack;

// 编辑帖子
+ (void)showEditPostWithWithPushVC:(UIViewController *)pushVC callBack:(PushVCCallBack)callBack;

@end
