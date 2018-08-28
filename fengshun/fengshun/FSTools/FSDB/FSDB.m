//
//  FSDB.m
//  fengshun
//
//  Created by dengjiang on 15/8/17.
//  Copyright (c) 2015年 ShiCaiDai. All rights reserved.
//

#import "FSDB.h"

#define MQDB_PATH       @"FSPrivate/DB"

@implementation FSDB

+ (NSString *)getDBPathName:(NSString *)dbName
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", [NSString bm_libraryPath], MQDB_PATH];
    BMLog(@"%@", dbPath);
    NSString *dbPathName = [dbPath stringByAppendingPathComponent:dbName];
    
    return dbPathName;
}

+ (NSString *)makeDBPathName:(NSString *)dbName
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", [NSString bm_libraryPath], MQDB_PATH];
    BMLog(@"%@", dbPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dbPath isDirectory:&isDir];
    if (!existed || !isDir)
    {
        [fileManager createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dbPathName = [dbPath stringByAppendingPathComponent:dbName];
    
    return dbPathName;
}

// 创建数据库
+ (BOOL)createDB:(NSString *)dbName withTableName:(NSString *)tableName tableContent:(NSString *)tableContent deleteDB:(BOOL)deleteDB
{
    NSString *dbPathName = [FSDB makeDBPathName:dbName];
    if (![dbPathName bm_isNotEmpty])
    {
        return NO;
    }
    
    __block BOOL result = NO;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        [FSDB deleteDB:dbName];
        return NO;
    }
    
//    if (checkExist)
//    {
//        [queue inDatabase:^(FMDatabase *db) {
//            result = [db tableExists:tableName];
//        }];
//        if (result)
//        {
//            return YES;
//        }
//    }

    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (%@)", tableName, tableContent];
        result = [db executeUpdate:sql];
        
        if ([db hadError])
        {
            BMLog(@"Create Table Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            *rollback = YES;
        }
    }];
    
    if (!result)
    {
        BMLog(@"Create Table %@ in DB %@ Error", tableName, dbName);
        if (deleteDB)
        {
            [FSDB deleteDB:dbName];
        }
    }

    return result;
}

+ (BOOL)createDB:(NSString *)dbName withTableName:(NSString *)tableName tableContent:(NSString *)tableContent, ...
{
    NSString *dbPathName = [FSDB makeDBPathName:dbName];
    if (![dbPathName bm_isNotEmpty])
    {
        return NO;
    }
    
    NSMutableArray *tableNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *tableContentArray = [[NSMutableArray alloc] init];
    
    [tableNameArray addObject:tableName];
    [tableContentArray addObject:tableContent];
    
    va_list args;
    va_start(args, tableContent);
    
    NSString *tableNameTemp = va_arg(args, NSString *);
    while (tableNameTemp != nil)
    {
        NSString *tableContentTemp = va_arg(args, NSString *);
        NSAssert(tableContentTemp, @"Lost some parameters must pair for tableName and tableContent.");
        
        [tableNameArray addObject:tableNameTemp];
        [tableContentArray addObject:tableContentTemp];
        
        tableNameTemp = va_arg(args, NSString *);
    }
    
    va_end(args);

    __block BOOL result = NO;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        [FSDB deleteDB:dbName];
        return NO;
    }
    
    for (NSUInteger index = 0; index<tableNameArray.count; index++)
    {
        tableNameTemp = tableNameArray[index];
        NSString *tableContentTemp = tableContentArray[index];
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (%@)", tableNameTemp, tableContentTemp];
            result = [db executeUpdate:sql];
            
            if ([db hadError])
            {
                BMLog(@"Create Table Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                *rollback = YES;
            }
        }];
        
        if (!result)
        {
            BMLog(@"Create Table %@ in DB %@ Error", tableName, dbName);
            [FSDB deleteDB:dbName];
            break;
        }
    }
    
    return result;
}

// 删除数据库
+ (BOOL)deleteDB:(NSString *)dbName
{
    BOOL result = NO;
    NSError *error;
    
    NSString *dbPathName = [FSDB getDBPathName:dbName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbPathName];
    if (!isExist)
    {
        return YES;
    }
    
    result = [fm removeItemAtPath:dbPathName error:&error];
    if (!result)
    {
        BMLog(@"Failed to delete old database file %@ with message '%@'.", dbName, [error localizedDescription]);
    }
    
    return result;
}

