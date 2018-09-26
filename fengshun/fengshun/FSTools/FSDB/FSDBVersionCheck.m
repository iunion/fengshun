//
//  FSDBVersionCheck.m
//  fengshun
//
//  Created by dengjiang on 15/8/17.
//  Copyright (c) 2015年 ShiCaiDai. All rights reserved.
//

#import "FSDBVersionCheck.h"

#import "AppDelegate.h"
#import "FSUserInfo.h"

#define DBVER_USERINFO                @"1.0"
#define DBVER_USERINFO_KEY            @"dbver_userinfo_key"


@implementation FSDBVersionCheck

+ (void)checkDBVer
{
    if (![FSDBVersionCheck checkUserInfo_DBVer])
    {
#if 0
        FSUserInfoModel *oldUserInfo = [FSUserInfoDB getUserInfoWithUserIdFrom1_0:[FSUserInfoModel getCurrentUserId]];
            
//        if (!oldUserInfo)
//        {
//            oldUserInfo = [FSUserInfoDB getUserInfoWithUserIdFrome1_1:[FSUserInfoModel getCurrentUserId]];
//        }
        
        [FSUserInfoDB deleteUserInfoDB];
            
        if (oldUserInfo.m_Token)
        {
            [FSUserInfoDB createUserInfoDB];
            
            [FSUserInfoDB insertAndUpdateUserInfo:oldUserInfo];
            GetAppDelegate.m_UserInfo = oldUserInfo;
        }
#else
        [FSUserInfoDB deleteUserInfoDB];
#endif
    }
    
    [FSUserInfoDB createUserInfoDB];
}

+ (BOOL)checkUserInfo_DBVer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *DBVer = [defaults objectForKey:DBVER_USERINFO_KEY];
    
    if ([DBVer isEqualToString:DBVER_USERINFO])
    {
        return YES;
    }
    else
    {
        [defaults setObject:DBVER_USERINFO forKey:DBVER_USERINFO_KEY];
        [defaults synchronize];
        
        return NO;
    }
}

@end
