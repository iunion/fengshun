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

static NSString *UserInfoDBTableContent = @"userid text NOT NULL PRIMARY KEY, mobilenum text NOT NULL, token text NOT NULL, rftoken text, username text, usertype text, nickname text, idcard text, sex text, headurl text, isfacialverify bool, isrealname bool, rolename text, rolecode text, lastupdatets double";

static NSString *UserInfoDBTableInsert = @"(userid, mobilenum, token, rftoken, username, usertype, nickname, idcard, sex, headurl, isfacialverify, isrealname, rolename, rolecode, lastupdatets) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";


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
            
            // 最后更新时间: lastupdatets
            userInfo.m_LastUpdateTs = [rs doubleForColumn:@"lastupdatets"];
            
            // 🔐用户令牌token(登录注册)💡: token
            NSString *dbToken = [rs stringForColumn:@"token"];
            userInfo.m_Token = [FSEncodeAPI decodeDES:dbToken];
            // 🔐用户刷新令牌💡: rftoken
            NSString *dbRefreshToke = [rs stringForColumn:@"rftoken"];
            userInfo.m_RefreshToken = [FSEncodeAPI decodeDES:dbRefreshToke];

            // Base
            userInfo.m_UserBaseInfo = [[FSUserBaseInfoModle alloc] init];

            // 🔐用户ID💡: userid
            NSString *dbUserId = [rs stringForColumn:@"userid"];
            userInfo.m_UserBaseInfo.m_UserId = [FSEncodeAPI decodeDES:dbUserId];
            // 🔐真实姓名: username
            NSString *dbUserName = [rs stringForColumn:@"username"];
            userInfo.m_UserBaseInfo.m_RealName = [FSEncodeAPI decodeDES:dbUserName];
            // 用户登录类型: usertype
            // 普通用户:COMMON, 工作人员:STAFF, 默认设置-普通用户
            userInfo.m_UserBaseInfo.m_UserType = [rs stringForColumn:@"usertype"];
            
            // 🔐用户手机号码: mobilenum
            NSString *dbPhoneNum = [rs stringForColumn:@"mobilenum"];
            userInfo.m_UserBaseInfo.m_PhoneNum = [FSEncodeAPI decodeDES:dbPhoneNum];
            // 🔐身份证号: idcard
            NSString *dbIdCardNo = [rs stringForColumn:@"idcard"];
            userInfo.m_UserBaseInfo.m_IdCardNo = [FSEncodeAPI decodeDES:dbIdCardNo];
            // 🔐邮箱: email
            //NSString *dbEmail = [rs stringForColumn:@"email"];
            //userInfo.m_UserBaseInfo.m_Email = [FSEncodeAPI decodeDES:dbEmail];
            // 昵称: nickname
            userInfo.m_UserBaseInfo.m_NickName = [rs stringForColumn:@"nickname"];
            // 性别: sex
            userInfo.m_UserBaseInfo.m_Sex = [rs stringForColumn:@"sex"];
            // 头像地址: headurl
            userInfo.m_UserBaseInfo.m_AvatarUrl = [rs stringForColumn:@"headurl"];
            
            // 人脸识别: isfacialverify
            userInfo.m_UserBaseInfo.m_IsFacialVerify = [rs boolForColumn:@"isfacialverify"];
            // 实名认证: isrealname
            userInfo.m_UserBaseInfo.m_IsRealName = [rs boolForColumn:@"isrealname"];

            
            // role
            userInfo.m_UserRole = [[FSUserRoleModle alloc] init];
            
            // 用户身份: rolename
            userInfo.m_UserRole.m_Role = [rs stringForColumn:@"rolename"];
            // 用户身份编码: rolecode
            userInfo.m_UserRole.m_RoleCode = [rs stringForColumn:@"rolecode"];
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
    if (![userInfo.m_UserBaseInfo.m_PhoneNum bm_isNotEmpty] || ![userInfo.m_UserBaseInfo.m_UserId bm_isNotEmpty] || ![userInfo.m_Token bm_isNotEmpty])
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

        NSString *token = [FSEncodeAPI encodeDES:userInfo.m_Token];
        NSString *rftoken = [FSEncodeAPI encodeDES:userInfo.m_RefreshToken];

        NSString *userId = [FSEncodeAPI encodeDES:userInfo.m_UserBaseInfo.m_UserId];
        NSString *phoneNum = [FSEncodeAPI encodeDES:userInfo.m_UserBaseInfo.m_PhoneNum];
        NSString *realName = [FSEncodeAPI encodeDES:userInfo.m_UserBaseInfo.m_RealName];
        NSString *idCardNo = [FSEncodeAPI encodeDES:userInfo.m_UserBaseInfo.m_IdCardNo];
        
        result = [UserInfoDB executeUpdate:sql, userId, phoneNum, token, rftoken, realName, userInfo.m_UserBaseInfo.m_UserType, userInfo.m_UserBaseInfo.m_NickName, idCardNo, userInfo.m_UserBaseInfo.m_Sex, userInfo.m_UserBaseInfo.m_AvatarUrl, @(userInfo.m_UserBaseInfo.m_IsFacialVerify), @(userInfo.m_UserBaseInfo.m_IsRealName), userInfo.m_UserRole.m_Role, userInfo.m_UserRole.m_RoleCode, @(lastUpdateTs)];
    }];
    
    return result;
}

@end
