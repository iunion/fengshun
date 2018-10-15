//
//  FSApiRequest.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSApiRequest.h"
#import "FSAppInfo.h"
#import "UIDevice+BMCategory.h"
#import "FSLocation.h"
#import "FSCoreStatus.h"
#import "FSUserInfo.h"

@implementation FSApiRequest

+ (NSString *)publicErrorMessageWithCode:(NSInteger)code
{
    NSString *errorMessage;
    switch (code)
    {
        case 9999:
            errorMessage = @"服务器内部异常";
            break;
        case 1001:
            errorMessage = @"用户未登录";
            break;
        case 1002:
            errorMessage = @"认证令牌失效";
            break;
        case 1003:
            errorMessage = @"非法参数";
            break;
        case 1004:
            errorMessage = @"权限不足";
            break;
        case 1005:
            errorMessage = @"结果为空";
            break;
        case 1006:
            errorMessage = @"操作数据库失败";
            break;
        case 136001:
            errorMessage = @"您已举报过该内容，系统将尽快处理。";
            break;
        case FSAPI_NET_ERRORCODE:
            if ([FSCoreStatus currentNetWorkStatus] == FSCoreNetWorkStatusNone)
            {
                errorMessage = @"网络错误，请稍后再试";
            }
            else
            {
                errorMessage = @"服务器繁忙，请稍后再试";
            }
            break;
            
        case FSAPI_DATA_ERRORCODE:
        case FSAPI_JSON_ERRORCODE:
            errorMessage = @"数据错误，请稍后再试";
            break;

        default:
            errorMessage = @"其他错误";
            break;
    }
    return errorMessage;
}

// deviceId     设备号
// deviceModel  设备型号
// osVersion    系统版本号
// cType        设备系统类型
// appVersion   app版本

// JWTToken
// timer        当前时间戳
+ (AFJSONRequestSerializer *)requestSerializer
{
    static AFJSONRequestSerializer *FSRequestSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FSRequestSerializer = [AFJSONRequestSerializer serializer];
        FSRequestSerializer.timeoutInterval = FSAPI_TIMEOUT_SECONDS;
        // 设备号
        [FSRequestSerializer setValue:[FSAppInfo getOpenUDID] forHTTPHeaderField:@"deviceId"];
        // 设备型号
        [FSRequestSerializer setValue:[UIDevice bm_devicePlatformString] forHTTPHeaderField:@"deviceModel"];
        // 设备系统类型
        [FSRequestSerializer setValue:@"IOS" forHTTPHeaderField:@"cType"];
        // 系统版本号
        [FSRequestSerializer setValue:CURRENT_SYSTEMVERSION forHTTPHeaderField:@"osVersion"];
        // app名称
        [FSRequestSerializer setValue:FSAPP_APPNAME forHTTPHeaderField:@"appName"];
        // app版本
        [FSRequestSerializer setValue:APP_VERSIONNO forHTTPHeaderField:@"appVersion"];
        // 渠道 "App Store"
        [FSRequestSerializer setValue:[FSAppInfo catchChannelName] forHTTPHeaderField:@"channelCode"];
    });
    
    return FSRequestSerializer;
}

+ (void)logUrlPramaWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    __block NSString *queryString = nil;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *escapedKey = key;//[key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *escapedValue = value;//[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (!queryString)
        {
            queryString = [NSString stringWithFormat:@"%@=%@", escapedKey, escapedValue];
        }
        else
        {
            queryString = [queryString stringByAppendingFormat:@"&%@=%@", escapedKey, escapedValue];
        }
    }];
    
    BMLog(@"%@", [NSString stringWithFormat:[URLString rangeOfString:@"?"].location == NSNotFound ? @"%@?%@" : @"%@&%@", URLString, queryString]);
}

+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    return [FSApiRequest makeRequestWithURL:URLString parameters:parameters isPost:YES];
}

