//
//  AppDelegate.h
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTabBarController.h"

#define GetAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class FSUserInfoModle;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) FSTabBarController *m_TabBarController;

@property (nonatomic, strong) FSUserInfoModle *m_UserInfo;

// GPS状态
- (BOOL)checkCLAuthorizationStatus;

// 踢出登录, 同logOut
- (void)kickOut;
// 退出登录
- (void)logOut;
// 使用API退出登录
- (void)logOutWithApi;

@end

