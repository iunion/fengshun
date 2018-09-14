//
//  FSSetPhoneVC.h
//  fengshun
//
//  Created by jiang deng on 2018/9/11.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"

@interface FSSetPhoneVC : FSSetTableViewVC

@property (nonatomic, strong) NSString *m_OldPhoneNum;
@property (nonatomic, strong) NSString *m_OldVerificationCode;

// for BMVerificationCodeType_Type4 变更手机号码刷新数据及返回页面使用
@property (nonatomic, weak) FSSetTableViewVC *m_PopToViewController;

@end
