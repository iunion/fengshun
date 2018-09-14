//
//  UIView+BMCorner.m
//  BMBasekit
//
//  Created by DennisDeng on 16/6/17.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import "UIView+BMCorner.h"
#import "UIView+BMSize.h"
#import <objc/runtime.h>

#pragma mark -
#pragma mark UIView + Corner

@implementation UIView (BMCorner)

- (void)bm_connerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    CGRect rect = self.bounds;
    // 创建shapelayer
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.frame = rect;
    // 设置路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    masklayer.path = path.CGPath;
    
    self.layer.mask = masklayer;
}

- (void)bm_createGradientWithColors:(NSArray * _Nonnull)colors direction:(UIViewLinearGradientDirection)direction
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    NSMutableArray *mutableColors = colors.mutableCopy;
    for (NSUInteger i = 0; i < colors.count; i++)
    {
        UIColor *currentColor = colors[i];
        [mutableColors replaceObjectAtIndex:i withObject:(id)currentColor.CGColor];
    }
    gradient.colors = mutableColors;
    
    switch (direction)
    {
        case UIViewLinearGradientDirectionVertical:
        {
            gradient.startPoint = CGPointMake(0.5f, 0.0f);
            gradient.endPoint = CGPointMake(0.5f, 1.0f);
            break;
        }
        case UIViewLinearGradientDirectionHorizontal:
        {
            gradient.startPoint = CGPointMake(0.0f, 0.5f);
            gradient.endPoint = CGPointMake(1.0f, 0.5f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown:
        {
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(1.0f, 1.0f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop:
        {
            gradient.startPoint = CGPointMake(0.0f, 1.0f);
            gradient.endPoint = CGPointMake(1.0f, 0.0f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown:
        {
            gradient.startPoint = CGPointMake(1.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop:
        {
            gradient.startPoint = CGPointMake(1.0f, 1.0f);
            gradient.endPoint = CGPointMake(0.0f, 0.0f);
            break;
        }
    }
    [self.layer insertSublayer:gradient atIndex:0];
}

@end


#pragma mark -
#pragma mark UIView + RoundedRect

@implementation UIView (BMRoundedRect)

- (void)bm_roundedRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 设置那个圆角的有多圆
    self.layer.cornerRadius = radius;
    // 设置边框的宽度，当然可以不要
    self.layer.borderWidth = borderWidth;
    // 设置边框的颜色
    self.layer.borderColor = [borderColor CGColor];
    // 设为NO去试试
    self.layer.masksToBounds = YES;
}

- (void)bm_roundedRect:(CGFloat)radius
{
    // 设置那个圆角的有多圆
    self.layer.cornerRadius = radius;
    // 设为NO去试试
    self.layer.masksToBounds = YES;
}

- (void)bm_circleView
{
    // 设置那个圆角的有多圆
    self.layer.cornerRadius = self.bm_width*0.5f;
    // 设为NO去试试
    self.layer.masksToBounds = YES;
}

- (void)bm_removeBorders
{
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.layer.borderColor = nil;
    self.layer.masksToBounds = NO;
    
    if (self.bm_dashRectLayer.superlayer)
    {
        [self.bm_dashRectLayer removeFromSuperlayer];
    }
}

- (CAShapeLayer *)bm_dashRectLayer
{
    CAShapeLayer *layer = objc_getAssociatedObject(self, _cmd);
    return layer;
}

- (void)setBm_dashRectLayer:(CAShapeLayer *)layer
{
    objc_setAssociatedObject(self, @selector(bm_dashRectLayer), layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)bm_roundedDashRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    [self bm_roundedDashRect:radius borderWidth:borderWidth borderColor:borderColor dashPattern:@[@4, @2]];
}

- (void)bm_roundedDashRect:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor dashPattern:(NSArray<NSNumber *> *)dashPattern
{
    if (!self.bm_dashRectLayer)
    {
        self.bm_dashRectLayer = [CAShapeLayer layer];
    }

    //虚线的颜色
    self.bm_dashRectLayer.strokeColor = borderColor.CGColor;
    //填充的颜色
    self.bm_dashRectLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    //设置路径
    self.bm_dashRectLayer.path = path.CGPath;
    self.bm_dashRectLayer.frame = self.bounds;
    
    //虚线的宽度
    self.bm_dashRectLayer.lineWidth = borderWidth;
    
    //设置线条的样式
    // self.bm_dashRectLayer.lineCap = @"square";
    
    //虚线的间隔
    self.bm_dashRectLayer.lineDashPattern = dashPattern;
    
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;

    [self.layer addSublayer:self.bm_dashRectLayer];
}


@end
