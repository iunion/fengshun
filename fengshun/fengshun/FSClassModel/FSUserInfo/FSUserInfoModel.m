//
//  FSUserInfoModel.m
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#define USERINFO_USERID_KEY                 @"userinfo_userid_key"
#define USERINFO_USERTOKEN_KEY              @"userinfo_usertoken_key"
#define USERINFO_MOBILE_KEY                 @"userinfo_mobile_key"

#import "FSUserInfoModel.h"
#import "AppDelegate.h"
#import "FSUserInfoDB.h"

@interface FSUserBaseInfoModel ()

@property (nullable, nonatomic, strong) NSMutableArray *m_AbilityArray;

@end

@implementation FSUserBaseInfoModel

+ (instancetype)userBaseInfoWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *userId = [dic bm_stringTrimForKey:@"userId"];
    if (![userId bm_isNotEmpty])
    {
        return nil;
    }
    
    FSUserBaseInfoModel *userBaseInfo = [[FSUserBaseInfoModel alloc] init];
    [userBaseInfo updateWithServerDic:dic];
    
    if ([userBaseInfo.m_UserId bm_isNotEmpty])
    {
        return userBaseInfo;
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
        _m_UserId = [FSUserInfoModel getCurrentUserId];
    }

    return self;
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    
    // 🔐用户ID💡: userId
    NSString *userId = [dic bm_stringTrimForKey:@"userId"];
    if (![userId bm_isNotEmpty])
    {
        return;
    }
    self.m_UserId = userId;

    // 🔐真实姓名: userName
    self.m_RealName = [dic bm_stringTrimForKey:@"userName"];
    // 用户登录类型: userType
    // 普通用户:COMMON, 工作人员:STAFF, 默认设置-普通用户
    self.m_UserType = [dic bm_stringTrimForKey:@"userType" withDefault:@"COMMON"];
    
    // 🔐用户手机号码: mobilePhone
    self.m_PhoneNum = [dic bm_stringTrimForKey:@"mobilePhone"];
    // 🔐身份证号: idCard
    self.m_IdCardNo = [dic bm_stringTrimForKey:@"idCard"];
    // 🔐邮箱: email
    if ([dic bm_containsObjectForKey:@"email"])
    {
        self.m_Email = [dic bm_stringTrimForKey:@"email"];
    }
    // 昵称: nickName
    self.m_NickName = [dic bm_stringTrimForKey:@"nickName"];
    // 性别: sex
    self.m_Sex = [dic bm_stringTrimForKey:@"sex"];
    // 头像地址: headPortraitUrl
    self.m_AvatarUrl = [dic bm_stringTrimForKey:@"headPortraitUrl"];
    
    // 人脸识别: isFacialVerify
    self.m_IsFacialVerify = [dic bm_boolForKey:@"isFacialVerify"];
    // 实名认证: isRealName
    self.m_IsRealName = [dic bm_boolForKey:@"isRealName"];
    if (![self.m_RealName bm_isNotEmpty])
    {
        self.m_IsRealName = NO;
    }
    if (!self.m_IsRealName)
    {
        self.m_RealName = nil;
    }

    // 身份认证: isIdAuth
    self.m_IsIdAuth = [dic bm_boolForKey:@"isIdAuth"];
    // 职位: job
    self.m_Job = [dic bm_stringTrimForKey:@"job"];
    if (![self.m_Job bm_isNotEmpty])
    {
        self.m_IsIdAuth = NO;
    }
    if (!self.m_IsIdAuth)
    {
        self.m_Job = nil;
    }


#pragma mark searchUserBaseInfo

    // 生日: birthTime
    if ([dic bm_containsObjectForKey:@"birthTime"])
    {
        NSString *birthDayStr = [dic bm_stringTrimForKey:@"birthTime"];
        NSDate *birthday = [NSDate bm_dateFromString:birthDayStr withFormat:@"yyyy-MM-dd"];
        
        self.m_Birthday = [birthday timeIntervalSince1970];
    }

    // 擅长领域: ability ','分割成数组
    if ([dic bm_containsObjectForKey:@"ability"])
    {
        NSString *ability = [dic bm_stringTrimForKey:@"ability"];
        self.m_Ability = ability;
    }
    
    // 从业时间: employmentTime
    if ([dic bm_containsObjectForKey:@"employmentTime"])
    {
        self.m_EmploymentTime = [dic bm_uintForKey:@"employmentTime"];
    }
    
    // 个人签名: personalitySignature
    if ([dic bm_containsObjectForKey:@"personalitySignature"])
    {
        self.m_Signature = [dic bm_stringTrimForKey:@"personalitySignature"];
    }

    // 工作机构: workOrganization
    // 工作机构(单位名称): workOrganization
    if ([dic bm_containsObjectForKey:@"workOrganization"])
    {
        self.m_Organization = [dic bm_stringTrimForKey:@"workOrganization"];
    }
    
    // 工作单位地址区域: workLocation
    if ([dic bm_containsObjectForKey:@"workLocation"])
    {
        self.m_CompanyArea = [dic bm_stringTrimForKey:@"workLocation"];
    }
    
    // 工作单位地址: workAddress
    if ([dic bm_containsObjectForKey:@"workAddress"])
    {
        self.m_CompanyAddress = [dic bm_stringTrimForKey:@"workAddress"];
    }
    
    // 工作单位区域信息: workspace
    if ([dic bm_containsObjectForKey:@"workspace"])
    {
        self.m_WorkArea = [dic bm_stringTrimForKey:@"workspace"];
    }
    
    // 工作年限: workingLife
    if ([dic bm_containsObjectForKey:@"workingLife"])
    {
        self.m_WorkingLife = [dic bm_uintForKey:@"workingLife"];
    }
    
    // 工作证明url: workProofUrl
    if ([dic bm_containsObjectForKey:@"workProofUrl"])
    {
        self.m_WorkProofUrl = [dic bm_stringTrimForKey:@"workProofUrl"];
    }

    // 专业职务: jobInfo
    if ([dic bm_containsObjectForKey:@"jobInfo"])
    {
        self.m_ProfessionalQualification = [dic bm_stringTrimForKey:@"jobInfo"];
    }
 
    // 工作经历: workExperience
    if ([dic bm_containsObjectForKey:@"workExperience"])
    {
        self.m_WorkExperience = [dic bm_stringTrimForKey:@"workExperience"];
    }
}

