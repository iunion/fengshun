//
//  UIView+BMCorner.h
//  BMBasekit
//
//  Created by DennisDeng on 16/6/17.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Direction of the linear gradient
 */
typedef NS_ENUM(NSInteger, UIViewLinearGradientDirection)
{
    /**
     *  Linear gradient vertical
     */
    UIViewLinearGradientDirectionVertical = 0,
    /**
     *  Linear gradient horizontal
     */
    UIViewLinearGradientDirectionHorizontal,
    /**
     *  Linear gradient from left to right and top to down
     */
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown,
    /**
     *  Linear gradient from left to right and down to top
     */
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop,
    /**
     *  Linear gradient from right to left and top to down
     */
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown,
    /**
     *  Linear gradient from right to left and down to top
     */
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop
};


@interface UIView (BMCorner)

// corners 圆角位置 UIRectCornerTopLeft|UIRectCornerTopRight
// cornerRadii 圆角尺寸 CGSizeMake(5, 10)
- (void)bm_connerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 *  Create a linear gradient
 *
 *  @param colors    NSArray of UIColor instances
 *  @param direction Direction of the gradient
 */
- (void)bm_createGradientWithColors:(NSArray * _Nonnull)colors
                          direction:(UIViewLinearGradientDirection)direction;

@end

@interface UIView (BMRoundedRect)

@property (nonnull, nonatomic, strong) CAShapeLayer *bm_dashRectLayer;

- (void)bm_roundedRect:(CGFloat)radius;
- (void)bm_roundedRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor * _Nullable)borderColor;

- (void)bm_circleView;

- (void)bm_roundedDashRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor;

- (void)bm_roundedDashRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor dashPattern:(nullable NSArray<NSNumber *> *)dashPattern;

/**
 *  Remove the borders around the UIView
 */
- (void)bm_removeBorders;

@end

