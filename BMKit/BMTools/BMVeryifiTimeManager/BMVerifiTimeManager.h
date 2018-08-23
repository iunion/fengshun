//
//  BMVerifiTimeManager.h
//  BMBaseKit
//
//  Created by DennisDeng on 16/4/21.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BMVerificationCodeType)
{
    BMVerificationCodeType_Unknown = 0,
    BMVerificationCodeType_Type1 = 1,
    BMVerificationCodeType_Type2 = 2,
    BMVerificationCodeType_Type3 = 3,
    BMVerificationCodeType_Type4 = 4,
    BMVerificationCodeType_Type5 = 5,
    BMVerificationCodeType_Type6 = 6
};

@interface BMVerifiTimeManager : NSObject

typedef void(^BMVerifiTimeBlock)(BMVerificationCodeType type, NSInteger ticket, BOOL stop);


+ (BMVerifiTimeManager *)manager;

// 启动计时
- (NSInteger)startTimeWithType:(BMVerificationCodeType)type process:(BMVerifiTimeBlock)verifiBlock;
- (NSInteger)startTimeWithType:(BMVerificationCodeType)type duration:(CFTimeInterval)duration process:(BMVerifiTimeBlock)verifiBlock;


// 停止计时，并调用block
- (void)stopTimeWithType:(BMVerificationCodeType)type;
// 不停止计时，只去除block调用
- (void)removeBlockWithType:(BMVerificationCodeType)type;

// 停止所有计时，不会调用block
- (void)stopAllType;

// 检查当前计时状态
- (NSInteger)checkTimeWithType:(BMVerificationCodeType)type process:(BMVerifiTimeBlock)verifiBlock;

@end
