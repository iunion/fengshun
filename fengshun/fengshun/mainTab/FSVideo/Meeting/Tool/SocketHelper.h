//
//  SocketHelper.h
//  ODR
//
//  Created by DH on 2018/7/11.
//  Copyright © 2018年 DH. All rights reserved.
//

FOUNDATION_EXPORT NSString * const kNotiReceiveNewPublicMessageName;
FOUNDATION_EXPORT NSString * const kNotiReceiveNewPrivateMessageName;
FOUNDATION_EXPORT NSString * const kNotiReceiveHistoryPrivateMessageListName;


#import <Foundation/Foundation.h>
#import "VideoCallModel.h"

@protocol SocketHelperDelegate;
@class MediateMeetingMessageModel, PlayerModel;
@interface SocketHelper : NSObject

@property (nonatomic, weak) id <SocketHelperDelegate> delegate;
//@property (nonatomic, strong, readonly) VideoCallEnterRoomModel *model;

/**
 初始化入口

 @return sh
 */
+ (instancetype)shareHelper;


/**
 单例销毁
 */
+ (void)destroy;

/**
 连接socket
 */
- (void)connectWithRoomId:(NSString *)roomId JWTToken:(NSString *)token;

/**
 关闭socket
 */
- (void)close;

/**
 发送文本消息
  */
- (void)sentTextMessageEvent:(NSString *)content receiverId:(NSString *)receiverId isVoice:(BOOL)isVoice;

/**
 查看聊天消息列表
  */
- (void)sentListMessageEvent:(NSString *)senderId startId:(NSString *)startId pageSize:(NSInteger)pageSize;

/**
 开启或关闭麦克风事件

 @param userId userId
 @param enable 1:开启， 0关闭
 */
- (void)sendAudioEventWithUserId:(NSString *)userId enable:(BOOL)enable;

/**
 开启或关闭摄像头事件

 @param userId userId
 @param enable 1:开启， 0关闭
 */
- (void)sendVideoEventWithUserId:(NSString *)userId enable:(BOOL)enable;

/**
 发送开始录制，或者停止录制事件

 @param isStart 1:停止， 
 */
- (void)sendRecordEventWithIsStartRecord:(BOOL)isStart;

/**
 发送语音识别开启或关闭事件

 @param enable enable
 */
- (void)sendSpeechRecognitionEventWithEnable:(BOOL)enable;

@end


@protocol SocketHelperDelegate <NSObject>
@optional

/**
 发生error

 @param socketHelper sh
 @param error error
 */
- (void)socketHelper:(SocketHelper *)socketHelper error:(NSError *)error;

/**
 socket链接成功，返回登录相关数据

 @param socketHelper sh
 @param model model
 */
- (void)socketHelper:(SocketHelper *)socketHelper RTCRoomInfo:(RTCRoomInfoModel *)model loginAndJoinRoomSuccessHandler:(void(^)(void))handler;


/**
 人员变动事件

 @param socketHelper sh
 @param model model
 */
- (void)socketHelper:(SocketHelper *)socketHelper roomEvent:(VideoCallMemberModel *)model;

/**
 开始录制成功事件

 @param socketHelper sh
 */
- (void)socketHelperStartRecordSuccess:(SocketHelper *)socketHelper;

/**
 结束录制成功事件

 @param socketHelper sh
 */
- (void)socketHelperStopRecordSuccess:(SocketHelper *)socketHelper;

@end
