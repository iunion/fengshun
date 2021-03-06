
//
//  SocketHelper.m
//  ODR
//
//  Created by DH on 2018/7/11.
//  Copyright © 2018年 DH. All rights reserved.
//

// socket收到了新的消息
NSString * const kNotiReceiveNewPublicMessageName = @"kNotiReceiveNewPublicMessageName";
NSString * const kNotiReceiveNewPrivateMessageName = @"kNotiReceiveNewPrivateMessageName";
NSString * const kNotiReceiveHistoryPrivateMessageListName = @"kNotiReceiveHistoryPrivateMessageListName";

#import "SocketHelper.h"
#import "SRWebSocket.h"
#import "FSAPIMacros.h"
#import "MJExtension.h"
#import "FSUserInfoModel.h"

@interface SocketHelper() <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong) NSTimer *heartTimer;
@property (nonatomic, strong) VideoCallRoomModel *roomModel;
@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) NSTimeInterval lastRoomEventTime;

@property (nonatomic, assign) NSTimeInterval lastConnectTime;
@property (nonatomic, assign) NSInteger reconnectCount;
@property (nonatomic, strong) NSString *m_RoomId;
@property (nonatomic, strong) NSString *m_Token;

@end

@implementation SocketHelper

static SocketHelper *_instance;
static dispatch_once_t onceToken;
+ (instancetype)shareHelper {
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (void)destroy {
    onceToken = 0;
    [_instance close];
    _instance = nil;
}

- (void)dealloc {
    NSLog(@"qq");
}

- (void)reconnect
{
    if (_socket) {
        [_socket close];
        _socket.delegate = nil;
    }

    NSLog(@"尝试第%@次重连", @(self.reconnectCount + 1));

    self.lastConnectTime = [[NSDate date] timeIntervalSince1970];
    NSString *socketUrl = [NSString stringWithFormat:@"%@/stormChatGateway/joinRoom/%@?JWTToken=%@&watcher=%d", FS_URL_SERVER, self.m_RoomId, self.m_Token, NO];
    NSURL *url = [NSURL URLWithString:socketUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    _socket = [[SRWebSocket alloc] initWithURLRequest:request];
    _socket.delegate = self;
    [_socket open];
    self.reconnectCount ++;
}

- (void)connectWithRoomId:(NSString *)roomId JWTToken:(NSString *)token{
    self.m_RoomId = roomId;
    self.m_Token = token;
    
    [self reconnect];
    
    _heartTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(sendHeartSocket) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_heartTimer forMode:UITrackingRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:_heartTimer forMode:NSDefaultRunLoopMode];
    [_heartTimer fire];
}

- (void)sendHeartSocket {
    if (!(_socket.readyState == SR_OPEN)) {
        return;
    }
    NSDictionary *t = @{@"roomTimeStamp" : @(self.lastRoomEventTime)};
    NSDictionary *dict = @{@"event" : @"HEARTBEAT",
                           @"data" : t};
    [_socket send:[dict mj_JSONString]];
}

- (void)close {
    [_socket close];
    [_heartTimer invalidate];
}


#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    self.reconnectCount = 0;
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    if (self.reconnectCount == 0) {
        // 发现断开连接，立即开始尝试连接
        [self reconnect];
    } else if (self.reconnectCount < 3) {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (now - self.lastConnectTime >= 5) {
            // 距离上次请求已经超过5s，立即发出请求
            [self reconnect];
        } else {
            // 间隔不到5s，那么等到5s的时候再发起请求
            [self performSelector:@selector(reconnect) withObject:nil afterDelay:5.0 - (now - self.lastConnectTime)];
        }
    } else {
        NSLog(@"重连超过3次，报错后离开视频%@", error);
        if ([self.delegate respondsToSelector:@selector(socketHelper:error:)]) {
            [self.delegate socketHelper:self error:error];
        }
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode");
    NSDictionary *userInfo = nil;
    if (reason != nil) {
        userInfo = @{NSLocalizedDescriptionKey: reason};
    }
    if ([self.delegate respondsToSelector:@selector(socketHelper:error:)]) {
        [self.delegate socketHelper:self error:[NSError errorWithDomain:@"webSocketDidClosed" code:code userInfo:userInfo]];
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSMutableDictionary *messageDic = [message mj_JSONObject];
    NSString *event = messageDic[@"event"];
    NSDictionary *data = messageDic[@"data"];
    
    NSLog(@"didReceiveMessage %@", messageDic);

    // error
    if ([event isEqualToString:@"ERROR"]) {
        NSInteger code = [data[@"code"] integerValue];
        NSDictionary *userInfo = nil;
        if (data[@"message"] != nil) {
            userInfo = @{NSLocalizedDescriptionKey: data[@"message"]};
        }

        NSError *error = [NSError errorWithDomain:@"domain" code:code userInfo:userInfo];
        if ([self.delegate respondsToSelector:@selector(socketHelper:error:)]) {
            [self.delegate socketHelper:self error:error];
        }
        return;
    }
    
    // room_info
    if ([event isEqualToString:@"RTC_ROOM_INFO"]) {
        RTCRoomInfoModel *model = [RTCRoomInfoModel modelWithParams:data];
        model.roomModel = _roomModel;
        if ([self.delegate respondsToSelector:@selector(socketHelper:RTCRoomInfo:loginAndJoinRoomSuccessHandler:)]) {
            [self.delegate socketHelper:self RTCRoomInfo:model loginAndJoinRoomSuccessHandler:^{
                self.flag = YES;
                [self dealRoomEvent];
            }];
        }
        return;
    }
    
    // room
    if ([event isEqualToString:@"ROOM"]) {
        self.lastRoomEventTime = [messageDic[@"timestamp"] doubleValue];
        _roomModel = [VideoCallRoomModel modelWithParams:data];
        [self dealRoomEvent];
        return;
    }
    

    // 广播单条消息
    if ([event isEqualToString:@"BROADCAST_MESSAGE"]) {
        // 暂时只支持纯文本消息，不支持文件及音视频多媒体
        if ([data[@"messageType"] isEqualToString:@"TEXT"]) {
            if ([data bm_containsObjectForKey:@"receiver"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiReceiveNewPrivateMessageName object:nil userInfo:messageDic];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiReceiveNewPublicMessageName object:nil userInfo:messageDic];
            }
        }
        
        return;
    }
    
    // 聊天消息列表数据
    if([event isEqualToString:@"STREAM_MESSAGE"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiReceiveHistoryPrivateMessageListName object:nil userInfo:messageDic];
        return;
    }
    // 开始录制
    if([event isEqualToString:@"START_RECORD"]) {
        if ([self.delegate respondsToSelector:@selector(socketHelperStartRecordSuccess:)]) {
            [self.delegate socketHelperStartRecordSuccess:self];
        }
        return;
    }
    // 关闭录制
    if([event isEqualToString:@"STOP_RECORD"]) {
        if ([self.delegate respondsToSelector:@selector(socketHelperStopRecordSuccess:)]) {
            [self.delegate socketHelperStopRecordSuccess:self];
        }
        return;
    }
    // 关闭房间
    if([event isEqualToString:@"CLOSE_ROOM"]) {
        if ([self.delegate respondsToSelector:@selector(socketHelperCloseRoomSuccess:)]) {
            [self.delegate socketHelperCloseRoomSuccess:self];
        }
        return;
    }
    // 接收到开关摄像头或麦克风消息
    if([event isEqualToString:@"SWITCH_MEDIA"]) {
        NSString *type = data[@"mediaType"];
        if ([type isEqualToString:@"VIDEO"] || [type isEqualToString:@"VOICE"]) {
            if ([self.delegate respondsToSelector:@selector(socketHelper:switchMemberId:type:)]) {
                [self.delegate socketHelper:self switchMemberId:data[@"memberId"] type:[type isEqualToString:@"VIDEO"]];
            }
        }
        return;
    }
}

- (void)dealRoomEvent {
    if (!_flag) {
        return;
    }
    for (int i = 0; i < _roomModel.members.count; i ++) {
        VideoCallMemberModel *model = _roomModel.members[i];
        if ([self.delegate respondsToSelector:@selector(socketHelper:roomEvent:)]) {
            [self.delegate socketHelper:self roomEvent:model];
        }
    }
}

#pragma mark -send 相关

//发送文本消息
- (void)sentTextMessageEvent:(NSString *)content receiverId:(NSString *)receiverId  isVoice:(BOOL)isVoice
{
    NSMutableDictionary *dataDic = @{@"content": content}.mutableCopy;
    
    if (receiverId) {
        [dataDic setObject:receiverId forKey:@"receiverId"];
    }
    
    if (isVoice) {
        [dataDic setObject:@"VOICE_DISCERN" forKey:@"messageResource"];
    } else {
        [dataDic setObject:@"HANDLER_INPUT" forKey:@"messageResource"];
    }
    
    NSDictionary *dic = @{@"event": @"SEND_TEXT",
                          @"data" : dataDic
                          };

    if (_socket.readyState == SR_OPEN) {
        
        NSLog(@"sentTextMessageEvent = %@", dic);

        [_socket send:[dic mj_JSONString]];
    }
}

// 查看聊天消息列表
- (void)sentListMessageEvent:(NSString *)senderId startId:(NSString *)startId pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *dataDic = @{}.mutableCopy;
//    NSMutableDictionary *dataDic = @{@"pageIndex": @(1)}.mutableCopy;
   if (pageSize) {
        [dataDic setObject:@(pageSize) forKey:@"pageSize"];
    }
    if (startId) {
        [dataDic setObject:startId forKey:@"startId"];
    }
    if (senderId) {
        [dataDic setObject:senderId forKey:@"senderId"];
    }
    NSDictionary *dic = @{@"event": @"STREAM_MESSAGE",
                          @"data" : dataDic
                          };
    
    if (_socket.readyState == SR_OPEN) {
        [_socket send:[dic mj_JSONString]];
    }
}

