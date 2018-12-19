//
//  FSAppConfig.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "BMkit.h"

#import "FSAppMacros.h"
#import "FSAppUIDef.h"

#ifndef FSAppConfig_h
#define FSAppConfig_h

// APPSTORE
#define APPSTORE_DOWNLOADAPP_ADDRESS    @"itms-apps://itunes.apple.com/app/id1443980533"
#define APPID                           @"1443980533"

//#define APPSTORE_CHECK_VERSON_ADDRESS @"http://itunes.apple.com/lookup?id=628470263"

// 友盟
#define UMeng_AppKey            @"5b9b22b1f43e484912000027"


// 分享相关
#define Redirect_URL            @"http://mobile.umeng.com/social"
// QQ
#define QQ_AppId                @"101499801"
#define QQ_AppKey               @"41841d247cf98e781d73e1d455300a0d"

// 微信
#define Wechat_AppId            @"wx39307cf41337107d"
#define Wechat_AppSecret        @"134f3aa7376bd9d2b5fdf6a11b396325"

// 微博
#define Sina_AppId              @"4252476878"
#define Sina_AppSecret          @"962744c41629dee8a6034b66c667e813"

// GrowingIO
#define GrowingIO_AccountID     @"9a7f59a4f5c02c79"


#ifdef FSVIDEO_ON
//开发环境配置
//1400119577 32661
//测试环境配置
//1400119579 32662
//生产环境配置
//1400119581 32663

// 腾讯RTC

#define FS_ILiveControlRole         @"user"

#if USE_TEST_HELP

// 开发环境
#define FS_ILiveSDKAPPID_DEV        (1400119577)
#define FS_ILiveAccountType_DEV     (32661)

// 测试环境
#define FS_ILiveSDKAPPID_TEST       (1400119579)
#define FS_ILiveAccountType_TEST    (32662)

// 线上环境
#define FS_ILiveSDKAPPID_ONLINE     (1400119581)
#define FS_ILiveAccountType_ONLINE  (32663)

#define FS_ILiveSDKAPPID_INIT       FS_ILiveSDKAPPID_DEV
#define FS_ILiveAccountType_INIT    FS_ILiveAccountType_DEV

#define FS_ILiveSDKAPPID_KEY        (@"debug_ILiveSDKAPPID")
#define FS_ILiveSDKAPPID            [[[NSUserDefaults standardUserDefaults] objectForKey:FS_ILiveSDKAPPID_KEY] integerValue]

#define FS_ILiveAccountType_KEY     (@"debug_ILiveAccountType")
#define FS_ILiveAccountType         [[[NSUserDefaults standardUserDefaults] objectForKey:FS_ILiveAccountType_KEY] integerValue]

#else

// 测试环境
#define FS_ILiveSDKAPPID            (1400119581)
#define FS_ILiveAccountType         (32663)

#endif

#endif

#endif /* FSAppConfig_h */
