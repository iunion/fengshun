//
//  VideoCallModel.h
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "FSSuperModel.h"

/**
 视频会话成员状态
 
 - VideoCallMemberStatusUnKnown: 默认
 */
typedef NS_ENUM(NSInteger, VideoCallMemberStatus) {
    VideoCallMemberStatusUnKnown, ///< 未知
    VideoCallMemberStatusOnline, ///< 在线
    VideoCallMemberStatusOffline, ///< 离线
};

#import <Foundation/Foundation.h>

@interface VideoCallMemberModel : FSSuperModel
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, assign) VideoCallMemberStatus memberStatus;
@property (nonatomic, assign) BOOL memberVoiceStatus;
@property (nonatomic, assign) BOOL memberVideoStatus;
@property (nonatomic, copy) NSString *memberType;
@end

@interface VideoCallRoomModel : FSSuperModel
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, assign) BOOL voiceDiscernSwitch; ///< 语音识别开关
@end


@interface RTCRoomInfoModel : FSSuperModel
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userSig;
@property (nonatomic, copy) NSString *privateMapKey;
@property (nonatomic, strong) VideoCallRoomModel *roomModel;
@end


