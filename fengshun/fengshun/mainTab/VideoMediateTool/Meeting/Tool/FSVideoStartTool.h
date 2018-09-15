//
//  FSVideoStartTool.h
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSApiRequest.h"

@interface FSVideoStartTool : NSObject

+ (BOOL)startMeetingWithMeetingId:(NSInteger)meetingId completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

+ (BOOL)getJoinMeetingToken:(NSString *)inviteCode phone:(NSString *)phone completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

@end
