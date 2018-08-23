//
//  CALayer+Size.h
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/8/8.
//Copyright © 2018年 DJ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Size)

@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, readonly) CGSize frameHalfSize;
@property (nonatomic, readonly) CGFloat frameHalfWidth;
@property (nonatomic, readonly) CGFloat frameHalfHeight;

@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGFloat frameLetf;
@property (nonatomic, assign) CGFloat frameTop;
@property (nonatomic, assign) CGFloat frameRight;
@property (nonatomic, assign) CGFloat frameBottom;

@property (nonatomic, assign) CGPoint frameCenter;
@property (nonatomic, assign) CGFloat frameCenterX;
@property (nonatomic, assign) CGFloat frameCenterY;

@property (nonatomic, readonly) CGRect frameAsIfNoTransformIsApplied;

@property (nonatomic, assign) CGPoint boundsOrigin;
@property (nonatomic, assign) CGSize boundsSize;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;

@property (nonatomic, readonly) CGPoint boundsCenter;
@property (nonatomic, readonly) CGSize boundsHalfSize;
@property (nonatomic, readonly) CGFloat boundsHalfWidth;
@property (nonatomic, readonly) CGFloat boundsHalfHeight;

@property (nonatomic, assign) CGFloat positionX;
@property (nonatomic, assign) CGFloat positionY;

@property (nonatomic, assign) CGFloat anchorPointX;
@property (nonatomic, assign) CGFloat anchorPointY;

@end
