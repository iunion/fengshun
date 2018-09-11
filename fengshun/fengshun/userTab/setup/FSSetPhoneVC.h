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

// for BMVerificationCodeType_Type2
@property (nonatomic, weak) FSSetTableViewVC *m_PopToViewController;

@end
