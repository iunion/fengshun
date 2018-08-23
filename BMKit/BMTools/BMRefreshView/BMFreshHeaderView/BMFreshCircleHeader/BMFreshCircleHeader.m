//
//  BMFreshCircleHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshCircleHeader.h"

#define DEFAULT_ANIMATETIME     0.75f
#define DEFAULT_LINEWIDTH       2.0f
#define DEFAULT_RADIUS          12.0f

@interface BMFreshCircleHeader ()
<
CAAnimationDelegate
>

@property (nonatomic, strong) CAShapeLayer *shadowLayer;
@property (nonatomic, strong) CAShapeLayer *coverLayer;

@end

@implementation BMFreshCircleHeader
@synthesize circleRadius = _circleRadius;


- (CAShapeLayer *)shadowLayer
{
    if (_shadowLayer == nil)
    {
        _shadowLayer = [CAShapeLayer layer];
        _shadowLayer.contentsScale = [[UIScreen mainScreen] scale];
        _shadowLayer.fillColor = [UIColor clearColor].CGColor;
        _shadowLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _shadowLayer.lineCap = kCALineCapRound;
        _shadowLayer.lineJoin = kCALineJoinRound;
        _shadowLayer.lineWidth = DEFAULT_LINEWIDTH;
        _shadowLayer.frame = CGRectMake(0, 0, DEFAULT_RADIUS * 2, DEFAULT_RADIUS * 2);
        //_shadowLayer.path = [UIBezierPath bezierPathWithOvalInRect:_shadowLayer.bounds].CGPath;
        [self.containerView.layer insertSublayer:_shadowLayer atIndex:0];
    }
    return _shadowLayer;
}

- (CAShapeLayer *)coverLayer
{
    if (!_coverLayer)
    {
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
        [self.containerView.layer addSublayer:_coverLayer];
    }
    return _coverLayer;
}

- (void)setCoverColor:(UIColor *)coverColor
{
    _coverColor = coverColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
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

- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    
    [self setNeedsLayout];
}

- (void)prepare
{
    [super prepare];
    
    self.circleRadius = DEFAULT_RADIUS;
    self.animationDuration = DEFAULT_ANIMATETIME;
    self.isSemiCircle = NO;
    
    self.shadowColor = [UIColor lightGrayColor];
    self.coverColor = [UIColor redColor];
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    self.shadowLayer.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
    self.coverLayer.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
    self.isShowShadow = NO;
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.coverLayer.frame = CGRectMake(0, 0, self.circleRadius*2, self.circleRadius*2);
    self.coverLayer.path = [UIBezierPath bezierPathWithOvalInRect:_coverLayer.bounds].CGPath;
    self.shadowLayer.frame = CGRectMake(0, 0, self.circleRadius*2, self.circleRadius*2);
    self.shadowLayer.path = [UIBezierPath bezierPathWithOvalInRect:_shadowLayer.bounds].CGPath;
    
    self.shadowLayer.strokeColor = self.shadowColor.CGColor;
    self.coverLayer.strokeColor = self.coverColor.CGColor;
    
    self.shadowLayer.hidden = !self.isShowShadow;
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
    [self startAnimation:NO];
    
    [super freshStateRefreshing];
}

- (void)startAnimation:(BOOL)reverse
{
    if (self.isSemiCircle)
    {
        [self startSemiCircleAnimation];
    }
    else
    {
        [self startCircleAnimation:reverse];
    }
}

- (void)startCircleAnimation:(BOOL)reverse
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (reverse)
    {
        self.coverLayer.strokeStart = 0.89;
        self.coverLayer.strokeEnd = 0.9;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @(0.9);
        strokeAnimation.duration = self.animationDuration;
        strokeAnimation.delegate = self;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
        [self.coverLayer removeAnimationForKey:@"strokeStart"];
        [self.coverLayer addAnimation:strokeAnimation forKey:@"strokeStart"];
        
    }
    else
    {
        self.coverLayer.strokeStart = 0;
        self.coverLayer.strokeEnd = 0.9;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @(0.9);
        strokeAnimation.duration = self.animationDuration;
        strokeAnimation.delegate = self;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
        
        [self.coverLayer removeAnimationForKey:@"strokeEnd"];
        [self.coverLayer addAnimation:strokeAnimation forKey:@"strokeEnd"];
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(0);
        rotationAnimation.toValue = @(2 * M_PI);
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.duration = 2*self.animationDuration;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        [self.coverLayer removeAnimationForKey:@"rotation"];
        [self.coverLayer addAnimation:rotationAnimation forKey:@"rotation"];
    }
    [CATransaction commit];
}

- (void)startSemiCircleAnimation
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.coverLayer.strokeStart = 0;
    self.coverLayer.strokeEnd = 0.8;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = self.animationDuration;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = HUGE;
    [self.coverLayer removeAnimationForKey:@"rotation"];
    [self.coverLayer addAnimation:rotationAnimation forKey:@"rotation"];
    [CATransaction commit];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished && [anim isKindOfClass:[CABasicAnimation class]])
    {
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
        BOOL isStrokeEnd = [basicAnim.keyPath isEqualToString:@"strokeEnd"];
        [self startAnimation:isStrokeEnd];
    }
}

@end
