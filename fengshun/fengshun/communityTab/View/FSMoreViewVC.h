//
//  FSMoreViewVC.h
//  fengshun
//
//  Created by best2wa on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"
#import "FSShareManager.h"

@protocol FSMoreViewVCDelegate <NSObject>

@optional

- (void)moreViewClickWithType:(NSInteger )index;

@end

@interface FSMoreViewVC : FSSuperVC
/**
 帖子详情页用

 @param delegate 代理
 @param isOwner 是否本人帖子
 @param isCollection 是否收藏过
 */
+ (FSMoreViewVC *)showTopicMoreDelegate:(id)delegate isOwner:(BOOL)isOwner isCollection:(BOOL)isCollection presentVC:(UIViewController *)presentVC;
/**
 web详情页使用

 @param delegate 代理
 @param isCollection 是否收藏过
 @param hasRefresh yes为刷新功能、no为复制功能
 */
+ (FSMoreViewVC *)showWebMoreDelegate:(id)delegate isCollection:(BOOL)isCollection hasRefresh:(BOOL)hasRefresh  presentVC:(UIViewController *)presentVC;

// 只有分享功能
+ (FSMoreViewVC *)showSingleShareAlertViewDelegate:(id)delegate presentVC:(UIViewController *)presentVC;;

// 课堂案例详情（只有分享刷新功能）
+ (FSMoreViewVC *)showClassroomCaseDetailShareAlertViewDelegate:(id)delegate  presentVC:(UIViewController *)presentVC;

@property (nonatomic, assign)id <FSMoreViewVCDelegate> delegate;

@end


