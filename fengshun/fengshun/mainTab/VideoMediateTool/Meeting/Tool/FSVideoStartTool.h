//
//  FSVideoStartTool.h
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSApiRequest.h"
#import "MBProgressHUD.h"

@interface FSVideoStartTool : NSObject

+ (BOOL)startMeetingWithMeetingId:(NSInteger)meetingId progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

+ (BOOL)endMeetingWithMeetingId:(NSInteger)meetingId progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

+ (BOOL)deleteMeetingWithMeetingId:(NSInteger)meetingId progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

+ (BOOL)getJoinMeetingToken:(NSString *)inviteCod name:(NSString *)namee progressHUD:(MBProgressHUD *)hud completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

@end
