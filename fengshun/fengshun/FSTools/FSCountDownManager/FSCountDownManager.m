//
//  FSCountDownManager.m
//  fengshun
//
//  Created by jiang deng on 2018/11/15.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCountDownManager.h"

@implementation FSCountDownManager

// 开始倒计时
- (void)startCountDownWithType:(FSVerificationCodeType)countDownType processBlock:(BMCountDownProcessBlock)processBlock
{
    [self startCountDownWithIdentifier:@(countDownType) processBlock:processBlock];
}

- (void)startCountDownWithType:(FSVerificationCodeType)countDownType timeInterval:(NSInteger)timeInterval processBlock:(BMCountDownProcessBlock)processBlock
{
    [self startCountDownWithIdentifier:@(countDownType) timeInterval:timeInterval processBlock:processBlock];
}

// 获取倒计时
- (NSInteger)timeIntervalWithType:(FSVerificationCodeType)countDownType
{
    return [self timeIntervalWithIdentifier:@(countDownType)];
}

// 设置processBlock调用
- (void)setProcessBlock:(BMCountDownProcessBlock)processBlock withType:(FSVerificationCodeType)countDownType
{
    [self setProcessBlock:processBlock withIdentifier:@(countDownType)];
}

// 不停止计时，只去除processBlock调用
- (void)removeProcessBlockWithType:(FSVerificationCodeType)countDownType
{
    [self removeProcessBlockWithIdentifier:@(countDownType)];
}

// 停止倒计时，并调用processBlock
- (void)stopCountDownType:(FSVerificationCodeType)countDownType
{
    [self stopCountDownIdentifier:@(countDownType)];
}

// 是否正在倒计时
- (BOOL)isCountDownWithType:(FSVerificationCodeType)countDownType
{
    return [self isCountDownWithIdentifier:@(countDownType)];
}

@end
