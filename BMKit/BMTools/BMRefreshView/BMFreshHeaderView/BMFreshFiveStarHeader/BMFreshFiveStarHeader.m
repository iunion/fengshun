//
//  BMFreshFiveStarHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshFiveStarHeader.h"

#define DEFAULT_STARWIDTH   24.0f
#define DEFAULT_SIDECOLOR   [UIColor redColor]

@interface BMFreshFiveStarHeader ()

@property (nonatomic, strong) CAShapeLayer *starShapeLayer;

@end

@implementation BMFreshFiveStarHeader

- (void)setCoverColor:(UIColor *)coverColor
{
    _coverColor = coverColor;
}

- (void)setStarWidth:(CGFloat)starWidth
{
    _starWidth = starWidth;
    self.containerSize = CGSizeMake(starWidth, starWidth);
    
    self.starShapeLayer.position = CGPointMake(DEFAULT_STARWIDTH/2, DEFAULT_STARWIDTH/2);
    self.starShapeLayer.strokeStart = 0.0f;
    self.starShapeLayer.strokeEnd = 0.0f;
    self.starShapeLayer.speed = 0.0f;
    
    // 外接圆半径
    CGFloat radius = DEFAULT_STARWIDTH/2/sin(72*M_PI/180);
    // 中心点到两点间垂线
    CGFloat hight = cos(36*M_PI/180) * radius;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    [bezierPath moveToPoint:CGPointMake(DEFAULT_STARWIDTH, DEFAULT_STARWIDTH-radius)];
    [bezierPath addLineToPoint:CGPointMake(DEFAULT_STARWIDTH-sin(36*M_PI/180)*radius, DEFAULT_STARWIDTH+hight)];
    [bezierPath addLineToPoint:CGPointMake(DEFAULT_STARWIDTH+DEFAULT_STARWIDTH/2, DEFAULT_STARWIDTH-DEFAULT_STARWIDTH/2*tan(18*M_PI/180))];
    [bezierPath addLineToPoint:CGPointMake(DEFAULT_STARWIDTH-DEFAULT_STARWIDTH/2, DEFAULT_STARWIDTH-DEFAULT_STARWIDTH/2*tan(18*M_PI/180))];
    [bezierPath addLineToPoint:CGPointMake(DEFAULT_STARWIDTH+sin(36*M_PI/180)*radius, DEFAULT_STARWIDTH+hight)];
    [bezierPath closePath];
    self.starShapeLayer.path = bezierPath.CGPath;
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.fromValue = @(0.0);
    basic.toValue = @(1.0f);
    basic.duration = 1.0f;
    basic.removedOnCompletion = NO;
    basic.fillMode = kCAFillModeForwards;
    [self.starShapeLayer addAnimation:basic forKey:@"AnimationStroke"];
}

- (void)prepare
{
    [super prepare];
    
    //self.starWidth = DEFAULT_STARWIDTH;
    self.coverColor = DEFAULT_SIDECOLOR;
}

- (void)makeStarShapeLayer
{
    self.starShapeLayer = [CAShapeLayer layer];
    self.starShapeLayer.bounds = CGRectMake(0, 0, DEFAULT_STARWIDTH*2, DEFAULT_STARWIDTH*2);
    self.starShapeLayer.lineWidth = 2.0f;
    self.starShapeLayer.lineCap = kCALineCapRound;
    self.starShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.starShapeLayer.strokeColor = DEFAULT_SIDECOLOR.CGColor;
    [self.containerView.layer addSublayer:self.starShapeLayer];
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    [self makeStarShapeLayer];
    
    self.starWidth = DEFAULT_STARWIDTH;
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.starShapeLayer.strokeColor = self.coverColor.CGColor;
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    self.starShapeLayer.speed = 0.0f;
    
    CGFloat timeOffset = 0;
    if (self.pullingPercent >= 0.5)
    {
        timeOffset = [BMFreshHeaderView zoomFloatData:self.pullingPercent fromMin:0.5 fromMax:1 toMin:0 toMax:1];
    }
    self.starShapeLayer.timeOffset = timeOffset;
    
    if (pullingPercent == 0)
    {
        [self.starShapeLayer removeAnimationForKey:@"animationGroup"];
    }
}

- (void)freshStateRefreshing
{
    [self startAnimation];
    
    [super freshStateRefreshing];
}

- (void)startAnimation
{
    self.starShapeLayer.speed = 1.0f;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @(0.0);
    rotate.toValue = @(2*M_PI);
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *scale =[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0.6, 0.6)],[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
    scale.removedOnCompletion = NO;
    scale.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *groupAni = [CAAnimationGroup animation];
    groupAni.duration = 2.0f;
    groupAni.repeatCount = HUGE;
    groupAni.removedOnCompletion = NO;
    groupAni.fillMode = kCAFillModeForwards;
    groupAni.animations = @[rotate,scale];
    [self.starShapeLayer addAnimation:groupAni forKey:@"animationGroup"];
}

@end
