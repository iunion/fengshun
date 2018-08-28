//
//  FSDBVersionCheck.m
//  fengshun
//
//  Created by dengjiang on 15/8/17.
//  Copyright (c) 2015年 ShiCaiDai. All rights reserved.
//

#import "FSDBVersionCheck.h"

#import "AppDelegate.h"
#import "FSUserInfoModle.h"

#define DBVER_USERINFO                @"1.0"
#define DBVER_USERINFO_KEY            @"dbver_userinfo_key"


@implementation FSDBVersionCheck

+ (void)checkDBVer
{
//    if (![FSDBVersionCheck checkUserInfo_DBVer])
//    {
//        FSUserInfoModle *userInfo = GetAppDelegate.m_UserInfo;
//        if (!userInfo.m_Token)
//        {
//            MQUserInfo *oldUserInfo = [MQUserInfoDB getUserInfoWithUserIdFrom3_0:[MQUserInfo getCurrentUserId]];
////            if (!oldUserInfo)
////            {
////                oldUserInfo = [MQUserInfoDB getUserInfoWithUserIdFrome1_1:[MQUserInfo getCurrentUserId]];
////            }
//            
//            [MQUserInfoDB deleteUserInfoDB];
//            
//            if (oldUserInfo.m_Token)
//            {
//                [MQUserInfoDB createUserInfoDB];
//                
//                [MQUserInfoDB insertAndUpdateUserInfo:oldUserInfo];
//                GetAppDelegate.m_UserInfo = oldUserInfo;
//            }
//        }
//        else
//        {
//            [MQUserInfoDB deleteUserInfoDB];
//        }
//    }
//    
//    [MQUserInfoDB createUserInfoDB];
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
