//
//  UIView+BMCountDownManager.m
//  BMTableViewManagerSample
//
//  Created by jiang deng on 2018/11/14.
//Copyright © 2018 DJ. All rights reserved.
//

#import "UIView+BMCountDownManager.h"
#import "NSObject+BMCategory.h"
#import <objc/runtime.h>


@implementation UIView (BMCountDownManager)
@dynamic countDownIdentifier;
@dynamic countDownProcessBlock;


- (id)countDownIdentifier
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setCountDownIdentifier:(id)identifier
{
    if ([identifier isKindOfClass:[NSNumber class]])
    {
        if ([identifier unsignedIntegerValue] == 0)
        {
            // identifier == 0，停止倒计时
            [self stopCountDown];
        }
    }
    else if (![identifier bm_isNotEmpty])
    {
        // identifier标识设置nil时，停止倒计时
        [self stopCountDown];
    }

    objc_setAssociatedObject(self, @selector(countDownIdentifier), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BMCountDownProcessBlock)countDownProcessBlock
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setCountDownProcessBlock:(BMCountDownProcessBlock)processBlock
{
    if ([self.countDownIdentifier isKindOfClass:[NSNumber class]])
    {
        if ([self.countDownIdentifier unsignedIntegerValue] == 0)
        {
            return;
        }
    }
    else if (![self.countDownIdentifier bm_isNotEmpty])
    {
        return;
    }
    
    if ([[BMCountDownManager manager] isCountDownWithIdentifier:self.countDownIdentifier])
    {
        // 倒计时运行时，设置每秒触发响应事件并调用一次
        if (processBlock)
        {
            NSInteger timeInterval = [[BMCountDownManager manager] timeIntervalWithIdentifier:self.countDownIdentifier];
            processBlock(self.countDownIdentifier, timeInterval, NO);
        }
        [[BMCountDownManager manager] setProcessBlock:processBlock withIdentifier:self.countDownIdentifier];
    }

    objc_setAssociatedObject(self, @selector(countDownProcessBlock), processBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)startCountDownWithTimeInterval:(NSInteger)timeInterval
{
    if ([self.countDownIdentifier isKindOfClass:[NSNumber class]])
    {
        if ([self.countDownIdentifier unsignedIntegerValue] == 0)
        {
            return;
        }
    }
    else if (![self.countDownIdentifier bm_isNotEmpty])
    {
        return;
    }

    [[BMCountDownManager manager] startCountDownWithIdentifier:self.countDownIdentifier timeInterval:timeInterval processBlock:self.countDownProcessBlock];
}

- (void)stopCountDown
{
    if ([self.countDownIdentifier isKindOfClass:[NSNumber class]])
    {
        if ([self.countDownIdentifier unsignedIntegerValue] == 0)
        {
            return;
        }
    }
    else if (![self.countDownIdentifier bm_isNotEmpty])
    {
        return;
    }

    [[BMCountDownManager manager] stopCountDownIdentifier:self.countDownIdentifier];
}

@end
