//
//  UIView+DJBadge.m
//  DJBadgeSample
//
//  Created by jiang deng on 2018/8/17.
//Copyright © 2018年 DJ. All rights reserved.
//

#import "UIView+BMBadge.h"
#import <objc/runtime.h>
#import "UIView+BMSize.h"
#import "UILabel+BMCategory.h"
#import "CAAnimation+Animation.h"


#define kBadgeBreatheAniKey     @"breathe"
#define kBadgeRotateAniKey      @"rotate"
#define kBadgeShakeAniKey       @"shake"
#define kBadgeScaleAniKey       @"scale"
#define kBadgeBounceAniKey      @"bounce"

@implementation UIView (BMBadge)

- (UILabel *)badgeInit
{
    CGFloat redotWidth = BMBadgeDefaultRedDotRadius * 2;
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame), -redotWidth, redotWidth, redotWidth);
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:frame];
    badgeLabel.numberOfLines = 0;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.text = @"";
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.layer.masksToBounds = YES;

    //badgeLabel.hidden = YES;
    [self addSubview:badgeLabel];
    
    self.badgeLabel = badgeLabel;
    
    return badgeLabel;
}

#pragma mark - setter/getter

- (UILabel *)badgeLabel
{
    UILabel *label = objc_getAssociatedObject(self, _cmd);
    if (nil == label)
    {
        label = [self badgeInit];
    }
    return label;
}

- (void)setBadgeLabel:(UILabel *)badgeLabel
{
    // KVO
    [self willChangeValueForKey:@"badgeLabel"];
    objc_setAssociatedObject(self, @selector(badgeLabel), badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"badgeLabel"];
}

- (BMBadgeStyle)badgeStyle
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj unsignedIntegerValue];
    }
    return BMBadgeStyleRedDot;
}

- (void)setBadgeStyle:(BMBadgeStyle)badgeStyle
{
    objc_setAssociatedObject(self, @selector(badgeStyle), @(badgeStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BMBadgeAnimationType)badgeAnimationType
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj unsignedIntegerValue];
    }
    return BMBadgeAnimationTypeNone;
}

- (void)setBadgeAnimationType:(BMBadgeAnimationType)badgeAnimationType
{
    objc_setAssociatedObject(self, @selector(badgeAnimationType), @(badgeAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self removeAnimation];
    [self beginAnimation];
}

- (NSUInteger)badgeValue
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj unsignedIntegerValue];
    }
    return 0;
}

- (void)setBadgeValue:(NSUInteger)badgeValue
{
    [self willChangeValueForKey:@"badgeValue"];
    objc_setAssociatedObject(self, @selector(badgeValue), @(badgeValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"badgeValue"];
    
    NSUInteger bits = [NSString stringWithFormat:@"%@", @(badgeValue)].length;
    if (bits > self.badgeMaxBits)
    {
        NSMutableString *text = [NSMutableString stringWithCapacity:self.badgeMaxBits];
        for (NSUInteger i = 0; i<self.badgeMaxBits; i++)
        {
            [text appendString:@"9"];
        }
        [text appendString:@"+"];
        self.badgeLabel.text = text;
    }
    else
    {
        self.badgeLabel.text = [NSString stringWithFormat:@"%@", @(badgeValue)];
    }
}

- (NSUInteger)badgeMaxBits
{
    // 最大保留位数 默认：2位 即：1~99
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        NSUInteger bits = [obj unsignedIntegerValue];
        if (bits == 0)
        {
            bits = BMBadgeDefaultMaxBits;
        }
        return bits;
    }
    return BMBadgeDefaultMaxBits;
}

- (void)setBadgeMaxBits:(NSUInteger)badgeMaxBits
{
    // 最大5位 即：1~99999
    if (badgeMaxBits < BMBadgeDefaultMaxBits)
    {
        badgeMaxBits = BMBadgeDefaultMaxBits;
    }
    
    if (badgeMaxBits > 5)
    {
        badgeMaxBits = 5;
    }
    
    objc_setAssociatedObject(self, @selector(badgeMaxBits), @(badgeMaxBits), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)badgeFont
{
    UIFont *font = objc_getAssociatedObject(self, _cmd);
    if (font)
    {
        return font;
    }
    return BMBadgeDefaultFont;
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, @selector(badgeFont), badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)badgeBgColor
{
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color)
    {
        return color;
    }
    return BMBadgeDefaultBgColor;
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor
{
    objc_setAssociatedObject(self, @selector(badgeBgColor), badgeBgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)badgeTextColor
{
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color)
    {
        return color;
    }
    return BMBadgeDefaultTextColor;
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, @selector(badgeTextColor), badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BMBadgeHorizontallyAlignment)badgeHorizontallyAlignment
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj unsignedIntegerValue];
    }
    return BMBadgeHorizontallyAlignmentRight;
}

