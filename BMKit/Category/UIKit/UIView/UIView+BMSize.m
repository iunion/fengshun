//
//  UIView+BMSize.h
//  BMBasekit
//
//  Created by DennisDeng on 14-5-5.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import "UIView+BMSize.h"

@implementation UIView (BMSize)

- (void)setBm_size:(CGSize)size
{
  CGPoint origin = [self frame].origin;
  
  [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (CGSize)bm_size
{
  return [self frame].size;
}

- (void)setBm_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)bm_origin
{
    return self.frame.origin;
}

- (CGFloat)bm_left
{
  return CGRectGetMinX([self frame]);
}

- (void)setBm_left:(CGFloat)x
{
  CGRect frame = [self frame];
  frame.origin.x = x;
  [self setFrame:frame];
}

- (CGFloat)bm_top
{
  return CGRectGetMinY([self frame]);
}

- (void)setBm_top:(CGFloat)y
{
  CGRect frame = [self frame];
  frame.origin.y = y;
  [self setFrame:frame];
}

- (CGFloat)bm_right
{
  return CGRectGetMaxX([self frame]);
}

- (void)setBm_right:(CGFloat)right
{
  CGRect frame = [self frame];
  frame.origin.x = right - frame.size.width;
  
  [self setFrame:frame];
}

- (CGFloat)bm_bottom
{
  return CGRectGetMaxY([self frame]);
}

- (void)setBm_bottom:(CGFloat)bottom
{
  CGRect frame = [self frame];
  frame.origin.y = bottom - frame.size.height;

  [self setFrame:frame];
}

- (CGFloat)bm_originX
{
    return CGRectGetMinX(self.frame);
}

- (void)setBm_originX:(CGFloat)aOriginX
{
    self.frame = CGRectMake(aOriginX, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)bm_originY
{
    return CGRectGetMinY(self.frame);
}

- (void)setBm_originY:(CGFloat)aOriginY
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), aOriginY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)bm_centerX
{
  return [self center].x;
}

- (void)setBm_centerX:(CGFloat)centerX
{
  [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)bm_centerY
{
  return [self center].y;
}

- (void)setBm_centerY:(CGFloat)centerY
{
  [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGFloat)bm_width
{
  return CGRectGetWidth([self frame]);
}

- (void)setBm_width:(CGFloat)width
{
  CGRect frame = [self frame];
  frame.size.width = width;

  [self setFrame:CGRectStandardize(frame)];
}

- (CGFloat)bm_height
{
  return CGRectGetHeight([self frame]);
}

- (void)setBm_height:(CGFloat)height
{
  CGRect frame = [self frame];
  frame.size.height = height;
	
  [self setFrame:CGRectStandardize(frame)];
}


// bounds accessors

- (CGSize)bm_boundsSize
{
    return self.bounds.size;
}

- (void)setBm_boundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)bm_boundsWidth
{
    return self.bm_boundsSize.width;
}

- (void)setBm_boundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)bm_boundsHeight
{
    return self.bm_boundsSize.height;
}

- (void)setBm_boundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}


// content getters

- (CGRect)bm_contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.bm_boundsWidth, self.bm_boundsHeight);
}

- (CGPoint)bm_contentCenter
{
    return CGPointMake(self.bm_boundsWidth*0.5f, self.bm_boundsHeight*0.5f);
}

- (void)bm_setLeft:(CGFloat)left right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.size.width = right - left;
    self.frame = frame;
}

- (void)bm_setWidth:(CGFloat)width right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - width;
    frame.size.width = width;
    self.frame = frame;
}

- (void)bm_setTop:(CGFloat)top bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    frame.size.height = bottom - top;
    self.frame = frame;
}

- (void)bm_setHeight:(CGFloat)height bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - height;
    frame.size.height = height;
    self.frame = frame;
}

@end
