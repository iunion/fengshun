//
//  FSApiRequest.h
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "FSAPIMacros.h"
#import "XMRequestManager.h"

typedef NS_ENUM(NSUInteger, FSVerificationCodeType)
{
    FSVerificationCodeType_Unknown = 0,
    FSMVerificationCodeType_Register = 1,
    FSVerificationCodeType_ResetPassword = 2,
    FSVerificationCodeType_UpdatePhoneNum = 3
 };

NS_ASSUME_NONNULL_BEGIN

@interface FSApiRequest : NSObject

+ (NSString *)publicErrorMessageWithCode:(NSInteger)code;
+ (AFJSONRequestSerializer *)requestSerializer;

+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;
+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters isPost:(BOOL)isPost;

@end


@interface FSApiRequest (user)

// 判断手机号是否存在-仅限普通用户
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/checkMobileFlagUsingPOST
+ (nullable NSMutableURLRequest *)checkUserWithPhoneNum:(NSString *)phoneNum;

// 用户登录
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/userLoginUsingPOST
+ (nullable NSMutableURLRequest *)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password;

// 获取短信验证码
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/getSMSCodeUsingPOST
+ (nullable NSMutableURLRequest *)getVerificationCodeWithType:(FSVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum;

// 验证短信验证码是否正确
// http://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/checkSMSCodeFlagUsingPOST
+ (nullable NSMutableURLRequest *)checkVerificationCodeWithType:(FSVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum verificationCode:(NSString *)verificationCode;

// 用户注册
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/registerUserUsingPOST
+ (nullable NSMutableURLRequest *)registWithPhoneNum:(NSString *)phoneNum password:(NSString *)password verificationCode:(NSString *)verificationCode;

// 重置密码/忘记密码
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/resetUserPassWordUsingPOST
+ (nullable NSMutableURLRequest *)resetUserPasswordWithPhoneNum:(NSString *)phoneNum newPassword:(NSString *)password verificationCode:(NSString *)verificationCode;

// 查询用户基础信息
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/searchUserBaseInfoUsingPOST
+ (nullable NSMutableURLRequest *)getUserInfo;

// 用户退出登录
// http://123.206.193.140:8121/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/userLoginOutUsingPOST
+ (nullable NSMutableURLRequest *)userLogOut;


// 刷新token
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/refreshTokenUsingPOST
+ (nullable NSMutableURLRequest *)updateUserToken:(NSString *)token;



#pragma mark - 首页API

// 获取首页数据
// http://123.206.193.140:8121/swagger-ui.html#/%E9%A6%96%E9%A1%B5%E7%9B%B8%E5%85%B3/getAppHomeDataUsingPOST
+ (NSMutableURLRequest *)loadHomePageData;

// 获取是否有未读信息
// http://123.206.193.140:8121/swagger-ui.html#/%E9%A6%96%E9%A1%B5%E7%9B%B8%E5%85%B3/getMessageUnReadFlagUsingPOST
+ (XMRequest *)getMessageUnReadFlagSuccess:(nullable XMSuccessBlock)successBlock
                                   failure:(nullable XMFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
