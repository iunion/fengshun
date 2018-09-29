//
//  FSVCShow.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTopicDetailVC.h"

@class FSWebViewController, FSFileScanImagePreviewVC,FSCommunitySecVC;
@protocol FSWebViewControllerDelegate;

// 跳转回调
typedef void (^PushVCCallBack)(void);

@interface FSPushVCManager : NSObject
// 社区二级页面
+ (FSCommunitySecVC *)showCommunitySecVCPushVC:(UIViewController *)pushVC FourmId:(NSInteger)fourId;

// 社区详情
+ (void)showPostDetailVCWithPushVC:(UIViewController *)pushVC url:(NSString *)url;

// 发帖|| 编辑帖子
+ (void)showSendPostWithPushVC:(UIViewController *)pushVC isEdited:(BOOL )isEdited relatedId:(NSInteger )relatedId callBack:(PushVCCallBack)callBack;

//帖子详情
+ (FSTopicDetailVC *)showTopicDetail:(UIViewController *)pushVC  topicId:(NSString *)topicId;

+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title;
+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title animated:(BOOL)animated;
+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color animated:(BOOL)animated;
+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color delegate:(id<FSWebViewControllerDelegate>)delegate animated:(BOOL)animated;

#pragma mark - homePage push

// 案例检索
+ (void)homePage:(UIViewController *)mainVC pushToCaseSearchWithHotKeys:(NSArray *)hotKeys;
+ (void)searchVCPushtToCaseOCrSearchVC:(UIViewController *)searchVC;


// 法规检索
+ (void)pushToLawSearch:(UIViewController *)mainVC;
+ (void)searchVCPushtToLawsOCrSearchVC:(UIViewController *)searchVC;

#ifdef FSVIDEO_ON
// 视频调解
+ (void)pushVideoMediateList:(UINavigationController *)nav;
#endif
// 文书范本
+ (void)homePagePushToTextSplitVC:(UIViewController *)mainVC;
+ (void)pushToTextSearchVC:(UIViewController *)showVC;
+ (void)pushToTextDetail:(UIViewController *)pushVC url:(NSString *)url withFileId:(NSString *)fileId documentId:(NSString *)documentId title:(NSString *)title;

// 文件扫描
+ (void)homePagePushToFileScanVC:(UIViewController *)mainVC;
// 文件扫描图片预览
+ (FSFileScanImagePreviewVC *)fileScanVC:(UIViewController *)fileCacnVC pushToImagePreviewWithSourceArray:(NSMutableArray *)sourceArray selectIndex:(NSInteger)selectIndex;
// 文字识别结果
+(void)viewController:(UIViewController *)vc pushToOCRResultVCWithImage:(UIImage *)image;

// 显示个人信息
+ (void)showMessageVC:(UIViewController *)pushVC;

#pragma mark - H5跳转

// 智能咨询
+ (void)pushToAIConsultVC:(UIViewController *)pushVC;

// 法规专题
+ (void)viewController:(UIViewController *)pushVC pushToLawTopicVCWithLawTopic:(NSString *)lawTopic;

// 法规详情
+ (void)viewController:(UIViewController *)vc pushToLawDetailWithId:(NSString *)lawId keywords:(NSString *)keywordsStr;

// 案例详情
+ (void)viewController:(UIViewController *)vc pushToCaseDetailWithId:(NSString *)caseId isGuide:(BOOL)isGuide keywords:(NSString *)keywordsStr;

// 课程详情(图文详情)
+ (void)viewController:(UIViewController *)vc pushToCourseDetailWithId:(NSString *)CourseId;

@end
