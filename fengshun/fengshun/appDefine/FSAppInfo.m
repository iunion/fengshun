//
//  FSAppInfo.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSAppInfo.h"
#import "AppDelegate.h"
#import "OpenUDID.h"

#define OPENUDID_KEY                @"fsopenUDID_appUID"
#define CURRENT_PHONENUM_KEY        @"fscurrent_phoneNum"
#define UPDATE_VERSION_KEY          @"fsupdate_version"

@implementation FSAppInfo

+ (NSString *)catchChannelName
{
    return @"App Store";
}

// OpenUDID
+ (NSString *)getOpenUDID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appUID = [defaults objectForKey:OPENUDID_KEY];
    if (![appUID bm_isNotEmpty])
    {
        // The AppUID will uniquely identify this app within the pastebins
        //
        appUID = [OpenUDID value];

        [FSAppInfo setOpenUDID:appUID];
    }
    
    return appUID;
}

+ (void)setOpenUDID:(NSString *)openUDID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:openUDID forKey:OPENUDID_KEY];
    
    [defaults synchronize];
}

+ (NSString *)getCurrentPhoneNum
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:CURRENT_PHONENUM_KEY];
    return phoneNum;
}

+ (void)setCurrentPhoneNum:(NSString *)phoneNum
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([phoneNum bm_isNotEmpty])
    {
        [defaults setObject:phoneNum forKey:CURRENT_PHONENUM_KEY];
    }
    else
    {
        [defaults removeObjectForKey:CURRENT_PHONENUM_KEY];
    }
    
    [defaults synchronize];
}

+ (NSString *)getUpdateVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [defaults objectForKey:UPDATE_VERSION_KEY];
    return version;
}

+ (void)setUpdateVersion:(NSString *)version
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([version bm_isNotEmpty])
    {
        [defaults setObject:version forKey:UPDATE_VERSION_KEY];
    }
    
    [defaults synchronize];
}

@end
