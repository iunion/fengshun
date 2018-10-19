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
<
    SocketHelperDelegate,
    VideoCallTopBarDelegate,
    VideoCallBottomBarDelegate,
    TIMUserStatusListener,
    ILiveRoomDisconnectListener,
    TIMConnListener,
    ASRDelegate,
    VideoCallVideoViewDelegate
>

// 保存调解笔录消息
@property (nonatomic, strong) PublicTextChatViewController *publicTextChatVC; // 纯消息列表
@property (nonatomic, strong) VideoCallBottomBar *bottomBar;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *roomToken;
@property (nonatomic, assign) NSInteger meetingId;
@property (nonatomic, assign) BOOL isShowError;
@property (nonatomic, assign) NSInteger joinRoomStep;
@end


@implementation VideoCallController

+ (instancetype)VCWithRoomId:(NSString *)roomId meetingId:(NSInteger)meetingId token:(NSString *)token{
    VideoCallController *vc = [VideoCallController new];
    vc.roomId = roomId;
    vc.roomToken = token;
    vc.meetingId = meetingId;
    return vc;
}


- (void)dealloc {
    NSLog(@"VideoCallController dealloc");
}

- (void)exitVC {
    [self dismissViewControllerAnimated:YES completion:^{
        [[ILiveSDK getInstance] setConnListener:nil];
        [[ILiveSDK getInstance] setUserStatusListener:nil];
        [[ILiveRoomManager getInstance] quitRoom:^{
            NSLog(@"退出房间成功");
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            NSLog(@"退出房间失败 %d : %@", errId, errMsg);
        }];
        [SocketHelper destroy];
        [[ASRManager defaultManager] stop];
        [ASRManager defaultManager].delegate = nil;
//        [ASRManager destroy];
    }];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Custom Method

- (void)showAlertError:(NSError *)error {
    if (error.localizedFailureReason) {
        [self showAlertWithTitle:error.localizedFailureReason msg:nil];
    } else {
        [self showAlertWithTitle:nil msg:error.localizedDescription];
    }
}

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg{
    
    if (self.isShowError) {
        return;
    }
    
    self.isShowError = YES;
    
    BMWeakSelf
    if ((![msg bm_isNotEmpty]) && (![title bm_isNotEmpty])) {
        msg = @"发生未知错误，请尝试退出重进";
    }
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf exitVC];
    }];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)sendEndMeetingRequest
{
    BMWeakSelf
    [self.m_ProgressHUD bm_bringToFront];
    [FSVideoStartTool endMeetingWithMeetingId:self.meetingId progressHUD:self.m_ProgressHUD completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *resDic = responseObject;
        NSInteger statusCode = [resDic bm_intForKey:@"code"];
        if (statusCode == 1000)
        {
            if (weakSelf.endMeetingBlock) {
                weakSelf.endMeetingBlock();
            }
            
            [MBProgressHUD showHUDAddedTo:[FSVideoStartTool mainWindow] animated:NO withText:@"视频已结束" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FSVideoMediateChangedNotification object:nil userInfo:nil];
            [[SocketHelper shareHelper] sendCloseRoomEvent];
            return;
        }
    }];
}

#pragma mark - JoinRoom Method
- (void)loginRoomWithModel:(RTCRoomInfoModel *)model handler:(void (^)(void))handler {
    // 登录
    [self.m_ProgressHUD bm_bringToFront];
    [self.m_ProgressHUD showAnimated:YES withText:@"正在登录"];
    BMWeakSelf
    BMWeakType(model)

    [[ILiveSDK getInstance] setConnListener:self];
    [[ILiveSDK getInstance] setUserStatusListener:self];
    
    [[ILiveLoginManager getInstance] iLiveLogin:model.userId sig:model.userSig succ:^{
        // 加入房间
        NSLog(@"登录账号成功！！！！！！！");
        [weakSelf joinRoomWithModel:weakmodel handler:handler];
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        // 登录失败
        [weakSelf.m_ProgressHUD hideAnimated:YES];
        [weakSelf showAlertWithTitle:@"登录失败" msg:errMsg];
        NSLog(@"登录账号失败！！！！！！！");
    }];
}

