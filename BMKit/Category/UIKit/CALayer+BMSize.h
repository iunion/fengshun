//
//  CALayer+BMSize.h
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/8/8.
//Copyright © 2018年 DJ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (BMSize)

@property (nonatomic, assign) CGSize bm_frameSize;
@property (nonatomic, assign) CGFloat bm_frameWidth;
@property (nonatomic, assign) CGFloat bm_frameHeight;
@property (nonatomic, readonly) CGSize bm_frameHalfSize;
@property (nonatomic, readonly) CGFloat bm_frameHalfWidth;
@property (nonatomic, readonly) CGFloat bm_frameHalfHeight;

@property (nonatomic, assign) CGPoint bm_frameOrigin;
@property (nonatomic, assign) CGFloat bm_frameLetf;
@property (nonatomic, assign) CGFloat bm_frameTop;
@property (nonatomic, assign) CGFloat bm_frameRight;
@property (nonatomic, assign) CGFloat bm_frameBottom;

@property (nonatomic, assign) CGPoint bm_frameCenter;
@property (nonatomic, assign) CGFloat bm_frameCenterX;
@property (nonatomic, assign) CGFloat bm_frameCenterY;

@property (nonatomic, readonly) CGRect bm_frameAsIfNoTransformIsApplied;

@property (nonatomic, assign) CGPoint bm_boundsOrigin;
@property (nonatomic, assign) CGSize bm_boundsSize;
@property (nonatomic, assign) CGFloat bm_boundsWidth;
@property (nonatomic, assign) CGFloat bm_boundsHeight;

@property (nonatomic, readonly) CGPoint bm_boundsCenter;
@property (nonatomic, readonly) CGSize bm_boundsHalfSize;
@property (nonatomic, readonly) CGFloat bm_boundsHalfWidth;
@property (nonatomic, readonly) CGFloat bm_boundsHalfHeight;

@property (nonatomic, assign) CGFloat bm_positionX;
@property (nonatomic, assign) CGFloat bm_positionY;

@property (nonatomic, assign) CGFloat bm_anchorPointX;
@property (nonatomic, assign) CGFloat bm_anchorPointY;

@end
