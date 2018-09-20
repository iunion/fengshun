//
//  UIViewController+VideoCall.h
//  ODR
//
//  Created by DH on 2018/8/15.
//  Copyright © 2018年 DH. All rights reserved.
//  视频控制器  方法分类

#import "VideoCallController.h"

@interface VideoCallController (VideoCall)

- (void)vc_showMessage:(NSString *)msg;

- (void)showAlertError:(NSError *)error;

- (void)loginAndJoinRoomWithModel:(RTCRoomInfoModel *)model handler:(void (^)(void))handler;

@end
