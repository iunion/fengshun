
//
//  MDTMeetingListModel.m
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "MDTMeetingListModel.h"

@implementation MDTMeetingListModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *meetingType = dic[@"meetingType"];
    if ([meetingType isEqualToString:@"MEETING_MEDIATE"]) {
        _meetingType = MeetingTypeMediate;
    } else if ([meetingType isEqualToString:@"MEETING_SURVEY"]) {
        _meetingType = MeetingTypeSurvey;
    } else {
        _meetingType = MeetingTypeUnknown;
    }
    return YES;
}
@end
