//
//  FSWebViewProgressView.m
//  FSWebView
//
//  Created by DJ on 2017/7/21.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "FSWebViewProgressView.h"

@implementation FSWebViewProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureViews];
}

- (void)configureViews
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    // 初始进度
    _progressBarView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    //_progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
//    if ([UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(setTintColor:)] && UIApplication.sharedApplication.delegate.window.tintColor) {
//        tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
//    }
//    _progressBarView.backgroundColor = tintColor;
    _progressBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setBarColor:(UIColor *)barColor
{
    if (!barColor)
    {
        barColor = [UIColor whiteColor];
    }
    self.progressBarView.backgroundColor = barColor;
}

- (UIColor *)barColor
{
    return self.progressBarView.backgroundColor;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self->_progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        self->_progressBarView.frame = frame;
    } completion:nil];

    if (progress >= 1.0)
    {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self->_progressBarView.frame;
            frame.size.width = 0;
            self->_progressBarView.frame = frame;
        }];
    }
    else
    {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

@end