//
//  FSCountDownManager.h
//  fengshun
//
//  Created by jiang deng on 2018/11/15.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMCountDownManager.h"
#import "FSApiRequest.h"


NS_ASSUME_NONNULL_BEGIN

@interface FSCountDownManager : BMCountDownManager

// 开始倒计时
- (void)startCountDownWithType:(FSVerificationCodeType)countDownType processBlock:(nullable BMCountDownProcessBlock)processBlock;
- (void)startCountDownWithType:(FSVerificationCodeType)countDownType timeInterval:(NSInteger)timeInterval processBlock:(nullable BMCountDownProcessBlock)processBlock;

// 获取倒计时
- (NSInteger)timeIntervalWithType:(FSVerificationCodeType)countDownType;

// 设置processBlock调用
- (void)setProcessBlock:(nullable BMCountDownProcessBlock)processBlock withType:(FSVerificationCodeType)countDownType;

// 不停止计时，只去除processBlock调用
- (void)removeProcessBlockWithType:(FSVerificationCodeType)countDownType;

// 停止倒计时，并调用processBlock
- (void)stopCountDownType:(FSVerificationCodeType)countDownType;

// 是否正在倒计时
- (BOOL)isCountDownWithType:(FSVerificationCodeType)countDownType;

@end

NS_ASSUME_NONNULL_END
