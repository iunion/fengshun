//
//  BMFreshTriangleDotHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshTriangleDotHeader.h"

// 圆点直径
#define DEFAULT_DIAMETER        10.0f
// 圆点间距
#define DEFAULT_DISTANCE        4.0f
// 拖动时颜色
#define DEFAULT_DOTNORMALCOLOR  [UIColor lightGrayColor]
// 刷新颜色
#define DEFAULT_DOTREFRESHCOLOR [UIColor redColor]

@interface BMFreshTriangleDotHeader ()

@property (nonatomic, strong) CAShapeLayer *leftLayer;
@property (nonatomic, strong) CAShapeLayer *middleLayer;
@property (nonatomic, strong) CAShapeLayer *rightLayer;

@end
@implementation BMFreshTriangleDotHeader

- (void)setDotDiameter:(CGFloat)dotDiameter
{
    _dotDiameter = dotDiameter;
    self.containerSize = CGSizeMake(dotDiameter*3+self.dotGap*2, dotDiameter*3+self.dotGap*2);
    
    [self setNeedsLayout];
}

- (void)setDotGap:(CGFloat)dotGap
{
    _dotGap = dotGap;
    self.containerSize = CGSizeMake(self.dotDiameter*3+dotGap*2, self.dotDiameter*3+dotGap*2);
    
    [self setNeedsLayout];
}

- (void)setDotNormalColor:(UIColor *)dotNormalColor
{
    _dotNormalColor = dotNormalColor;
}

- (void)setDotRefreshColor:(UIColor *)dotRefreshColor
{
    _dotRefreshColor = dotRefreshColor;
}

- (void)prepare
{
    [super prepare];
    
    self.dotDiameter = DEFAULT_DIAMETER;
    self.dotGap = DEFAULT_DISTANCE;
    
    self.dotNormalColor = DEFAULT_DOTNORMALCOLOR;
    self.dotRefreshColor = DEFAULT_DOTREFRESHCOLOR;
}

- (void)makeDotViews
{
    _leftLayer = [CAShapeLayer layer];
    _leftLayer.backgroundColor = DEFAULT_DOTNORMALCOLOR.CGColor;
    _leftLayer.bounds = CGRectMake(0, 0, DEFAULT_DIAMETER, DEFAULT_DIAMETER);
    _leftLayer.cornerRadius = DEFAULT_DIAMETER*0.5f;
    _leftLayer.masksToBounds = YES;
    [self.containerView.layer addSublayer:_leftLayer];
    
    _middleLayer = [CAShapeLayer layer];
    _middleLayer.backgroundColor = DEFAULT_DOTNORMALCOLOR.CGColor;
    _middleLayer.bounds = CGRectMake(0, 0, DEFAULT_DIAMETER, DEFAULT_DIAMETER);
    _middleLayer.cornerRadius = DEFAULT_DIAMETER*0.5f;
    _middleLayer.masksToBounds = YES;
    [self.containerView.layer addSublayer:_middleLayer];
    
    _rightLayer = [CAShapeLayer layer];
    _rightLayer.backgroundColor = DEFAULT_DOTNORMALCOLOR.CGColor;
    _rightLayer.bounds = CGRectMake(0, 0, DEFAULT_DIAMETER, DEFAULT_DIAMETER);
    _rightLayer.cornerRadius = DEFAULT_DIAMETER*0.5f;
    _rightLayer.masksToBounds = YES;
    [self.containerView.layer addSublayer:_rightLayer];
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    [self makeDotViews];
}

