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
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/checkMobileFlag", FS_URL_SERVER];
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

+ (NSString *)getVerificationType:(FSVerificationCodeType)verificationCodeType
{
    // 注册短信: SMS_REGISTER_USER_CODE
    // 找回密码: SMS_RESET_PASSWORD_CODE
    // 更新手机号码: SMS_UPDATE_MOBILEPHONE_CODE
    
    NSString *verificationType;
    switch (verificationCodeType)
    {
        case FSMVerificationCodeType_Register:
            verificationType = @"SMS_REGISTER_USER_CODE";
            break;
            
        case FSVerificationCodeType_ResetPassword:
            verificationType = @"SMS_RESET_PASSWORD_CODE";
            break;
            
        case FSVerificationCodeType_UpdatePhoneNumOld:
            verificationType = @"SMS_UPDATE_MOBILEPHONE_CODE";
            break;
            
        case FSVerificationCodeType_UpdatePhoneNumNew:
            verificationType = @"SMS_UPDATE_MOBILEPHONE_CODE";
            break;
            
        default:
            verificationType = @"SMS_REGISTER_USER_CODE";
            break;
    }
    
    return verificationType;
}

// 获取短信验证码
+ (NSMutableURLRequest *)getVerificationCodeWithType:(FSVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/getSMSCode", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    NSString *verificationType = [self getVerificationType:verificationCodeType];

    [parameters bm_setApiString:verificationType forKey:@"codeType"];
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 验证短信验证码是否正确
+ (NSMutableURLRequest *)checkVerificationCodeWithType:(FSVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum verificationCode:(NSString *)verificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/checkSMSCodeFlag", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    NSString *verificationType = [self getVerificationType:verificationCodeType];
    
    [parameters bm_setApiString:verificationType forKey:@"codeType"];
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    [parameters bm_setApiString:verificationCode forKey:@"validateCode"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 用户注册
+ (NSMutableURLRequest *)registWithPhoneNum:(NSString *)phoneNum password:(NSString *)password verificationCode:(NSString *)verificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/registerUser", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    [parameters bm_setApiString:verificationCode forKey:@"validateCode"];
    [parameters bm_setApiString:password forKey:@"password"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 重置密码/忘记密码
+ (NSMutableURLRequest *)resetUserPasswordWithPhoneNum:(NSString *)phoneNum newPassword:(NSString *)password verificationCode:(NSString *)verificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/resetUserPassWord", FS_URL_SERVER];
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

+ (NSMutableURLRequest *)userLogOut
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/userLoginOut", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 更新普通用户
+ (NSMutableURLRequest *)updateUserInfoWithOperaType:(FSUpdateUserInfoOperaType)operaType changeValue:(id)value
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/updateUserBaseInfo", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    switch (operaType)
    {
        case FSUpdateUserInfo_AvatarImageUrl:
            [parameters bm_setApiString:@"UPDATE_HEAD_PORTRAIT_URL" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"headPortraitUrl"];
            break;
            
        case FSUpdateUserInfo_NickName:
            [parameters bm_setApiString:@"UPDATE_NICK_NAME" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"nickName"];
            break;
            
        case FSUpdateUserInfo_RealName:
            [parameters bm_setApiString:@"UPDATE_REAL_NAME" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"userName"];
            break;
            
        case FSUpdateUserInfo_Organization:
            [parameters bm_setApiString:@"UPDATE_WORK_ORGANIZATION" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"workOrganization"];
            break;
            
        case FSUpdateUserInfo_Job:
            [parameters bm_setApiString:@"UPDATE_JOB" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"job"];
            break;
            
        case FSUpdateUserInfo_WorkTime:
            [parameters bm_setApiString:@"UPDATE_EMPLOYMENT_TIME" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"employmentTime"];
            break;
            
        case FSUpdateUserInfo_Ability:
            [parameters bm_setApiString:@"UPDATE_ABILITY" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"ability"];
            break;
            
        case FSUpdateUserInfo_Signature:
            [parameters bm_setApiString:@"UPDATE_PERSONALITY_SIGNATURE" forKey:@"operaEnum"];
            [parameters bm_setApiString:value forKey:@"personalitySignature"];
            break;
            
        default:
            break;
    }
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 修改手机号码
+ (NSMutableURLRequest *)changeMobilePhoneWithOldPhoneNum:(NSString *)oldPhoneNum oldVerificationCode:(NSString *)oldVerificationCode newPhoneNum:(NSString *)newPhoneNum newVerificationCode:(NSString *)newVerificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/updateMobilePhone", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:oldPhoneNum forKey:@"oldMobilePhone"];
    [parameters bm_setApiString:oldVerificationCode forKey:@"oldValidateCode"];
    
    [parameters bm_setApiString:newPhoneNum forKey:@"newMobilePhone"];
    [parameters bm_setApiString:newVerificationCode forKey:@"newValidateCode"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 修改密码
+ (NSMutableURLRequest *)changeUserPasswordWithPhoneNum:(NSString *)phoneNum newPassword:(NSString *)password verificationCode:(NSString *)verificationCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/updatePassword", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:phoneNum forKey:@"mobilePhone"];
    [parameters bm_setApiString:password forKey:@"newPassword"];
    [parameters bm_setApiString:verificationCode forKey:@"validateCode"];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 实名认证
+ (NSMutableURLRequest *)authenticationWithId:(NSString *)idCard name:(NSString *)name
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/user/setRealNameAuthentication", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:idCard forKey:@"idCard"];
    [parameters bm_setApiString:name forKey:@"userName"];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 联系客服
// http://115.159.33.190:8121/swagger-ui.html#/%E6%88%91%E7%9A%84%E7%9B%B8%E5%85%B3/getCustomerServiceUsingPOST
+ (NSMutableURLRequest *)getCustomerService
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/personal/getCustomerService", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 我的收藏
+ (NSMutableURLRequest *)getMyCollections
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/personal/getMyCollections", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 我的评论
+ (NSMutableURLRequest *)getMyComments
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/personal/etMyComments", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 我的帖子
+ (NSMutableURLRequest *)getMyTopic
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/personal/getMyPosts", FS_URL_SERVER];
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
