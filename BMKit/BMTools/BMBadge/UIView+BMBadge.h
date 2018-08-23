//
//  UIView+BMBadge.h
//  BMBadgeSample
//
//  Created by jiang deng on 2018/8/17.
//Copyright © 2018年 DJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMBadgeDefine.h"

@interface UIView (BMBadge)

@property (nonnull, nonatomic, strong) UILabel *badgeLabel;

// badge类型
@property (nonatomic, assign) BMBadgeStyle badgeStyle;
// badge动画类型
@property (nonatomic, assign) BMBadgeAnimationType badgeAnimationType;

// 当前badge值
@property (nonatomic, assign) NSUInteger badgeValue;
// 最大保留位数 默认：2位 即：1~99 最大5位 即：1~99999
@property (nonatomic, assign) NSUInteger badgeMaxBits;

#pragma mark - UI

@property (nullable, nonatomic, strong) UIFont *badgeFont;
@property (nullable, nonatomic, strong) UIColor *badgeBgColor;
@property (nullable, nonatomic, strong) UIColor *badgeTextColor;

@property (nonatomic, assign) BMBadgeHorizontallyAlignment badgeHorizontallyAlignment;
@property (nonatomic, assign) BMBadgeVerticallyAlignment badgeVerticallyAlignment;

@property (nonatomic, assign) CGFloat badgeRadius;
@property (nonatomic, assign) CGPoint badgeCenterOffset;

//@property (nonatomic, assign) CGFloat badgeCornerRadius;
@property (nonatomic, assign) CGFloat badgeBorderWidth;
@property (nullable, nonatomic, strong) UIColor *badgeBorderColor;


- (void)showBadgeWithStyle:(BMBadgeStyle)style
                     value:(NSInteger)value
             animationType:(BMBadgeAnimationType)animationType;

- (void)showRedDotBadge;
- (void)showRedDotBadgeWithAnimationType:(BMBadgeAnimationType)animationType;

- (void)showNumberBadgeWithValue:(NSInteger)value;
- (void)showNumberBadgeWithValue:(NSInteger)value
                   animationType:(BMBadgeAnimationType)animationType;

- (void)showNewBadge;
- (void)showNewBadgeWithAnimationType:(BMBadgeAnimationType)animationType;

- (void)clearBadge;

@end
