//
//  FSCoreStatus.h
//  miaoqian
//
//  Created by dengjiang on 16/1/19.
//  Copyright © 2016年 ShiCaiDai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

/** 网络状态 */
typedef NS_ENUM(NSUInteger, FSCoreNetWorkStatus)
{
    /** 无网络 */
    FSCoreNetWorkStatusNone = 0,
    
    /** Wifi网络 */
    FSCoreNetWorkStatusWifi,
    
    /** 蜂窝网络 */
    FSCoreNetWorkStatusWWAN,
    
    /** 2G网络 */
    FSCoreNetWorkStatus2G,
    
    /** 3G网络 */
    FSCoreNetWorkStatus3G,
    
    /** 4G网络 */
    FSCoreNetWorkStatus4G,
    
    //未知网络
    FSCoreNetWorkStatusUnkhow
};

@protocol FSCoreNetWorkStatusProtocol;

@interface FSCoreStatus : NSObject

/** 获取当前网络状态：枚举 */
+ (FSCoreNetWorkStatus)currentNetWorkStatus;

/** 获取当前网络状态：字符串 */
+ (NSString *)currentNetWorkStatusString;
+ (NSString *)currentFSNetWorkStatusString;

/** 获取当前网络运营商：字符串 */
+ (NSString *)currentBrandName;

/** 开始网络监听 */
+ (void)beginMonitorNetwork:(id<FSCoreNetWorkStatusProtocol>)listener;

/** 停止网络监听 */
+ (void)endMonitorNetwork:(id<FSCoreNetWorkStatusProtocol>)listener;


/** 是否是Wifi */
+ (BOOL)isWifiEnable;

/** 是否有网络 */
+ (BOOL)isNetworkEnable;

/** 是否处于高速网络环境：3G、4G、Wifi */
+ (BOOL)isHighSpeedNetwork;

@end


@protocol FSCoreNetWorkStatusProtocol <NSObject>

@required

/** 网络状态变更 */
- (void)coreNetworkChanged:(NSNotification *)noti;

@optional

@end

