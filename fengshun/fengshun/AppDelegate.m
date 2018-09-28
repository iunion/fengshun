//
//  AppDelegate.m
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "AppDelegate.h"

#import "BMApp.h"

#import "FSLocation.h"
#import "FSCoreStatus.h"

#import "FSDBVersionCheck.h"

#import "FSUserInfo.h"
#import "BMVerifiTimeManager.h"

#import "FSFirstGuideVC.h"

#import "FSSetTableViewVC.h"
#import "FSUserMainVC.h"

#import "FSGlobleDataModel.h"
#import "FSCustomInfoVC.h"

#if USE_TEST_HELP
#import "FSTestHelper.h"
#endif

#ifdef FSVIDEO_ON
#import <ILiveSDK/ILiveSDK.h>
#import <ILiveSDK/ILiveCoreHeader.h>
#endif

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

//#import "SDWebImageCodersManager.h"
//#import "SDWebImageGIFCoder.h"

@interface AppDelegate ()
<
    CLLocationManagerDelegate,
    FSCoreNetWorkStatusProtocol,
    FSFirstGuideVCDelegate
>
{
    BOOL s_IsShownFirstGuide;
}

// 位置信息
@property (strong, nonatomic) CLLocationManager *m_LocationManager;

@property (strong, nonatomic) NSURLSessionDataTask *m_LoginOutTask;

@property (weak, nonatomic) FSSetTableViewVC *m_GetAbilityVC;
@property (strong, nonatomic) NSURLSessionDataTask *m_UserAbilityTask;

@end

@implementation AppDelegate

- (void)dealloc
{
    [FSCoreStatus endMonitorNetwork:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:nil];
    
    [self removeObserver:self forKeyPath:@"m_UserInfo"];

    [_m_LoginOutTask cancel];
    _m_LoginOutTask = nil;

    [_m_UserAbilityTask cancel];
    _m_UserAbilityTask = nil;
}

#ifdef FSVIDEO_ON
//#pragma mark - 配置iLiveSDK
- (void)setupILiveSDK
{
    // 初始化SDK
    [[ILiveSDK getInstance] initSdk:(int)FS_ILiveSDKAPPID accountType:(int)FS_ILiveAccountType];
    [[ILiveSDK getInstance] setChannelMode:E_ChannelIMSDK withHost:@""];
    
    // 获取版本号
    NSLog(@"ILiveSDK version:%@", [[ILiveSDK getInstance] getVersion]);
    NSLog(@"AVSDK version:%@", [QAVContext getVersion]);
    NSLog(@"IMSDK version:%@", [[TIMManager sharedInstance] GetVersion]);
}
#endif

// Umeng统计
- (void)setupUmeng
{
    [UMConfigure initWithAppkey:UMeng_AppKey channel:@"App Store"];
    
    [MobClick setScenarioType:E_UM_NORMAL];
}

- (void)setupThirdParty
{
#ifdef FSVIDEO_ON
    // 腾讯视频
    [self setupILiveSDK];
#endif

    // Umeng统计
    [self setupUmeng];
}

- (void)setUpApp
{
    // Flush all cached data
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // 网络状态
    [FSCoreStatus beginMonitorNetwork:self];
    
    // GPS数据
    self.m_LocationManager = [[CLLocationManager alloc] init];
    self.m_LocationManager.delegate = self;
    self.m_LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //self.m_LocationManager.distanceFilter = 100; //1英里≈1609米
    self.m_LocationManager.distanceFilter = kCLDistanceFilterNone;
    //self.m_LocationManager.headingFilter = kCLHeadingFilterNone;
    //self.m_LocationManager.purpose = @"To provide functionality based on user's current location.";
    [self batteryChangedForLocationManager];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if (IOS_VERSION >= 8.0f)
        {
            [self.m_LocationManager requestWhenInUseAuthorization];
        }
        
        [self.m_LocationManager startUpdatingLocation];
    }
    else
    {
        BMLog(@"not use location!!!!!!!!!!!!!!!!!!!!");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChangedForLocationManager) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    
    // SDWebImage支持gif动画显示，加载GIFCoder
    //[[SDWebImageCodersManager sharedInstance] addCoder:[SDWebImageGIFCoder sharedCoder]];
    
    // 版本升级
#ifdef DEBUG
    [BMApp onFirstStartForCurrentBuildVersion:^(BOOL isFirstStart) {
        self->s_IsShownFirstGuide = YES;
        NSLog(@"isFirstStart");
    } withKey:FSAPP_APPNAME];
