//
//  FSApiRequest+VideoMediate.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSApiRequest.h"

@implementation FSApiRequest (VideoMediate)

+ (nullable NSMutableURLRequest *)getMeetingListWithType:(NSString *)meetingTypeEnums
                                                  status:(NSString *)meetingStatusEnums
                                               pageIndex:(NSInteger)pageIndex
                                                pageSize:(NSInteger)pageSize
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/meeting/getMeetingList", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:pageIndex forKey:@"pageIndex"];
    [parameters bm_setInteger:pageSize forKey:@"pageSize"];
    [parameters bm_setString:meetingTypeEnums forKey:@"meetingTypeEnums"];
    [parameters bm_setString:meetingStatusEnums forKey:@"meetingStatusEnums"];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

+ (nullable NSMutableURLRequest *)saveMeetingWithInfo:(NSDictionary *)dic
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/meeting/saveMeeting", FS_URL_SERVER];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:dic];
}

+ (nullable NSMutableURLRequest *)getMeetingDetailWithId:(NSInteger)meetingId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/meeting/meetingDetail", FS_URL_SERVER];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:@{@"id":@(meetingId)}];
}

+ (nullable NSMutableURLRequest *)inviteListPersonnelWithId:(NSInteger)meetingId personList:(NSArray *)list
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/meeting/inviteListPersonnel", FS_URL_SERVER];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setInteger:meetingId forKey:@"id"];
    [parameters setObject:list forKey:@"meetingPersonnelRequestDTO"];

    return [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
}

+ (nullable NSMutableURLRequest *)getRoomMessageRecordList:(NSInteger)roomId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/meeting/getMessageRecord", FS_URL_SERVER];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:@{@"roomId":@(roomId)}];
}

+ (nullable NSMutableURLRequest *)getMeetingVideoList:(NSInteger)meetingId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/storm/meeting/getVideoList", FS_URL_SERVER];
    return [FSApiRequest makeRequestWithURL:urlStr parameters:@{@"id":@(meetingId)}];
}

@end
