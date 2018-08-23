//
//  BMFreshDotCircleHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshDotCircleHeader.h"

#define DEFAULT_ANIMATETIME     0.75f
#define DEFAULT_LINEWIDTH       2.0f
#define DEFAULT_RADIUS          12.0f

@interface BMFreshDotCircleHeader ()

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;

@property (nonatomic, strong) CAShapeLayer *coverLayer;

@end

@implementation BMFreshDotCircleHeader

@synthesize circleRadius = _circleRadius;

- (CAReplicatorLayer *)replicatorLayer
{
    if (!_replicatorLayer)
    {
        _replicatorLayer = [CAReplicatorLayer layer];
        _replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
        _replicatorLayer.shouldRasterize = YES;
        _replicatorLayer.rasterizationScale = [[UIScreen mainScreen] scale];
        [self.containerView.layer insertSublayer:_replicatorLayer atIndex:0];
        
        _replicatorLayer.instanceCount = 12;
        _replicatorLayer.instanceDelay = 0.05;//0.8/12;
        CGFloat angle = (2 * M_PI)/_replicatorLayer.instanceCount;
        _replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 0.1);
        _replicatorLayer.instanceBlueOffset = -0.01;
        _replicatorLayer.instanceGreenOffset = -0.01;
    }
    return _replicatorLayer;
}

- (CAShapeLayer *)coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [CAShapeLayer layer];
        _coverLayer.contentsScale = [[UIScreen mainScreen] scale];
        _coverLayer.fillColor = [UIColor clearColor].CGColor;
        _coverLayer.strokeColor = [UIColor redColor].CGColor;
        _coverLayer.lineCap = kCALineCapRound;
        _coverLayer.lineJoin = kCALineJoinRound;
        _coverLayer.lineWidth = DEFAULT_LINEWIDTH;
        _coverLayer.bounds = CGRectMake(0, 0, DEFAULT_RADIUS * 2, DEFAULT_RADIUS * 2);
        //_coverLayer.path = [UIBezierPath bezierPathWithOvalInRect:_coverLayer.bounds].CGPath;
        _coverLayer.strokeStart = 0;
        _coverLayer.strokeEnd = 0;
        [self.replicatorLayer addSublayer:_coverLayer];
    }
    return _coverLayer;
}

- (void)setCoverStartColor:(UIColor *)coverStartColor
{
    _coverStartColor = coverStartColor;
}

- (void)setCoverEndColor:(UIColor *)coverEndColor
{
    _coverEndColor = coverEndColor;
}

- (CGFloat)circleRadius
{
    if (self.containerSize.width != self.containerSize.height)
    {
        return 0;
    }
    
    return _circleRadius;
}

- (void)setCircleRadius:(CGFloat)circleRadius
{
    _circleRadius = circleRadius;
    
    self.containerSize = CGSizeMake(circleRadius*2.0f, circleRadius*2.0f);
    
    [self setNeedsLayout];
}

- (void)prepare
{
    [super prepare];
    
    self.circleRadius = DEFAULT_RADIUS;
    self.animationDuration = DEFAULT_ANIMATETIME;
    
    self.coverStartColor = [UIColor whiteColor];
    self.coverEndColor = [UIColor redColor];
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    self.replicatorLayer.frame  = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
    //self.coverLayer.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.replicatorLayer.frame = CGRectMake(0, 0, self.circleRadius*2, self.circleRadius*2);
    
    CGFloat dotWidth = self.circleRadius / 4;
    self.coverLayer.frame = CGRectMake(self.circleRadius - dotWidth*0.5, dotWidth*0.5, dotWidth, dotWidth);
    self.coverLayer.cornerRadius = dotWidth*0.5;
    //    self.coverLayer.strokeColor = self.coverColor.CGColor;
    //    self.coverLayer.backgroundColor = self.coverColor.CGColor;
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    if (self.pullingPercent == 0)
    {
        self.coverLayer.strokeStart = 0;
        self.coverLayer.strokeEnd = 0;
        [self.coverLayer removeAllAnimations];
    }
    
    UIColor *color = self.coverEndColor;
    if (self.pullingPercent<=0.5f)
    {
        color = self.coverStartColor;
    }
    else if (self.pullingPercent<1.0f)
    {
        color = [UIColor bm_startColor:self.coverStartColor endColor:self.coverEndColor progress:self.pullingPercent-0.5];
    }
    self.coverLayer.strokeColor = color.CGColor;
    self.coverLayer.backgroundColor = color.CGColor;
    
    /*
     if (pullingPercent<=0.2f)
     {
     CGFloat dotWidth = self.circleRadius / 6;
     self.coverLayer.frame = CGRectMake(self.circleRadius - dotWidth*0.5, dotWidth*0.5, dotWidth, dotWidth);
     }
     else
     {
     CGFloat dotWidth = self.circleRadius/6*(1+pullingPercent);
     self.coverLayer.frame = CGRectMake(self.circleRadius - dotWidth*0.5, dotWidth*0.5, dotWidth, dotWidth);
     
     if (pullingPercent>0.2f && pullingPercent<1.0f)
     {
     self.coverLayer.strokeColor = self.coverColor.CGColor;
     self.coverLayer.backgroundColor = self.coverColor.CGColor;
     }
     else
     {
     self.coverLayer.strokeColor = [UIColor redColor].CGColor;
     self.coverLayer.backgroundColor = [UIColor redColor].CGColor;
     }
     }
     */
    
    
}

- (void)freshStateRefreshing
{
    [self startAnimation];
    
    [super freshStateRefreshing];
}

- (void)startAnimation
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0.2);
    animation.duration = self.animationDuration;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    [self.coverLayer addAnimation:animation forKey:animation.keyPath];
    
    [CATransaction commit];
}


@end
