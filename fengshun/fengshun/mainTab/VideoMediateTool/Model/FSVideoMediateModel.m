//
//  FSVideoMediateModel.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateModel.h"
#import "FSUserInfoModle.h"


static NSDictionary *FSMeetingSimpleTypeDic;
static NSDictionary *FSMeetingSimpleStatusDic;
static NSDictionary *FSMeetingAllTypeDic;
static NSDictionary *FSMeetingAllStatusDic;
static NSDictionary *FSMeetingPersonIdentityTypeDic;

@implementation FSMeetingDataForm

+ (NSDictionary *)getMeetingDataDicWithType:(FSMeetingDataType)type
{
    switch (type) {
        case FSMeetingDataType_MeetingType:
            return [self sharedMeetingSimpleTypeDic];
            break;
            
        case FSMeetingDataType_AllMeetingType:
            return [self sharedMeetingAllTypeDic];
            break;
            
        case FSMeetingDataType_MeetingStatus:
            return [self sharedMeetingSimpleStatusDic];
            break;
            
        case FSMeetingDataType_AllMeetingStatus:
            return [self sharedMeetingAllStatusDic];
            break;
            
        case FSMeetingDataType_PersonIdentityType:
            return [self sharedMeetingPersonIdentityTypeDic];
            break;
    }
    
    return nil;
}

+ (NSArray *)getMeetingDataAllValuesWithType:(FSMeetingDataType)type
{
    switch (type) {
        case FSMeetingDataType_MeetingType:
            return @[@"调解", @"调查"];
            break;
            
        case FSMeetingDataType_AllMeetingType:
            return @[@"全部", @"调解", @"调查"];
            break;
            
        case FSMeetingDataType_MeetingStatus:
            return @[@"未开始", @"进行中", @"已结束"];
            break;
            
        case FSMeetingDataType_AllMeetingStatus:
            return @[@"全部", @"未开始", @"进行中", @"已结束"];
            break;
            
        case FSMeetingDataType_PersonIdentityType:
            return @[@"申请人", @"被申请人", @"申请人一般代理人", @"被申请人一般代理人", @"申请人特别授权代理人", @"被申请人特别授权代理人"];
            break;
    }
    
    return nil;
}

+ (NSString *)getValueForKey:(NSString *)key type:(FSMeetingDataType)type
{
    NSDictionary *dic = [self getMeetingDataDicWithType:type];
    return [dic valueForKey:key];
}

+ (NSString *)getKeyForVlaue:(NSString *)value type:(FSMeetingDataType)type
{
    NSDictionary *dic = [self getMeetingDataDicWithType:type];

    for (NSString *key in [dic allKeys]) {
        if ([[dic valueForKey:key] isEqualToString:value]) {
            return key;
        }
    }
    
    return nil;
}

+ (NSArray *)formMeetingDataToModelWithType:(FSMeetingDataType)type
{
    NSMutableArray *temp = [NSMutableArray array];
    NSArray *allVlaues = [self getMeetingDataAllValuesWithType:type];
    for (NSString *value in allVlaues) {
        NSString *key = [self getKeyForVlaue:value type:type];
        FSSelectorListModel *model = [FSSelectorListModel modelWithName:value key:key];
        [temp addObject:model];
    }
    
    return [NSArray arrayWithArray:temp];
}

+ (NSDictionary *)sharedMeetingSimpleTypeDic
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        FSMeetingSimpleTypeDic = @{@"MEETING_MEDIATE":@"调解",
                                   @"MEETING_SURVEY":@"调查",
                                   };
    });
    
    return FSMeetingSimpleTypeDic;
}

+(NSDictionary *)sharedMeetingAllTypeDic
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        FSMeetingAllTypeDic = @{@"MEETING_TYPE_OR":@"全部",
                                @"MEETING_MEDIATE":@"调解",
                                @"MEETING_SURVEY":@"调查",
                                };
    });
    
    return FSMeetingAllTypeDic;
}

+(NSDictionary *)sharedMeetingSimpleStatusDic
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        FSMeetingSimpleStatusDic = @{@"MEETING_NOT_START":@"未开始",
                                     @"MEETING_UNDERWAY":@"进行中",
                                     @"MEETING_END":@"已结束",
                                     };
    });
    
    return FSMeetingSimpleStatusDic;
}

+(NSDictionary *)sharedMeetingAllStatusDic
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        FSMeetingAllStatusDic = @{@"MEETING_STATUS_OR":@"全部",
                                  @"MEETING_NOT_START":@"未开始",
                                  @"MEETING_UNDERWAY":@"进行中",
                                  @"MEETING_END":@"已结束",
                                  };
    });
    
    return FSMeetingAllStatusDic;
}

+(NSDictionary *)sharedMeetingPersonIdentityTypeDic
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        FSMeetingPersonIdentityTypeDic = @{@"APPLICAT":@"申请人",
                                           @"RESPONDENT":@"被申请人",
                                           @"APPLICAT_GENERAL_AGENT":@"申请人一般代理人",
                                           @"APPLICAT_ESPECIALLY_IMPOWER_AGENTAPPLICAT":@"申请人特别授权代理人",
                                           @"RESPONDENT_GENERAL_AGENT":@"被申请人一般代理人",
                                           @"RESPONDENT_ESPECIALLY_IMPOWER_AGENT":@"被申请人特别授权代理人",
                                           @"MEDIATOR":@"调解员",
                                           };
        
    });

    return FSMeetingPersonIdentityTypeDic;
}

