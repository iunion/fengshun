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

typedef NS_ENUM(NSUInteger, FSUpdateUserInfoOperaType)
{
    FSUpdateUserInfo_AvatarImageUrl = 0,
    FSUpdateUserInfo_NickName,
    FSUpdateUserInfo_RealName,
    FSUpdateUserInfo_Organization,
    FSUpdateUserInfo_Job,
    FSUpdateUserInfo_WorkTime,
    FSUpdateUserInfo_Ability,
    FSUpdateUserInfo_Signature
};

NS_ASSUME_NONNULL_BEGIN

@interface FSApiRequest : NSObject

+ (NSString *)publicErrorMessageWithCode:(NSInteger)code;
+ (AFJSONRequestSerializer *)requestSerializer;

+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;
+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters isPost:(BOOL)isPost;

@end


#pragma mark - 用户相关

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

// 更新普通用户
// http://123.206.193.140:8121/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/updateUserBaseInfoUsingPOST
+ (nullable NSMutableURLRequest *)updateUserInfoWithOperaType:(FSUpdateUserInfoOperaType)operaType changeValue:(id)value;


// 刷新token
// https://devftls.odrcloud.net/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/refreshTokenUsingPOST
+ (nullable NSMutableURLRequest *)updateUserToken:(NSString *)token;

@end


#pragma mark - 首页API

@interface FSApiRequest (HomePage)

// 获取首页数据
// http://123.206.193.140:8121/swagger-ui.html#/%E9%A6%96%E9%A1%B5%E7%9B%B8%E5%85%B3/getAppHomeDataUsingPOST
+ (NSMutableURLRequest *)loadHomePageData;

// 获取是否有未读信息
// http://123.206.193.140:8121/swagger-ui.html#/%E9%A6%96%E9%A1%B5%E7%9B%B8%E5%85%B3/getMessageUnReadFlagUsingPOST
+ (XMRequest *)getMessageUnReadFlagSuccess:(nullable XMSuccessBlock)successBlock
                                   failure:(nullable XMFailureBlock)failureBlock;
+ (XMRequest *)getCaseSearchHotkeysSuccess:(nullable XMSuccessBlock)successBlock
                                   failure:(nullable XMFailureBlock)failureBlock;

@end

#pragma mark - 社区模块

@interface FSApiRequest (Community)


/**
 获取板块推荐列表
 
 @return XMRequest
 */

+ (XMRequest *)getPlateRecommendPostListWithPageIndex:(NSInteger)pageIndex
                                             pageSize:(NSInteger)pageSize
                                              success:(nullable XMSuccessBlock)successBlock
                                              failure:(nullable XMFailureBlock)failureBlock;

/**
 获取板块列表
 
 @return XMRequest
 */

+ (XMRequest *)getPlateListWithPageIndex:(NSInteger)pageIndex
                                pageSize:(NSInteger)pageSize
                                 success:(nullable XMSuccessBlock)successBlock
                                 failure:(nullable XMFailureBlock)failureBlock;
/**
 编辑帖子
 
 @param title 标题
 @param content 内容
 @param postId 帖子Id
 @return XMRequest
 */
+ (XMRequest *)editPostsWithTitle:(NSString *)title
                          content:(NSString *)content
                           postId:(NSInteger)postId
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;
/**
 发帖
 
 @param title 标题
 @param content 内容
 @param forumId 版块ID
 @return XMRequest
 */
+ (XMRequest *)sendPostsWithTitle:(NSString *)title
                          content:(NSString *)content
                          forumId:(NSInteger)forumId
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;
/**
 帖子评论列表
 
 @param detailId 帖子ID/课程ID
 @param maxId 上次请求返回中的maxId，最大的Id
 @param pageSize 每页的数量
 @return XMRequest
 */
+ (XMRequest *)getPostCommentListWithDetailId:(NSInteger)detailId
                                        maxId:(NSInteger)maxId
                                     pageSize:(NSInteger)pageSize
                                      success:(nullable XMSuccessBlock)successBlock
                                      failure:(nullable XMFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
