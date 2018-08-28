//
//  FSUserInfoDB.m
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSUserInfoDB.h"
#import "FSDB.h"
#import "FSEncodeAPI.h"

static NSString *UserInfoDBName = @"userinfo.dat";
static NSString *UserInfoDBTableName = @"userinfo";

static NSString *UserInfoDBTableContent = @"userid text NOT NULL PRIMARY KEY, mobilenum text NOT NULL, token text NOT NULL, nickname text, realname text, identitynum text, userlevel text, lastupdatets double";

static NSString *UserInfoDBTableInsert = @"(userid, mobilenum, token, nickname, realname, identitynum, userlevel, lastupdatets) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";


@implementation FSUserInfoDB

+ (BOOL)createUserInfoDB
{
    return [FSDB createDB:UserInfoDBName withTableName:UserInfoDBTableName tableContent:UserInfoDBTableContent, nil];
}

// 删除数据库
+ (BOOL)deleteUserInfoDB
{
    return [FSDB deleteDB:UserInfoDBName];
}

+ (BOOL)reCreateUserInfoDB
{
    if ([FSUserInfoDB deleteUserInfoDB])
    {
        return [FSUserInfoDB createUserInfoDB];
    }
    
    return NO;
}

+ (FSUserInfoModle *)getUserInfoWithUserId:(NSString *)userId
{
    if (![userId bm_isNotEmpty])
    {
        return nil;
    }
    
    __block FSUserInfoModle *userInfo = nil;
    __block BOOL result = YES;
    
    NSString *encodeUserId = [FSEncodeAPI encodeDES:userId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid = '%@'", UserInfoDBTableName, encodeUserId];
    [FSDB executeQuery:sql inDb:UserInfoDBName queryResBlock:^(FMDatabase *DB, FMResultSet *rs) {
        if ([rs next])
        {
            userInfo = [[FSUserInfoModle alloc] init];
            
            // 最后更新时间
            userInfo.m_LastUpdateTs = [rs doubleForColumn:@"lastupdatets"];
            
            // Base
            
            // 用户令牌: token
            userInfo.m_Token = [rs stringForColumn:@"token"];
            // 🔐用户ID: custId
            NSString *dbUserId = [rs stringForColumn:@"userid"];
            userInfo.m_UserId = [FSEncodeAPI decodeDES:dbUserId];
            // 🔐用户手机号码: mobile
            NSString *phoneNum = [rs stringForColumn:@"mobilenum"];
            userInfo.m_PhoneNum = [FSEncodeAPI decodeDES:phoneNum];
            // 🔐真实姓名: userName
            NSString *realName = [rs stringForColumn:@"realname"];
            userInfo.m_RealName = [FSEncodeAPI decodeDES:realName];
            // 昵称: nickName
            userInfo.m_NickName = [rs stringForColumn:@"nickname"];
            // 用户等级: custLevel
            userInfo.m_UserLevel = [rs stringForColumn:@"userlevel"];
            // 🔐身份证号: idCard
            NSString *idCardNo = [rs stringForColumn:@"identitynum"];
            userInfo.m_IdCardNo = [FSEncodeAPI decodeDES:idCardNo];
        }
        result = ![DB hadError];
    }];
    
    if (result)
    {
        return userInfo;
    }
    
    return nil;
}

+ (BOOL)insertAndUpdateUserInfo:(FSUserInfoModle *)userInfo
{
    if (![userInfo.m_PhoneNum bm_isNotEmpty] || ![userInfo.m_UserId bm_isNotEmpty] || ![userInfo.m_Token bm_isNotEmpty])
    {
        return NO;
    }
    
    NSString *dbPathName = [FSDB getDBPathName:UserInfoDBName];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPathName];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    
    [queue inDatabase:^(FMDatabase *UserInfoDB) {
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ %@", UserInfoDBTableName, UserInfoDBTableInsert];
        
        NSTimeInterval lastUpdateTs = [[NSDate date] timeIntervalSince1970];
        
        NSString *userId = [FSEncodeAPI encodeDES:userInfo.m_UserId];
        NSString *phoneNum = [FSEncodeAPI encodeDES:userInfo.m_PhoneNum];
        NSString *realName = [FSEncodeAPI encodeDES:userInfo.m_RealName];
        NSString *idCardNo = [FSEncodeAPI encodeDES:userInfo.m_IdCardNo];
        
        result = [UserInfoDB executeUpdate:sql, userId, phoneNum, userInfo.m_Token, userInfo.m_NickName, realName, idCardNo, userInfo.m_UserLevel, @(lastUpdateTs)];
    }];
    
    return result;
}

@end
