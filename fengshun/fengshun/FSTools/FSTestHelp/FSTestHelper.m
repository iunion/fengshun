//
//  FSTestHelper.m
//  Home
//
//  Created by Heyanyang 2014-07-25
//  Copyright (c) 2014年 babytree. All rights reserved.
//
#if USE_TEST_HELP


#import "FSTestHelper.h"
#include <asl.h>

#import "FSAPIMacros.h"

#ifdef FSVIDEO_ON
#import <ILiveSDK/ILiveSDK.h>
#import <ILiveSDK/ILiveCoreHeader.h>
#endif

#import "AppDelegate.h"
#import "FSWebViewController.h"

#import "BMAlertView.h"

@implementation FSTestHelper

- (void)dealloc
{
}

// 获取一个sharedInstance实例，如果有必要的话，实例化一个
+ (FSTestHelper *)sharedInstance
{
    static FSTestHelper *sharedTestHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedTestHelper = [[[self class] alloc] init];
    });
    
    return sharedTestHelper;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        // BMConsole初始化，deviceShakeToShow(摇动开启)默认设为NO，开启请设为YES
        [BMConsole sharedConsole].delegate = self;
        [BMConsole sharedConsole].deviceShakeToShow = YES;
        
        [self setDebugServer];
    }
    
    return self;
}

