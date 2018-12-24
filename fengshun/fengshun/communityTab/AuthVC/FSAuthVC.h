//
//  FSAuthVC.h
//  fengshun
//
//  Created by BeSt2wa on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperNetVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSAuthVC : FSSuperNetVC
// 类型 0：所有信息未完善；1：所有信息已完善；2：实名认证信息未完善；3：昵称未完善

@property (nonatomic , copy) void (^complateUserMessage)(void);

+ (instancetype)vcWithAuthType:(FSAuthState ) type;

@end

NS_ASSUME_NONNULL_END
