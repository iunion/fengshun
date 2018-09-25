//
//  FSVideoStartTool.m
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoStartTool.h"

@implementation FSVideoStartTool

+ (UIWindow *)mainWindow
{
    UIWindow *window = [[UIApplication sharedApplication].windows count] > 0 ? [[UIApplication sharedApplication].windows objectAtIndex:0] : nil;
    if (!window)
    {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

+ (BOOL)startMeetingWithMeetingId:(NSInteger)meetingId progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest startMeetingWithId:meetingId];
    if (request)
    {
        [hud showAnimated:YES showBackground:NO];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                NSDictionary *resDic = responseObject;
                if (![resDic bm_isNotEmptyDictionary])
                {
                    [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    return;
                }
                
                NSInteger statusCode = [resDic bm_intForKey:@"code"];
                if (statusCode == 1000)
                {
                    [hud hideAnimated:YES];
                    completionHandler(response, responseObject, error);
                    return;
                }
                
                NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                [hud showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
        }];
        [task resume];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)endMeetingWithMeetingId:(NSInteger)meetingId progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest endMeetingWithId:meetingId];
    if (request)
    {
        [hud showAnimated:YES withText:@"正在结束视频"];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                NSDictionary *resDic = responseObject;
                if (![resDic bm_isNotEmptyDictionary])
                {
                    [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    return;
                }
                
                NSInteger statusCode = [resDic bm_intForKey:@"code"];
                if (statusCode == 1000)
                {
                    completionHandler(response, responseObject, error);
                    return;
                }
                
                NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                [hud showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
        }];
        [task resume];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteMeetingWithMeetingId:(NSInteger)meetingId progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest deleteMeetingWithId:meetingId];
    if (request)
    {
        [hud showAnimated:YES showBackground:NO];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            if (error)
            {
                BMLog(@"Error: %@", error);
                [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                NSDictionary *resDic = responseObject;
                if (![resDic bm_isNotEmptyDictionary])
                {
                    [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    return;
                }
                
                NSInteger statusCode = [resDic bm_intForKey:@"code"];
                if (statusCode == 1000)
                {
                    [hud hideAnimated:YES];
                    completionHandler(response, responseObject, error);
                    return;
                }
                
                NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                [hud showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            
        }];
        [task resume];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)getJoinMeetingToken:(NSString *)inviteCode name:(NSString *)name progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest getJoinMeetingToken:inviteCode inviteName:name];
    if (request)
    {
        [hud showAnimated:YES showBackground:NO];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            if (error)
            {
                BMLog(@"Error: %@", error);
                [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                
                NSDictionary *resDic = responseObject;
                if (![resDic bm_isNotEmptyDictionary])
                {
                    [hud showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                    return;
                }
                
                NSInteger statusCode = [resDic bm_intForKey:@"code"];
                if (statusCode == 1000)
                {
                    [hud hideAnimated:YES];
                    completionHandler(response, responseObject, error);
                    
                    return;
                }
                
                NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
                [hud showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
        }];
        [task resume];
        
        return NO;
    }
    
    return YES;
}

@end
