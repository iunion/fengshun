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

// 测试
#ifdef __OPTIMIZE__
#define USE_TEST_HELP           0
#else
#define USE_TEST_HELP           1
#endif

#if USE_TEST_HELP
#define FLEX_FS                 1
#endif

// 使用内存检测
#define LEAKS_ENABLED           1


#pragma mark -
#pragma mark 通知

// 刷新网页
#define freshWebViewNotification                @"freshWebViewNotification"

#define userInfoChangedNotification             @"userInfoChangedNotification"



#endif /* FSAppMacros_h */
