//
//  FSShareManager.h
//  fengshun
//
//  Created by 龚旭杰 on 2018/10/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FSShareManagerType) {
    FSShareManagerType_Wechat,
    FSShareManagerType_Wechat_Cycle,
    FSShareManagerType_QQ,
    FSShareManagerType_QQZone,
    FSShareManagerType_Sina,
};

@protocol FSShareManagerDelegate;

@interface FSShareManager : NSObject
/**
 配置分享平台
 */
+ (void)configSharePlateform;

/**
 分享网页

 @param title 标题
 @param descr 描述
 @param thumImage 缩略图
 @param webpageUrl 网页地址
 @param platform 平台
 @param currentVC 当前vc
 @param delegate 代理
 */
+ (void)shareWebUrlWithTitle:(NSString *)title
                       descr:(NSString *)descr
                   thumImage:(id )thumImage
                  webpageUrl:(NSString *)webpageUrl
                    platform:(FSShareManagerType )platform
                   currentVC:(UIViewController *)currentVC
                    delegate:(id<FSShareManagerDelegate>)delegate;

/**
 分享图片

 @param thumbImage 缩略图
 @param shareImage 分享的图片
 @param platform 平台
 @param currentVC 当前VC
 @param delegate 代理
 */
+ (void)shareImageWithThumbImage:(id)thumbImage
                      shareImage:(id)shareImage
                        platform:(FSShareManagerType )platform
                       currentVC:(UIViewController *)currentVC
                        delegate:(id<FSShareManagerDelegate>)delegate;

/**
 分享文本
 
 @param text 文本内容
 @param title 标题
 @param platform 平台
 @param currentVC 当前VC
 @param delegate 代理
 */
+ (void)shareText:(NSString *)text withTitle:(NSString *)title platform:(FSShareManagerType)platform currentVC:(UIViewController *)currentVC delegate:(id<FSShareManagerDelegate>)delegate;

@end


@protocol FSShareManagerDelegate<NSObject>

@optional

- (void)shareDidSucceed:(id)data;

- (void)shareFailedWithError:(NSError *)error;

@end
