//
//  NSBundle+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 2017/4/13.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "NSBundle+BMCategory.h"

@implementation NSBundle (BMCategory)

+ (NSString *)bm_mainResourcePath
{
    return [NSBundle mainBundle].resourcePath;
}

+ (NSString *)bm_mainBundlePath
{
    return [NSBundle mainBundle].bundlePath;
}

+ (NSString *)bm_applicationPath
{
    return [NSBundle mainBundle].executablePath;
}

+ (NSString *)bm_applicationName
{
    return [NSBundle bm_applicationPath].lastPathComponent;
}

- (NSString *)bm_appName
{
    return self.infoDictionary[@"CFBundleDisplayName"];
}

- (NSString *)bm_version
{
    return self.infoDictionary[@"CFBundleShortVersionString"];
}

- (NSString *)bm_buildVersion
{
    return self.infoDictionary[@"CFBundleVersion"];
}

@end
