//
//  BMNavigationBar.m
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/4/28.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMNavigationBar.h"
#import "BMNavigationBarDefine.h"

@interface BMNavigationBar ()

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *shadowLineImageView;

@end

@implementation BMNavigationBar

- (UIVisualEffectView *)effectView
{
    [UIView setAnimationsEnabled:NO];
    if (self.subviews.count && !_effectView)
    {
        [super setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        UIView *view = self.subviews.firstObject;
        
        _effectView = [[UIVisualEffectView alloc] initWithEffect:BMNavigationBar_DefaultEffect];
        //_effectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        _effectView.userInteractionEnabled = NO;
        _effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view insertSubview:_effectView atIndex:0];
        _effectView.frame = view.bounds;
    }
    [UIView setAnimationsEnabled:YES];

    return _effectView;
}

- (UIVisualEffect *)effect
{
    return self.effectView.effect;
}

- (void)setEffect:(UIVisualEffect *)effect
{
    self.effectView.effect = effect;
}

- (UIImageView *)backgroundImageView
{
    [UIView setAnimationsEnabled:NO];
    if (self.subviews.count && !_backgroundImageView)
    {
        UIView *view = self.subviews.firstObject;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = NO;
        _backgroundImageView.contentScaleFactor = 1;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view insertSubview:_backgroundImageView aboveSubview:self.effectView];
    }
    [UIView setAnimationsEnabled:YES];
    
    return _backgroundImageView;
}

- (UIImageView *)shadowLineImageView
{
    [UIView setAnimationsEnabled:NO];
    if (self.subviews.count && !_shadowLineImageView)
    {
        [super setShadowImage:[UIImage new]];
        UIView *view = self.subviews.firstObject;
        
        _shadowLineImageView = [[UIImageView alloc] init];
        _shadowLineImageView.userInteractionEnabled = NO;
        _shadowLineImageView.contentScaleFactor = 1;
        [view insertSubview:_shadowLineImageView aboveSubview:self.backgroundImageView];
    }
    [UIView setAnimationsEnabled:YES];

    return _shadowLineImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.effectView.frame = self.effectView.superview.bounds;
    self.backgroundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.shadowLineImageView.superview.bounds), CGRectGetHeight(self.shadowLineImageView.superview.bounds)-1.0f/[UIScreen mainScreen].scale);
    self.shadowLineImageView.frame = CGRectMake(0, CGRectGetHeight(self.shadowLineImageView.superview.bounds)-1.0f/[UIScreen mainScreen].scale, CGRectGetWidth(self.shadowLineImageView.superview.bounds), 1.0f/[UIScreen mainScreen].scale);
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    self.backgroundImageView.image = backgroundImage;
    return;
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    [super setBarTintColor:barTintColor];
    self.effectView.contentView.backgroundColor = barTintColor;
}

- (void)setShadowImage:(UIImage *)shadowImage
{
    self.shadowLineImageView.image = shadowImage;
    if (shadowImage)
    {
        self.shadowLineImageView.backgroundColor = nil;
    }
    else
    {
        self.shadowLineImageView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.4f];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01)
    {
        return nil;
    }
    
    UIView *view = [super hitTest:point withEvent:event];
    
    NSString *viewName = [[[view classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    
    if (view && [viewName isEqualToString:@"BMNavigationBar"])
    {
        for (UIView *subview in self.subviews)
        {
            NSString *viewName = [[[subview classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
            NSArray *array = @[@"UINavigationItemButtonView"];
            if ([array containsObject:viewName])
            {
                CGPoint convertedPoint = [self convertPoint:point toView:subview];
                CGRect bounds = subview.bounds;
                if (bounds.size.width < 80.0f)
                {
                    bounds = CGRectInset(bounds, bounds.size.width - 80.0f, 0);
                }
                if (CGRectContainsPoint(bounds, convertedPoint))
                {
                    return view;
                }
            }
        }
    }
    
    NSArray *array = @[ @"UINavigationBarContentView", @"UITAMICAdaptorView", @"BMNavigationBar" ];
    if ([array containsObject:viewName])
    {
        if (self.effectView.alpha < 0.01)
        {
            return nil;
        }
    }

    if (CGRectEqualToRect(view.bounds, CGRectZero))
    {
        return nil;
    }
    
    return view;
}

@end
