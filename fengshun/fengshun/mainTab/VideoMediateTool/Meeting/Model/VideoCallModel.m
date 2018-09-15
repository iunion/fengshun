
//
//  VideoCallModel.m
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "VideoCallModel.h"

@implementation VideoCallMemberModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    VideoCallMemberModel *model = [[self alloc] init];
    model.memberId              = [params bm_stringForKey:@"memberId"];
    model.memberName            = [params bm_stringForKey:@"memberName"];
    model.memberType            = [params bm_stringForKey:@"memberType"];
    model.memberVoiceStatus     = [params bm_boolForKey:@"memberVoiceStatus"];
    model.memberVideoStatus     = [params bm_boolForKey:@"memberVideoStatus"];

    if ([params[@"memberStatus"] isEqualToString:@"ONLINE"]) {
        model.memberStatus = VideoCallMemberStatusOnline;
    } else {
        model.memberStatus = VideoCallMemberStatusOffline;
    }

    return model;
}
@end

@implementation VideoCallRoomModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    VideoCallRoomModel *model = [[self alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in params[@"members"]) {
        VideoCallMemberModel *temp = [VideoCallMemberModel modelWithParams:dic];
        [array addObject:temp];
    }
    model.members = [NSArray arrayWithArray:array];
    model.voiceDiscernSwitch = [params bm_boolForKey:@"voiceDiscernSwitch"];
    return model;
}
@end

@implementation RTCRoomInfoModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    RTCRoomInfoModel *model = [[self alloc] init];
    model.roomId                    = [params bm_intForKey:@"roomId"];
    model.userId                    = [params bm_stringForKey:@"userId"];
    model.userSig                   = [params bm_stringForKey:@"userSig"];
    model.privateMapKey             = [params bm_stringForKey:@"privateMapKey"];
    model.caseStatus                = [params bm_intForKey:@"caseStatus"];
    model.roomModel                 = [VideoCallRoomModel modelWithParams:params];
    return model;
}

@end


@implementation MDTVideoRecordModel

+ (instancetype)modelWithParams:(NSDictionary *)params
{
    MDTVideoRecordModel *model = [[self alloc] init];
    model.uploadTime                    = [params bm_longForKey:@"uploadTime"];
    model.download                      = [params bm_stringForKey:@"download"];
    model.joinUser                      = [params bm_stringForKey:@"joinUser"];
    model.url                           = [params bm_stringForKey:@"url"];
    return model;
}

@end