#else
    [BMApp onFirstStartForCurrentVersion:^(BOOL isFirstStart) {
        self->s_IsShownFirstGuide = YES;
        
    } withKey:FSAPP_APPNAME];
#endif
    
    // 检查数据库版本
    [FSDBVersionCheck checkDBVer];
    
    // 创建搜索历史存储目录
    [FSUserInfoDB makeSearchHistoryPath];
}


#pragma mark - network status

- (void)coreNetworkChanged:(NSNotification *)noti
{
    NSDictionary *userDic = noti.userInfo;
    
    BMLog(@"网络环境: %@", [userDic bm_stringForKey:@"currentStatusString"]);
    BMLog(@"网络运营商: %@", [userDic bm_stringForKey:@"currentBrandName"]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if USE_TEST_HELP
    self.window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [FSTestHelper sharedInstance];
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    // Override point for customization after application launch.
    // TODO: Substitute UIViewController with your own subclass.

    [self setUpApp];
    
    [self setupThirdParty];

    // 添加观察者，监听用户信息的改变
    [self addObserver:self forKeyPath:@"m_UserInfo" options:NSKeyValueObservingOptionNew context:nil];
    self.m_UserInfo = [FSUserInfoDB getUserInfoWithUserId:[FSUserInfoModel getCurrentUserId]];
    if (!self.m_UserInfo)
    {
        self.m_UserInfo = [[FSUserInfoModel alloc] init];
    }

    [self showFirstGuideView];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self getUserAbilityInfoWithVc:nil];
    
    return YES;
}

#if USE_TEST_HELP
- (void)showFPS
{
    iConsoleWindow *window = (iConsoleWindow *)self.window;
    [window.fpsLabel bm_bringToFront];
}
#endif

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"m_UserInfo"])
    {
        //FSUserInfoModel *oldUserInfo = [change objectForKey:NSKeyValueChangeOldKey];
        //FSUserInfoModel *newUserInfo = [change objectForKey:NSKeyValueChangeNewKey];
        
        //if (![oldUserInfo bm_isValided])
        {
            // 用户数据变更，包括登录注册，退出登录
            [[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.m_LocationManager stopUpdatingLocation];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self getNewLocation];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return NO;
}


#pragma mark -
#pragma mark CLAuthorizationStatus

- (BOOL)checkCLAuthorizationStatus
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    BMLog(@"CLAuthorizationStatus %@", @(status));
    
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            if (IOS_VERSION >= 8.0f)
            {
                [self.m_LocationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
            if (IOS_VERSION >= 8.0f)
            {
                [self.m_LocationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            [self.m_LocationManager stopUpdatingLocation];
            [self.m_LocationManager startUpdatingLocation];
        }
        default:
            break;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    BMLog(@"%@", currLocation);
    
    [FSLocation setGPSLoaction:currLocation];
    
    [self.m_LocationManager stopUpdatingLocation];
}


#pragma mark -
#pragma mark CLLocationManager Actions

- (void)batteryChangedForLocationManager
{
    if(([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) || ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateFull))
    {
        self.m_LocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    else
    {
        self.m_LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
}

- (void)getNewLocation
{
    [self batteryChangedForLocationManager];
    [self.m_LocationManager stopUpdatingLocation];
    [self.m_LocationManager startUpdatingLocation];
}


#pragma mark -
#pragma mark 限制使用系统自带键盘,不允许使用第三方键盘(有兼容性问题)

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier
{
//    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"])
//    {
//        return NO;
//    }
    
    return YES;
}


#pragma mark -
#pragma mark 首次启动引导页

- (void)showFirstGuideView
{
    if (s_IsShownFirstGuide)
    {
        FSFirstGuideVC *firstGuideVC = [[FSFirstGuideVC alloc] init];
        firstGuideVC.delegate = self;
        self.window.rootViewController = firstGuideVC;
#if USE_TEST_HELP
        [self showFPS];
#endif
    }
    else
    {
        [self showTabMain];
    }
}


#pragma mark -
#pragma mark MQFirstGuideVCDelegate

- (void)showFirstGuideVCFinish
{
    [self showTabMain];
}


- (void)showTabMain
{
    FSTabBarController *tabBarController = [[FSTabBarController alloc] initWithDefaultItems];
    [tabBarController addViewControllers];
    self.m_TabBarController = tabBarController;
    
    self.window.rootViewController = tabBarController;
#if USE_TEST_HELP
    [self showFPS];
#endif
}


#pragma mark -
#pragma mark logOut

// 踢出登录, 同logOut
- (void)kickOut
{
    [self logOut];
}

- (void)logOut
{
    [self logOutQuit:NO showLogin:YES];
}

// 退出登录
- (void)logOutQuit:(BOOL)quit showLogin:(BOOL)show
{
    // 重置所有倒计时
    [[BMVerifiTimeManager manager] stopAllType];
    
    [FSUserInfoModel logOut];
    
    if (quit)
    {
        UIViewController *vc = [self.m_TabBarController getCurrentRootViewController];
        if ([vc isKindOfClass:[FSUserMainVC class]])
        {
            if ([self.m_TabBarController getCurrentNavigationController].viewControllers.count != 1)
            {
                [[self.m_TabBarController getCurrentNavigationController] popToRootViewControllerAnimated:NO];
            }
        }
        else
        {
            [self.m_TabBarController selectedTabWithIndex:BMTabIndex_User];
        }
    }
    
    if (show)
    {
        UIViewController *vc = [self.m_TabBarController getCurrentViewController];
        FSSuperVC *superVC = (FSSuperVC *)vc;
        [superVC showLogin];
    }
}

// 使用API退出登录
- (void)logOutWithApi
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest userLogOut];
    if (request)
    {
        [self.m_LoginOutTask cancel];
        self.m_LoginOutTask = nil;

        BMWeakSelf
        self.m_LoginOutTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
#ifdef DEBUG
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf loginOutRequestFailed:response error:error];
                
            }
            else
            {
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
                [weakSelf loginOutRequestFinished:response responseDic:responseObject];
            }
#endif
        }];
        [self.m_LoginOutTask resume];
    }
    
    [self logOutQuit:YES showLogin:NO];
}

