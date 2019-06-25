//
//  BMApp.h
//  BMBaseKit
//
//  Created by jiang deng on 2018/6/14.
//  Copyright © 2018年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^firstStartAppHandler)(NSString * _Nonnull version, NSString * _Nonnull buildVersion, BOOL isFirstStart);
typedef void (^firstStartHandler)(BOOL isFirstStart);

#define BMAPP_NAME      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define BMAPP_BUILD     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define BMAPP_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface BMApp : NSObject

// 第一次启动app
+ (void)onFirstStartApp:(nonnull firstStartAppHandler)block;

// 注意version最好比currentVersion低，否则如果两个版本相等时会每次都调用block
// version > lastVersion && version <= appVersion
+ (void)onFirstStartForVersion:(nonnull NSString *)version
                         block:(nonnull firstStartHandler)block;
// buildVersion > lastBuildVersion && buildVersion <= appBuildVersion
+ (void)onFirstStartForBuildVersion:(nonnull NSString *)buildVersion
                              block:(nonnull firstStartHandler)block;

+ (void)onFirstStartForCurrentVersion:(nonnull firstStartHandler)block;
+ (void)onFirstStartForCurrentBuildVersion:(nonnull firstStartHandler)block;

+ (void)reset;


// 用户不同应用设置key
+ (void)onFirstStartApp:(nonnull firstStartAppHandler)block withKey:(nullable NSString *)key;

+ (void)onFirstStartForVersion:(nonnull NSString *)version
                         block:(nonnull firstStartHandler)block
                       withKey:(nullable NSString *)key;
+ (void)onFirstStartForBuildVersion:(nonnull NSString *)buildVersion
                              block:(nonnull firstStartHandler)block
                            withKey:(nullable NSString *)key;

+ (void)onFirstStartForCurrentVersion:(nonnull firstStartHandler)block withKey:(nullable NSString *)key;
+ (void)onFirstStartForCurrentBuildVersion:(nonnull firstStartHandler)block withKey:(nullable NSString *)key;

+ (void)resetWithKey:(nullable NSString *)key;

@end
