//
//  FSSetPassWordVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/30.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"
#import "FSLoginProtocol.h"

@interface FSSetPassWordVC : FSSetTableViewVC

@property (nonatomic, weak) id <FSLoginDelegate> delegate;

@property (nonatomic, assign, readonly) FSVerificationCodeType m_VerificationType;

@property (nonatomic, strong, readonly) NSString *m_PhoneNum;


- (instancetype)initWithVerificationType:(FSVerificationCodeType)verificationType phoneNum:(NSString *)phoneNum verificationCode:(NSString *)VerificationCode;

@end
