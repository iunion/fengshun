//
//  FSVCShow.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSWebViewController;
@protocol FSWebViewControllerDelegate;

// 跳转回调
typedef void (^PushVCCallBack)(id object);

@interface FSPushVCManager : NSObject
// 社区二级页面
+ (void)showCommunitySecVCPushVC:(UIViewController *)pushVC FourmId:(NSInteger)fourId;

// 社区详情
+ (void)showPostDetailVCWithPushVC:(UIViewController *)pushVC url:(NSString *)url;

// 发帖
+ (void)showSendPostWithPushVC:(UIViewController *)pushVC callBack:(PushVCCallBack)callBack;

// 编辑帖子
+ (void)showEditPostWithPushVC:(UIViewController *)pushVC callBack:(PushVCCallBack)callBack;

//帖子详情
+ (void)showTopicDetail:(UIViewController *)pushVC  topicId:(NSString *)topicId;

+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title;
+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title animated:(BOOL)animated;
+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color animated:(BOOL)animated;
+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color delegate:(id<FSWebViewControllerDelegate>)delegate animated:(BOOL)animated;

#pragma mark - homePage push

// 案例检索
+(void)homePage:(UIViewController *)mainVC pushToCaseSearchWithHotKeys:(NSArray *)hotKeys;

// 法规检索
+ (void)homePage:(UIViewController *)mainVC pushToLawSearchWithTopics:(NSArray *)topics;
// 视频调解
+ (void)pushVideoMediateList:(UINavigationController *)nav;
// 文书范本
+ (void)homePagePushToTextSplitVC:(UIViewController *)mainVC;
@end
