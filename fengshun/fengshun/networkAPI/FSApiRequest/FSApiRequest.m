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

+ (AFHTTPRequestSerializer *)requestSerializer
{
    static AFHTTPRequestSerializer *FSRequestSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FSRequestSerializer = [AFHTTPRequestSerializer serializer];
        FSRequestSerializer.timeoutInterval = FSAPI_TIMEOUT_SECONDS;
        [FSRequestSerializer setValue:[FSAppInfo getOpenUDID] forHTTPHeaderField:@"deviceId"];
        [FSRequestSerializer setValue:[UIDevice bm_devicePlatformString] forHTTPHeaderField:@"deviceModel"];
        [FSRequestSerializer setValue:@"iOS" forHTTPHeaderField:@"cType"];
        [FSRequestSerializer setValue:FSAPP_APPNAME forHTTPHeaderField:@"appName"];
        [FSRequestSerializer setValue:APP_VERSIONNO forHTTPHeaderField:@"appVersion"];
        [FSRequestSerializer setValue:[FSAppInfo catchChannelName] forHTTPHeaderField:@"channelCode"];
        [FSRequestSerializer setValue:[NSString stringWithFormat:@"%@", @(IOS_VERSION)] forHTTPHeaderField:@"osVersion"];
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
    AFHTTPRequestSerializer *requestSerializer = [FSApiRequest requestSerializer];
    
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
    
    [request setValue:[NSString stringWithFormat:@"%f", [FSLocation userLocationLongitude]] forHTTPHeaderField:FSAPI_GPS_LONGITUDE_KEY];
    [request setValue:[NSString stringWithFormat:@"%f", [FSLocation userLocationLatitude]] forHTTPHeaderField:FSAPI_GPS_LATITUDE_KEY];
    
    [request setValue:[FSCoreStatus currentMQNetWorkStatusString] forHTTPHeaderField:@"netWorkStandard"];
//    if ([[MQUserInfo userInfo].m_Token isNotEmpty])
//    {
//        [request setValue:[MQUserInfo userInfo].m_Token forHTTPHeaderField:@"token"];
//    }
    
    BMLog(@"HeaderFields: %@", [request allHTTPHeaderFields]);
    
    return request;
}



@end
