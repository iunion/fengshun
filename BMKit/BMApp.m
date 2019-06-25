//
//  BMApp.m
//  BMBaseKit
//
//  Created by jiang deng on 2018/6/14.
//  Copyright © 2018年 BM. All rights reserved.
//

#import "BMApp.h"

static NSString * const BMAppHasBeenOpenedKey       = @"BMApp.hasBeenOpened";

static NSString * const BMAppLastVersionKey         = @"BMApp.lastVersion";
static NSString * const BMAppLastBuildVersionKey    = @"BMApp.lastBuildVersion";

@implementation BMApp

+ (void)onFirstStartApp:(firstStartAppHandler)block
{
    [self onFirstStartApp:block withKey:BMAPP_NAME];
}

+ (void)onFirstStartApp:(firstStartAppHandler)block withKey:(NSString *)key;
{
    NSString *appkey = BMAppHasBeenOpenedKey;
    if ([appkey bm_isNotEmpty])
    {
        appkey = [NSString stringWithFormat:@"%@_%@", BMAppHasBeenOpenedKey, key];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasBeenOpened = [defaults boolForKey:appkey];
    if (hasBeenOpened != true)
    {
        [defaults setBool:YES forKey:appkey];
        [defaults synchronize];
    }
    
    block(BMAPP_VERSION, BMAPP_BUILD, hasBeenOpened);
}

+ (void)onFirstStartForVersion:(NSString *)version
                         block:(firstStartHandler)block
{
    [self onFirstStartForVersion:version block:block withKey:BMAPP_NAME];
}

+ (void)onFirstStartForVersion:(NSString *)version
                         block:(firstStartHandler)block
                       withKey:(NSString *)key
{
    // version > lastVersion && version <= appVersion
    if ([version compare:[self lastVersionWithKey:key] options:NSNumericSearch] == NSOrderedDescending &&
        [version compare:BMAPP_VERSION options:NSNumericSearch] != NSOrderedDescending)
    {
        block(YES);
        
#ifdef DEBUG
        BMLog(@"BMApp: Running migration for version %@", version);
#endif
        
        [self setLastVersion:version withKey:key];
    }
    else
    {
        block(NO);
    }
}

+ (void)onFirstStartForBuildVersion:(NSString *)buildVersion
                              block:(firstStartHandler)block
{
    [self onFirstStartForBuildVersion:buildVersion block:block withKey:BMAPP_NAME];
}

+ (void)onFirstStartForBuildVersion:(NSString *)buildVersion
                              block:(firstStartHandler)block
                            withKey:(NSString *)key
{
    // buildVersion > lastBuildVersion && buildVersion <= appBuildVersion
    if ([buildVersion compare:[self lastBuildVersionWithKey:key] options:NSNumericSearch] == NSOrderedDescending &&
        [buildVersion compare:BMAPP_BUILD options:NSNumericSearch] != NSOrderedDescending)
    {
        block(YES);
        
#ifdef DEBUG
        BMLog(@"BMApp: Running migration for buildVersion %@", buildVersion);
#endif
        
        [self setLastBuildVersion:buildVersion withKey:key];
    }
    else
    {
        block(NO);
    }
}

+ (void)onFirstStartForCurrentVersion:(firstStartHandler)block
{
    [self onFirstStartForCurrentVersion:block withKey:BMAPP_NAME];
}

+ (void)onFirstStartForCurrentVersion:(firstStartHandler)block withKey:(NSString *)key
{
    if (![[self lastVersionWithKey:key] isEqualToString:BMAPP_VERSION])
    {
        block(YES);

#ifdef DEBUG
        BMLog(@"BMApp: Running update Block for version %@", BMAPP_VERSION);
#endif
        
        [self setLastVersion:BMAPP_VERSION withKey:key];
    }
}

+ (void)onFirstStartForCurrentBuildVersion:(firstStartHandler)block
{
    [self onFirstStartForCurrentBuildVersion:block withKey:BMAPP_NAME];
}

+ (void)onFirstStartForCurrentBuildVersion:(nonnull firstStartHandler)block withKey:(nullable NSString *)key
{
    if (![[self lastBuildVersionWithKey:key] isEqualToString:BMAPP_BUILD])
    {
        block(YES);
        
#ifdef DEBUG
        BMLog(@"BMApp: Running update Block for buildVersion %@", BMAPP_BUILD);
#endif
        
        [self setLastBuildVersion:BMAPP_BUILD withKey:key];
    }
}


#pragma mark - UserDefaults

+ (void)reset
{
    [self resetWithKey:BMAPP_NAME];
}

+ (void)resetWithKey:(NSString *)key
{
    NSString *appkey = BMAppHasBeenOpenedKey;
    if ([appkey bm_isNotEmpty])
    {
        appkey = [NSString stringWithFormat:@"%@_%@", BMAppHasBeenOpenedKey, key];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:appkey];
    
    [self setLastVersion:nil withKey:key];
    [self setLastBuildVersion:nil withKey:key];
}

+ (NSString *)lastVersionWithKey:(NSString *)key
{
    NSString *appkey = BMAppLastVersionKey;
    if ([appkey bm_isNotEmpty])
    {
        appkey = [NSString stringWithFormat:@"%@_%@", BMAppLastVersionKey, key];
    }
    
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:appkey];
    return (res ? res : @"");
}

+ (void)setLastVersion:(NSString *)version withKey:(NSString *)key
{
    NSString *appkey = BMAppLastVersionKey;
    if ([appkey bm_isNotEmpty])
    {
        appkey = [NSString stringWithFormat:@"%@_%@", BMAppLastVersionKey, key];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:appkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)lastBuildVersionWithKey:(NSString *)key
{
    NSString *appkey = BMAppLastBuildVersionKey;
    if ([appkey bm_isNotEmpty])
    {
        appkey = [NSString stringWithFormat:@"%@_%@", BMAppLastBuildVersionKey, key];
    }
    
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:appkey];
    return (res ? res : @"");
}

+ (void)setLastBuildVersion:(NSString *)version withKey:(NSString *)key
{
    NSString *appkey = BMAppLastBuildVersionKey;
    if ([appkey bm_isNotEmpty])
    {
        appkey = [NSString stringWithFormat:@"%@_%@", BMAppLastBuildVersionKey, key];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:appkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
