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

#define FSSearchHistoryPath     @"fsSearchHistory"
#define FSSearchHistoryUserId   @"master"

static NSString *UserInfoDBName = @"userinfo.dat";
static NSString *UserInfoDBTableName = @"userinfo";

static NSString *UserInfoDBTableContent = @"userid text NOT NULL PRIMARY KEY, mobilephone text NOT NULL, token text NOT NULL, rftoken text, username text, usertype text, idcard text, nickname text, email text, sex text, headurl text, birthtime text, isfacialverify bool, isrealname bool, isidauth bool, job text, jobinfo text, ability text, organization text, workaddress text, worklocation text, workspace text, workproofurl text, employmenttime integer, workinglife integer, signature text, workexperience text, lastupdatets double";

static NSString *UserInfoDBTableInsert = @"(userid, mobilephone, token, rftoken, username, usertype, idcard, nickname, email, sex, headurl, birthtime, isfacialverify, isrealname, isidauth, job, jobinfo, ability, organization, workaddress, worklocation, workspace, workproofurl, employmenttime, workinglife, signature, workexperience, lastupdatets) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";


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

+ (FSUserInfoModel *)getUserInfoWithUserId:(NSString *)userId
{
    if (![userId bm_isNotEmpty])
    {
        return nil;
    }
    
    __block FSUserInfoModel *userInfo = nil;
    __block BOOL result = YES;
    
    NSString *encodeUserId = [FSEncodeAPI encodeDES:userId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid = '%@'", UserInfoDBTableName, encodeUserId];
    [FSDB executeQuery:sql inDb:UserInfoDBName queryResBlock:^(FMDatabase *DB, FMResultSet *rs) {
        if ([rs next])
        {
            userInfo = [[FSUserInfoModel alloc] init];
            
            // 最后更新时间: lastupdatets
            userInfo.m_LastUpdateTs = [rs doubleForColumn:@"lastupdatets"];
            
            // 🔐用户令牌token(登录注册)💡: token
            NSString *dbToken = [rs stringForColumn:@"token"];
            userInfo.m_Token = [FSEncodeAPI decodeDES:dbToken];
            // 🔐用户刷新令牌💡: rftoken
            NSString *dbRefreshToke = [rs stringForColumn:@"rftoken"];
            userInfo.m_RefreshToken = [FSEncodeAPI decodeDES:dbRefreshToke];

            // Base
            userInfo.m_UserBaseInfo = [[FSUserBaseInfoModel alloc] init];

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
            NSString *dbPhoneNum = [rs stringForColumn:@"mobilephone"];
            userInfo.m_UserBaseInfo.m_PhoneNum = [FSEncodeAPI decodeDES:dbPhoneNum];
            // 🔐身份证号: idcard
            NSString *dbIdCardNo = [rs stringForColumn:@"idcard"];
            userInfo.m_UserBaseInfo.m_IdCardNo = [FSEncodeAPI decodeDES:dbIdCardNo];
            // 🔐邮箱: email
            NSString *dbEmail = [rs stringForColumn:@"email"];
            userInfo.m_UserBaseInfo.m_Email = [FSEncodeAPI decodeDES:dbEmail];
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

            // 身份认证: isIdAuth
            userInfo.m_UserBaseInfo.m_IsIdAuth = [rs boolForColumn:@"isidauth"];
            // 职位: job
            userInfo.m_UserBaseInfo.m_Job = [rs stringForColumn:@"job"];
            
            
#pragma mark - searchUserBaseInfo

            // 生日: birthTime
            userInfo.m_UserBaseInfo.m_Birthday =[rs doubleForColumn:@"birthtime"];

            // 擅长领域: ability ','分割成数组
            userInfo.m_UserBaseInfo.m_Ability = [rs stringForColumn:@"ability"];

            // 工作机构: workOrganization
            userInfo.m_UserBaseInfo.m_Organization = [rs stringForColumn:@"organization"];
            // 工作年限: workingLife
            userInfo.m_UserBaseInfo.m_WorkingLife = (NSUInteger)[rs unsignedLongLongIntForColumn:@"workinglife"];
            // 从业时间: employmentTime
            userInfo.m_UserBaseInfo.m_EmploymentTime = (NSUInteger)[rs unsignedLongLongIntForColumn:@"employmenttime"];

            // 工作单位地址区域: workLocation
            userInfo.m_UserBaseInfo.m_CompanyArea = [rs stringForColumn:@"worklocation"];
            // 工作单位地址: workAddress
            userInfo.m_UserBaseInfo.m_CompanyAddress = [rs stringForColumn:@"workaddress"];
            // 工作单位服务区域信息: workspace
            userInfo.m_UserBaseInfo.m_WorkArea = [rs stringForColumn:@"workspace"];
            // 工作证明url: workProofUrl
            userInfo.m_UserBaseInfo.m_WorkProofUrl = [rs stringForColumn:@"workproofurl"];
            // 专业职务: jobInfo
            userInfo.m_UserBaseInfo.m_ProfessionalQualification = [rs stringForColumn:@"jobinfo"];
            // 工作经历: workExperience
            userInfo.m_UserBaseInfo.m_WorkExperience = [rs stringForColumn:@"workexperience"];

            // 个人签名: personalitySignature
            userInfo.m_UserBaseInfo.m_Signature = [rs stringForColumn:@"signature"];
        }
        result = ![DB hadError];
    }];
    
    if (result)
    {
        return userInfo;
    }
    
    return nil;
}

+ (BOOL)insertAndUpdateUserInfo:(FSUserInfoModel *)userInfo
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
        NSString *emial = [FSEncodeAPI encodeDES:userInfo.m_UserBaseInfo.m_Email];
        NSString *realName = [FSEncodeAPI encodeDES:userInfo.m_UserBaseInfo.m_RealName];
        NSString *idCardNo = [FSEncodeAPI encodeDES:userInfo.m_UserBaseInfo.m_IdCardNo];
        
        result = [UserInfoDB executeUpdate:sql, userId, phoneNum, token, rftoken, realName, userInfo.m_UserBaseInfo.m_UserType, idCardNo, userInfo.m_UserBaseInfo.m_NickName, emial, userInfo.m_UserBaseInfo.m_Sex, userInfo.m_UserBaseInfo.m_AvatarUrl, @(userInfo.m_UserBaseInfo.m_Birthday), @(userInfo.m_UserBaseInfo.m_IsFacialVerify), @(userInfo.m_UserBaseInfo.m_IsRealName), @(userInfo.m_UserBaseInfo.m_IsIdAuth), userInfo.m_UserBaseInfo.m_Job, userInfo.m_UserBaseInfo.m_Job, userInfo.m_UserBaseInfo.m_Ability, userInfo.m_UserBaseInfo.m_Organization, userInfo.m_UserBaseInfo.m_CompanyAddress, userInfo.m_UserBaseInfo.m_CompanyArea, userInfo.m_UserBaseInfo.m_WorkArea, userInfo.m_UserBaseInfo.m_WorkProofUrl, @(userInfo.m_UserBaseInfo.m_EmploymentTime), @(userInfo.m_UserBaseInfo.m_WorkingLife), userInfo.m_UserBaseInfo.m_Signature, userInfo.m_UserBaseInfo.m_ProfessionalQualification, @(lastUpdateTs)];
    }];
    
    return result;
}