@end


@implementation FSMeetingPersonnelModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSMeetingPersonnelModel *model = [[self alloc] init];
    model.personnelId                            = [params bm_intForKey:@"id"];
    model.userName                      = [params bm_stringForKey:@"userName"];
    model.inviteCode                    = [params bm_stringForKey:@"inviteCode"];
    model.mobilePhone                   = [params bm_stringForKey:@"mobilePhone"];
    model.meetingIdentityTypeEnums      = [params bm_stringForKey:@"meetingIdentityTypeEnums"];
    return model;
}

+ (instancetype)userModel
{
    FSUserInfoModle *user = [FSUserInfoModle userInfo];
    
    FSMeetingPersonnelModel *model = [FSMeetingPersonnelModel new];
    model.personnelId = [user.m_UserBaseInfo.m_UserId integerValue];
    model.mobilePhone = user.m_UserBaseInfo.m_PhoneNum;
    model.userName = user.m_UserBaseInfo.m_RealName;
    model.meetingIdentityTypeEnums = @"MEDIATOR";

    return model;
}

@end


@implementation FSMeetingDetailModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    FSMeetingDetailModel *model = [[self alloc] init];
    model.meetingId         = [params bm_intForKey:@"id"];
    model.creatorId         = [params bm_intForKey:@"creatorId"];
    model.roomId            = [params bm_stringForKey:@"roomId"];
    model.meetingName       = [params bm_stringForKey:@"meetingName"];
    model.meetingType       = [params bm_stringForKey:@"meetingType"];
    model.meetingStatus     = [params bm_stringForKey:@"meetingStatus"];
    model.meetingContent    = [params bm_stringForKey:@"meetingContent"];
    model.startTime         = [params bm_doubleForKey:@"startTime"];
    model.endTime           = [params bm_doubleForKey:@"endTime"];
    model.meetingType       = [params bm_stringForKey:@"meetingType"];
    model.meetingInvite       = [params bm_stringForKey:@"meetingInvite"];
    
    model.meetingPersonnelResponseDTO = [FSMeetingPersonnelModel modelsWithDataArray:[params bm_arrayForKey:@"meetingPersonnelResponseDTO"]];
    return model;
}


- (NSDictionary *)formToParameters
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.meetingContent) {
        [dic bm_setString:self.meetingContent forKey:@"meetingContent"];
    }
    [dic bm_setString:self.meetingName forKey:@"meetingName"];
    [dic bm_setString:self.meetingType forKey:@"meetingType"];
    [dic bm_setString:self.orderHour forKey:@"orderHour"];
    NSString *time  = [NSString stringWithFormat:@"%.0f",self.startTime];
    [dic setObject:[NSNumber numberWithDouble:[time doubleValue]]  forKey:@"startTime"];

    NSMutableArray *array = [NSMutableArray array];
    for (FSMeetingPersonnelModel *model in self.meetingPersonnelResponseDTO) {
        
        if (model.selectState != 1) {
            continue;
        }
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic bm_setString:model.userName forKey:@"userName"];
        [tempDic bm_setString:model.mobilePhone forKey:@"mobilePhone"];
        [tempDic bm_setString:model.meetingIdentityTypeEnums forKey:@"meetingIdentityTypeEnums"];
        [array addObject:tempDic];
    }
    [dic setObject:array forKey:@"list"];

    return dic;
}

- (NSString *)getMeetingPersonnelNameList
{
    NSMutableString *string = [NSMutableString string];
    NSInteger count = self.meetingPersonnelResponseDTO.count;
    if (count > 2)
    {
        for (int index = 0; index < 2; index++) {
            FSMeetingPersonnelModel *model = self.meetingPersonnelResponseDTO[index];
            [string appendString:model.userName];
            [string appendString:@"、"];
        }

        [string appendString:[NSString stringWithFormat:@"等%ld人", count]];
    }
    else
    {
        NSInteger index = 0;
        for (FSMeetingPersonnelModel *model in self.meetingPersonnelResponseDTO) {
            [string appendString:model.userName];
            index ++;
            if (index < count) {
                [string appendString:@"、"];
            }
        }
    }
    return string;
}

@end


@implementation FSHeaderCommonSelectorModel

+ (instancetype)modelWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)list
{
    return [[FSHeaderCommonSelectorModel alloc] initWithTitle:title hiddenkey:key list:list];
}

- (instancetype)initWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)list
{
    self = [super init];
    
    if (self) {
        _title = title;
        _hiddenkey = key;
        _list = list;
    }
    
    return self;
}

@end


@implementation FSSelectorListModel

+ (instancetype)modelWithName:(NSString *)name key:(NSString *)key
{
    return [[FSSelectorListModel alloc] initWithName:name key:key];
}

- (instancetype)initWithName:(NSString *)name key:(NSString *)key
{
    self = [super init];
    
    if (self) {
        _showName = name;
        _hiddenkey = key;
    }
    
    return self;
}

@end