- (void)loginOutRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"登出返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        BMLog(@"登出成功");
        return;
    }

    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    BMLog(@"%@", message);
}

- (void)loginOutRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
}

- (void)getUserAbilityInfoWithVc:(FSSetTableViewVC *)vc
{
    self.m_GetAbilityVC = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest getDictionaryInfoWithLevelCode:@"ABILITY_TYPE"];
    if (request)
    {
        if (vc)
        {
            self.m_GetAbilityVC = vc;
            [vc.m_ProgressHUD showAnimated:YES showBackground:NO];
        }

        [self.m_UserAbilityTask cancel];
        self.m_UserAbilityTask = nil;
        
        BMWeakSelf
        self.m_UserAbilityTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf getUserAbilityInfoRequestFailed:response error:error];
                
            }
            else
            {
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
                [weakSelf getUserAbilityInfoRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_UserAbilityTask resume];
    }
}

- (void)getUserAbilityInfoRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        if (self.m_GetAbilityVC)
        {
            [self.m_GetAbilityVC.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        self.m_GetAbilityVC = nil;
        
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"查询擅长领域返回数据是:+++++%@", responseStr);
#endif
    
    if (self.m_GetAbilityVC)
    {
        [self.m_GetAbilityVC.m_ProgressHUD hideAnimated:YES];
    }

    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        BMLog(@"查询擅长领域成功");
        
        NSArray *dataDicArray = [resDic bm_arrayForKey:@"data"];
        if ([dataDicArray bm_isNotEmpty])
        {
            NSMutableArray *abilityArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dataDic in dataDicArray)
            {
                FSGlobleDataModel *abilityData = [FSGlobleDataModel globleDataModelWithServerDic:dataDic];
                if (abilityData)
                {
                    [abilityArray addObject:abilityData];
                }
            }
            
            if ([abilityArray bm_isNotEmpty])
            {
                self.m_Globle_UserAbilityInfo = abilityArray;
                if (self.m_GetAbilityVC)
                {
                    if ([self.m_GetAbilityVC isKindOfClass:[FSCustomInfoVC class]])
                    {
                        FSCustomInfoVC *customInfoVC = (FSCustomInfoVC *)self.m_GetAbilityVC;
                        [customInfoVC editAbility];
                    }
                }
            }
        }

        self.m_GetAbilityVC = nil;
        
        return;
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    BMLog(@"%@", message);
    if (self.m_GetAbilityVC)
    {
        [self.m_GetAbilityVC.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        self.m_GetAbilityVC = nil;
    }
}

- (void)getUserAbilityInfoRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"查询擅长领域失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    if (self.m_GetAbilityVC)
    {
        [self.m_GetAbilityVC.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        self.m_GetAbilityVC = nil;
    }
}

@end
