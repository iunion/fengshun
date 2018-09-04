//
//  FSUserInfoModle.h
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 💡: 不能为nil，用于数据完整性判断
// 🔐: 需要加密存储数据

@interface FSUserBaseInfoModle : NSObject

// 🔐用户ID💡: userId
@property (nonatomic, strong) NSString *m_UserId;
// 🔐真实姓名: userName
@property (nullable, nonatomic, strong) NSString *m_RealName;
// 用户登录类型: userType
// 普通用户:COMMON, 工作人员:STAFF, 默认设置-普通用户
@property (nonatomic, strong) NSString *m_UserType;

// 🔐用户手机号码: mobilePhone
@property (nonatomic, strong) NSString *m_PhoneNum;
// 🔐身份证号: idCard
@property (nullable, nonatomic, strong) NSString *m_IdCardNo;
// 🔐邮箱: email
//@property (nullable, nonatomic, strong) NSString *m_Email;
// 昵称: nickName
@property (nullable, nonatomic, strong) NSString *m_NickName;
// 性别: sex
@property (nullable, nonatomic, strong) NSString *m_Sex;
// 头像地址: headPortraitUrl
@property (nullable, nonatomic, strong) NSString *m_AvatarUrl;

// 人脸识别: isFacialVerify
@property (nonatomic, assign) BOOL m_IsFacialVerify;
// 实名认证: isRealName
@property (nonatomic, assign) BOOL m_IsRealName;

+ (instancetype)userBaseInfoWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end

@interface FSUserRoleModle : NSObject

// 用户身份: roleName
@property (nullable, nonatomic, strong) NSString *m_Role;
// 用户身份编码: roleCode
@property (nullable, nonatomic, strong) NSString *m_RoleCode;

+ (instancetype)userRoleWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end

@interface FSUserInfoModle : NSObject

// 最后更新时间
@property (nonatomic, assign) NSTimeInterval m_LastUpdateTs;

// 🔐用户令牌token(登录注册)💡: authToken
@property (nonatomic, strong) NSString *m_Token;
// 🔐用户刷新令牌💡: refreshToken
@property (nonatomic, strong) NSString *m_RefreshToken;

@property (nonatomic, strong) FSUserBaseInfoModle *m_UserBaseInfo;

@property (nonatomic, strong) FSUserRoleModle *m_UserRole;

+ (FSUserInfoModle *)userInfo;

// 用户登录ID
+ (nullable NSString *)getCurrentUserId;
+ (void)setCurrentUserID:(nullable NSString *)userID;

// 用户登录token
+ (nullable NSString *)getCurrentUserToken;
+ (void)setCurrentUserToken:(nullable NSString *)userToken;

// 通过服务器Dic初始化
+ (instancetype)userInfoWithServerDic:(NSDictionary *)dic;
+ (instancetype)userInfoWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi;

- (void)updateWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi;

+ (BOOL)isLogin;
+ (void)logOut;

@end

NS_ASSUME_NONNULL_END

