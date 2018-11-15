//
//  UIView+FSCountDownManager.m
//  fengshun
//
//  Created by jiang deng on 2018/11/15.
//Copyright © 2018 FS. All rights reserved.
//

#import "UIView+FSCountDownManager.h"
#import "NSObject+BMCategory.h"
#import <objc/runtime.h>

@implementation UIView (FSCountDownManager)
@dynamic countDownType;
@dynamic countDownProcessBlock;


- (FSVerificationCodeType)countDownType
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return [obj unsignedIntegerValue];
}

- (void)setCountDownType:(FSVerificationCodeType)type
{
    if (type == 0)
    {
        // identifier == 0，停止倒计时
        [self stopCountDown];
    }
    
    objc_setAssociatedObject(self, @selector(countDownType), @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BMCountDownProcessBlock)countDownProcessBlock
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setCountDownProcessBlock:(BMCountDownProcessBlock)processBlock
{
    if (self.countDownType == 0)
    {
        return;
    }
    
    if ([[FSCountDownManager manager] isCountDownWithType:self.countDownType])
    {
        // 倒计时运行时，设置每秒触发响应事件并调用一次
        if (processBlock)
        {
            NSInteger timeInterval = [[FSCountDownManager manager] timeIntervalWithType:self.countDownType];
            processBlock(@(self.countDownType), timeInterval, NO);
        }
        [[FSCountDownManager manager] setProcessBlock:processBlock withType:self.countDownType];
    }
    
    objc_setAssociatedObject(self, @selector(countDownProcessBlock), processBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)startCountDown
{
    [self startCountDownWithTimeInterval:BMCountDown_DefaultTimeInterval];
}

- (void)startCountDownWithTimeInterval:(NSInteger)timeInterval
{
    if (self.countDownType == 0)
    {
        return;
    }
    
    [[FSCountDownManager manager] startCountDownWithType:self.countDownType timeInterval:timeInterval processBlock:self.countDownProcessBlock];
}

- (void)stopCountDown
{
    if (self.countDownType == 0)
    {
        return;
    }
    
    [[FSCountDownManager manager] stopCountDownType:self.countDownType];
}
@end
