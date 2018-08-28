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

@interface FSUserInfoModle : NSObject

// 最后更新时间
@property (nonatomic, assign) NSTimeInterval m_LastUpdateTs;

// 用户令牌(登录注册)💡: token
@property (nonatomic, strong) NSString *m_Token;
// 🔐用户ID💡: custId
@property (nonatomic, strong) NSString *m_UserId;


// 🔐用户手机号码: mobile
@property (nonatomic, strong) NSString *m_PhoneNum;
// 昵称: nickName
@property (nullable, nonatomic, strong) NSString *m_NickName;
// 🔐真实姓名: userName
@property (nullable, nonatomic, strong) NSString *m_RealName;
// 🔐身份证号: idCard
@property (nullable, nonatomic, strong) NSString *m_IdCardNo;
// 用户等级: custLevel
@property (nonatomic, strong) NSString *m_UserLevel;


// 用户登录ID
+ (NSString *)getCurrentUserId;
+ (void)setCurrentUserID:(NSString *)userID;

// 用户登录token
+ (NSString *)getCurrentUserToken;
+ (void)setCurrentUserToken:(NSString *)userToken;

// 通过服务器Dic初始化
+ (instancetype)userInfoWithServerDic:(NSDictionary *)dic;
+ (instancetype)userInfoWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoAp;

- (void)updateWithServerDic:(NSDictionary *)dic isUpDateByUserInfoApi:(BOOL)userInfoApi;

@end

NS_ASSUME_NONNULL_END