- (void)joinRoomWithModel:(RTCRoomInfoModel *)model handler:(void (^)(void))handler {
    // 1、创建房间配置对象
    self.joinRoomStep = 1;
    [self.m_ProgressHUD showAnimated:YES withText:@"正在加入房间"];

    ILiveRoomOption *option = [ILiveRoomOption defaultGuestLiveOption];
    // 2、配置进房票据
    option.avOption.privateMapKey = [model.privateMapKey dataUsingEncoding:NSUTF8StringEncoding];
    option.imOption.imSupport = NO;
    option.avOption.autoCamera = NO;
    option.avOption.autoMic = NO;
    option.controlRole = FS_ILiveControlRole;
    // 设置房间中断事件监听
    option.roomDisconnectListener = self;
    
    BMWeakSelf

    [[ILiveRoomManager getInstance] joinRoom:(int)model.roomId option:option succ:^{
        NSLog(@"加入房间成功！！！！！！！");
        weakSelf.joinRoomStep = 2;
        [weakSelf.m_ProgressHUD hideAnimated:YES];
        handler();
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        // 加入房间失败
        NSLog(@"failed 加入房间失败！！！！！！！");
        weakSelf.joinRoomStep = 3;
        [weakSelf.m_ProgressHUD hideAnimated:YES];
        [weakSelf showAlertWithTitle:@"加入房间失败" msg:errMsg];
    }];
}

#pragma mark - SocketHelperDelegate
- (void)socketHelper:(SocketHelper *)socketHelper error:(NSError *)error {
    [self showAlertError:error];
}

- (void)socketHelper:(SocketHelper *)socketHelper RTCRoomInfo:(RTCRoomInfoModel *)model loginAndJoinRoomSuccessHandler:(void (^)(void))handler {
    if (self.model) {
        return;
    }
    BMWeakSelf
    [self loginRoomWithModel:model handler:^{
        handler();
        weakSelf.model = model;
        if (model.roomModel) {
            if (model.roomModel.voiceDiscernSwitch) {
                [[ASRManager defaultManager] start];
                [weakSelf.topBar setBtnIsSelected:YES index:2];
            } else {
                [[ASRManager defaultManager] stop];
                [weakSelf.topBar setBtnIsSelected:NO index:2];
            }
        }
    }];
}

