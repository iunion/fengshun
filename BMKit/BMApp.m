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

static NSString * const MTMigrationLastAppVersionKey = @"MTMigration.lastAppVersion";
static NSString * const MTMigrationLastAppBuildKey  = @"MTMigration.lastAppBuild";

@implementation BMApp

+ (void)onFirstStartApp:(firstStartAppHandler)block
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasBeenOpened = [defaults boolForKey:BMAppHasBeenOpenedKey];
    if (hasBeenOpened != true)
    {
        [defaults setBool:YES forKey:BMAppHasBeenOpenedKey];
        [defaults synchronize];
    }
    
    block(BMAPP_VERSION, BMAPP_BUILD, hasBeenOpened);
}

+ (void)onFirstStartForVersion:(NSString *)version
                         block:(firstStartHandler)block
{
    // version > lastVersion && version <= appVersion
    if ([version compare:[self lastVersion] options:NSNumericSearch] == NSOrderedDescending &&
        [version compare:BMAPP_VERSION options:NSNumericSearch] != NSOrderedDescending)
    {
        block(YES);
        
#if DEBUG
        BMLog(@"BMApp: Running migration for version %@", version);
#endif
        
        [self setLastVersion:version];
    }
    else
    {
        block(NO);
    }
}

+ (void)onFirstStartForBuildVersion:(nonnull NSString *)buildVersion
                              block:(nonnull firstStartHandler)block
{
    // buildVersion > lastBuildVersion && buildVersion <= appBuildVersion
    if ([buildVersion compare:[self lastBuildVersion] options:NSNumericSearch] == NSOrderedDescending &&
        [buildVersion compare:BMAPP_BUILD options:NSNumericSearch] != NSOrderedDescending)
    {
        block(YES);
        
#if DEBUG
        BMLog(@"BMApp: Running migration for buildVersion %@", buildVersion);
#endif
        
        [self setLastBuildVersion:buildVersion];
    }
    else
    {
        block(NO);
    }
}

+ (void)onFirstStartForCurrentVersion:(firstStartHandler)block
{
    if (![[self lastVersion] isEqualToString:BMAPP_VERSION])
    {
        block(YES);

#if DEBUG
        BMLog(@"BMApp: Running update Block for version %@", BMAPP_VERSION);
#endif
        
        [self setLastVersion:BMAPP_VERSION];
    }
}

+ (void)onFirstStartForCurrentBuildVersion:(nonnull firstStartHandler)block
{
    if (![[self lastBuildVersion] isEqualToString:BMAPP_BUILD])
    {
        block(YES);
        
#if DEBUG
        BMLog(@"BMApp: Running update Block for buildVersion %@", BMAPP_BUILD);
#endif
        
        [self setLastBuildVersion:BMAPP_BUILD];
    }
}


#pragma mark - UserDefaults

+ (void)reset
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:BMAppHasBeenOpenedKey];
    
    [self setLastVersion:nil];
    [self setLastBuildVersion:nil];
}

+ (NSString *)lastVersion
{
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:BMAppLastVersionKey];
    return (res ? res : @"");
}

+ (void)setLastVersion:(NSString *)version
{
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:BMAppLastVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)lastBuildVersion
{
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:BMAppLastBuildVersionKey];
    return (res ? res : @"");
}

+ (void)setLastBuildVersion:(NSString *)version
{
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:BMAppLastBuildVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