- (void)setM_Ability:(NSString *)ability
{
    if ([ability bm_isNotEmpty])
    {
        if ([[ability substringFromIndex:ability.length-1] isEqualToString:@","])
        {
            ability = [ability substringToIndex:ability.length-1];
        }
    }
    _m_Ability = ability;
    
    NSArray *array = [ability componentsSeparatedByString:@","];
    self.m_AbilityArray = [NSMutableArray arrayWithArray:array];
}

- (void)setM_ProfessionalQualification:(NSString *)professionalQualification
{
    if ([professionalQualification bm_isNotEmpty])
    {
        if ([[professionalQualification substringFromIndex:professionalQualification.length-1] isEqualToString:@","])
        {
            professionalQualification = [professionalQualification substringToIndex:professionalQualification.length-1];
        }
    }
    _m_ProfessionalQualification = professionalQualification;
    
    NSArray *array = [professionalQualification componentsSeparatedByString:@","];
    self.m_ProfessionalArray = [NSMutableArray arrayWithArray:array];
#warning Test
//    self.m_ProfessionalArray = [NSMutableArray arrayWithCapacity:0];
//    [self.m_ProfessionalArray addObject:@"氧气吐司"];
//    [self.m_ProfessionalArray addObject:@"小酥饼"];
}


@end


#pragma mark - FSUserInfoModel

@implementation FSUserInfoModel

+ (FSUserInfoModel *)userInfo
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
    return [FSUserInfoModel userInfoWithServerDic:dic isUpDateByUserInfoApi:YES];
}

+ (instancetype)userInfoWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    if (!userInfoApi)
    {
        NSString *token = [dic bm_stringTrimForKey:@"authToken"];
        if (![token bm_isNotEmpty])
        {
            return nil;
        }
    }

    FSUserInfoModel *userInfo = [[FSUserInfoModel alloc] init];
    [userInfo updateWithServerDic:dic isUpDateByUserInfoApi:userInfoApi];
    
    if ([userInfo.m_Token bm_isNotEmpty] && [userInfo.m_UserBaseInfo.m_UserId bm_isNotEmpty])
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
        
        _m_Token = [FSUserInfoModel getCurrentUserToken];
        
        _m_UserBaseInfo = [[FSUserBaseInfoModel alloc] init];
    }
    
    return self;
}

- (void)updateWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }

    NSDictionary *userBaseDic = dic;

    if (!userInfoApi)
    {
        // 🔐用户令牌token(登录注册)💡: token
        NSString *token = [dic bm_stringTrimForKey:@"authToken"];
        if (![token bm_isNotEmpty])
        {
            return;
        }
    
        // 🔐用户刷新令牌💡: refreshToken
        NSString *refreshToken = [dic bm_stringTrimForKey:@"refreshToken"];
//        if (![refreshToken bm_isNotEmpty])
//        {
//            return;
//        }

        self.m_Token = token;
        self.m_RefreshToken = refreshToken;

        userBaseDic = [dic bm_dictionaryForKey:@"loginInfo"];
        if ([userBaseDic bm_isNotEmptyDictionary])
        {
            userBaseDic = [userBaseDic bm_dictionaryForKey:@"userInfo"];
        }
    }
    
    if (![userBaseDic bm_isNotEmptyDictionary])
    {
        return;
    }

    //self.m_UserBaseInfo = [FSUserBaseInfoModel userBaseInfoWithServerDic:userBaseDic];
    [self.m_UserBaseInfo updateWithServerDic:userBaseDic];
    
    // 最后更新时间
    self.m_LastUpdateTs = [[NSDate date] timeIntervalSince1970];
}

+ (BOOL)isLogin
{
    FSUserInfoModel *currentUser = GetAppDelegate.m_UserInfo;
    if ([currentUser.m_Token bm_isNotEmpty] && [currentUser.m_UserBaseInfo.m_UserId bm_isNotEmpty] && [currentUser.m_UserBaseInfo.m_PhoneNum bm_isNotEmpty])
    {
        return YES;
    }
    
    return NO;
}

+ (void)logOut
{
    [FSUserInfoModel setCurrentUserID:nil];
    [FSUserInfoModel setCurrentUserToken:nil];
    GetAppDelegate.m_UserInfo = nil;
}

// 实名认证
+ (BOOL)isCertification
{
    if ([self isLogin])
    {
        FSUserInfoModel *currentUser = GetAppDelegate.m_UserInfo;
        if (currentUser.m_UserBaseInfo.m_IsRealName)
        {
            return YES;
        }
    }
    
    return NO;
}


@end
