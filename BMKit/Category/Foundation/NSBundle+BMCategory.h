//
//  NSBundle+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/4/13.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (BMCategory)

+ (nullable NSString *)bm_mainResourcePath;

+ (nonnull NSString *)bm_mainBundlePath;

+ (nullable NSString *)bm_applicationPath;
+ (nullable NSString *)bm_applicationName;

/** The app name. */
@property (nonatomic, assign, readonly, nullable) NSString *bm_appName;

/** The app version. */
@property (nonatomic, assign, readonly, nullable) NSString *bm_version;

/** The app build. */
@property (nonatomic, assign, readonly, nullable) NSString *bm_buildVersion;

@end
