//
//  FSDB.h
//  fengshun
//
//  Created by dengjiang on 15/8/17.
//  Copyright (c) 2015年 ShiCaiDai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MQDBResultSetBlock)(FMDatabase * _Nullable DB, FMResultSet * _Nullable rs);

@interface FSDB : NSObject

+ (NSString *)getDBPathName:(NSString *)dbName;

// 创建数据库
+ (BOOL)createDB:(NSString *)dbName withTableName:(NSString *)tableName tableContent:(NSString *)tableContent deleteDB:(BOOL)deleteDB;
+ (BOOL)createDB:(NSString *)dbName withTableName:(NSString *)tableName tableContent:(NSString *)tableContent, ...NS_REQUIRES_NIL_TERMINATION;

// 删除数据库
+ (BOOL)deleteDB:(NSString *)dbName;
// 删除表
+ (BOOL)deleteTable:(NSString *)tableName inDb:(NSString *)dbName;

// 表记录数计算
+ (NSUInteger)countTable:(NSString *)tableName inDb:(NSString *)dbName;
// 获取表结构
+ (nullable NSArray *)getTableSchema:(NSString *)tableName inDb:(NSString *)dbName;
// 数据库中是否存在表
+ (BOOL)isExistTable:(NSString *)tableName inDb:(NSString *)dbName;

// 执行一个查询语句
+ (void)executeQuery:(NSString *)sql inDb:(NSString *)dbName queryResBlock:(MQDBResultSetBlock)queryResBlock;

+ (NSString *)makeInsertSqlWithColumns:(NSArray <NSString *> *)columns;

@end

NS_ASSUME_NONNULL_END
