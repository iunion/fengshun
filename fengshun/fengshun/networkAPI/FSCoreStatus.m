//
//  MQCoreStatus.m
//  miaoqian
//
//  Created by dengjiang on 16/1/19.
//  Copyright © 2016年 ShiCaiDai. All rights reserved.
//

#import "FSCoreStatus.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static NSString *const FSCoreStatusChangedNotify = @"FSCoreStatusChangedNotify";


@interface FSCoreStatus ()

/** 2G数组 */
@property (nonatomic, strong) NSArray *technology2GArray;

/** 3G数组 */
@property (nonatomic, strong) NSArray *technology3GArray;

/** 4G数组 */
@property (nonatomic, strong) NSArray *technology4GArray;

/** 网络状态中文数组 */
@property (nonatomic, strong) NSArray *coreNetworkStatusStringArray;
@property (nonatomic, strong) NSArray *fsNetworkStatusStringArray;

@property (nonatomic, strong) Reachability *m_Reachability;

@property (nonatomic, strong) CTTelephonyNetworkInfo *m_TelephonyNetworkInfo;

@property (nonatomic, copy) NSString *m_CurrentRaioAccess;

/** 是否正在监听 */
@property (nonatomic,assign) BOOL m_isMonitor;


@end

@implementation FSCoreStatus

+ (instancetype)sharedCoreStatus
{
    static id _instace;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    
    return _instace;
}

+ (void)initialize
{
    FSCoreStatus *status = [FSCoreStatus sharedCoreStatus];
    status.m_TelephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    status.m_isMonitor = NO;
}

/** 获取当前网络状态：枚举 */
+ (FSCoreNetWorkStatus)currentNetWorkStatus
{
    FSCoreStatus *status = [FSCoreStatus sharedCoreStatus];
    
    return [status statusWithRadioAccessTechnology];
}

/** 获取当前网络状态：字符串 */
+ (NSString *)currentNetWorkStatusString
{
    FSCoreStatus *status = [FSCoreStatus sharedCoreStatus];
    
    return status.coreNetworkStatusStringArray[[self currentNetWorkStatus]];
}

+ (NSString *)currentFSNetWorkStatusString
{
    FSCoreStatus *status = [FSCoreStatus sharedCoreStatus];
    
    return status.fsNetworkStatusStringArray[[self currentNetWorkStatus]];
}

/** 获取当前网络运营商：字符串 */
+ (NSString *)currentBrandName
{
    FSCoreNetWorkStatus netWorkStatus = [FSCoreStatus currentNetWorkStatus];
    if (netWorkStatus > FSCoreNetWorkStatusWifi && netWorkStatus < FSCoreNetWorkStatusUnkhow)
    {
        FSCoreStatus *status = [FSCoreStatus sharedCoreStatus];
        
        CTCarrier *carrier = [status.m_TelephonyNetworkInfo subscriberCellularProvider];
        
        NSString *mcc = carrier.mobileCountryCode;
        if ([mcc isEqualToString:@"460"])
        {
            NSString *mnc = carrier.mobileNetworkCode;
            if ([mnc isEqualToString:@"00"] || [mnc isEqualToString:@"02"] || [mnc isEqualToString:@"07"])
            {
                return @"中国移动";
            }
            else if ([mnc isEqualToString:@"01"] || [mnc isEqualToString:@"06"] || [mnc isEqualToString:@"09"])
            {
                return @"中国联通";
            }
            else if ([mnc isEqualToString:@"03"] || [mnc isEqualToString:@"05"] || [mnc isEqualToString:@"11"])
            {
                return @"中国电信";
            }
            else if ([mnc isEqualToString:@"20"])
            {
                return @"中国铁通";
            }
        }
        else
        {
            return @"非中国大陆";
        }
    }
    
    return @"未知";
}

- (FSCoreNetWorkStatus)statusWithRadioAccessTechnology
{
    NetworkStatus rNetWorkStatus = [self.m_Reachability currentReachabilityStatus];
    
    FSCoreNetWorkStatus netWorkStatus = FSCoreNetWorkStatusNone;
    
    switch (rNetWorkStatus)
    {
        case NotReachable:
        {
            netWorkStatus = FSCoreNetWorkStatusNone;
            break;
        }
        case ReachableViaWiFi:
        {
            netWorkStatus = FSCoreNetWorkStatusWifi;
            break;
        }
        case ReachableViaWWAN:
        {
            netWorkStatus = FSCoreNetWorkStatusWWAN;
            break;
        }
    }
    
    NSString *technology = self.m_CurrentRaioAccess;
    
    if (netWorkStatus == FSCoreNetWorkStatusWWAN && technology != nil)
    {
        if ([self.technology2GArray containsObject:technology])
        {
            netWorkStatus = FSCoreNetWorkStatus2G;
        }
        else if ([self.technology3GArray containsObject:technology])
        {
            netWorkStatus = FSCoreNetWorkStatus3G;
        }
        else if ([self.technology4GArray containsObject:technology])
        {
            netWorkStatus = FSCoreNetWorkStatus4G;
        }
    }
    
    return netWorkStatus;
}