- (void)setBadgeHorizontallyAlignment:(BMBadgeHorizontallyAlignment)badgeHorizontallyAlignment
{
    objc_setAssociatedObject(self, @selector(badgeHorizontallyAlignment), @(badgeHorizontallyAlignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BMBadgeVerticallyAlignment)badgeVerticallyAlignment
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj unsignedIntegerValue];
    }
    return BMBadgeVerticallyAlignmentTop;
}

- (void)setBadgeVerticallyAlignment:(BMBadgeVerticallyAlignment)badgeVerticallyAlignment
{
    objc_setAssociatedObject(self, @selector(badgeVerticallyAlignment), @(badgeVerticallyAlignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)badgeRadius
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj doubleValue];
    }
    return BMBadgeDefaultRedDotRadius;
}

- (void)setBadgeRadius:(CGFloat)badgeRadius
{
    objc_setAssociatedObject(self, @selector(badgeRadius), @(badgeRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)badgeCenterOffset
{
    CGPoint point = CGPointZero;
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj && [obj isKindOfClass:[NSDictionary class]])
    {
        BOOL success = CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)obj, &point);
        if (success)
        {
            return point;
        }
    }
    return CGPointZero;
}

- (void)setBadgeCenterOffset:(CGPoint)badgeCenterOffset
{
    CFDictionaryRef dictionary = CGPointCreateDictionaryRepresentation(badgeCenterOffset);
    NSDictionary *pointDict = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)dictionary];
    CFRelease(dictionary);
    
    objc_setAssociatedObject(self, @selector(badgeCenterOffset), pointDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#if 0
- (CGFloat)badgeCornerRadius
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj doubleValue];
    }
    return BMBadgeDefaultBorderRadius;
}

- (void)setBadgeCornerRadius:(CGFloat)badgeCornerRadius
{
    objc_setAssociatedObject(self, @selector(badgeCornerRadius), @(badgeCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#endif

- (CGFloat)badgeBorderWidth
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj doubleValue];
    }
    return BMBadgeDefaultBorderWidth;
}

