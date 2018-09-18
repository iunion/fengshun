//
//  UIViewController+VideoCall.m
//  ODR
//
//  Created by DH on 2018/8/15.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "UIViewController+VideoCall.h"
#import "ASRManager.h"

@implementation VideoCallController (VideoCall)

//#pragma mark - privte
- (void)vc_showMessage:(NSString *)msg {
    
    __block MASConstraint *labelTopMas;
    
    UILabel *label = [UILabel new];
    label.text = msg;
    label.font = UI_FONT_16;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = UI_COLOR_BL1;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(35);
        make.left.right.equalTo(self.view);
        labelTopMas = make.top.equalTo(self.topBar.mas_bottom).offset(-35);
    }];
    
    [self.view layoutIfNeeded];
    [labelTopMas uninstall];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        labelTopMas = make.top.equalTo(self.topBar.mas_bottom).offset(0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view layoutIfNeeded];
        [labelTopMas uninstall];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            labelTopMas = make.top.equalTo(self.topBar.mas_bottom).offset(-35);
        }];
        [UIView animateWithDuration:0.25 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

- (void)showAlertError:(NSError *)error {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"error" message:error.localizedFailureReason preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg code:(NSInteger)code {
    NSString *fmsg = [NSString stringWithFormat:@"errId:%ld errMsg:%@", code, msg];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:fmsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loginAndJoinRoomWithModel:(RTCRoomInfoModel *)model handler:(void (^)(void))handler {
    // 登录
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:@"正在登录"];
    [[ILiveLoginManager getInstance] iLiveLogin:model.userId sig:model.userSig succ:^{
        // 加入房间
        
        // 1、创建房间配置对象
        ILiveRoomOption *option = [ILiveRoomOption defaultGuestLiveOption];
        // 2、配置进房票据
        option.avOption.privateMapKey = [model.privateMapKey dataUsingEncoding:NSUTF8StringEncoding];
        option.imOption.imSupport = NO;
        option.avOption.autoCamera = YES;
        option.avOption.autoMic = YES;
        // 设置房间中断事件监听
        option.roomDisconnectListener = self;
        // 首帧到达监听
        //    option.firstFrameListener = toVC;
        option.controlRole = KILiveControlRole;
        
        [hud showAnimated:YES withText:@"正在加入房间"];
        [[ILiveRoomManager getInstance] joinRoom:(int)model.roomId option:option succ:^{
            [hud hideAnimated:YES];
            handler();
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            // 加入房间失败
            [hud hideAnimated:YES];
            [self showAlertWithTitle:@"加入房间失败" msg:errMsg code:errId];
        }];
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        // 登录失败
        [hud hideAnimated:YES];
        [self showAlertWithTitle:@"登录失败" msg:errMsg code:errId];
    }];
}
@end
