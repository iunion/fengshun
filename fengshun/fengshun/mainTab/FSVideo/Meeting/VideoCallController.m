//
//  MDTViewCallController.m
//  ODR
//
//  Created by DH on 2018/8/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "VideoCallController.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+VideoCall.h"
#import "ASRManager.h"
#import "SingleTextChatViewController.h"
#import "UIButton+BMContentRect.h"
#import "PublicTextChatViewController.h"
#import "FSVideoInviteLitigantVC.h"
#import "FSVideoStartTool.h"
#import "FSMeetingDataEnum.h"

@interface VideoCallController ()
<SocketHelperDelegate,
VideoCallTopBarDelegate,
VideoCallBottomBarDelegate,
ASRDelegate,
VideoCallVideoViewDelegate>

// 保存调解笔录消息
@property (nonatomic, strong) PublicTextChatViewController *publicTextChatVC; // 纯消息列表

@property (nonatomic, strong) VideoCallBottomBar *bottomBar;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *roomToken;
@property (nonatomic, assign) NSInteger meetingId;
@end


@implementation VideoCallController

+ (instancetype)VCWithRoomId:(NSString *)roomId meetingId:(NSInteger)meetingId token:(NSString *)token{
    VideoCallController *vc = [VideoCallController new];
    vc.roomId = roomId;
    vc.roomToken = token;
    vc.meetingId = meetingId;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bm_colorWithHex:0x111924];
    // 1/
    [self _setupUI];
    
    // 2/连接socket
    [[SocketHelper shareHelper] connectWithRoomId:_roomId JWTToken:self.roomToken];
    [SocketHelper shareHelper].delegate = self;
    
    // 3/初始化语音识别
    [ASRManager defaultManager].delegate = self;
    
    // 4
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewPrivateMessage:) name:kNotiReceiveNewPrivateMessageName object:nil];
}


#pragma mark - SocketHelperDelegate
- (void)socketHelper:(SocketHelper *)socketHelper error:(NSError *)error {
    [self showAlertError:error];
}

- (void)socketHelper:(SocketHelper *)socketHelper RTCRoomInfo:(RTCRoomInfoModel *)model loginAndJoinRoomSuccessHandler:(void (^)(void))handler {
    [self loginAndJoinRoomWithModel:model handler:^{
        handler();
        self.model = model;
        if (model.roomModel) {
            if (model.roomModel.voiceDiscernSwitch) {
                [[ASRManager defaultManager] start];
                [self.topBar setBtnIsSelected:YES index:2];
            } else {
                [[ASRManager defaultManager] stop];
                [self.topBar setBtnIsSelected:NO index:2];
            }
        }
    }];
}

- (void)socketHelper:(SocketHelper *)socketHelper roomEvent:(VideoCallMemberModel *)model {
    // 判断此model在不在
    // 人员加入事件
    VideoCallVideoView *view = [_packView elementForUserId:model.memberId];
    if (model.memberStatus == VideoCallMemberStatusOnline) {
        if (view) {return;}
        ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
        ILiveRenderView *renderView = [frameDispatcher addRenderAt:CGRectZero forIdentifier:model.memberId srcType:QAVVIDEO_SRC_TYPE_CAMERA];
        renderView.autoRotate = YES;
        renderView.isRotate = NO;
        renderView.identifier = model.memberId;
        VideoCallVideoView *videoView = [[VideoCallVideoView alloc] initWithRenderView:renderView model:model];
        videoView.delegate = self;
        [self.packView addSubview:videoView];
        [self.packView adjustLayout];
    } else if (model.memberStatus == VideoCallMemberStatusOffline) {
        // 人员退出事件
        if (!view) {return;}
        ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
        [frameDispatcher removeRenderViewFor:view.userId srcType:QAVVIDEO_SRC_TYPE_CAMERA];
        [view removeFromSuperview];
        [self.packView adjustLayout];
    } else {
        NSAssert(NO, @"error");
    }
}

- (void)socketHelperStartRecordSuccess:(SocketHelper *)socketHelper {
    [_topBar setBtnIsSelected:YES index:1];
}

- (void)socketHelperStopRecordSuccess:(SocketHelper *)socketHelper {
    [_topBar setBtnIsSelected:NO index:1];
}


