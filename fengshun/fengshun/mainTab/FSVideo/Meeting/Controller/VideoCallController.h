//
//  MDTViewCallController.h
//  ODR
//
//  Created by DH on 2018/8/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "FSSuperNetVC.h"
#import "VideoCallModel.h"
#import <ILiveSDK/ILiveCoreHeader.h>
#import "VideoCallView.h"
#import "SocketHelper.h"
#import "VideoCallModel.h"

typedef void(^FSVideoMediateEndMeetingBlock)(void);

@interface VideoCallController : FSSuperNetVC <ILiveRoomDisconnectListener>
@property (nonatomic, strong) VideoCallTopBar *topBar;
@property (nonatomic, strong) VideoCallPackView *packView;
@property (nonatomic, strong) RTCRoomInfoModel *model;
@property (nonatomic, copy) FSVideoMediateEndMeetingBlock endMeetingBlock;
+ (instancetype)VCWithRoomId:(NSString *)roomId meetingId:(NSInteger)meetingId token:(NSString *)token;
@end

