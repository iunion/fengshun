//
//  UIDevice+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 12-1-11.
//  Copyright (c) 2012年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (BMCategory)

+ (NSString * _Nonnull)bm_deviceModel;
+ (NSString * _Nonnull)bm_localizedModel;

/**
 *  平台
 *  Returns the device platform string
 *  Example: "iPhone7,2"
 *
 *  @return Returns the device platform string
 */
+ (NSString * _Nonnull)bm_devicePlatform;
/**
 *  设备型号
 *  Returns the user-friendly device platform string
 *  Example: "iPad Air (Cellular)"
 *
 *  @return Returns the user-friendly device platform string
 */
+ (NSString * _Nonnull)bm_devicePlatformString;

/**
 *  Check if the current device is an iPad
 *
 *  @return Returns YES if it's an iPad, NO if not
 */
+ (BOOL)bm_isiPad;

/**
 *  Check if the current device is an iPhone
 *
 *  @return Returns YES if it's an iPhone, NO if not
 */
+ (BOOL)bm_isiPhone;

/**
 *  Check if the current device is an iPod
 *
 *  @return Returns YES if it's an iPod, NO if not
 */
+ (BOOL)bm_isiPod;

/**
 *  Check if the current device is an Apple TV
 *
 *  @return Returns YES if it's an Apple TV, NO if not
 */
+ (BOOL)bm_isAppleTV;

/**
 *  Check if the current device is an Apple Watch
 *
 *  @return Returns YES if it's an Apple Watch, NO if not
 */
+ (BOOL)bm_isAppleWatch;

/**
 *  Check if the current device is the simulator
 *
 *  @return Returns YES if it's the simulator, NO if not
 */
+ (BOOL)bm_isSimulator;

/**
 *  Check if the current device has a Retina display
 *
 *  @return Returns YES if it has a Retina display, NO if not
 */
+ (BOOL)bm_isRetina;// DEPRECATED_MSG_ATTRIBUTE("Use +isRetina in UIScreen class");

/**
 *  Check if the current device has a Retina HD display
 *
 *  @return Returns YES if it has a Retina HD display, NO if not
 */
+ (BOOL)bm_isRetinaHD;// DEPRECATED_MSG_ATTRIBUTE("Use +isRetinaHD in UIScreen class");

/**
 *  Returns the iOS version without the subversion
 *  Example: 7
 *
 *  @return Returns the iOS version
 */
+ (CGFloat)bm_iOSVersion;

/** 获取设备上次重启的时间 */
+ (NSDate * _Nullable)bm_systemUptime;

#pragma mark - CPU

/**
 *  获取CPU频率
 *  Returns the current device CPU frequency
 *
 *  @return Returns the current device CPU frequency
 */
+ (NSUInteger)bm_cpuFrequency;

/**
 *  获取总线程频率
 *  Returns the current device BUS frequency
 *
 *  @return Returns the current device BUS frequency
 */
+ (NSUInteger)bm_busFrequency;

/**
 *  Returns the current device RAM size
 *
 *  @return Returns the current device RAM size
 */
+ (NSUInteger)bm_ramSize;

/**
 *  CPU核心数
 *  Returns the current device CPU number
 *
 *  @return Returns the current device CPU number
 */
+ (NSUInteger)bm_cpuNumber;
+ (NSUInteger)bm_cpuAvailableCount;

#pragma mark - Memory

/**
 *  内存总量
 *  Returns the current device total memory
 *
 *  @return Returns the current device total memory
 */
+ (NSUInteger)bm_totalMemory;

/**
 *  已用内存
 *  Returns the current device non-kernel memory
 *
 *  @return Returns the current device non-kernel memory
 */
+ (NSUInteger)bm_userMemory;

/**
 * 内存余量
 */
+ (NSUInteger)bm_freeMemory;

+ (NSUInteger)bm_maxSocketBufferSize;

/** 获取活跃的内存空间 */
+ (int64_t)bm_activeMemory;

/** 获取不活跃的内存空间 */
+ (int64_t)bm_inActiveMemory;

/** 获取存放内核的内存空间 */
+ (int64_t)bm_wiredMemory;

/** 获取可释放的内存空间 */
+ (int64_t)bm_purgableMemory;

#pragma mark - Disk

+ (NSString * _Nonnull)bm_applicationSize;

/**
 *  磁盘总大小
 *  Returns the current device total disk space
 *
 *  @return Returns the current device total disk space
 */
+ (NSNumber * _Nonnull)bm_totalDiskSpace;
+ (NSString * _Nonnull)bm_totalDiskSpaceString;

/**
 * 已用磁盘空间
 */
+ (NSNumber * _Nonnull)bm_usedDiskSpace;
+ (NSString * _Nonnull)bm_usedDiskSpaceString;

/**
 *  剩余磁盘空间
 *  Returns the current device free disk space
 *
 *  @return Returns the current device free disk space
 */
+ (NSNumber * _Nonnull)bm_freeDiskSpace;
+ (NSString * _Nonnull)bm_freeDiskSpaceString;

/**
 * 设备名称
 */
+ (NSString * _Nonnull)bm_deviceName;

/**
 * 系统版本
 */
+ (NSString * _Nonnull)bm_OSVersion;

/**
 * 是否支持多任务
 */
+ (BOOL)bm_isMultitaskingSupported;

/**
 * 是否越狱
 */
+ (BOOL)bm_hasJailBroken;

@end
