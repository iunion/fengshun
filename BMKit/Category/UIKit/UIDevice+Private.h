//
//  UIDevice+Private.h
//  fengshun
//
//  Created by jiang deng on 2019/1/7.
//Copyright © 2019 FS. All rights reserved.
//

#if USE_TEST_HELP

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Private)

/** 获取设备颜色 */
+ (NSString *)bm_deviceColor;
/** 获取设备外壳颜色 */
+ (NSString *)bm_deviceEnclosureColor;

@end

@interface UIDevice (Authority)

// 地理位置权限
+ (NSString *)bm_locationAuthority;

// 是否有联网功能
+ (NSString *)bm_netAuthority;

// push权限
+ (NSString *)bm_pushAuthority;

// 拍照权限
+ (NSString *)bm_cameraAuthority;

// 相册权限
+ (NSString *)bm_photoAuthority;

// 麦克风权限
+ (NSString *)bm_audioAuthority;

// 通讯录权限
+ (NSString *)bm_addressAuthority;

// 日历权限
+ (NSString *)bm_calendarAuthority;

// 提醒事项权限
+ (NSString *)bm_remindAuthority;

// 蓝牙权限
+ (NSString *)bm_bluetoothAuthority;

@end

NS_ASSUME_NONNULL_END

#endif
