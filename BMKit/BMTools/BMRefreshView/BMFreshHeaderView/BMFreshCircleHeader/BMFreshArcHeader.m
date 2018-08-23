//
//  BMFreshArcHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshArcHeader.h"

#define DEFAULT_ANIMATETIME     0.75f
#define DEFAULT_LINEWIDTH       2.0f
#define DEFAULT_RADIUS          12.0f

@interface BMFreshArcHeader ()

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;

@property (nonatomic, strong) CAShapeLayer *coverLayer;

@end

@implementation BMFreshArcHeader

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
        
        _replicatorLayer.instanceCount = 2;
        _replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 0.1);
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

- (void)setCoverColor:(UIColor *)coverColor
{
    _coverColor = coverColor;
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
    
    self.coverColor = [UIColor redColor];
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    self.replicatorLayer.frame  = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
    self.coverLayer.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.replicatorLayer.frame = CGRectMake(0, 0, self.circleRadius*2, self.circleRadius*2);
    
    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath addArcWithCenter:CGPointMake(self.circleRadius, self.circleRadius)
                       radius:self.circleRadius
                   startAngle:M_PI/2.3
                     endAngle:-M_PI/2.3
                    clockwise:NO];
    
    self.coverLayer.frame = CGRectMake(0, 0, self.circleRadius*2, self.circleRadius*2);
    self.coverLayer.path = arcPath.CGPath;
    
    self.coverLayer.strokeColor = self.coverColor.CGColor;
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
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.coverLayer.strokeEnd = self.pullingPercent;
    [CATransaction commit];
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
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0.0);
    animation.toValue = @(2*M_PI);
    animation.duration = self.animationDuration;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    [self.coverLayer addAnimation:animation forKey:animation.keyPath];
    
    [CATransaction commit];
}


@end