/** 开始网络监听 */
+ (void)beginMonitorNetwork:(id<FSCoreNetWorkStatusProtocol>)listener
{
    FSCoreStatus *status = [FSCoreStatus sharedCoreStatus];
    
    if (status.m_isMonitor)
    {
        BMLog(@"CoreStatus已经处于监听中，请检查其他页面是否关闭监听！");
        
        [self endMonitorNetwork:listener];
    }
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:listener selector:@selector(coreNetworkChanged:) name:FSCoreStatusChangedNotify object:status];
    [[NSNotificationCenter defaultCenter] addObserver:status selector:@selector(coreNetWorkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:status selector:@selector(coreNetWorkStatusChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    
    [status.m_Reachability startNotifier];
    
    // 标记
    status.m_isMonitor = YES;
}

/** 停止网络监听 */
+ (void)endMonitorNetwork:(id<FSCoreNetWorkStatusProtocol>)listener
{
    FSCoreStatus *status = [FSCoreStatus sharedCoreStatus];
    
    if (!status.m_isMonitor)
    {
        BMLog(@"CoreStatus监听已经被关闭");
        return;
    }
    
    // 解除监听
    [[NSNotificationCenter defaultCenter] removeObserver:status name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:status name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:listener name:FSCoreStatusChangedNotify object:status];
    
    // 标记
    status.m_isMonitor = NO;
}

- (void)coreNetWorkStatusChanged:(NSNotification *)notification
{
    // 发送通知
    if (notification.name == CTRadioAccessTechnologyDidChangeNotification && notification.object != nil)
    {
        self.m_CurrentRaioAccess = self.m_TelephonyNetworkInfo.currentRadioAccessTechnology;
    }
    
    // 再次发出通知
    NSDictionary *userInfo = @{@"currentStatusEnum": @([FSCoreStatus currentNetWorkStatus]),
                               @"currentStatusString": [FSCoreStatus currentNetWorkStatusString],
                               @"currentBrandName": [FSCoreStatus currentBrandName]
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FSCoreStatusChangedNotify object:self userInfo:userInfo];
}

/** 是否是Wifi */
+ (BOOL)isWifiEnable
{
    return [FSCoreStatus currentNetWorkStatus] == FSCoreNetWorkStatusWifi;
}

/** 是否有网络 */
+ (BOOL)isNetworkEnable
{
    FSCoreNetWorkStatus networkStatus = [FSCoreStatus currentNetWorkStatus];
    
    return networkStatus != FSCoreNetWorkStatusUnkhow && networkStatus != FSCoreNetWorkStatusNone;
}

/** 是否处于高速网络环境：3G、4G、Wifi */
+ (BOOL)isHighSpeedNetwork
{
    FSCoreNetWorkStatus networkStatus = [self currentNetWorkStatus];
    return networkStatus == FSCoreNetWorkStatus3G || networkStatus == FSCoreNetWorkStatus4G || networkStatus == FSCoreNetWorkStatusWifi;
}


#pragma mark -
#pragma mark 懒加载

- (Reachability *)m_Reachability
{
    if (_m_Reachability == nil)
    {
        _m_Reachability = [Reachability reachabilityForInternetConnection];
    }
    
    return _m_Reachability;
}


- (CTTelephonyNetworkInfo *)m_TelephonyNetworkInfo
{
    if (_m_TelephonyNetworkInfo == nil)
    {
        _m_TelephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    
    return _m_TelephonyNetworkInfo;
}


- (NSString *)m_CurrentRaioAccess
{
    if (_m_CurrentRaioAccess == nil)
    {
        _m_CurrentRaioAccess = self.m_TelephonyNetworkInfo.currentRadioAccessTechnology;
    }
    
    return _m_CurrentRaioAccess;
}

/** 2G数组 */
- (NSArray *)technology2GArray
{
    if (_technology2GArray == nil)
    {
        _technology2GArray = @[CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyGPRS];
    }
    
    return _technology2GArray;
}


/** 3G数组 */
- (NSArray *)technology3GArray
{
    if (_technology3GArray == nil)
    {
        _technology3GArray = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMA1x,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    }
    
    return _technology3GArray;
}

/** 4G数组 */
- (NSArray *)technology4GArray
{
    if (_technology4GArray == nil)
    {
        _technology4GArray = @[CTRadioAccessTechnologyLTE];
    }
    
    return _technology4GArray;
}

/** 网络状态中文数组 */
- (NSArray *)coreNetworkStatusStringArray
{
    if (_coreNetworkStatusStringArray == nil)
    {
        _coreNetworkStatusStringArray = @[@"无网络", @"Wifi", @"蜂窝网络", @"2G", @"3G", @"4G", @"未知网络"];
    }
    
    return _coreNetworkStatusStringArray;
}

- (NSArray *)fsNetworkStatusStringArray
{
    // 2G/3G/4G/WIFI/unknown
    if (_fsNetworkStatusStringArray == nil)
    {
        _fsNetworkStatusStringArray = @[@"no", @"WIFI", @"cellular", @"2G", @"3G", @"4G", @"unknown"];
    }
    
    return _fsNetworkStatusStringArray;
}

@end
