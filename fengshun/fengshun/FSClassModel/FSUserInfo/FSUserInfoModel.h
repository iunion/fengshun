//
//  FSUserInfoModel.h
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 💡: 不能为nil，用于数据完整性判断
// 🔐: 需要加密存储数据

@interface FSUserBaseInfoModel : NSObject

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
@property (nullable, nonatomic, strong) NSString *m_Email;
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

// 身份认证: isIdAuth
@property (nonatomic, assign) BOOL m_IsIdAuth;
// 职位: job
@property (nullable, nonatomic, strong) NSString *m_Job;


#pragma mark - searchUserBaseInfo

// 生日: birthTime “2018-10-1”
@property (nonatomic, assign) NSTimeInterval m_Birthday;

// 擅长领域: ability ','分割成数组
@property (nullable, nonatomic, strong) NSString *m_Ability;
@property (nullable, nonatomic, strong, readonly) NSMutableArray *m_AbilityArray;
// 从业时间: employmentTime
@property (nonatomic, assign) NSUInteger m_EmploymentTime;
// 个人签名: personalitySignature
@property (nullable, nonatomic, strong) NSString *m_Signature;
// 工作机构(单位名称): workOrganization
@property (nullable, nonatomic, strong) NSString *m_Organization;
// 工作单位地址区域: workLocation
@property (nullable, nonatomic, strong) NSString *m_CompanyArea;
// 工作单位地址: workAddress
@property (nullable, nonatomic, strong) NSString *m_CompanyAddress;
// 工作单位服务区域信息: workspace
@property (nullable, nonatomic, strong) NSString *m_WorkArea;
// 工作年限: workingLife
@property (nonatomic, assign) NSUInteger m_WorkingLife;
// 工作证明url: workProofUrl
@property (nullable, nonatomic, strong) NSString *m_WorkProofUrl;
// 专业职务: jobInfo
@property (nullable, nonatomic, strong) NSString *m_ProfessionalQualification;
@property (nullable, nonatomic, strong) NSMutableArray <NSString *> *m_ProfessionalArray;
// 工作经历: workExperience
@property (nullable, nonatomic, strong) NSString *m_WorkExperience;

+ (nullable instancetype)userBaseInfoWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end

@interface FSUserInfoModel : NSObject

// 最后更新时间
@property (nonatomic, assign) NSTimeInterval m_LastUpdateTs;

// 🔐用户令牌token(登录注册)💡: authToken
@property (nonatomic, strong) NSString *m_Token;
// 🔐用户刷新令牌💡: refreshToken
@property (nonatomic, strong) NSString *m_RefreshToken;

@property (nonatomic, strong) FSUserBaseInfoModel *m_UserBaseInfo;

+ (FSUserInfoModel *)userInfo;

// 用户登录ID
+ (nullable NSString *)getCurrentUserId;
+ (void)setCurrentUserID:(nullable NSString *)userID;

// 用户登录token
+ (nullable NSString *)getCurrentUserToken;
+ (void)setCurrentUserToken:(nullable NSString *)userToken;

// 通过服务器Dic初始化
+ (nullable instancetype)userInfoWithServerDic:(NSDictionary *)dic;
+ (nullable instancetype)userInfoWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi;

- (void)updateWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi;

+ (BOOL)isLogin;
+ (void)logOut;

// 实名认证
+ (BOOL)isCertification;

@end

NS_ASSUME_NONNULL_END