#pragma mark - ILiveRoomDisconnectListener
- (BOOL)onRoomDisconnect:(int)reason {
    NSLog(@"房间异常退出：%d", reason);
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

#pragma mark - VideoCallTopBarDelegate
- (void)videoCallTopBarDidClick:(VideoCallTopBar *)topBar index:(NSInteger)index {
    if (index == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (index == 1) { /// 开始录制事件
        // 获取按钮当前状态
        BOOL status = [topBar getBtnSelectedStatusWithIndex:1];
        if (![[SocketHelper shareHelper] sendRecordEventWithIsStartRecord:!status] && !status ) {
            [self vc_showMessage:@"当前在线用户小于2人，无法开启录制"];
        }
    } else if (index == 2) { /// 语音识别事件
        [[SocketHelper shareHelper] sendSpeechRecognitionEventWithEnable:NO];
        BOOL status = [topBar getBtnSelectedStatusWithIndex:2];
        if (status) {
            [[ASRManager defaultManager] stop];
        } else {
            [[ASRManager defaultManager] start];
        }
        [topBar setBtnIsSelected:!status index:2];
    } else if (index == 3) { // 翻转摄像头
        [[ILiveRoomManager getInstance] switchCamera:^{
            
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            NSString *msg = [NSString stringWithFormat:@"翻转摄像头操作失败\n%d:%@", errId, errMsg];
            [self vc_showMessage:msg];
        }];
    }
}

#pragma mark - VideoCallBottomBarDelegate
- (void)videoCallBottomBar:(VideoCallBottomBar *)bottomBar index:(NSInteger)index {
        if (index == 0) { /// 群聊
            if (_publicTextChatVC == nil) {
                self.publicTextChatVC = [PublicTextChatViewController vcWithMeetingModel:_model];
                _publicTextChatVC.modalPresentationStyle = UIModalPresentationCustom;
                _publicTextChatVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            }
            [self presentViewController:_publicTextChatVC animated:YES completion:nil];
        } else if (index == 1) {
            // 邀请
            FSVideoInviteLitigantVC *vc = [FSVideoInviteLitigantVC new];
            BMWeakSelf
            vc.inviteComplete = ^(NSArray *litigantList) {
                if (weakSelf.inviteBlock) {
                    weakSelf.inviteBlock(litigantList);
                }
            };
            vc.meetingId = self.meetingId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // 结束视频
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"确定要现在结束视频吗？结束后，所有人离开视频不可再次进入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"结束" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self sendEndMeetingRequest];
            }];
            [vc addAction:action];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [vc addAction:action2];
            
            [self presentViewController:vc animated:YES completion:nil];
        }
}

- (void)sendEndMeetingRequest
{
    BMWeakSelf
    [FSVideoStartTool endMeetingWithMeetingId:self.meetingId progressHUD:self.m_ProgressHUD completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *resDic = responseObject;
        NSInteger statusCode = [resDic bm_intForKey:@"code"];
        if (statusCode == 1000)
        {
            if (weakSelf.endMeetingBlock) {
                weakSelf.endMeetingBlock();
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    }];
}

#pragma mark - SingleTextChatViewControllerDelegate
#pragma mark - 私聊界面退出事件
- (void)finishPriviteSessionModel:(VideoCallMemberModel *)member {
    VideoCallVideoView *view = [self.packView elementForUserId:member.memberId];
    [view isShowRedPoint:NO];
}

#pragma mark - 接收到私聊消息通知
- (void)receiveNewPrivateMessage:(NSNotification *)noti {
    NSLog(@"%@", noti.userInfo);
}


#pragma mark - ASRDelegate
- (void)asrReceiveText:(NSString *)text {
    if (text.length) {
        [[SocketHelper shareHelper] sentTextMessageEvent:text receiverId:nil isVoice:YES];
    }
}

- (void)dealloc {
    [[ILiveRoomManager getInstance] quitRoom:^{
        NSLog(@"退出房间成功");
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSLog(@"退出房间失败 %d : %@", errId, errMsg);
    }];
    [SocketHelper destroy];
    [[ASRManager defaultManager] stop];
    [ASRManager defaultManager].delegate = nil;
}

#pragma mark - VideoCallVideoViewDelegate
- (void)videoCallVideoView:(VideoCallVideoView *)view avPackViewDidTap:(VideoCallMemberModel *)model {
//    NSLog(@"音视频点击事件");
    NSString *msg1; NSString *msg2;
    if (model.memberVoiceStatus) {
        msg1 = @"关闭麦克风";
    } else {
        msg1 = @"打开麦克风";
    }
    if (model.memberVideoStatus) {
        msg2 = @"关闭摄像头";
    } else {
        msg2 = @"打开摄像头";
    }
    UIAlertController *tovc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *a1 = [UIAlertAction actionWithTitle:msg1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self audioControlWithModel:model];
        [view reloadData];
    }];

    UIAlertAction *a2 = [UIAlertAction actionWithTitle:msg2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self videoControlWithModel:model];
        [view reloadData];
    }];
    UIAlertAction *a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [tovc addAction:a1];
    [tovc addAction:a2];
    [tovc addAction:a3];
    [self presentViewController:tovc animated:YES completion:nil];
}

