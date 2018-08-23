//
//  UIImage+BMTint.h
//  BMBasekit
//
//  Created by DennisDeng on 17/3/14.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BMTint)

NS_ASSUME_NONNULL_BEGIN

- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor insets:(UIEdgeInsets)insets;
- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor rect:(CGRect)rect;

- (UIImage *)bm_imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)bm_imageWithGradientTintColor:(UIColor *)tintColor insets:(UIEdgeInsets)insets;
- (UIImage *)bm_imageWithGradientTintColor:(UIColor *)tintColor rect:(CGRect)rect;

- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor rect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

NS_ASSUME_NONNULL_END

@end
