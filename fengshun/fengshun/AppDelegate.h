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

@class FSUserInfoModel, FSSetTableViewVC;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) FSTabBarController *m_TabBarController;

@property (nonatomic, strong) FSUserInfoModel *m_UserInfo;

// 用户擅长领域数据
@property (nonatomic, strong) NSMutableArray *m_Globle_UserAbilityInfo;


// GPS状态
- (BOOL)checkCLAuthorizationStatus;

// 踢出登录, 同logOut
- (void)kickOut;
// 退出登录
- (void)logOut;
// 是否退出到我的首页，是否显示登录
- (void)logOutQuit:(BOOL)quit showLogin:(BOOL)show;

// 使用API退出登录
- (void)logOutWithApi;


- (void)getUserAbilityInfoWithVc:(FSSetTableViewVC *)vc;

@end

