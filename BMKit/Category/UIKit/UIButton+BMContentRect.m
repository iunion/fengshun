//
//  UIButton+BMContentRect.m
//  BMBasekit
//
//  Created by DennisDeng on 15/7/20.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import "UIButton+BMContentRect.h"
#import "NSObject+BMCategory.h"
#import <objc/runtime.h>


@implementation UIButton (BMContentRect)

static const char *titleRectKey = "BMTitleRectKey";
static const char *imageRectKey = "BMImageRectKey";

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self bm_swizzleMethod:@selector(titleRectForContentRect:) withMethod:@selector(bm_titleRectForContentRect:) error:nil];
        [self bm_swizzleMethod:@selector(imageRectForContentRect:) withMethod:@selector(bm_imageRectForContentRect:) error:nil];
    });
}

- (CGRect)bm_titleRect
{
    NSValue *rectValue = objc_getAssociatedObject(self, titleRectKey);
    return [rectValue CGRectValue];
}

- (void)setBm_titleRect:(CGRect)rect
{
    objc_setAssociatedObject(self, titleRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

- (CGRect)bm_imageRect
{
    NSValue *rectValue = objc_getAssociatedObject(self, imageRectKey);
    return [rectValue CGRectValue];
}

- (void)setBm_imageRect:(CGRect)rect
{
    objc_setAssociatedObject(self, imageRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

- (CGRect)bm_titleRectForContentRect:(CGRect)contentRect
{
    if (!CGRectIsEmpty(self.bm_titleRect) && !CGRectEqualToRect(self.bm_titleRect, CGRectZero))
    {
        return self.bm_titleRect;
    }
    return [self bm_titleRectForContentRect:contentRect];
    
}

- (CGRect)bm_imageRectForContentRect:(CGRect)contentRect
{
    if (!CGRectIsEmpty(self.bm_imageRect) && !CGRectEqualToRect(self.bm_imageRect, CGRectZero))
    {
        return self.bm_imageRect;
    }
    return [self bm_imageRectForContentRect:contentRect];
}

- (void)bm_layoutButtonWithEdgeInsetsStyle:(BMButtonEdgeInsetsStyle)style imageTitleGap:(CGFloat)gap
{
    CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame);
    
    if (labelWidth == 0)
    {
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        labelWidth = titleSize.width;
    }
    
    CGFloat imageInsetsTop = 0.0f;
    CGFloat imageInsetsLeft = 0.0f;
    CGFloat imageInsetsBottom = 0.0f;
    CGFloat imageInsetsRight = 0.0f;
    
    CGFloat titleInsetsTop = 0.0f;
    CGFloat titleInsetsLeft = 0.0f;
    CGFloat titleInsetsBottom = 0.0f;
    CGFloat titleInsetsRight = 0.0f;
    
    switch (style)
    {
        case BMButtonEdgeInsetsStyleImageRight:
        {
            gap = gap * 0.5f;
            
            imageInsetsLeft = labelWidth + gap;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = -(imageViewWidth + gap);
            titleInsetsRight = -titleInsetsLeft;
        }
            break;
            
        case BMButtonEdgeInsetsStyleImageLeft:
        {
            gap = gap * 0.5f;
            
            imageInsetsLeft = -gap;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = gap;
            titleInsetsRight = -titleInsetsLeft;
        }
            break;
            
        case BMButtonEdgeInsetsStyleImageBottom:
        {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + gap + labelHeight) * 0.5f;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageBottomY = CGRectGetMaxY(self.imageView.frame);
            CGFloat titleTopY = CGRectGetMinY(self.titleLabel.frame);
            
            imageInsetsTop = buttonHeight - (buttonHeight * 0.5f - boundsCentery) - imageBottomY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = -imageInsetsLeft;
            imageInsetsBottom = -imageInsetsTop;
            
            titleInsetsTop = (buttonHeight * 0.5 - boundsCentery) - titleTopY;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = -titleInsetsLeft;
            titleInsetsBottom = -titleInsetsTop;
            
        }
            break;
            
        case BMButtonEdgeInsetsStyleImageTop:
        {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + gap + labelHeight) * 0.5f;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageTopY = CGRectGetMinY(self.imageView.frame);
            CGFloat titleBottom = CGRectGetMaxY(self.titleLabel.frame);
            
            imageInsetsTop = (buttonHeight * 0.5 - boundsCentery) - imageTopY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = -imageInsetsLeft;
            imageInsetsBottom = -imageInsetsTop;
            
            titleInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - titleBottom;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = -titleInsetsLeft;
            titleInsetsBottom = -titleInsetsTop;
        }
            break;
            
        default:
            break;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageInsetsTop, imageInsetsLeft, imageInsetsBottom, imageInsetsRight);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleInsetsTop, titleInsetsLeft, titleInsetsBottom, titleInsetsRight);
}

@end
