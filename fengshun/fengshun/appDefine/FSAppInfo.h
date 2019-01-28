//
//  FSAppInfo.h
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSAppInfo : NSObject

// 渠道名称
+ (NSString *)catchChannelName;

// OpenUDID
+ (NSString *)getOpenUDID;
+ (void)setOpenUDID:(NSString *)openUDID;

// 用户标识
+ (NSString *)getCurrentPhoneNum;
+ (void)setCurrentPhoneNum:(NSString *)phoneNum;

// 升级版本
+ (NSString *)getUpdateVersion;
+ (void)setUpdateVersion:(NSString *)version;

@end
