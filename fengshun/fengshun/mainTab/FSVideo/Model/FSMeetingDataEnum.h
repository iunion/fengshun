//
//  FSMeetingDataEnum.h
//  fengshun
//
//  Created by ILLA on 2018/9/20.
//  Copyright © 2018年 FS. All rights reserved.
//  视频会议相关的枚举类型

#import <Foundation/Foundation.h>

#define FSMakeVideoMediateSuccessNotification               @"FSMakeVideoMediateSuccessNotification"
#define FSVideoMediateChangedNotification                   @"FSVideoMediateChangedNotification"

#define FSMEETING_PERSON_MAX_COUNT 8
#define FSMEETING_PERSON_MAXCOUNT_TIP [NSString stringWithFormat:@"参会人员不能大于%@人",@(FSMEETING_PERSON_MAX_COUNT)]

// 视频会议相关的枚举类型数据
@interface FSMeetingDataEnum : NSObject

#pragma mark 会议类型
+ (NSArray *)meetingTypeChineseArrayContainAll:(BOOL)contain;
+ (NSString *)meetingTypeEnglishToChinese:(NSString *)en;   // 英文转中文
+ (NSString *)meetingTypeChineseToEnglish:(NSString *)ch;   // 中文转英文
+ (NSString *)meetingTypeAllEnglish;                        // 英文的全部类型
+ (NSString *)meetingTypeMediateEnglish;                    // 英文的调解类型


#pragma mark 会议状态
+ (NSArray *)meetingStatusChineseArrayContainAll:(BOOL)contain;
+ (NSString *)meetingStatusEnglishToChinese:(NSString *)en;     // 英文转中文
+ (NSString *)meetingStatusChineseToEnglish:(NSString *)ch;     // 中文转英文
+ (NSString *)meetingStatusAllEnglish;                          // 英文的全部状态
+ (NSString *)meetingStatusNoStartEnglish;                     // 英文的未开始
+ (NSString *)meetingStatusUnderwayEnglish;                     // 英文的进行中
+ (NSString *)meetingStatusEndEnglish;                          // 英文的已结束


#pragma mark 参会人员身份
+ (NSArray *)meetingIdentityChineseArrayContainMediator:(BOOL)contain;
+ (NSString *)meetingIdentityEnglishToChinese:(NSString *)en;   // 英文转中文
+ (NSString *)meetingIdentityChineseToEnglish:(NSString *)ch;   // 中文转英文
+ (NSString *)meetingMediatorEnglish;
+ (NSString *)meetingApplicatenglish;
+ (NSString *)meetingRespondentenglish;
+ (BOOL)isMediatorIdentity:(NSString *)str;

@end

