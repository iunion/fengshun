//
//  FSSetTableViewVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"
#import "BMTableViewManager.h"

@interface FSSetTableViewVC : FSTableViewVC
<
   BMTableViewManagerDelegate
>

@property (nonatomic, strong, readonly) BMTableViewManager *m_TableManager;

// 支持键盘相应
- (BOOL)needKeyboardEvent;

- (void)interfaceSettings;
- (void)freshView;

// 手机号
- (BOOL)verifyPhoneNum:(NSString *)phoneNum;
- (BOOL)verifyPhoneNum:(NSString *)phoneNum showMessage:(BOOL)showMessage;
// 密码
- (BOOL)verifyPassword:(NSString *)password;
- (BOOL)verifyPassword:(NSString *)password showMessage:(BOOL)showMessage;

@end