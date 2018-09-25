//
//  FSVideoMediateModel.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSMeetingDataEnum.h"
#import "FSSuperModel.h"

// 参会人员model
@interface FSMeetingPersonnelModel : FSSuperModel
@property (nonatomic, assign) NSInteger personnelId;
@property (nonatomic, copy) NSString *inviteCode;               // 邀请码
@property (nonatomic, copy) NSString *meetingIdentityTypeEnums; // 身份类型
@property (nonatomic, copy) NSString *mobilePhone;              // 手机号码
@property (nonatomic, copy) NSString *userName;                 // 邀请人姓名
@property (nonatomic, assign) NSUInteger selectState;           // 选中状态 0没选中 1选中

+ (instancetype)userModel;

- (NSDictionary *)formToParametersWithPersonnelId:(BOOL)withID;

- (BOOL)isMediatorPerson;

@end

// 会议列表简单类型
@interface FSMeetingDetailModel : FSSuperModel
@property (nonatomic, assign) NSInteger meetingId;
@property (nonatomic, copy) NSString *roomId;           // 房间id
@property (nonatomic, copy) NSString *meetingContent;   // 会议内容
@property (nonatomic, copy) NSString *meetingName;      // 会议名称
@property (nonatomic, copy) NSString *meetingStatus;    // 会议状态
@property (nonatomic, copy) NSString *meetingType;  //会议类型
@property (nonatomic, assign) NSTimeInterval startTime; // 会议开始时间
@property (nonatomic, assign) NSTimeInterval endTime;   // 会议结束时间
@property (nonatomic, strong) NSArray<FSMeetingPersonnelModel *> *meetingPersonnelResponseDTO; // 参会人员
@property (nonatomic, assign) NSInteger creatorId;    // 创建人id
@property (nonatomic, copy) NSString *meetingInvite;//会议邀请链接
@property (nonatomic, copy) NSString *orderHour;

- (NSDictionary *)formToParametersWithPersonnelId:(BOOL)withID;
- (NSString *)getMeetingPersonnelNameListWithShowCount:(NSInteger)count;
- (FSMeetingPersonnelModel *)getMeetingMediator;
@end


@interface FSVideoRecordModel : FSSuperModel

@property (nonatomic, copy) NSString *download;// 媒体流ID
@property (nonatomic, copy) NSString *joinUser;
@property (nonatomic, copy) NSString *url;      // 播放地址URL
@property (nonatomic, copy) NSString *preview;
@property (nonatomic, assign) NSTimeInterval uploadTime;// 上传时间

@end