- (void)socketHelper:(SocketHelper *)socketHelper roomEvent:(VideoCallMemberModel *)model {
    // 判断此model在不在
    // 人员加入事件
    VideoCallVideoView *view = [_packView elementForUserId:model.memberId];
    if (model.memberStatus == VideoCallMemberStatusOnline) {
        if (view == nil) {
            ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
            ILiveRenderView *renderView = [frameDispatcher addRenderAt:CGRectZero forIdentifier:model.memberId srcType:QAVVIDEO_SRC_TYPE_CAMERA];
            renderView.autoRotate = YES;
            renderView.isRotate = NO;
            renderView.identifier = model.memberId;
            VideoCallVideoView *videoView = [[VideoCallVideoView alloc] initWithRenderView:renderView model:model];
            videoView.delegate = self;
            [self.packView addSubview:videoView];
            [self.packView adjustLayout];
            view = videoView;
        }
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
    
    // 同步状态
    if (view && model.memberStatus == VideoCallMemberStatusOnline) {
        view.model.memberVideoStatus = model.memberVideoStatus;
        view.model.memberVoiceStatus = model.memberVoiceStatus;
        [view reloadData];

        if ([FSMeetingDataEnum isMediatorIdentity:view.model.memberType]) {
            BOOL curCameraState = [[ILiveRoomManager getInstance] getCurCameraState];
            if (curCameraState != view.model.memberVideoStatus) {
                // 获取视频方位
                cameraPos pos = [[ILiveRoomManager getInstance] getCurCameraPos];
                [[ILiveRoomManager getInstance] enableCamera:pos enable:view.model.memberVideoStatus succ:^{
                    if (view.model.memberVideoStatus) {
                        NSLog(@"摄像头已开启");
                    } else {
                        NSLog(@"摄像头已关闭");
                    }
                } failed:^(NSString *module, int errId, NSString *errMsg) {
                    NSLog(@"摄像头操作失败\n%d:%@", errId, errMsg);
                }];
            }
            
            BOOL curMicState = [[ILiveRoomManager getInstance] getCurMicState];
            if (curMicState != view.model.memberVoiceStatus) {
                [[ILiveRoomManager getInstance] enableMic:view.model.memberVoiceStatus succ:^{
                    if (view.model.memberVoiceStatus) {
                        NSLog(@"麦克风已开启");
                    } else {
                        NSLog(@"麦克风已关闭");
                    }
                } failed:^(NSString *module, int errId, NSString *errMsg) {
                    NSLog(@"麦克风操作失败\n%d:%@", errId, errMsg);
                }];
            }
        }
    }
}

-(void)socketHelper:(SocketHelper *)socketHelper switchMemberId:(NSString *)memberId type:(BOOL)isVideo
{
    VideoCallVideoView *view = [_packView elementForUserId:memberId];
    if (isVideo)
    {
        view.model.memberVideoStatus = !view.model.memberVideoStatus;
        if ([FSMeetingDataEnum isMediatorIdentity:view.model.memberType]) {
            // 关闭自己视屏
            BOOL curCameraState = [[ILiveRoomManager getInstance] getCurCameraState];
            if (curCameraState != view.model.memberVideoStatus) {
                // 获取视频方位
                cameraPos pos = [[ILiveRoomManager getInstance] getCurCameraPos];
                [[ILiveRoomManager getInstance] enableCamera:pos enable:view.model.memberVideoStatus succ:^{
                    if (view.model.memberVideoStatus) {
                        [self vc_showMessage:@"摄像头已开启"];
                    } else {
                        [self vc_showMessage:@"摄像头已关闭"];
                    }
                } failed:^(NSString *module, int errId, NSString *errMsg) {
                    NSString *msg = [NSString stringWithFormat:@"摄像头操作失败\n%d:%@", errId, errMsg];
                    [self vc_showMessage:msg];
                }];
            }
        }
    }
    else
    {
        view.model.memberVoiceStatus = !view.model.memberVoiceStatus;
        if ([FSMeetingDataEnum isMediatorIdentity:view.model.memberType]) {
            // 关闭自己的麦克风
            BOOL curMicState = [[ILiveRoomManager getInstance] getCurMicState];
            if (curMicState != view.model.memberVoiceStatus) {
                [[ILiveRoomManager getInstance] enableMic:view.model.memberVoiceStatus succ:^{
                    if (view.model.memberVoiceStatus) {
                        [self vc_showMessage:@"麦克风已开启"];
                    } else {
                        [self vc_showMessage:@"麦克风已关闭"];
                    }
                    if (view.model.memberVoiceStatus) {
                        NSLog(@"麦克风已开启");
                    } else {
                        NSLog(@"麦克风已关闭");
                    }
                } failed:^(NSString *module, int errId, NSString *errMsg) {
                    NSString *msg = [NSString stringWithFormat:@"麦克风操作失败\n%d:%@", errId, errMsg];
                    [self vc_showMessage:msg];
                    NSLog(@"麦克风操作失败\n%d:%@", errId, errMsg);
                }];
            }
        }
    }
    [view reloadData];
}

- (void)socketHelperStartRecordSuccess:(SocketHelper *)socketHelper {
    [_topBar setBtnIsSelected:YES index:1];
}

- (void)socketHelperStopRecordSuccess:(SocketHelper *)socketHelper {
    [_topBar setBtnIsSelected:NO index:1];
}

- (void)socketHelperCloseRoomSuccess:(SocketHelper *)socketHelper {
    [self.m_ProgressHUD hideAnimated:NO];
    [self exitVC];
}

#pragma mark - TIMUserStatusListener
- (void)onForceOffline
{
    NSLog(@"踢下线通知");
    [self showAlertWithTitle:@"您已被踢下线" msg:nil];
}

- (void)onReConnFailed:(int)code err:(NSString*)err
{
    NSLog(@"断线重连失败");
    [self showAlertWithTitle:@"断线重连失败" msg:err];
}

- (void)onUserSigExpired
{
//    NSLog(@"用户登录的userSig过期");
//    [self showAlertWithTitle:@"登录userSig已过期" msg:nil];
}

#pragma mark -  TIMConnListener

- (void)onConnSucc
{
    NSLog(@"onConnSucc 网络连接成功");
}

// 网络连接失败
- (void)onConnFailed:(int)code err:(NSString*)err
{
    NSLog(@"onConnFailed %@ %@", @(code), err);
}

//  网络连接断开（断线只是通知用户，不需要重新登陆，重连以后会自动上线）
- (void)onDisconnect:(int)code err:(NSString*)err
{
    NSLog(@"onDisconnect %@ %@", @(code), err);
    if (self.joinRoomStep == 1) {
        NSLog(@"onDisconnect joinRoomStep = 1");
        self.joinRoomStep = 10;
        [self performSelector:@selector(joinRoomFailed) withObject:nil afterDelay:10];
    }
}

- (void)onConnecting
{
    NSLog(@"onConnecting 网络连接中……");
}

- (void)joinRoomFailed {
    if (self.joinRoomStep == 10) {
        [self showAlertWithTitle:@"加入房间失败" msg:nil];
    }
}

#pragma mark - ILiveRoomDisconnectListener
- (BOOL)onRoomDisconnect:(int)reason {
    NSLog(@"房间异常退出：%d", reason);
    [self showAlertWithTitle:nil msg:@"发生未知错误，请尝试退出重进"];
    return YES;
}

#pragma mark - VideoCallTopBarDelegate
- (void)videoCallTopBarDidClick:(VideoCallTopBar *)topBar index:(NSInteger)index {
    if (index == 0) {
        [self exitVC];
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
        BMWeakSelf
        // 摄像头打开状态下才能翻转
        if ([[ILiveRoomManager getInstance] getCurCameraState]) {
            [[ILiveRoomManager getInstance] switchCamera:^{
                
            } failed:^(NSString *module, int errId, NSString *errMsg) {
                NSString *msg = [NSString stringWithFormat:@"翻转摄像头操作失败\n%d:%@", errId, errMsg];
                [weakSelf vc_showMessage:msg];
            }];
        }else {
            [self vc_showMessage:@"摄像头已关闭,操作失败"];
        }
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
            BMWeakSelf
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"确定要现在结束视频吗？结束后，所有人离开视频不可再次进入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"结束" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf sendEndMeetingRequest];
            }];
            [vc addAction:action];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [vc addAction:action2];
            
            [self presentViewController:vc animated:YES completion:nil];
        }
}

