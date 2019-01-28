//
//  FSAuthVC.h
//  fengshun
//
//  Created by BeSt2wa on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSAuthVC : FSSetTableViewVC
// 类型 0：所有信息未完善；1：所有信息已完善；2：实名认证信息未完善；3：昵称未完善

+ (instancetype)vcWithAuthType:(FSAuthState ) type;

@end

NS_ASSUME_NONNULL_END
