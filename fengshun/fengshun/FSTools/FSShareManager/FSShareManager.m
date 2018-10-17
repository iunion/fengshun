//
//  FSShareManager.m
//  fengshun
//
//  Created by 龚旭杰 on 2018/10/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSShareManager.h"
#import <UMShare/UMShare.h>

@interface FSShareManager()

@end

@implementation FSShareManager

+ (void)configSharePlateform
{
    // 初始化分享平台
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:Wechat_AppId appSecret:Wechat_AppSecret redirectURL:Redirect_URL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_AppId/*设置QQ平台的appID*/  appSecret:nil redirectURL:Redirect_URL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:Sina_AppId  appSecret:Sina_AppSecret redirectURL:Redirect_URL];
}

+ (void)shareWebUrlWithTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage webpageUrl:(NSString *)webpageUrl platform:(FSShareManagerType)platform currentVC:(UIViewController *)currentVC delegate:(id<FSShareManagerDelegate>)delegate
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (![title bm_isNotEmpty] || ![descr bm_isNotEmpty] || ![webpageUrl bm_isNotEmpty])
    {
        BMLog(@"分享内容不能为空");
        return;
    }
    if (![self isInstallShowHud:platform currentVC:currentVC])
    {
        BMLog(@"未安装该平台");
        return;
    }
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    //设置网页地址
    shareObject.webpageUrl = webpageUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //分享平台
    UMSocialPlatformType platformType = [self getPlatform:platform];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentVC completion:^(id data, NSError *error) {
        if (error) {
            if (delegate && [delegate respondsToSelector:@selector(shareFailedWithError:)])
            {
                [delegate shareFailedWithError:error];
            }
            BMLog(@"************Share fail with error %@*********",error);
        }
        else
        {
            if (delegate && [delegate respondsToSelector:@selector(shareDidSucceed:)])
            {
                [delegate shareDidSucceed:data];
            }
            BMLog(@"response data is %@",data);
        }
    }];
}

+ (void)shareImageWithThumbImage:(id)thumbImage shareImage:(id)shareImage platform:(FSShareManagerType)platform currentVC:(UIViewController *)currentVC delegate:(id<FSShareManagerDelegate>)delegate
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    if (thumbImage != nil)
    {
        shareObject.thumbImage = thumbImage;
    }
    if (shareImage == nil)
    {
        return;
    }
    if (![self isInstallShowHud:platform currentVC:currentVC])
    {
        BMLog(@"未安装该平台");
        return;
    }
    [shareObject setShareImage:shareImage];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //分享平台
    UMSocialPlatformType platformType = [self getPlatform:platform];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentVC completion:^(id data, NSError *error) {
        if (error) {
            if (delegate && [delegate respondsToSelector:@selector(shareFailedWithError:)])
            {
                [delegate shareFailedWithError:error];
            }
            BMLog(@"************Share fail with error %@*********",error);
        }
        else
        {
            if (delegate && [delegate respondsToSelector:@selector(shareDidSucceed:)])
            {
                [delegate shareDidSucceed:data];
            }
            BMLog(@"response data is %@",data);
        }
    }];
}
+ (void)shareText:(NSString *)text withTitle:(NSString *)title platform:(FSShareManagerType)platform currentVC:(UIViewController *)currentVC delegate:(id<FSShareManagerDelegate>)delegate
{
    if (text.length == 0)
    {
        return;
    }
    if (![self isInstallShowHud:platform currentVC:currentVC])
    {
        BMLog(@"未安装该平台");
        return;
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
   
    messageObject.title = title;
    messageObject.text = text;
    //分享平台
    UMSocialPlatformType platformType = [self getPlatform:platform];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentVC completion:^(id data, NSError *error) {
        if (error) {
            if (delegate && [delegate respondsToSelector:@selector(shareFailedWithError:)])
            {
                [delegate shareFailedWithError:error];
            }
            BMLog(@"************Share fail with error %@*********",error);
        }
        else
        {
            if (delegate && [delegate respondsToSelector:@selector(shareDidSucceed:)])
            {
                [delegate shareDidSucceed:data];
            }
            BMLog(@"response data is %@",data);
        }
    }];
}
+ (UMSocialPlatformType )getPlatform:(FSShareManagerType )platform
{
    UMSocialPlatformType platformType;
    switch (platform) {
        case FSShareManagerType_Wechat:
            platformType = UMSocialPlatformType_WechatSession;
            break;
        case FSShareManagerType_Wechat_Cycle:
            platformType = UMSocialPlatformType_WechatTimeLine;
            break;
        case FSShareManagerType_QQ:
            platformType = UMSocialPlatformType_QQ;
            break;
        case FSShareManagerType_QQZone:
            platformType = UMSocialPlatformType_Qzone;
            break;
        case FSShareManagerType_Sina:
            platformType = UMSocialPlatformType_Sina;
            break;
        default:
            platformType = UMSocialPlatformType_UnKnown;
            break;
    }
    return platformType;
}

+ (BOOL)isInstall:(FSShareManagerType )platformType
{
    return [[UMSocialManager defaultManager]isInstall:[self getPlatform:platformType]];
}

+ (BOOL)isInstallShowHud:(FSShareManagerType )platformType currentVC:(UIViewController *)vc
{
    BOOL isInstall = [self isInstall:platformType];
    if (!isInstall)
    {
        MBProgressHUD *m_ProgressHUD = [[MBProgressHUD alloc]initWithView:vc.view];
        m_ProgressHUD.animationType = MBProgressHUDAnimationFade;
        [vc.view addSubview:m_ProgressHUD];
        [m_ProgressHUD showAnimated:YES withText:@"未安装该平台" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    return isInstall;
}

@end