#pragma mark - SingleTextChatViewControllerDelegate
#pragma mark - 私聊界面退出事件
- (void)finishPriviteSessionModel:(VideoCallMemberModel *)member {
    VideoCallVideoView *view = [self.packView elementForUserId:member.memberId];
    [view isShowRedPoint:NO];
}

#pragma mark - ASRDelegate
- (void)asrReceiveText:(NSString *)text {
    NSLog(@"asrReceiveText = %@", text);
    if (text.length) {
        [[SocketHelper shareHelper] sentTextMessageEvent:text receiverId:nil isVoice:YES];
    }
}

-(void)asrFailedWithError:(NSError *)error
{
    NSLog(@"asrFailedWithError = %@", error);
    if ([error.localizedFailureReason bm_isNotEmpty]) {
//        [self vc_showMessage:error.localizedFailureReason];
    } else if ([error.localizedDescription bm_isNotEmpty]) {
//        [self vc_showMessage:error.localizedDescription];
    }
}

-(void)asrStateChange:(ASRState)state
{
    NSLog(@"asrStateChange = %@", @(state));
}

#pragma mark - VideoCallVideoViewDelegate
- (void)videoCallVideoView:(VideoCallVideoView *)view avPackViewDidTap:(VideoCallMemberModel *)model {
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
    BMWeakSelf
    UIAlertController *tovc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *a1 = [UIAlertAction actionWithTitle:msg1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf audioControlWithModel:model];
    }];

    UIAlertAction *a2 = [UIAlertAction actionWithTitle:msg2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf videoControlWithModel:model];
    }];
    UIAlertAction *a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [tovc addAction:a1];
    [tovc addAction:a2];
    [tovc addAction:a3];
    [self presentViewController:tovc animated:YES completion:nil];
}

- (void)audioControlWithModel:(VideoCallMemberModel *)model {
    [[SocketHelper shareHelper] sendAudioEventWithUserId:model.memberId enable:!model.memberVoiceStatus];
}

- (void)videoControlWithModel:(VideoCallMemberModel *)model {
    [[SocketHelper shareHelper] sendVideoEventWithUserId:model.memberId enable:!model.memberVideoStatus];
}

#pragma mark - 私聊按钮点击事件
//- (void)videoCallVideoView:(VideoCallVideoView *)view priChatBtnDidClick:(VideoCallMemberModel *)member {
//    SingleTextChatViewController *vc = [SingleTextChatViewController singleChatTextVCWithMeetingModel:member];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - UI

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

