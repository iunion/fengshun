//
//  CALayer+BMSize.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/8/8.
//Copyright © 2018年 DJ. All rights reserved.
//

#import "CALayer+BMSize.h"

@implementation CALayer (BMSize)

- (CGSize)bm_frameSize
{
    return self.frame.size;
}

- (void)setBm_frameSize:(CGSize)value
{
    CGRect rect = self.frame;
    rect.size = value;
    self.frame = rect;
}

- (CGFloat)bm_frameWidth
{
    return self.frame.size.width;
}

- (void)setBm_frameWidth:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.size.width = value;
    self.frame = rect;
}

- (CGFloat)bm_frameHeight
{
    return self.frame.size.height;
}

- (void)setBm_frameHeight:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.size.height = value;
    self.frame = rect;
}

- (CGSize)bm_frameHalfSize
{
    return CGSizeMake(self.bm_frameHalfWidth, self.bm_frameHalfHeight);
}

- (CGFloat)bm_frameHalfHeight
{
    return self.bm_frameHeight * 0.5;
}

- (CGFloat)bm_frameHalfWidth
{
    return self.bm_frameWidth * 0.5;
}

- (CGPoint)bm_frameOrigin
{
    return self.frame.origin;
}

- (void)setBm_frameOrigin:(CGPoint)value
{
    CGRect rect = self.frame;
    rect.origin = value;
    self.frame = rect;
}

- (CGFloat)bm_frameLetf
{
    return CGRectGetMinX(self.frame);
}

- (void)setBm_frameLetf:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value;
    self.frame = rect;
}

- (CGFloat)bm_frameTop
{
    return CGRectGetMinY(self.frame);
}

- (void)setBm_frameTop:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value;
    self.frame = rect;
}

- (CGFloat)bm_frameRight
{
    return CGRectGetMaxX(self.frame);
}

- (void)setBm_frameRight:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value - rect.size.width;
    self.frame = rect;
}

- (CGFloat)bm_frameBottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setBm_frameBottom:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value - rect.size.height;
    self.frame = rect;
}

- (CGPoint)bm_frameCenter
{
    return CGPointMake(self.bm_frameCenterX, self.bm_frameCenterY);
}

- (void)setBm_frameCenter:(CGPoint)value
{
    self.bm_frameCenterX = value.x;
    self.bm_frameCenterY = value.y;
}

- (CGFloat)bm_frameCenterX
{
    return CGRectGetMidX(self.frame);
}

- (void)setBm_frameCenterX:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value - (rect.size.width * 0.5);
    self.frame = rect;
}

- (CGFloat)bm_frameCenterY
{
    return CGRectGetMidY(self.frame);
}

- (void)setBm_frameCenterY:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value - (rect.size.height * 0.5);
    self.frame = rect;
}

- (CGRect)bm_frameAsIfNoTransformIsApplied
{
    return CGRectMake(self.position.x - (self.bounds.size.width * self.anchorPoint.x),
                      self.position.y - (self.bounds.size.height * self.anchorPoint.y),
                      self.bounds.size.width,
                      self.bounds.size.height);
}

- (CGPoint)bm_boundsOrigin
{
    return self.bounds.origin;
}

- (void)setBm_boundsOrigin:(CGPoint)value
{
    CGRect rect = self.bounds;
    rect.origin = value;
    self.bounds = rect;
}

- (CGSize)bm_boundsSize
{
    return self.bounds.size;
}

- (void)setBm_boundsSize:(CGSize)value
{
    CGRect rect = self.bounds;
    rect.size = value;
    self.bounds = rect;
}

- (CGFloat)bm_boundsWidth
{
    return self.bounds.size.width;
}

- (void)setBm_boundsWidth:(CGFloat)value
{
    CGRect rect = self.bounds;
    rect.size.width = value;
    self.bounds = rect;
}

- (CGFloat)bm_boundsHeight
{
    return self.bounds.size.height;
}

- (void)setBm_boundsHeight:(CGFloat)value
{
    CGRect rect = self.bounds;
    rect.size.height = value;
    self.bounds = rect;
}

- (CGFloat)bm_boundsHalfHeight
{
    return self.bm_boundsHeight * 0.5;
}

- (CGFloat)bm_boundsHalfWidth
{
    return self.bm_boundsWidth * 0.5;
}

- (CGSize)bm_boundsHalfSize
{
    return CGSizeMake(self.bm_boundsHalfWidth, self.bm_boundsHalfHeight);
}

- (CGPoint)bm_boundsCenter
{
    return CGPointMake(self.bm_boundsHalfWidth, self.bm_boundsHalfHeight);
}

- (CGFloat)bm_positionX
{
    return self.position.x;
}

- (void)setBm_positionX:(CGFloat)value
{
    self.position = CGPointMake(value, self.position.y);
}

- (CGFloat)bm_positionY
{
    return self.position.y;
}

- (void)setBm_positionY:(CGFloat)value
{
    self.position = CGPointMake(self.position.x, value);
}

- (CGFloat)bm_anchorPointX
{
    return self.anchorPoint.x;
}

- (void)setBm_anchorPointX:(CGFloat)value
{
    self.anchorPoint = CGPointMake(value, self.anchorPoint.y);
}

- (CGFloat)bm_anchorPointY
{
    return self.anchorPoint.y;
}

- (void)setBm_anchorPointY:(CGFloat)value
{
    self.anchorPoint = CGPointMake(self.anchorPoint.x, value);
}

@end
