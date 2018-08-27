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