- (void)freshSubviews
{
    [super freshSubviews];
    
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    self.leftLayer.backgroundColor = self.middleLayer.backgroundColor = self.rightLayer.backgroundColor = self.dotNormalColor.CGColor;
    
    if (self.pullingPercent == 0)
    {
        [self.leftLayer removeAllAnimations];
        [self.middleLayer removeAllAnimations];
        [self.rightLayer removeAllAnimations];
    }
    
    CGFloat move = (self.containerSize.height-self.dotDiameter)*0.5f*self.pullingPercent - 2.0f;
    
    if (self.pullingPercent<=0.5f)
    {
        self.leftLayer.frame = CGRectMake(0, 0, self.dotDiameter, self.dotDiameter);
        self.middleLayer.frame = CGRectMake(self.dotDiameter+self.dotGap, 0, self.dotDiameter, self.dotDiameter);
        self.rightLayer.frame = CGRectMake(2*(self.dotDiameter+self.dotGap), 0, self.dotDiameter, self.dotDiameter);
    }
    else if (self.pullingPercent<1.0f)
    {
        _leftLayer.bm_frameCenterY = self.containerSize.height*0.5f + move;
        _rightLayer.bm_frameCenterY = self.containerSize.height*0.5f + move;
        _middleLayer.bm_frameCenterY = self.containerSize.height*0.5f - move;
        
        UIColor *color = [UIColor bm_startColor:self.dotNormalColor endColor:self.dotRefreshColor progress:self.pullingPercent-0.5];
        _leftLayer.backgroundColor = _middleLayer.backgroundColor = _rightLayer.backgroundColor = color.CGColor;
    }
    else
    {
        _leftLayer.bm_frameCenterY = self.containerSize.height-(self.dotDiameter*0.5+2.0f);
        _rightLayer.bm_frameCenterY = self.containerSize.height-(self.dotDiameter*0.5+2.0f);
        _middleLayer.bm_frameCenterY = self.dotDiameter*0.5+2.0f;
        
        _leftLayer.backgroundColor = _middleLayer.backgroundColor = _rightLayer.backgroundColor = self.dotRefreshColor.CGColor;
    }
}

- (void)freshStateRefreshing
{
    [self startAnimation];
    
    [super freshStateRefreshing];
}

- (void)startAnimation
{
    CGPoint topPoint = self.middleLayer.position;
    CGPoint leftPoint = self.leftLayer.position;
    CGPoint rightPoint = self.rightLayer.position;
    
    NSArray *vertexs = @[[NSValue valueWithCGPoint:topPoint],
                         [NSValue valueWithCGPoint:leftPoint],
                         [NSValue valueWithCGPoint:rightPoint]];
    
    CAKeyframeAnimation *key0 = [self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:topPoint vertexs:vertexs] duration:1.5];
    [self.middleLayer addAnimation:key0 forKey:key0.keyPath];
    
    CAKeyframeAnimation *key1 = [self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:leftPoint vertexs:vertexs] duration:1.5];
    [self.rightLayer addAnimation:key1 forKey:key1.keyPath];
    
    CAKeyframeAnimation *key2 = [self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:rightPoint vertexs:vertexs] duration:1.5];
    [self.leftLayer addAnimation:key2 forKey:key2.keyPath];
    
}

- (CAKeyframeAnimation *)keyFrameAnimationWithPath:(UIBezierPath *)path
                                          duration:(NSTimeInterval)duration
{
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.duration = duration;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    return animation;
}

- (UIBezierPath *)trianglePathWithStartPoint:(CGPoint)startPoint vertexs:(NSArray *)vertexs
{
    CGPoint topPoint  = [[vertexs objectAtIndex:0] CGPointValue];
    CGPoint leftPoint  = [[vertexs objectAtIndex:1] CGPointValue];
    CGPoint rightPoint  = [[vertexs objectAtIndex:2] CGPointValue];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (CGPointEqualToPoint(startPoint, topPoint))
    {
        [path moveToPoint:startPoint];
        [path addLineToPoint:rightPoint];
        [path addLineToPoint:leftPoint];
    }
    else if (CGPointEqualToPoint(startPoint, leftPoint))
    {
        [path moveToPoint:startPoint];
        [path addLineToPoint:topPoint];
        [path addLineToPoint:rightPoint];
    }
    else
    {
        [path moveToPoint:startPoint];
        [path addLineToPoint:leftPoint];
        [path addLineToPoint:topPoint];
    }
    
    [path closePath];
    
    return path;
}

@end