+ (NSMutableURLRequest *)makeRequestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters isPost:(BOOL)isPost
{
    AFJSONRequestSerializer *requestSerializer = [FSApiRequest requestSerializer];
    
    NSMutableDictionary *parameterDic;
    if ([parameters bm_isNotEmptyDictionary])
    {
        parameterDic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    }
    else
    {
        parameterDic = [[NSMutableDictionary alloc] init];
    }
    
#ifdef DEBUG
    [FSApiRequest logUrlPramaWithURL:URLString parameters:parameterDic];
#endif
    
    NSString *method = isPost ? @"POST" : @"GET";
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameterDic error:&serializationError];
    if (serializationError)
    {
        return nil;
    }
    
    // 时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *tmp = [NSString stringWithFormat:@"%@", @(time)];
    [request setValue:tmp forHTTPHeaderField:@"timer"];

    // GPS定位
    [request setValue:[NSString stringWithFormat:@"%f", [FSLocation userLocationLongitude]] forHTTPHeaderField:FSAPI_GPS_LONGITUDE_KEY];
    [request setValue:[NSString stringWithFormat:@"%f", [FSLocation userLocationLatitude]] forHTTPHeaderField:FSAPI_GPS_LATITUDE_KEY];
    
    // 网络状态
    [request setValue:[FSCoreStatus currentFSNetWorkStatusString] forHTTPHeaderField:@"netWorkStandard"];
    
    // token
    if ([FSUserInfoModel isLogin])
    {
        NSString *token = [FSUserInfoModel userInfo].m_Token;
        if ([token bm_isNotEmpty])
        {
            [request setValue:token forHTTPHeaderField:@"JWTToken"];
        }
    }
    
    BMLog(@"HeaderFields: %@", [request allHTTPHeaderFields]);
    
    return request;
}

// 通过最顶级字典code，一次性查出来所有的子集数据
+ (NSMutableURLRequest *)getDictionaryInfoWithLevelCode:(NSString *)levelCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/dictionary/searchDictionaryInfoByTopLevelCode", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:levelCode forKey:@"topLevelCode"];
    
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

// 请求分享
+ (NSMutableURLRequest *)getShareDataWithShareItemId:(NSString *)shareItemId shareType:(NSString *)shareType
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/share/askShare", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters bm_setApiString:shareItemId forKey:@"id"];
    [parameters bm_setApiString:shareType forKey:@"type"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

+ (XMRequest *)getCollectStateID:(NSString *)relateId type:(NSString *)type Success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setString:relateId forKey:@"id"];
    [parameters bm_setString:type forKey:@"type"];
    return [XMRequestManager rm_requestWithApi:@"/storm/user/collectionCount" parameters:parameters success:successBlock failure:failureBlock];
}


/**
 收藏、取消

 @param relateId 相关id
 @param isCollect 收藏/取消
 @param guidingCase 指导性案例,CASE时必传
 @param source 来源（当type为STATUTE，CASE时必传）
 @param title 标题（当type为STATUTE，CASE时必传）
 @param type 类型（COURSE-课程 POSTS-帖子 STATUTE-法规 CASE-案例 DOCUMENT-文书范本）
 @param successBlock 成功
 @param failureBlock 识别
 @return XMRequest
 */
+ (XMRequest *)updateCollectStateID:(NSString *)relateId isCollect:(BOOL)isCollect guidingCase:(NSString *)guidingCase source:(NSString *)source title:(NSString *)title type:(NSString *)type Success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setString:relateId forKey:@"id"];
    [parameters bm_setString:type forKey:@"type"];
    [parameters bm_setString:isCollect?@"COLLECTION":@"CANCEL_COLLECTION" forKey:@"collection"];
    [parameters bm_setString:guidingCase forKey:@"guidingCase"];
    [parameters bm_setString:source forKey:@"source"];
    [parameters bm_setString:title forKey:@"title"];
    return [XMRequestManager rm_requestWithApi:@"/storm/user/collection" parameters:parameters success:successBlock failure:failureBlock];
}

// 获取帖子分享信息

//类型（COURSE-课程 POSTS-帖子 STATUTE-法规 CASE-案例 DOCUMENT-文书范本 PERSONNEL-个人中心app分享 SPECIAL 专题分享）
+ (XMRequest *)getShareContent:(NSString *)relateId  type:(nonnull NSString *)type success:(nullable XMSuccessBlock)successBlock failure:(nullable XMFailureBlock)failureBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setString:relateId forKey:@"id"];
    //POSTS
    [parameters bm_setString:type forKey:@"type"];
    return [XMRequestManager rm_requestWithApi:@"/storm/share/askShare" parameters:parameters success:successBlock failure:failureBlock];
}

@end
