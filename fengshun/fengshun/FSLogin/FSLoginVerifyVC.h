//
//  FSLoginVerifyVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"
#import "FSLoginProtocol.h"
#import "BMVerifiTimeManager.h"

@interface FSLoginVerifyVC : FSSetTableViewVC

@property (nonatomic, weak) id <FSLoginDelegate> delegate;

@property (nonatomic, assign, readonly) BMVerificationCodeType m_VerificationType;

@property (nonatomic, strong, readonly) NSString *m_PhoneNum;

// for BMVerificationCodeType_Type4 变更手机号码刷新数据及返回页面使用
@property (nonatomic, weak) FSSetTableViewVC *m_PopToViewController;


- (instancetype)initWithVerificationType:(BMVerificationCodeType)verificationType phoneNum:(NSString *)phoneNum;

@end