// 删除表
+ (BOOL)deleteTable:(NSString *)tableName inDb:(NSString *)dbName
{
    NSString *dbPathName = [FSDB getDBPathName:dbName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbPathName];
    if (!isExist)
    {
        return YES;
    }
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        [FSDB deleteDB:dbName];
        return YES;
    }
    
    __block BOOL result = NO;
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
        result = [db executeUpdate:sql];
        
        if ([db hadError])
        {
            BMLog(@"Delete Table Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            *rollback = YES;
        }
    }];
    
    if (!result)
    {
        BMLog(@"Delete Table %@ in DB %@ Error", tableName, dbName);
        [FSDB deleteDB:dbName];
    }
    
    return result;
}

+ (NSUInteger)countTable:(NSString *)tableName inDb:(NSString *)dbName
{
    NSString *dbPathName = [FSDB getDBPathName:dbName];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        return 0;
    }
    
    __block NSUInteger count = 0;
    
    [queue inDatabase:^(FMDatabase *DB) {
        NSString *alias = @"count";
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS '%@' FROM %@",alias, tableName];
        
        FMResultSet *rs = [DB executeQuery:sql];
        if ([rs next])
        {
            count = [[rs stringForColumn:alias] integerValue];
        }
        
        [rs close];
    }];
    
    return count;
}

// result colums: cid[INTEGER], name[STRING], type[STRING], notnull[INTEGER], dflt_value[], pk[INTEGER]
+ (NSArray *)getTableSchema:(NSString *)tableName inDb:(NSString *)dbName
{
    NSString *dbPathName = [FSDB getDBPathName:dbName];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        return nil;
    }
    
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    [queue inDatabase:^(FMDatabase *DB) {
        NSString *sql = [NSString stringWithFormat: @"pragma table_info('%@')", tableName];
        
        // result colums: cid[INTEGER], name[STRING], type[STRING], notnull[INTEGER], dflt_value[], pk[INTEGER]
        FMResultSet *rs = [DB executeQuery:sql];
        while ([rs next])
        {
            //NSLog(@"%@", [rs columnNameToIndexMap]);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSUInteger count = [rs columnCount];
            for (int i = 0; i<count; i++)
            {
                NSString *name = [rs columnNameForIndex:i];
                NSString *value = [rs stringForColumnIndex:i];
                if (!value)
                {
                    value = @"NULL";
                }
                [dic setObject:value forKey:name];
            }
            BMLog(@"%@", dic);
            [array addObject:dic];
        }
        
        [rs close];
    }];
    
    return array;
}

+ (BOOL)isExistTable:(NSString *)tableName inDb:(NSString *)dbName 
{
    __block BOOL result = NO;
    
    NSString *dbPathName = [FSDB getDBPathName:dbName];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        return 0;
    }

    [queue inDatabase:^(FMDatabase *DB) {
        result = [DB tableExists:tableName];
    }];
    
    return result;
}

+ (void)executeQuery:(NSString *)sql inDb:(NSString *)dbName queryResBlock:(MQDBResultSetBlock)queryResBlock
{
    NSString *dbPathName = [FSDB getDBPathName:dbName];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        if (queryResBlock)
        {
            queryResBlock(nil, nil);
        }
    }
    
    [queue inDatabase:^(FMDatabase *DB) {
        FMResultSet *rs = [DB executeQuery:sql];
        
        if (queryResBlock)
        {
            queryResBlock(DB, rs);
        }
        
        [rs close];
    }];
}

+ (NSString *)makeInsertSqlWithColumns:(NSArray <NSString *> *)columns
{
    NSMutableString *keys = [NSMutableString string];
    NSMutableString *marks = [NSMutableString string];
    for (NSString *column in columns)
    {
        if (keys.length == 0)
        {
            [keys appendString:column];
        }
        else
        {
            [keys appendFormat:@", %@", column];
        }
        
        if (marks.length == 0)
        {
            [marks appendString:@"?"];
        }
        else
        {
            [marks appendString:@", ?"];
        }
    }
    
    return [NSString stringWithFormat:@"(%@) VALUES (%@)", keys, marks];
}

@end