- (void)sendAudioEventWithUserId:(NSString *)userId enable:(BOOL)enable {
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:@"SWITCH_MEDIA" forKey:@"event"];
    NSMutableDictionary *data = @{}.mutableCopy;
    [data setObject:@"VOICE" forKey:@"mediaType"];
    [data setObject:userId forKey:@"memberId"];
    [dic setObject:data.copy forKey:@"data"];
    if (_socket.readyState == SR_OPEN) {
        NSLog(@"sendAudioEvent %@", dic);
        [_socket send:[dic mj_JSONString]];
    }
}

- (void)sendVideoEventWithUserId:(NSString *)userId enable:(BOOL)enable {
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:@"SWITCH_MEDIA" forKey:@"event"];
    NSMutableDictionary *data = @{}.mutableCopy;
    [data setObject:@"VIDEO" forKey:@"mediaType"];
    [data setObject:userId forKey:@"memberId"];
    [dic setObject:data.copy forKey:@"data"];
    if (_socket.readyState == SR_OPEN) {
        NSLog(@"sendVideo %@", dic);
        [_socket send:[dic mj_JSONString]];
    }
}

- (void)sendSpeechRecognitionEventWithEnable:(BOOL)enable {
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:@"SWITCH_MEDIA" forKey:@"event"];
    NSMutableDictionary *data = @{}.mutableCopy;
    [data setObject:@"VOICE_DISCERN" forKey:@"mediaType"];
    [dic setObject:data.copy forKey:@"data"];
    if (_socket.readyState == SR_OPEN) {
        NSLog(@"sendSpeech%@", dic);
        [_socket send:[dic mj_JSONString]];
    }
}


- (BOOL)sendRecordEventWithIsStartRecord:(BOOL)isStart {
    NSDictionary *dic;
    if (isStart) {
        NSInteger onlineCount = 0;
        for (int i = 0; i < _roomModel.members.count; i ++) {
            VideoCallMemberModel *model = _roomModel.members[i];
            if (model.memberStatus == VideoCallMemberStatusOnline) {
                onlineCount ++;
            }
        }
        
        if (onlineCount < 2) {
            return NO;
        }

        dic = @{@"event" : @"START_RECORD", @"data" : @{}};
    } else {
        dic = @{@"event" : @"STOP_RECORD", @"data" : @{}};
    }
    
    if (_socket.readyState == SR_OPEN) {
        [_socket send:[dic mj_JSONString]];
    }
    
    return YES;
}

- (void)sendCloseRoomEvent{
    NSDictionary *dic = @{@"event":@"CLOSE_ROOM"};
    if (_socket.readyState == SR_OPEN) {
        NSLog(@"sendCloseRoomEvent %@", dic);
        [_socket send:[dic mj_JSONString]];
    }
}

@end
