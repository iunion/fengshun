//
//  FSApiUserRequest.m
//  fengshun
//
//  Created by jiang deng on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSApiRequest.h"

@implementation FSApiRequest (User)

// 判断手机号是否存在-仅限普通用户
+ (NSMutableURLRequest *)checkUserWithPhoneNum:(NSString *)phoneNum;
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/checkUserByMobile", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 用户登录
+ (NSMutableURLRequest *)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/userLogin", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:@"COMMON" forKey:@"loginType"];
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    [parameters bm_setApiString:password forKey:@"password"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 获取短信验证码
+ (NSMutableURLRequest *)getVerificationCodeWithType:(FSVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/getSMSCode", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:[NSString stringWithFormat:@"%@", @(verificationCodeType)] forKey:@"codeType"];
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 用户注册
+ (NSMutableURLRequest *)registWithPhoneNum:(NSString *)phoneNum verificationCode:(NSString *)verificationCode password:(NSString *)password
{
    NSString *urlStr = [NSString stringWithFormat:@"%@storm/user/registerUser", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    [parameters bm_setApiString:verificationCode forKey:@"validateCode"];
    [parameters bm_setApiString:password forKey:@"password"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 重置密码/忘记密码
+ (NSMutableURLRequest *)resetUserPasswordWithPhoneNum:(NSString *)phoneNum newPassword:(NSString *)password verificationCode:(NSString *)verificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@storm/user/resetUserPassWord", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    [parameters bm_setApiString:password forKey:@"password"];
    [parameters bm_setApiString:verificationCode forKey:@"validateCode"];
    [parameters bm_setApiString:@"COMMON" forKey:@"userTypeEnum"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 查询用户基础信息
+ (NSMutableURLRequest *)getUserInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/searchUserBaseInfo", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}


// 刷新token
+ (NSMutableURLRequest *)updateUserToken:(NSString *)token
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/refreshToken", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:token forKey:@"refreshToken"];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

@end