- (void)audioControlWithModel:(VideoCallMemberModel *)model {

    [[SocketHelper shareHelper] sendAudioEventWithUserId:model.memberId enable:!model.memberVoiceStatus];
    model.memberVoiceStatus = !model.memberVoiceStatus;
    if ([FSMeetingDataEnum isMediatorIdentity:model.memberType]) {
        // 关闭自己的麦克风
        BOOL curMicState = [[ILiveRoomManager getInstance] getCurMicState];
        if (curMicState != model.memberVoiceStatus) {
            [[ILiveRoomManager getInstance] enableMic:model.memberVoiceStatus succ:^{
                if (model.memberVoiceStatus) {
                    [self vc_showMessage:@"麦克风已开启"];
                } else {
                    [self vc_showMessage:@"麦克风已关闭"];
                }
            } failed:^(NSString *module, int errId, NSString *errMsg) {
                NSString *msg = [NSString stringWithFormat:@"麦克风操作失败\n%d:%@", errId, errMsg];
                [self vc_showMessage:msg];
            }];
        }
    } else {
        // 关闭别人的麦克风
        // 发socket，关闭麦克风
    }
}

- (void)videoControlWithModel:(VideoCallMemberModel *)model {
    [[SocketHelper shareHelper] sendVideoEventWithUserId:model.memberId enable:!model.memberVoiceStatus];
    model.memberVideoStatus = !model.memberVideoStatus;
    if ([FSMeetingDataEnum isMediatorIdentity:model.memberType]) {
        // 关闭自己视屏
        BOOL curCameraState = [[ILiveRoomManager getInstance] getCurCameraState];
        if (curCameraState != model.memberVideoStatus) {
            // 获取视频方位
            cameraPos pos = [[ILiveRoomManager getInstance] getCurCameraPos];
            [[ILiveRoomManager getInstance] enableCamera:pos enable:model.memberVideoStatus succ:^{
                if (model.memberVideoStatus) {
                    [self vc_showMessage:@"摄像头已开启"];
                } else {
                    [self vc_showMessage:@"摄像头已关闭"];
                }
            } failed:^(NSString *module, int errId, NSString *errMsg) {
                NSString *msg = [NSString stringWithFormat:@"摄像头操作失败\n%d:%@", errId, errMsg];
                [self vc_showMessage:msg];
            }];
        }
    } else {
        // 关闭别人的视屏
    }
}

#pragma mark - 私聊按钮点击事件
//- (void)videoCallVideoView:(VideoCallVideoView *)view priChatBtnDidClick:(VideoCallMemberModel *)member {
//    SingleTextChatViewController *vc = [SingleTextChatViewController singleChatTextVCWithMeetingModel:member];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)_setupUI {
    _bottomBar = ({
        VideoCallBottomBar *vcbb = [VideoCallBottomBar new];
        vcbb.delegate = self;
        [self.view addSubview:vcbb];
        [vcbb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.offset(49 + UI_HOME_INDICATOR_HEIGHT);
            make.bottom.equalTo(self.view);
        }];
        vcbb;
    });
    
    _packView = ({
        VideoCallPackView *vcpv = [VideoCallPackView new];
        [self.view addSubview:vcpv];
        [vcpv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(70);
            } else {
                make.top.left.right.equalTo(self.view).offset(90);
            }
            make.bottom.equalTo(_bottomBar.mas_top).offset(12);
        }];
        vcpv;
    });
    
    _topBar = ({
        VideoCallTopBar *vctb = [VideoCallTopBar new];
        vctb.backgroundColor = [UIColor bm_colorWithHex:0x0f1925];
        vctb.delegate = self;
        [self.view addSubview:vctb];
        [vctb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(70);
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            } else {
                make.top.equalTo(self.view).offset(20);
            }
        }];
        vctb;
    });
    
}

@end

