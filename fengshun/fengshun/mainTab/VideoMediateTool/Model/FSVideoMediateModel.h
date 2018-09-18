//
//  FSVideoMediateModel.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSuperModel.h"


typedef NS_ENUM(NSInteger, FSMeetingDataType) {
    FSMeetingDataType_MeetingType = 1,      // 会议类型  不含全部
    FSMeetingDataType_AllMeetingType,       // 会议类型  含全部
    FSMeetingDataType_MeetingStatus,        // 会议状态  不含全部
    FSMeetingDataType_AllMeetingStatus,     // 会议状态  含全部
    FSMeetingDataType_PersonIdentityType    // 人员身份
};


@interface FSMeetingDataForm : NSObject

+ (NSArray *)getMeetingDataAllValuesWithType:(FSMeetingDataType)type;
+ (NSString *)getValueForKey:(NSString *)key type:(FSMeetingDataType)type;
+ (NSString *)getKeyForVlaue:(NSString *)value type:(FSMeetingDataType)type;
+ (NSArray *)formMeetingDataToModelWithType:(FSMeetingDataType)type;

@end

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


@interface FSSelectorListModel : NSObject
@property (nonatomic, strong) NSString *showName;   // 表现出来的名称
@property (nonatomic, strong) NSString *hiddenkey;  // 隐形key
+ (instancetype)modelWithName:(NSString *)name key:(NSString *)key;
- (instancetype)initWithName:(NSString *)name key:(NSString *)key;
@end


@interface FSHeaderCommonSelectorModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *hiddenkey;  // 隐形key
@property (nonatomic, strong) NSArray<FSSelectorListModel *> *list;
+ (instancetype)modelWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)list;
- (instancetype)initWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)list;
@end



@interface FSVideoRecordModel : FSSuperModel
// 媒体流ID
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *joinUser;
// 播放地址URL
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *preview;

// 上传时间
@property (nonatomic, assign) NSTimeInterval uploadTime;

@end



