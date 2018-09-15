//
//  FSVideoStartTool.m
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoStartTool.h"
#import "MBProgressHUD.h"

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

+ (BOOL)startMeetingWithMeetingId:(NSInteger)meetingId completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest startMeetingWithId:meetingId];
    if (request)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self mainWindow] animated:YES];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [hud hideAnimated:YES];
            completionHandler(response, responseObject, error);
        }];
        [task resume];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)getJoinMeetingToken:(NSString *)inviteCode phone:(NSString *)phone completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest getJoinMeetingToken:inviteCode phone:phone];
    if (request)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self mainWindow] animated:YES];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [hud hideAnimated:YES];
            completionHandler(response, responseObject, error);
        }];
        [task resume];
        
        return NO;
    }
    
    return YES;
}

@end
