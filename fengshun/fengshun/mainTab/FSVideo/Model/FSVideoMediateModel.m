//
//  FSVideoMediateModel.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateModel.h"
#import "FSUserInfoModel.h"

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
    FSUserInfoModel *user = [FSUserInfoModel userInfo];
    
    FSMeetingPersonnelModel *model = [FSMeetingPersonnelModel new];
    model.personnelId = [user.m_UserBaseInfo.m_UserId integerValue];
    model.mobilePhone = user.m_UserBaseInfo.m_PhoneNum;
    model.userName = user.m_UserBaseInfo.m_RealName;
    model.meetingIdentityTypeEnums = [FSMeetingDataEnum meetingMediatorEnglish];

    return model;
}

- (NSDictionary *)formToParametersWithPersonnelId:(BOOL)withID
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic bm_setString:self.userName forKey:@"userName"];
    [tempDic bm_setString:self.mobilePhone forKey:@"mobilePhone"];
    [tempDic bm_setString:self.meetingIdentityTypeEnums forKey:@"meetingIdentityTypeEnums"];
    
    if (withID) {
        [tempDic setObject:@(self.personnelId) forKey:@"id"];
    }
    
    return tempDic;
}

- (BOOL)isMediatorPerson
{
    return [FSMeetingDataEnum isMediatorIdentity:self.meetingIdentityTypeEnums];
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


- (NSDictionary *)formToParametersWithPersonnelId:(BOOL)withID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.meetingContent) {
        [dic bm_setString:self.meetingContent forKey:@"meetingContent"];
    }
    if (self.meetingId > 0) {
        [dic setObject:@(self.meetingId) forKey:@"id"];
    }
    [dic bm_setString:self.meetingName forKey:@"meetingName"];
    [dic bm_setString:self.meetingType forKey:@"meetingType"];
    [dic bm_setString:self.orderHour forKey:@"orderHour"];
    [dic setObject:@(self.startTime)  forKey:@"startTime"];

    NSMutableArray *array = [NSMutableArray array];
    for (FSMeetingPersonnelModel *model in self.meetingPersonnelResponseDTO) {
        
        if (model.selectState != 1 || [model isMediatorPerson]) {
            continue;
        }
        [array addObject:[model formToParametersWithPersonnelId:withID]];
    }
    [dic setObject:array forKey:@"list"];

    return dic;
}

- (NSString *)getMeetingPersonnelNameListWithShowCount:(NSInteger)count;
{
    NSMutableString *string = [NSMutableString string];
    NSInteger allCount = self.meetingPersonnelResponseDTO.count;
    if (allCount > count)
    {
        for (int index = 0; index < count; index++) {
            FSMeetingPersonnelModel *model = self.meetingPersonnelResponseDTO[index];
            [string appendString:model.userName];
            if (index < count - 1) {
                [string appendString:@"、"];
            }
        }

        [string appendString:[NSString stringWithFormat:@"等%@人", @(allCount)]];
    }
    else
    {
        NSInteger index = 0;
        for (FSMeetingPersonnelModel *model in self.meetingPersonnelResponseDTO) {
            [string appendString:model.userName];
            index ++;
            if (index < allCount) {
                [string appendString:@"、"];
            }
        }
    }
    return string;
}

- (FSMeetingPersonnelModel *)getMeetingMediator
{
    for (FSMeetingPersonnelModel *model in self.meetingPersonnelResponseDTO) {
        if ([model isMediatorPerson]) {
            return model;
        }
    }

    return nil;
}

@end


@implementation FSVideoRecordModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    if ([[params bm_stringForKey:@"preview"] bm_isNotEmpty]) {
        FSVideoRecordModel *model = [[self alloc] init];
        model.uploadTime                    = [params bm_doubleForKey:@"uploadTime"];
        model.download                      = [params bm_stringForKey:@"download"];
        model.joinUser                      = [params bm_stringForKey:@"joinUser"];
        model.preview                       = [params bm_stringForKey:@"preview"];
        model.url                           = [params bm_stringForKey:@"url"];
        return model;
    }
    
    return nil;
}
@end

