//
//  AppDelegate.m
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "AppDelegate.h"

#import "FSLocation.h"
#import "FSCoreStatus.h"

#import "FSUserInfo.h"
#import "IQKeyboardManager.h"
//#import "SDWebImageCodersManager.h"
//#import "SDWebImageGIFCoder.h"

@interface AppDelegate ()
<
    CLLocationManagerDelegate,
    FSCoreNetWorkStatusProtocol
>

// 位置信息
@property (strong, nonatomic) CLLocationManager *m_LocationManager;

@end

@implementation AppDelegate

- (void)dealloc
{
    [FSCoreStatus endMonitorNetwork:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:nil];
    
    [self removeObserver:self forKeyPath:@"m_UserInfo"];
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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // TODO: Substitute UIViewController with your own subclass.

    [self setUpApp];
    
    // 添加观察者，监听用户信息的改变
    [self addObserver:self forKeyPath:@"m_UserInfo" options:NSKeyValueObservingOptionNew context:nil];
    self.m_UserInfo = [FSUserInfoDB getUserInfoWithUserId:[FSUserInfoModle getCurrentUserId]];
    if (!self.m_UserInfo)
    {
        self.m_UserInfo = [[FSUserInfoModle alloc] init];
    }

    FSTabBarController *tabBarController = [[FSTabBarController alloc] initWithDefaultItems];
    [tabBarController addViewControllers];
    self.m_TabBarController = tabBarController;
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initKeyboardManager];
    
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"m_UserInfo"])
    {
        //FSUserInfoModle *oldUserInfo = [change objectForKey:NSKeyValueChangeOldKey];
        //FSUserInfoModle *newUserInfo = [change objectForKey:NSKeyValueChangeNewKey];
        
        //if (![oldUserInfo bm_isValided])
        {
            // 用户数据变更，包括登录注册，退出登录
            [[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];
        }
    }
}

- (void)initKeyboardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
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

@end
