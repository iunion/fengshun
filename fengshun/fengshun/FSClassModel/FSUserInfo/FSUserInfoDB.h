//
//  FSUserInfoDB.h
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSUserInfoModel.h"

extern NSString *const FSUserInfoCaseSearchHistoryKey;
extern NSString *const FSUserInfoLawSearchHistoryKey;
extern NSString *const FSUserInfoTextSearchHistoryKey;

#define SEARCH_HISTORY_CACHEFILE(searchKey) [[NSString bm_documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"searchhistory_%@.plist", searchKey]]

@interface FSUserInfoDB : NSObject

// 删除数据库
+ (BOOL)deleteUserInfoDB;

// 创建数据库
+ (BOOL)createUserInfoDB;

// 重建数据库
+ (BOOL)reCreateUserInfoDB;

+ (FSUserInfoModel *)getUserInfoWithUserId:(NSString *)userId;

+ (BOOL)insertAndUpdateUserInfo:(FSUserInfoModel *)userInfo;


// 用户的使用历史数据,目前是本地文件存储
// 在登出和登录的时候进行清理,其实应该用户数据库存储,且用数据库管理
// 所以清理的方法添加到这儿
+ (void)cleanUserHistroyData;

@end
