//
//  BMFreshDotHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshDotHeader.h"

// 圆点直径
#define DEFAULT_DIAMETER        10.0f
// 圆点间距
#define DEFAULT_DISTANCE        4.0f
// 拖动时颜色
#define DEFAULT_DOTNORMALCOLOR  [UIColor lightGrayColor]
// 刷新颜色
#define DEFAULT_DOTREFRESHCOLOR [UIColor redColor]

@interface BMFreshDotHeader ()

@property (nonatomic, strong) CAShapeLayer *leftLayer;
@property (nonatomic, strong) CAShapeLayer *middleLayer;
@property (nonatomic, strong) CAShapeLayer *rightLayer;

@end

@implementation BMFreshDotHeader

- (void)setDotDiameter:(CGFloat)dotDiameter
{
    _dotDiameter = dotDiameter;
    self.containerSize = CGSizeMake(dotDiameter*3+self.dotGap*2, dotDiameter);
    
    [self setNeedsLayout];
}

- (void)setDotGap:(CGFloat)dotGap
{
    _dotGap = dotGap;
    self.containerSize = CGSizeMake(self.dotDiameter*3+dotGap*2, self.dotDiameter);
    
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
    
    self.leftLayer.frame = CGRectMake(0, 0, self.dotDiameter, self.dotDiameter);
    self.middleLayer.frame = CGRectMake(self.dotDiameter+self.dotGap, 0, self.dotDiameter, self.dotDiameter);
    self.rightLayer.frame = CGRectMake(2*(self.dotDiameter+self.dotGap), 0, self.dotDiameter, self.dotDiameter);
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
    
    if (self.pullingPercent<=0.5f)
    {
        _leftLayer.hidden = _rightLayer.hidden = YES;
    }
    else if (self.pullingPercent<1.0f)
    {
        _middleLayer.transform = CATransform3DMakeScale(2-self.pullingPercent, 2-self.pullingPercent, 2-self.pullingPercent);
        _leftLayer.hidden = _rightLayer.hidden = NO;
        
        _leftLayer.bm_frameCenterX = self.containerSize.width/2 - (self.dotDiameter + self.dotGap)*self.pullingPercent;
        _rightLayer.bm_frameCenterX = self.containerSize.width/2 + (self.dotDiameter + self.dotGap)*self.pullingPercent;
        
        UIColor *color = [UIColor bm_startColor:self.dotNormalColor endColor:self.dotRefreshColor progress:self.pullingPercent-0.5];
        _leftLayer.backgroundColor = _middleLayer.backgroundColor = _rightLayer.backgroundColor = color.CGColor;
    }
    else
    {
        _middleLayer.transform = CATransform3DIdentity;
        _leftLayer.hidden = _rightLayer.hidden = NO;
        
        _leftLayer.bm_frameLetf = 0;
        _rightLayer.bm_frameLetf = (self.dotDiameter + self.dotGap)*2;
        
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
    _leftLayer.backgroundColor = _middleLayer.backgroundColor = _rightLayer.backgroundColor = self.dotRefreshColor.CGColor;
    
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    CATransform3D t3 = CATransform3DScale(t, 0.1, 0.1, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    scaleAnim.duration = 0.45;
    scaleAnim.autoreverses = YES;
    scaleAnim.repeatCount = HUGE;
    [self.leftLayer addAnimation:scaleAnim forKey:nil];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        CATransform3D t2 = CATransform3DScale(t, 1.0, 1.0, 0.0);
        CATransform3D t3 = CATransform3DScale(t, 0.1, 0.1, 0.0);
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
        scaleAnim.duration = 0.45;
        scaleAnim.autoreverses = YES;
        scaleAnim.repeatCount = HUGE;
        [weakSelf.middleLayer addAnimation:scaleAnim forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
            CATransform3D t = CATransform3DIdentity;
            CATransform3D t2 = CATransform3DScale(t, 1.0, 1.0, 0.0);
            CATransform3D t3 = CATransform3DScale(t, 0.1, 0.1, 0.0);
            scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
            scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
            scaleAnim.duration = 0.45;
            scaleAnim.autoreverses = YES;
            scaleAnim.repeatCount = HUGE;
            [weakSelf.rightLayer addAnimation:scaleAnim forKey:nil];
        });
    });
}

@end
