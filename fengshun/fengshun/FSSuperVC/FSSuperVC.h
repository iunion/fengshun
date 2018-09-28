//
//  FSSuperVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSVCProtocol.h"

#import "FSUserInfo.h"

@interface FSSuperVC : UIViewController
<
    FSSuperVCProtocol
>

// 是否使用手势返回，bm_CanBackInteractive设置


#pragma mark -
#pragma mark 登录/注册

// 弹出登录
- (BOOL)showLogin;
// 隐藏登录
- (void)hideLogin;
// 弹出认证
- (void)pushAuthentication;


- (void)loginFinished;
- (void)loginFailed;
- (void)loginClosed;
- (void)authenticationFinished;


#pragma mark -
#pragma mark API状态校验

// RequestStatus
// 校验一些特殊全局状态码,比如:token失效,强制升级
- (BOOL)checkRequestStatus:(NSInteger)statusCode message:(NSString *)message responseDic:(NSDictionary *)responseDic logOutQuit:(BOOL)quit showLogin:(BOOL)show;
- (void)checkXMApiWithError:(NSError *)error;

@end
