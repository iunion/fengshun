//
//  FSApiErrorLog.m
//  miaoqian
//
//  Created by dengjiang on 15/12/30.
//  Copyright © 2015年 ShiCaiDai. All rights reserved.
//

#ifdef DEBUG

#import "FSApiErrorLog.h"
#import "FSUserInfo.h"

//#import "UMMobClick/MobClick.h"

#define FSApiErrorLog_SaveMaxLength     5120
#define FSApiErrorLog_FileName          @"apiErrorLog.plist"

@implementation FSApiErrorLog

+ (BOOL)insertAndUpdateErrorLogWithURLRequest:(NSURLRequest *)request error:(NSError *)error
{
    NSString *errorStr = @"";
    if (error)
    {
        if (error.code <= 0)
        {
            return NO;
        }
        errorStr = [NSString stringWithFormat:@"errorCode:%@ description:%@", @(error.code), error.localizedDescription];
    }
    else
    {
        return NO;
    }
    
    //[MobClick event:@"api_responseStatus" label:errorStr];
    
    if (error.code <= 400)
    {
        return NO;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSURL *url = request.URL;
    NSString *urlpath = [url path];
    if (![urlpath bm_isNotEmpty])
    {
        return NO;
    }
    
    NSString *urlPrama = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    if (![urlPrama bm_isNotEmpty])
    {
        return NO;
    }
    
    NSString *api = [NSString stringWithFormat:@"%@&%@", urlpath, urlPrama];
    NSString *api_name = urlpath;
    NSString *user_id = @"";
    if ([FSUserInfoModle isLogin])
    {
        user_id = [FSUserInfoModle userInfo].m_UserBaseInfo.m_UserId;
    }
    
    [dic bm_setString:api forKey:@"api"];
    [dic bm_setString:api_name forKey:@"api_name"];
    if ([request.allHTTPHeaderFields bm_isNotEmptyDictionary])
    {
        [dic setObject:request.allHTTPHeaderFields forKey:@"api_header"];
    }
    [dic bm_setString:user_id forKey:@"user_id"];
    [dic bm_setString:[NSDate bm_stringFromDate:[NSDate date]] forKey:@"addtime"];
    
    [dic bm_setString:url.absoluteString forKey:@"url"];
    [dic bm_setString:errorStr forKey:@"responseError"];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", [NSString bm_documentsPath], FSApiErrorLog_FileName];
    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:fileName];
    if (!dataArray)
    {
        dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    [dataArray addObject:dic];
    
    return [dataArray writeToFile:fileName atomically:NO];
}


@end

#endif
