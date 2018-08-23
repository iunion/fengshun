//
//  CALayer+Size.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/8/8.
//Copyright © 2018年 DJ. All rights reserved.
//

#import "CALayer+Size.h"

@implementation CALayer (Size)

- (CGSize)frameSize
{
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)value
{
    CGRect rect = self.frame;
    rect.size = value;
    self.frame = rect;
}

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.size.width = value;
    self.frame = rect;
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.size.height = value;
    self.frame = rect;
}

- (CGSize)frameHalfSize
{
    return CGSizeMake(self.frameHalfWidth, self.frameHalfHeight);
}

- (CGFloat)frameHalfHeight
{
    return self.frameHeight * 0.5;
}

- (CGFloat)frameHalfWidth
{
    return self.frameWidth * 0.5;
}

- (CGPoint)frameOrigin
{
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)value
{
    CGRect rect = self.frame;
    rect.origin = value;
    self.frame = rect;
}

- (CGFloat)frameLetf
{
    return CGRectGetMinX(self.frame);
}

- (void)setFrameLetf:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value;
    self.frame = rect;
}

- (CGFloat)frameTop
{
    return CGRectGetMinY(self.frame);
}

- (void)setFrameTop:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value;
    self.frame = rect;
}

- (CGFloat)frameRight
{
    return CGRectGetMaxX(self.frame);
}

- (void)setFrameRight:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value - rect.size.width;
    self.frame = rect;
}

- (CGFloat)frameBottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setFrameBottom:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value - rect.size.height;
    self.frame = rect;
}

- (CGPoint)frameCenter
{
    return CGPointMake(self.frameCenterX, self.frameCenterY);
}

- (void)setFrameCenter:(CGPoint)value
{
    self.frameCenterX = value.x;
    self.frameCenterY = value.y;
}

- (CGFloat)frameCenterX
{
    return CGRectGetMidX(self.frame);
}

- (void)setFrameCenterX:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value - (rect.size.width * 0.5);
    self.frame = rect;
}

- (CGFloat)frameCenterY
{
    return CGRectGetMidY(self.frame);
}

- (void)setFrameCenterY:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value - (rect.size.height * 0.5);
    self.frame = rect;
}

- (CGRect)frameAsIfNoTransformIsApplied
{
    return CGRectMake(self.position.x - (self.bounds.size.width * self.anchorPoint.x),
                      self.position.y - (self.bounds.size.height * self.anchorPoint.y),
                      self.bounds.size.width,
                      self.bounds.size.height);
}

- (CGPoint)boundsOrigin
{
    return self.bounds.origin;
}

- (void)setBoundsOrigin:(CGPoint)value
{
    CGRect rect = self.bounds;
    rect.origin = value;
    self.bounds = rect;
}

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)value
{
    CGRect rect = self.bounds;
    rect.size = value;
    self.bounds = rect;
}

- (CGFloat)boundsWidth
{
    return self.bounds.size.width;
}

- (void)setBoundsWidth:(CGFloat)value
{
    CGRect rect = self.bounds;
    rect.size.width = value;
    self.bounds = rect;
}

- (CGFloat)boundsHeight
{
    return self.bounds.size.height;
}

- (void)setBoundsHeight:(CGFloat)value
{
    CGRect rect = self.bounds;
    rect.size.height = value;
    self.bounds = rect;
}

- (CGFloat)boundsHalfHeight
{
    return self.boundsHeight * 0.5;
}

- (CGFloat)boundsHalfWidth
{
    return self.boundsWidth * 0.5;
}

- (CGSize)boundsHalfSize
{
    return CGSizeMake(self.boundsHalfWidth, self.boundsHalfHeight);
}

- (CGPoint)boundsCenter
{
    return CGPointMake(self.boundsHalfWidth, self.boundsHalfHeight);
}

- (CGFloat)positionX
{
    return self.position.x;
}

- (void)setPositionX:(CGFloat)value
{
    self.position = CGPointMake(value, self.position.y);
}

- (CGFloat)positionY
{
    return self.position.y;
}

- (void)setPositionY:(CGFloat)value
{
    self.position = CGPointMake(self.position.x, value);
}

- (CGFloat)anchorPointX
{
    return self.anchorPoint.x;
}

- (void)setAnchorPointX:(CGFloat)value
{
    self.anchorPoint = CGPointMake(value, self.anchorPoint.y);
}

- (CGFloat)anchorPointY
{
    return self.anchorPoint.y;
}

- (void)setAnchorPointY:(CGFloat)value
{
    self.anchorPoint = CGPointMake(self.anchorPoint.x, value);
}

@end
