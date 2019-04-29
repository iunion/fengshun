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
#import "FSCountDownManager.h"

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
#import <UMShare/UMShare.h>
#import "FSShareManager.h"

#import "Growing.h"

//#import "SDWebImageCodersManager.h"
//#import "SDWebImageGIFCoder.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()
<
    CLLocationManagerDelegate,
    FSCoreNetWorkStatusProtocol,
    FSFirstGuideVCDelegate,
    JPUSHRegisterDelegate
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

// Umeng统计、分享
- (void)setupUmeng
{
    [UMConfigure initWithAppkey:UMeng_AppKey channel:@"App Store"];
    
    [MobClick setScenarioType:E_UM_NORMAL];
    
    [FSShareManager configSharePlateform];
}


// 启动GrowingIO
- (void)setupGrowingIO
{
    [Growing startWithAccountId:GrowingIO_AccountID];
}

- (void)setupThirdPartyWithOptions:(NSDictionary *)launchOptions
{
#ifdef FSVIDEO_ON
    // 腾讯视频
    [self setupILiveSDK];
#endif

    // Umeng统计/分享
    [self setupUmeng];
    // 极光推送
    [self setupJPushWithOptions:launchOptions];
    
    // 启动GrowingIO
    [self setupGrowingIO];
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
    [FSTestHelper sharedInstance];
    self.window = [[BMConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[[BMConsole sharedConsole] handleConsoleCommand:@"mn"];
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    // Override point for customization after application launch.
    // TODO: Substitute UIViewController with your own subclass.

    [self setUpApp];
    
    [self setupThirdPartyWithOptions:launchOptions];
    
    
    // 处理通过通知启动APP的情况
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self handleAPNsContent:userInfo withRecieveState:FSReceivePushInfoState_PushInfoLaunching];
    }
    [self cleanBadge];

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
            NSString *phoneNum = _m_UserInfo.m_UserBaseInfo.m_PhoneNum;
            if ([phoneNum bm_isNotEmpty]) {
                [JPUSHService setAlias:phoneNum completion:nil seq:0];
            }
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
    [self cleanBadge];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([Growing handleUrl:url]) // 请务必确保该函数被调用
        {
            return YES;
        }
        if ([self.m_TabBarController topVCJumpWithUrl:url])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([Growing handleUrl:url]) // 请务必确保该函数被调用
        {
            return YES;
        }
        if ([self.m_TabBarController topVCJumpWithUrl:url])
        {
            return YES;
        }
    }
    return result;
}
#pragma mark -
#pragma mark 外部跳转信息
// 根据外部跳转信息进行跳转(远程推送,Safari进入等)
- (void)externalPushWithModel:(FSPushVCModel *)model andRevieveState:(FSReceivePushInfoState)recieveState
{
    switch (recieveState) {
        case FSReceivePushInfoState_Active:
            break;
            
        case FSReceivePushInfoState_PushInfoEnter:
            [self.m_TabBarController topVCPushWithModel:model];
            break;
        case FSReceivePushInfoState_PushInfoLaunching:
            self.m_PushModel = model;
            break;
    }
}
#pragma mark -
#pragma mark 远程推送

// 处理远程推送
- (void)handleAPNsContent:(NSDictionary *)userInfo withRecieveState:(FSReceivePushInfoState)recieveState
{
    BMLog(@"++++++[FTLS]APNs content:%@",userInfo);
    FSAPNsNotificationModel *model = [FSAPNsNotificationModel modelWithParams:userInfo];
    [self externalPushWithModel:model andRevieveState:recieveState];
    [self cleanBadge];
}

- (void)cleanBadge
{
    // 角标清零
    [JPUSHService resetBadge];
    // 先1在零,是为了防止通知中心的通知出现未被清除的情况
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
//  关于宏命令NSFoundationVersionNumber_iOS_9_x_Max，由于在iOS9(XCode7)中Apple已经提前支持了宏命令__IPHONE_10_0，所以这儿添加了NSFoundationVersionNumber_iOS_9_x_Max做判断
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- 通知到达/进入的不同iOS版本的回调
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    
    // >iOS10,在前台收到通知
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self handleAPNsContent:userInfo withRecieveState:FSReceivePushInfoState_Active];
    }
    completionHandler(0);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    // >iOS10, 通过通知进入APP
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self handleAPNsContent:userInfo withRecieveState:FSReceivePushInfoState_PushInfoEnter];
        
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // <iOS10, 通知到达(包括APP在前台和后台)
    [JPUSHService handleRemoteNotification:userInfo];
    [self handleAPNsContent:userInfo withRecieveState:(application.applicationState == UIApplicationStateActive)?FSReceivePushInfoState_Active:FSReceivePushInfoState_PushInfoEnter];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(12.0)){
    if (notification) {
//      从通知界面直接进入应用
    }else{
//      从系统设置界面进入应用
    }
}
#endif


#pragma mark 注册远程推送相关API

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    // 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    BMLog(@"[JPush]+++++++APNs注册失败")
}
// 配置&注册极光推送
- (void)setupJPushWithOptions:(NSDictionary *)launchOptions
{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // 3.0.0及以后版本注册
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
#ifdef DEBUG
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPush_AppKey
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
#else
    [JPUSHService setupWithOption:launchOptions appKey:JPush_AppKey
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
#endif
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            BMLog(@"[JPush]+++++++registrationID获取成功：%@",registrationID);
        }
        else{
            BMLog(@"[JPush]+++++++registrationID获取失败，code：%d",resCode);
        }
    }];
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
    [[FSCountDownManager manager] stopAllCountDownDoNothing];
    
    [FSUserInfoModel logOut];
    [JPUSHService deleteAlias:nil seq:0];
    
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