- (void)setBadgeBorderWidth:(CGFloat)badgeBorderWidth
{
    objc_setAssociatedObject(self, @selector(badgeBorderWidth), @(badgeBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)badgeBorderColor
{
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color)
    {
        return color;
    }
    return BMBadgeDefaultBorderColor;
}

- (void)setBadgeBorderColor:(UIColor *)badgeBorderColor
{
    objc_setAssociatedObject(self, @selector(badgeBorderColor), badgeBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - animation

- (void)beginAnimation
{
    switch(self.badgeAnimationType)
    {
        case BMBadgeAnimationTypeBreathe:
            [self.badgeLabel.layer addAnimation:[CAAnimation opacityForever_Animation:1.4]
                                         forKey:kBadgeBreatheAniKey];
            break;
        case BMBadgeAnimationTypeShake:
            [self.badgeLabel.layer addAnimation:[CAAnimation shake_AnimationRepeatTimes:CGFLOAT_MAX
                                                                               durTimes:1
                                                                                 forObj:self.badgeLabel.layer]
                                         forKey:kBadgeShakeAniKey];
            break;
        case BMBadgeAnimationTypeScale:
            [self.badgeLabel.layer addAnimation:[CAAnimation scaleFrom:1.4
                                                               toScale:0.6
                                                              durTimes:1
                                                                   rep:MAXFLOAT]
                                         forKey:kBadgeScaleAniKey];
            break;
        case BMBadgeAnimationTypeBounce:
            [self.badgeLabel.layer addAnimation:[CAAnimation bounce_AnimationRepeatTimes:CGFLOAT_MAX
                                                                                durTimes:1
                                                                                  forObj:self.badgeLabel.layer]
                                         forKey:kBadgeBounceAniKey];
            break;
        case BMBadgeAnimationTypeNone:
        default:
            break;
    }
}


- (void)removeAnimation
{
    if (self.badgeLabel)
    {
        [self.badgeLabel.layer removeAllAnimations];
    }
}

- (void)adjustbadgeLabelWidth
{
    //CGSize labelsize = [self.badgeLabel labelSizeToFitWidth:UI_SCREEN_WIDTH];
    CGSize labelsize = [self.badgeLabel sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH, MAXFLOAT)];
    labelsize.width += BMBadgeDefaultBorderGap + self.badgeBorderWidth;
    labelsize.height += BMBadgeDefaultBorderGap + self.badgeBorderWidth;
    if (labelsize.width < labelsize.height)
    {
        labelsize.width = labelsize.height;
    }
    
    self.badgeLabel.bm_size = labelsize;
}

- (void)layoutBadge
{
    CGPoint center = CGPointMake(self.bm_size.width*0.5+self.badgeCenterOffset.x, self.bm_size.height*0.5+self.badgeCenterOffset.y);
    self.badgeLabel.center = center;
    
    if (self.badgeHorizontallyAlignment == BMBadgeHorizontallyAlignmentLeft)
    {
        self.badgeLabel.bm_left = 0 - self.badgeLabel.bm_size.width*0.5 + self.badgeCenterOffset.x;
    }
    else if (self.badgeHorizontallyAlignment == BMBadgeHorizontallyAlignmentRight)
    {
        self.badgeLabel.bm_left = CGRectGetMaxX(self.bounds) - self.badgeLabel.bm_size.width*0.5 + self.badgeCenterOffset.x;
    }
    
    if (self.badgeVerticallyAlignment == BMBadgeVerticallyAlignmentTop)
    {
        self.badgeLabel.bm_top = 0 - self.badgeLabel.bm_size.height*0.5 + self.badgeCenterOffset.y;
    }
    else if (self.badgeVerticallyAlignment == BMBadgeVerticallyAlignmentBottom)
    {
        self.badgeLabel.bm_top = CGRectGetMaxY(self.bounds) - self.badgeLabel.bm_size.height*0.5 + self.badgeCenterOffset.y;
    }
    
    BMLog(@"%@", NSStringFromCGRect(self.badgeLabel.frame));
}

- (void)showBadgeWithStyle:(BMBadgeStyle)style
                     value:(NSInteger)value
             animationType:(BMBadgeAnimationType)animationType
{
    switch (style)
    {
        case BMBadgeStyleRedDot:
            [self showRedDotBadgeWithAnimationType:animationType];
            break;
        case BMBadgeStyleNumber:
            [self showNumberBadgeWithValue:value animationType:animationType];
            break;
        case BMBadgeStyleNew:
            [self showNewBadgeWithAnimationType:animationType];
            break;
        default:
            [self showRedDotBadgeWithAnimationType:animationType];
            break;
    }
}

- (void)showRedDotBadge
{
    [self showRedDotBadgeWithAnimationType:BMBadgeAnimationTypeNone];
}

- (void)showRedDotBadgeWithAnimationType:(BMBadgeAnimationType)animationType
{
    self.badgeLabel.hidden = NO;
    
    self.badgeStyle = BMBadgeStyleRedDot;
    
    self.badgeLabel.backgroundColor = self.badgeBgColor;
    self.badgeLabel.textColor = self.badgeTextColor;
    self.badgeLabel.font = self.badgeFont;
    
    self.badgeLabel.layer.cornerRadius = self.badgeRadius;
    self.badgeLabel.layer.borderWidth = self.badgeBorderWidth;
    self.badgeLabel.layer.borderColor = self.badgeBorderColor.CGColor;
    self.badgeLabel.text = @"";
    
    CGFloat redotWidth = self.badgeRadius * 2;
//    CGRect frame = CGRectMake(CGRectGetWidth(self.frame)+self.badgeCenterOffset.x, -redotWidth+self.badgeCenterOffset.y, redotWidth, redotWidth);
    self.badgeLabel.bm_size = CGSizeMake(redotWidth, redotWidth);
    [self layoutBadge];
    
    self.badgeAnimationType = animationType;
}

- (void)showNumberBadgeWithValue:(NSInteger)value
{
    [self showNumberBadgeWithValue:value animationType:BMBadgeAnimationTypeNone];
}

- (void)showNumberBadgeWithValue:(NSInteger)value
                   animationType:(BMBadgeAnimationType)animationType
{
    self.badgeLabel.hidden = NO;

    self.badgeStyle = BMBadgeStyleNumber;
    
    self.badgeLabel.backgroundColor = self.badgeBgColor;
    self.badgeLabel.textColor = self.badgeTextColor;
    self.badgeLabel.font = self.badgeFont;
    
    //self.badgeLabel.layer.cornerRadius = self.badgeCornerRadius;
    self.badgeLabel.layer.borderWidth = self.badgeBorderWidth;
    self.badgeLabel.layer.borderColor = self.badgeBorderColor.CGColor;

    self.badgeValue = value;

    [self adjustbadgeLabelWidth];
    [self layoutBadge];
    
    self.badgeLabel.layer.cornerRadius = self.badgeLabel.bm_height*0.5;

    self.badgeAnimationType = animationType;
}

- (void)showNewBadge
{
    [self showNewBadgeWithAnimationType:BMBadgeAnimationTypeNone];
}

- (void)showNewBadgeWithAnimationType:(BMBadgeAnimationType)animationType
{
    self.badgeLabel.hidden = NO;

    self.badgeStyle = BMBadgeStyleNew;
    
    self.badgeLabel.backgroundColor = self.badgeBgColor;
    self.badgeLabel.textColor = self.badgeTextColor;
    self.badgeLabel.font = self.badgeFont;
    
    //self.badgeLabel.layer.cornerRadius = self.badgeCornerRadius;
    self.badgeLabel.layer.borderWidth = self.badgeBorderWidth;
    self.badgeLabel.layer.borderColor = self.badgeBorderColor.CGColor;
    self.badgeLabel.text = @"new";
    
    [self adjustbadgeLabelWidth];
    [self layoutBadge];
    
    self.badgeLabel.layer.cornerRadius = self.badgeLabel.bm_height*0.33;

    self.badgeAnimationType = animationType;
}

- (void)clearBadge
{
    self.badgeLabel.hidden = YES;
}

@end
