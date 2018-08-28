//
//  FSUserInfoDB.h
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSUserInfoModle.h"

@interface FSUserInfoDB : NSObject

// 删除数据库
+ (BOOL)deleteUserInfoDB;

// 创建数据库
+ (BOOL)createUserInfoDB;

// 重建数据库
+ (BOOL)reCreateUserInfoDB;

+ (FSUserInfoModle *)getUserInfoWithUserId:(NSString *)userId;

+ (BOOL)insertAndUpdateUserInfo:(FSUserInfoModle *)userInfo;

@end
