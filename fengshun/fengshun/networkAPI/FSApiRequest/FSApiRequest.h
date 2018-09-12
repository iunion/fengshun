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
    FSVerificationCodeType_Unknown              = 0,
    FSMVerificationCodeType_Register            = 1,
    FSVerificationCodeType_ResetPassword        = 2,
    FSVerificationCodeType_UpdatePhoneNumOld    = 3,
    FSVerificationCodeType_UpdatePhoneNumNew    = 4
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

/**
 排序方式
 
 - FSTopicSortTypeNewReply: 最新回复
 - FSTopicSortTypeNewPulish: 最新发布
 - FSTopicSortTypeHot: 热门
 - FSTopicSortTypeEssence: 精华
 */
typedef NS_ENUM(NSUInteger, FSTopicSortType) {
    FSTopicSortTypeNewReply,   //最新回复
    FSTopicSortTypeNewPulish,  //最新发布
    FSTopicSortTypeHot,        //热门
    FSTopicSortTypeEssence     //精华
};

typedef NS_ENUM(NSUInteger, FSForumFollowState) {
    
    FSForumFollowState_Cancel_FOLLOW = 0, // 取关
    FSForumFollowState_Follow         //关注
};

NS_ASSUME_NONNULL_BEGIN

@interface FSApiRequest : NSObject

+ (NSString *)publicErrorMessageWithCode:(NSInteger)code;
+ (AFJSONRequestSerializer *)requestSerializer;

+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;
+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters isPost:(BOOL)isPost;

// 通过最顶级字典code，一次性查出来所有的子集数据
// http://115.159.33.190:8121/swagger-ui.html#/%E5%AD%97%E5%85%B8/searchDictionaryInfoByTopLevelCodeUsingPOST
+ (nullable NSMutableURLRequest *)getDictionaryInfoWithLevelCode:(NSString *)levelCode;

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

// 获取案例检索的热词
// http://122.112.248.222:13000/swagger-ui.html#!/391183584329702390348212821226696203632562832034/casesHotKeywordsUsingGET
+ (XMRequest *)getCaseSearchHotkeysSuccess:(nullable XMSuccessBlock)successBlock
                                   failure:(nullable XMFailureBlock)failureBlock;

// 案例检索
// http://122.112.248.222:13000/swagger-ui.html#!/391183584329702390348212821226696203632562832034/searchCasesUsingPOST
+(NSMutableURLRequest *)searchCaseWithKeywords:(NSArray *)keywords start:(NSUInteger)startLocation size:(NSUInteger)size filters:(NSArray *)filters;

// 获取法规检索的法规专题
// http://122.112.248.222:13000/swagger-ui.html#!/391183584329702390348212821227861352682562832034/casesHotKeywordsUsingGET_1
+ (XMRequest *)getLawTopicSuccess:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;

// 法规检索
// http://122.112.248.222:13000/swagger-ui.html#!/391183584329702390348212821227861352682562832034/searchLawsUsingPOST
+(NSMutableURLRequest *)searchLawsWithKeywords:(NSArray *)keywords start:(NSUInteger)startLocation size:(NSUInteger)size filters:(NSArray *)filters;

// 文书范本Index页数据
// http://115.159.33.190:8121/swagger-ui.html#/%E6%96%87%E4%B9%A6%E8%8C%83%E6%9C%AC/getDocumentHomeUsingPOST
+ (XMRequest *)loadTextIndexPageDataSuccess:(nullable XMSuccessBlock)successBlock
                                    failure:(nullable XMFailureBlock)failureBlock;

// 文书列表
// http://115.159.33.190:8121/swagger-ui.html#/%E6%96%87%E4%B9%A6%E8%8C%83%E6%9C%AC/getDocumentListUsingPOST
+ (NSMutableURLRequest *)loadTextListyWithType:(NSString *)typeName andTypeCode:(NSString *)typeCode;

@end

#pragma mark - 社区模块

@interface FSApiRequest (Community)

// 获取推荐帖子列表
// http://123.206.193.140:8121/swagger-ui.html#/%E7%A4%BE%E5%8C%BA%E9%A6%96%E9%A1%B5/recommendListUsingPOST
+ (nullable NSMutableURLRequest *)getPlateRecommendPostListWithPageIndex:(NSInteger)pageIndex
                                                                pageSize:(NSInteger)pageSize;
// 获取板块列表列表
// http://123.206.193.140:8121/swagger-ui.html#/%E7%A4%BE%E5%8C%BA%E9%A6%96%E9%A1%B5/recommendListUsingPOST
+ (nullable NSMutableURLRequest *)getForumListWithPageIndex:(NSInteger)pageIndex
                                                   pageSize:(NSInteger)pageSize;


// 获取二级页面header信息
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/twoLevelFourmInfoUsingPOST
+ (XMRequest *)getTwoLevelFourmInfoWithId:(NSInteger)topicId
                                  success:(nullable XMSuccessBlock)successBlock
                                  failure:(nullable XMFailureBlock)failureBlock;

// 获取二级列表：最新回复、最新发帖、热门、精华
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/newReplyListUsingPOST
+ (nullable NSMutableURLRequest *)getTopicListWithType:(NSString *)type
                                               forumId:(NSInteger)forumId
                                             pageIndex:(NSInteger)pageIndex
                                              pageSize:(NSInteger)pageSize;

// 关注板块/取消关注
// http://123.206.193.140:8121/swagger-ui.html#/operations/社区首页/followOrUnFollowUsingPOST
+ (XMRequest *)updateFourmAttentionStateWithFourmId:(NSInteger )fourmId
                                       followStatus:(FSForumFollowState )followStatus
                                            success:(nullable XMSuccessBlock)successBlock
                                            failure:(nullable XMFailureBlock)failureBlock;

#pragma mark - 帖子相关
// 发帖编辑帖子
// http://123.206.193.140:8121/swagger-ui.html#/operations/帖子信息/addPostUsingPOST
// http://123.206.193.140:8121/swagger-ui.html#/operations/帖子信息/editPostUsingPOST
+ (XMRequest *)sendPostsWithTitle:(NSString *)title
                          content:(NSString *)content
                          forumId:(NSInteger)forumId
                         isEdited:(BOOL)isEdited
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
