//
//  FSUserInfoModle.m
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#define USERINFO_USERID_KEY                 @"userinfo_userid_key"
#define USERINFO_USERTOKEN_KEY              @"userinfo_usertoken_key"
#define USERINFO_MOBILE_KEY                 @"userinfo_mobile_key"

#import "FSUserInfoModle.h"
#import "AppDelegate.h"
#import "FSUserInfoDB.h"

@implementation FSUserInfoModle

+ (FSUserInfoModle *)userInfo
{
    return GetAppDelegate.m_UserInfo;
}

// 用户登录ID
+ (NSString *)getCurrentUserId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:USERINFO_USERID_KEY];
    
    return userId;
}

+ (void)setCurrentUserID:(NSString *)userID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userID forKey:USERINFO_USERID_KEY];
    [defaults synchronize];
}

// 用户登录token
+ (NSString *)getCurrentUserToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:USERINFO_USERTOKEN_KEY];
    
    return userId;
}

+ (void)setCurrentUserToken:(NSString *)userToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userToken forKey:USERINFO_USERTOKEN_KEY];
    [defaults synchronize];
}

+ (instancetype)userInfoWithServerDic:(NSDictionary *)dic
{
    return [FSUserInfoModle userInfoWithServerDic:dic isUpDateByUserInfoApi:YES];
}

+ (instancetype)userInfoWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoAp
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *userId = [dic bm_stringTrimForKey:@"custId"];
    if (![userId bm_isNotEmpty])
    {
        return nil;
    }
    NSString *token = [dic bm_stringTrimForKey:@"token"];
    if (![token bm_isNotEmpty])
    {
        return nil;
    }

    // 数据库读取
    FSUserInfoModle *userInfo = [FSUserInfoDB getUserInfoWithUserId:userId];
    if (!userInfo)
    {
        userInfo = [[FSUserInfoModle alloc] init];
    }

    [userInfo updateWithServerDic:dic isUpDateByUserInfoApi:userInfoAp];
    
    if ([userInfo.m_UserId bm_isNotEmpty] && [userInfo.m_Token bm_isNotEmpty])
    {
        return userInfo;
    }
    else
    {
        return nil;
    }
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _m_LastUpdateTs = [[NSDate date] timeIntervalSince1970];
        
        _m_UserId = [FSUserInfoModle getCurrentUserId];
        _m_Token = [FSUserInfoModle getCurrentUserToken];
    }
    
    return self;
}

- (void)updateWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }

    // 🔐用户ID: custId
    NSString *userId = [dic bm_stringTrimForKey:@"custId"];
    if (![userId bm_isNotEmpty])
    {
        return;
    }
    
    // 用户令牌(登录注册)💡: token
    NSString *token = [dic bm_stringTrimForKey:@"token"];
    if (![token bm_isNotEmpty])
    {
        return;
    }

    if (userInfoApi)
    {
        // 判断关键key是否相同
        if ([self.m_UserId bm_isNotEmpty] && ![self.m_UserId isEqualToString:userId])
        {
            return;
        }
        
        if ([self.m_Token bm_isNotEmpty] && ![self.m_Token isEqualToString:token])
        {
            return;
        }
    }

    // custId
    self.m_UserId = userId;
        
    // token
    self.m_Token = token;

    
    
    
}

+ (BOOL)isLogin
{
    FSUserInfoModle *currentUser = GetAppDelegate.m_UserInfo;
    if ([currentUser.m_UserId bm_isNotEmpty] && [currentUser.m_Token bm_isNotEmpty])
    {
        return YES;
    }
    
    return NO;
}

+ (void)logOut
{
    [FSUserInfoModle setCurrentUserID:nil];
    [FSUserInfoModle setCurrentUserToken:nil];
    
    GetAppDelegate.m_UserInfo = nil;
}



@end
