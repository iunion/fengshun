//
//  BMNavigationBar.h
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/4/28.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMNavigationBar : UINavigationBar
// bar背景蒙层
@property (nonatomic, strong, readonly) UIVisualEffectView *effectView;
// 蒙层效果
// The effect is either a UIBlurEffect or a UIVibrancyEffect.
@property (nullable, nonatomic, strong) UIVisualEffect *effect;
// 背景
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
// 阴影线条
@property (nonatomic, strong, readonly) UIImageView *shadowLineImageView;

- (void)setBackgroundImage:(nullable UIImage *)backgroundImage;

@end

NS_ASSUME_NONNULL_END

