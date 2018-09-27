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

#define FSSEARCH_HISTORY_CACHEFILE(searchKey, userId) [[FSUserInfoDB getSearchHistoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"searchhistory_%@_user%@.plist", searchKey, userId]]

@interface FSUserInfoDB : NSObject

// 删除数据库
+ (BOOL)deleteUserInfoDB;

// 创建数据库
+ (BOOL)createUserInfoDB;

// 重建数据库
+ (BOOL)reCreateUserInfoDB;

+ (FSUserInfoModel *)getUserInfoWithUserId:(NSString *)userId;

+ (BOOL)insertAndUpdateUserInfo:(FSUserInfoModel *)userInfo;



// 获取搜索历史存储目录
+ (NSString *)getSearchHistoryPath;
// 创建搜索历史存储目录
+ (BOOL)makeSearchHistoryPath;

// 获取搜索历史
+ (NSArray *)getSearchHistoryWithUserId:(NSString *)userId key:(NSString *)key;
// 存储搜索历史
+ (void)saveSearchHistoryWithUserId:(NSString *)userId key:(NSString *)key searchHistories:(NSArray *)searchHistories;

// 清除搜索历史
+ (void)cleanUserSearchHistroyDataWithUserId:(NSString *)userId;

@end
