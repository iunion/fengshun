//
//  FSMeetingDataEnum.m
//  fengshun
//
//  Created by ILLA on 2018/9/20.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMeetingDataEnum.h"

static NSArray *FSMeetingTypeEnglishArray;
static NSArray *FSMeetingTypeChineseArray;
static NSArray *FSMeetingStatusEnglishArray;
static NSArray *FSMeetingStatusChineseArray;
static NSArray *FSMeetingIdentityEnglishArray;
static NSArray *FSMeetingIdentityChineseArray;


@implementation FSMeetingDataEnum

#pragma mark -
#pragma mark 会议类型
+ (NSArray *)meetingTypeChineseArrayContainAll:(BOOL)contain
{
    [self sharedMeetingDataEnumInit];

    NSMutableArray *result = [NSMutableArray arrayWithArray:FSMeetingTypeChineseArray];

    if (!contain) {
        [result bm_removeFirstObject];
    }

    return [NSArray arrayWithArray:result];
}

+ (NSString *)meetingTypeEnglishToChinese:(NSString *)en
{
    [self sharedMeetingDataEnumInit];

    NSInteger index = [FSMeetingTypeEnglishArray indexOfObject:en];
    return [FSMeetingTypeChineseArray objectAtIndex:index];
}

+ (NSString *)meetingTypeChineseToEnglish:(NSString *)ch
{
    [self sharedMeetingDataEnumInit];

    NSInteger index = [FSMeetingTypeChineseArray indexOfObject:ch];
    return [FSMeetingTypeEnglishArray objectAtIndex:index];
}

+ (NSString *)meetingTypeAllEnglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingTypeEnglishArray.firstObject;
}

+ (NSString *)meetingTypeMediateEnglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingTypeEnglishArray[1];
}

#pragma mark -
#pragma mark 会议状态
+ (NSArray *)meetingStatusChineseArrayContainAll:(BOOL)contain
{
    [self sharedMeetingDataEnumInit];

    NSMutableArray *result = [NSMutableArray arrayWithArray:FSMeetingStatusChineseArray];
    
    if (!contain) {
        [result bm_removeFirstObject];
    }
    
    return [NSArray arrayWithArray:result];
}

+ (NSString *)meetingStatusEnglishToChinese:(NSString *)en
{
    [self sharedMeetingDataEnumInit];

    NSInteger index = [FSMeetingStatusEnglishArray indexOfObject:en];
    return [FSMeetingStatusChineseArray objectAtIndex:index];
}

+ (NSString *)meetingStatusChineseToEnglish:(NSString *)ch
{
    [self sharedMeetingDataEnumInit];

    NSInteger index = [FSMeetingStatusChineseArray indexOfObject:ch];
    return [FSMeetingStatusEnglishArray objectAtIndex:index];
}

+ (NSString *)meetingStatusAllEnglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingStatusEnglishArray.firstObject;
}

+ (NSString *)meetingStatusNoStartEnglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingStatusEnglishArray[1];
}

+ (NSString *)meetingStatusUnderwayEnglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingStatusEnglishArray[2];
}

+ (NSString *)meetingStatusEndEnglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingStatusEnglishArray.lastObject;
}

#pragma mark -
#pragma mark 参会人员身份
+ (NSArray *)meetingIdentityChineseArrayContainMediator:(BOOL)contain
{
    [self sharedMeetingDataEnumInit];

    NSMutableArray *result = [NSMutableArray arrayWithArray:FSMeetingIdentityChineseArray];
    
    if (!contain) {
        [result bm_removeFirstObject];
    }
    
    return [NSArray arrayWithArray:result];
}

+ (NSString *)meetingIdentityEnglishToChinese:(NSString *)en
{
    [self sharedMeetingDataEnumInit];

    NSInteger index = [FSMeetingIdentityEnglishArray indexOfObject:en];
    return [FSMeetingIdentityChineseArray objectAtIndex:index];
}

+ (NSString *)meetingIdentityChineseToEnglish:(NSString *)ch
{
    [self sharedMeetingDataEnumInit];

    NSInteger index = [FSMeetingIdentityChineseArray indexOfObject:ch];
    return [FSMeetingIdentityEnglishArray objectAtIndex:index];
}

+ (NSString *)meetingMediatorEnglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingIdentityEnglishArray.firstObject;
}

+ (NSString *)meetingApplicatenglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingIdentityEnglishArray[1];
}

+ (NSString *)meetingRespondentenglish
{
    [self sharedMeetingDataEnumInit];
    return FSMeetingIdentityEnglishArray[2];
}

+ (BOOL)isMediatorIdentity:(NSString *)str
{
    return ([str isEqualToString:FSMeetingIdentityEnglishArray.firstObject] ||
            [str isEqualToString:FSMeetingIdentityChineseArray.firstObject]);
}

#pragma mark -
#pragma mark Data

+ (void)sharedMeetingDataEnumInit
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        FSMeetingTypeEnglishArray = @[@"MEETING_TYPE_OR", @"MEETING_MEDIATE", @"MEETING_SURVEY"];
        FSMeetingTypeChineseArray = @[@"全部", @"调解", @"调查"];
        FSMeetingStatusEnglishArray = @[@"MEETING_STATUS_OR", @"MEETING_NOT_START", @"MEETING_UNDERWAY", @"MEETING_END"];
        FSMeetingStatusChineseArray = @[@"全部", @"未开始", @"进行中", @"已结束"];
        FSMeetingIdentityEnglishArray = @[@"MEDIATOR",
                                          @"APPLICAT",
                                          @"RESPONDENT",
                                          @"APPLICAT_GENERAL_AGENT",
                                          @"RESPONDENT_GENERAL_AGENT",
                                          @"APPLICAT_ESPECIALLY_IMPOWER_AGENTAPPLICAT",
                                          @"RESPONDENT_ESPECIALLY_IMPOWER_AGENT"];
        FSMeetingIdentityChineseArray = @[@"调解员",
                                          @"申请人",
                                          @"被申请人",
                                          @"申请人一般代理人",
                                          @"被申请人一般代理人",
                                          @"申请人特别授权代理人",
                                          @"被申请人特别授权代理人"];
    });
}

@end
