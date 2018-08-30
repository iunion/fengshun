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

@property (nonatomic, strong, readonly) NSString *m_PhoneNum;

// 是否注册
@property (nonatomic, assign) BOOL m_IsRegist;

- (instancetype)initWithPhoneNum:(NSString *)phoneNum;

@end
