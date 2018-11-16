//
//  UIView+FSCountDownManager.h
//  fengshun
//
//  Created by jiang deng on 2018/11/15.
//Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCountDownManager.h"

NS_ASSUME_NONNULL_BEGIN

// 不要和 UIView+BMCountDownManager 混用
@interface UIView (FSCountDownManager)

// 倒计时标识
@property (nonatomic, assign) FSVerificationCodeType countDownType;
// 每秒触发响应事件
@property (nullable, nonatomic, copy) BMCountDownProcessBlock countDownProcessBlock;

// 启动倒计时，计时timeInterval
- (void)startCountDown;
- (void)startCountDownWithTimeInterval:(NSInteger)timeInterval;
// 停止倒计时
- (void)stopCountDown;

@end

NS_ASSUME_NONNULL_END
