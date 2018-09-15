//
//  MDTMeetingListModel.h
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//


/**
 会议类型
 
 - MeetingTypeUnknown: 未知
 */
typedef NS_ENUM(NSInteger, MeetingType) {
    MeetingTypeUnknown, ///< 未知
    MeetingTypeMediate, ///< 调解
    MeetingTypeSurvey, ///< 调查
};


#import <Foundation/Foundation.h>

@interface MDTMeetingListModel : NSObject
@property (nonatomic, assign) NSInteger lawCaseId;
@property (nonatomic, assign) NSInteger id; ///< 会议id
@property (nonatomic, copy) NSString *joinUserName; ///< 参会人员
@property (nonatomic, assign) int64_t orderTime; ///< 会议开始时间
@property (nonatomic, assign) MeetingType meetingType; ///< 会议类型
@property (nonatomic, copy) NSString *meetingName; ///< 会议名称
@property (nonatomic, assign) BOOL orderType; ///< 1为线下。0位线上。
@property (nonatomic, copy) NSString *meetingContent; ///< 会议内容
@property (nonatomic, copy) NSString *meetingVideoId; ///< 会议内容
@end