- (void)setDebugServer
{
    // 初始化配置
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:FS_URL_SERVER_KEY];
    if (!serverUrl)
    {
        [[NSUserDefaults standardUserDefaults] setObject:FS_URL_SERVER_INIT forKey:FS_URL_SERVER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *h5ServerUrl = [[NSUserDefaults standardUserDefaults] objectForKey:FS_H5_SERVER_KEY];
    if (!h5ServerUrl)
    {
        [[NSUserDefaults standardUserDefaults] setObject:FS_H5_SERVER_INIT forKey:FS_H5_SERVER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *fileAddress = [[NSUserDefaults standardUserDefaults] objectForKey:FS_FILE_ADDRESS_KEY];
    if (!fileAddress)
    {
        [[NSUserDefaults standardUserDefaults] setObject:FS_FILE_ADDRESS_INIT forKey:FS_FILE_ADDRESS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *caseStatuteH5Url = [[NSUserDefaults standardUserDefaults]objectForKey:FS_CASE_STATUTE_URL_KEY];

    if (!caseStatuteH5Url)
    {
        [[NSUserDefaults standardUserDefaults] setObject:FS_CASE_STATUTE_INIT forKey:FS_CASE_STATUTE_URL_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSString *aiAddress = [[NSUserDefaults standardUserDefaults] objectForKey:FS_AI_SERVER_KEY];
    if (!aiAddress)
    {
        [[NSUserDefaults standardUserDefaults] setObject:FS_AI_SERVER_INIT forKey:FS_AI_SERVER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    

#ifdef FSVIDEO_ON
    NSInteger ILiveSDKAPPID = [[[NSUserDefaults standardUserDefaults] objectForKey:FS_ILiveSDKAPPID_KEY] integerValue];
    if (ILiveSDKAPPID == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveSDKAPPID_INIT) forKey:FS_ILiveSDKAPPID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSInteger ILiveAccountType = [[[NSUserDefaults standardUserDefaults] objectForKey:FS_ILiveAccountType_KEY] integerValue];
    if (ILiveAccountType == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveAccountType_INIT) forKey:FS_ILiveAccountType_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
#endif
}

#pragma mark - BMConsole Delegate

// 按键事件
- (void)handleConsoleButton:(UIButton *)sender
{
    
}

- (BOOL)handleConsoleCommand:(NSString *)command
{
    return [self handleConsoleCommand:command withParameter:nil];
}

- (BOOL)handleConsoleCommand:(NSString *)command withParameter:(id)parameter
{
    if (![command bm_isNotEmpty])
    {
        return YES;
    }
    
    BOOL ret = NO;
    [BMConsole log:@"\n==========================================="];
    
    if ([command isEqualToString:@"api"])  // 查看API路径情况
    {
        ret = YES;
        [BMConsole log:@"当前API运行环境是'%@'", FS_URL_SERVER];
        [BMConsole log:@"当前H5运行环境是'%@'", FS_H5_SERVER];
        [BMConsole log:@"当前文件链接地址是'%@'", FS_FILE_ADDRESS];
        [BMConsole log:@"当前法规案例检索地址是'%@'", FS_CASE_STATUTE_URL];
        [BMConsole log:@"当前智能咨询链接地址是'%@'", FS_AI_SERVER];
#ifdef FSVIDEO_ON
        [BMConsole log:@"当前腾讯RTC环境是'%@ %@'", @(FS_ILiveSDKAPPID), @(FS_ILiveAccountType)];
#endif
    }
    else if ([command isEqualToString:@"www"] || [command isEqualToString:@"on"])
    {
        ret = YES;
        NSString *server = [[NSUserDefaults standardUserDefaults] objectForKey:FS_URL_SERVER_KEY];
        if (![server isEqualToString:FS_URL_SERVER_ONLINE])
        {
            [[NSUserDefaults standardUserDefaults] setObject:FS_URL_SERVER_ONLINE forKey:FS_URL_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_H5_SERVER_ONLINE forKey:FS_H5_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_FILE_ADDRESS_ONLINE forKey:FS_FILE_ADDRESS_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_CASE_STATUTE_ONLINE forKey:FS_CASE_STATUTE_URL_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_AI_SERVER_ONLINE forKey:FS_AI_SERVER_KEY];
#ifdef FSVIDEO_ON
            [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveSDKAPPID_ONLINE) forKey:FS_ILiveSDKAPPID_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveAccountType_ONLINE) forKey:FS_ILiveAccountType_KEY];
#endif
            [[NSUserDefaults standardUserDefaults] synchronize];
            
#ifdef FSVIDEO_ON
            [self initILiveSDK];
#endif
            
            [BMConsole log:@"当前api已经变更为'线上'"];
        }
        else
        {
            [BMConsole log:@"当前api运行环境为'线上'"];
        }
    }
    else if ([command isEqualToString:@"dev"])
    {
        ret = YES;
        NSString *server = [[NSUserDefaults standardUserDefaults] objectForKey:FS_URL_SERVER_KEY];
        if (![server isEqualToString:FS_URL_SERVER_DEV])
        {
            [[NSUserDefaults standardUserDefaults] setObject:FS_URL_SERVER_DEV forKey:FS_URL_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_H5_SERVER_DEV forKey:FS_H5_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_FILE_ADDRESS_DEV forKey:FS_FILE_ADDRESS_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_CASE_STATUTE_DEV forKey:FS_CASE_STATUTE_URL_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_AI_SERVER_DEV forKey:FS_AI_SERVER_KEY];
#ifdef FSVIDEO_ON
            [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveSDKAPPID_DEV) forKey:FS_ILiveSDKAPPID_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveAccountType_DEV) forKey:FS_ILiveAccountType_KEY];
#endif
            [[NSUserDefaults standardUserDefaults] synchronize];

#ifdef FSVIDEO_ON
            [self initILiveSDK];
#endif
        
            [BMConsole log:@"当前api已经变更为'开发'"];
        }
        else
        {
            [BMConsole log:@"当前api运行环境为'开发'"];
        }
    }
    else if ([command isEqualToString:@"test"])
    {
        ret = YES;
        NSString *server = [[NSUserDefaults standardUserDefaults] objectForKey:FS_URL_SERVER_KEY];
        if (![server isEqualToString:FS_URL_SERVER_TEST])
        {
            [[NSUserDefaults standardUserDefaults] setObject:FS_URL_SERVER_TEST forKey:FS_URL_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_H5_SERVER_TEST forKey:FS_H5_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_FILE_ADDRESS_TEST forKey:FS_FILE_ADDRESS_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_CASE_STATUTE_TEST forKey:FS_CASE_STATUTE_URL_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:FS_AI_SERVER_TEST forKey:FS_AI_SERVER_KEY];
#ifdef FSVIDEO_ON
            [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveSDKAPPID_TEST) forKey:FS_ILiveSDKAPPID_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:@(FS_ILiveAccountType_TEST) forKey:FS_ILiveAccountType_KEY];
#endif
            [[NSUserDefaults standardUserDefaults] synchronize];

#ifdef FSVIDEO_ON
            [self initILiveSDK];
#endif

            [BMConsole log:@"当前api已经变更为'测试'"];
        }
        else
        {
            [BMConsole log:@"当前api运行环境为'测试'"];
        }
    }
    else if ([command isEqualToString:@"h"] || [command isEqualToString:@"help"]) // help命令
    {
        ret = YES;
        NSMutableString *helpStr = [[NSMutableString alloc] init];
        [helpStr appendString:@"\n(01) 'help' 显示命令帮助文档\n"];
        [helpStr appendString:@"(02) 'version' 显示app版本\n"];
        [helpStr appendString:@"(03) 'clear' 清除控制台信息\n"];
        [helpStr appendString:@"(04) 'log' 打印所有NSLog\n"];
        [helpStr appendString:@"(05) 'app' 显示APP基本信息\n"];
        [helpStr appendString:@"(06) 'api' 显示当前所处API环境信息\n"];
        [helpStr appendString:@"(07) 'on' or 'www' 切换API环境到线上\n"];
        [helpStr appendString:@"(08) 'dev' 切换API环境到开发\n"];
        [helpStr appendString:@"(09) 'test' 切换API环境到测试\n"];
        [helpStr appendString:@"(10) 'fps' 显示隐藏FPS监测\n"];
        [helpStr appendString:@"(11) 'al' 显示隐藏标尺\n"];
        [helpStr appendString:@"(12) 'cp' 显示隐藏颜色提取\n"];
        [helpStr appendString:@"(13) 'gps' 模拟GPS定位数据\n"];
        [helpStr appendString:@"(14) 'mn' 网络监控开关\n"];
        [helpStr appendString:@"(15) 'nf' 网络监控表\n"];

        [BMConsole log:@"%@", helpStr];
    }
    else if ([command containsString:@"://"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:command]])
        {
            ret = YES;
            [BMConsole hide];
            
            FSWebViewController *vc = [[FSWebViewController alloc] initWithTitle:nil url:command];
            [[GetAppDelegate.m_TabBarController getCurrentViewController].navigationController pushViewController:vc animated:YES];
            
            [BMConsole log:@"浏览 %@", command];
        }
    }
    
    self.preCommand = command;
    
    return ret;
}

#ifdef FSVIDEO_ON
- (void)initILiveSDK
{
    // 重新初始化无用，所以需要重启app
    // 初始化SDK
    //[[ILiveSDK getInstance] initSdk:(int)FS_ILiveSDKAPPID accountType:(int)FS_ILiveAccountType];
    //[[ILiveSDK getInstance] setChannelMode:E_ChannelIMSDK withHost:@""];
    
    // 获取版本号
    //NSLog(@"ILiveSDK version:%@", [[ILiveSDK getInstance] getVersion]);
    //NSLog(@"AVSDK version:%@", [QAVContext getVersion]);
    //NSLog(@"IMSDK version:%@", [[TIMManager sharedInstance] GetVersion]);
    
    [BMConsole log:@"切换环境，视频功能需要重启app"];
    
    [BMAlertView showAlertWithTitle:@"切换环境，视频功能需要重启app" message:nil cancelTitle:@"取消" otherTitle:@"重启" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled)
        {
            [self exitApplication ];
        }
    }];
}

- (void)exitApplication
{
    UIWindow *window = GetAppDelegate.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}
#endif

@end

#endif
