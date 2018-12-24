//
//  UIViewController+FSPushVCAPI.m
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "UIViewController+FSPushVCAPI.h"

@implementation UIViewController (FSPushVCAPI)

- (void)fspush_withModel:(FSPushVCModel *)pushModel
{
    switch (pushModel.m_pushType) {
        case FSPushToVCType_None:
            return;
            break;
            
        case FSPushToVCType_NotificationCenter:
            [FSPushVCManager showMessageVC:self andShowNotificationTab:YES];
            break;
        case FSPushToVCType_VideoMeeting:
#ifdef FSVIDEO_ON
            [FSPushVCManager meetingDetailVCShowInVC:self withMeetingId:pushModel.m_requestId];
#endif
            break;
        case FSPushToVCType_TopicVC:
            [FSPushVCManager showTopicDetail:self topicId:pushModel.m_requestId];
            break;
        case FSPushToVCType_CourseVC:
            [FSPushVCManager viewController:self pushToCourseDetailWithId:pushModel.m_requestId andIsSerial:NO];
            break;
    }
}

@end
