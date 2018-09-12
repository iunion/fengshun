//
//  DJFreshBackContainerFooterView.h
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/7/27.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshBackFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshBackContainerFooterView : BMFreshBackFooterView

@property (nonatomic, weak, readonly) UIView *containerView;
@property (nonatomic, weak, readonly) UILabel *messageLabel;

// 方形size
@property (nonatomic, assign) CGSize containerSize;

// 文字与图片间距
@property (nonatomic, assign) CGFloat containerLabelGap;
// 整体左边偏移间距
@property (nonatomic, assign) CGFloat containerXOffset;
// 整体上边偏移间距
@property (nonatomic, assign) CGFloat containerYOffset;

@end

NS_ASSUME_NONNULL_END