NSString *const FSUserInfoCaseSearchHistoryKey = @"com.ftls.caseSearchHistory";
NSString *const FSUserInfoLawSearchHistoryKey = @"com.ftls.lawSearchHistory";
NSString *const FSUserInfoTextSearchHistoryKey = @"com.ftls.textSearchHistory";

+ (NSString *)getSearchHistoryPath
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [NSString bm_libraryPath], FSSearchHistoryPath];
    BMLog(@"%@", path);
    
    return path;
}

+ (BOOL)makeSearchHistoryPath
{
    NSString *path = [FSUserInfoDB getSearchHistoryPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!existed || !isDir)
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error)
        {
            return NO;
        }
    }
    
    return YES;
}

+ (NSArray *)getSearchHistoryWithUserId:(NSString *)userId key:(NSString *)key
{
    if (![userId bm_isNotEmpty])
    {
        userId = FSSearchHistoryUserId;
    }
    
    NSString *plistPath = FSSEARCH_HISTORY_CACHEFILE(key, userId);
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    
    return array;
}

+ (void)saveSearchHistoryWithUserId:(NSString *)userId key:(NSString *)key searchHistories:(NSArray *)searchHistories
{
    if (![userId bm_isNotEmpty])
    {
        userId = FSSearchHistoryUserId;
    }
    
    NSString *plistPath = FSSEARCH_HISTORY_CACHEFILE(key, userId);
    [searchHistories writeToFile:plistPath atomically:NO];
}

+ (void)cleanUserSearchHistroyDataWithUserId:(NSString *)userId
{
    if (![userId bm_isNotEmpty])
    {
        userId = FSSearchHistoryUserId;
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:FSSEARCH_HISTORY_CACHEFILE(FSUserInfoCaseSearchHistoryKey, userId) error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:FSSEARCH_HISTORY_CACHEFILE(FSUserInfoLawSearchHistoryKey, userId) error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:FSSEARCH_HISTORY_CACHEFILE(FSUserInfoTextSearchHistoryKey, userId) error:nil];
}

@end
