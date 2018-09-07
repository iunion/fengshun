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

typedef NS_ENUM(NSUInteger, FSVerificationCodeType) {
    FSVerificationCodeType_Unknown        = 0,
    FSMVerificationCodeType_Register      = 1,
    FSVerificationCodeType_ResetPassword  = 2,
    FSVerificationCodeType_UpdatePhoneNum = 3
};

typedef NS_ENUM(NSUInteger, FSUpdateUserInfoOperaType) {
    FSUpdateUserInfo_AvatarImageUrl = 0,
    FSUpdateUserInfo_NickName,
    FSUpdateUserInfo_RealName,
    FSUpdateUserInfo_Organization,
    FSUpdateUserInfo_Job,
    FSUpdateUserInfo_WorkTime,
    FSUpdateUserInfo_Ability,
    FSUpdateUserInfo_Signature
};

typedef NS_ENUM(NSUInteger, FSCommunityDetailListType) {
    FSCommunityDetailListType_NewReply,   //最新回复
    FSCommunityDetailListType_NewPulish,  //最新发帖
    FSCommunityDetailListType_Hot,        //热门
    FSCommunityDetailListType_Essence     //精华
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

// 修改手机号码
// http://123.206.193.140:8121/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/updateMobilePhoneUsingPOST
+ (nullable NSMutableURLRequest *)changeMobilePhoneWithOldPhoneNum:(NSString *)oldPhoneNum oldVerificationCode:(NSString *)oldVerificationCode newPhoneNum:(NSString *)newPhoneNum newVerificationCode:(NSString *)newVerificationCode;

// 修改密码
// http://123.206.193.140:8121/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/updatePasswordUsingPOST
+ (nullable NSMutableURLRequest *)changeUserPasswordWithPhoneNum:(NSString *)phoneNum newPassword:(NSString *)password verificationCode:(NSString *)verificationCode;

// 实名认证
// http://123.206.193.140:8121/swagger-ui.html#/%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/setRealNameAuthenticationUsingPOST
+ (nullable NSMutableURLRequest *)authenticationWithId:(NSString *)idCard name:(NSString *)name;


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


// 获取推荐帖子列表
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/recommendListUsingPOST
+ (XMRequest *)getPlateRecommendPostListWithPageIndex:(NSInteger)pageIndex
                                             pageSize:(NSInteger)pageSize
                                              success:(nullable XMSuccessBlock)successBlock
                                              failure:(nullable XMFailureBlock)failureBlock;

// 获取板块列表
//http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/fourmListUsingPOST
+ (XMRequest *)getPlateListWithPageIndex:(NSInteger)pageIndex
                                pageSize:(NSInteger)pageSize
                                 success:(nullable XMSuccessBlock)successBlock
                                 failure:(nullable XMFailureBlock)failureBlock;
// 发帖编辑帖子
// http://123.206.193.140:8121/swagger-ui.html#/operations/帖子信息/addPostUsingPOST
// http://123.206.193.140:8121/swagger-ui.html#/operations/帖子信息/editPostUsingPOST
+ (XMRequest *)sendPostsWithTitle:(NSString *)title
                          content:(NSString *)content
                          forumId:(NSInteger)forumId
                         isEdited:(BOOL )isEdited
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;

// 获取二级页面header信息
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/twoLevelFourmInfoUsingPOST
+ (XMRequest *)getTwoLevelFourmInfoWithId:(NSInteger)topicId
                                  success:(nullable XMSuccessBlock)successBlock
                                  failure:(nullable XMFailureBlock)failureBlock;

// 获取二级列表：最新回复、最新发帖、热门、精华
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/newReplyListUsingPOST
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/newPublishListUsingPOST
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/hotListUsingPOST
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/essenceListUsingPOST
+ (XMRequest *)getTwoLevelFourmListWithListType:(FSCommunityDetailListType)type
                                      topicIdId:(NSInteger)topicId
                                      PageIndex:(NSInteger)pageIndex
                                       pageSize:(NSInteger)pageSize
                                        success:(nullable XMSuccessBlock)successBlock
                                        failure:(nullable XMFailureBlock)failureBlock;

// 关注板块/取消关注
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/followOrUnFollowUsingPOST
+ (XMRequest *)updateFourmAttentionStateWithFourmId:(NSInteger )fourmId
                                            success:(nullable XMSuccessBlock)successBlock
                                            failure:(nullable XMFailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
