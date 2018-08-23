//
//  DJFreshBackNormalFooter.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/7/26.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshBackNormalFooter.h"

@interface BMFreshBackNormalFooter ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) UIImageView *arrowImageView;

@end

@implementation BMFreshBackNormalFooter

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView)
    {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        _indicatorView = loadingView;
        [self.containerView addSubview:loadingView];
    }
    return _indicatorView;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView)
    {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"djfresh_arrow"]];
        _arrowImageView = arrowView;
        [self.containerView addSubview: arrowView];
    }
    return _arrowImageView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.indicatorView = nil;
    [self setNeedsLayout];
}

- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.containerSize = CGSizeMake(24.0f, 24.0f);
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    self.indicatorView.center = CGPointMake(self.containerSize.width*0.5, self.containerSize.height*0.5);
    self.arrowImageView.center = self.indicatorView.center;
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.arrowImageView.bm_size = self.containerSize;
    self.indicatorView.center = CGPointMake(self.containerSize.width*0.5, self.containerSize.height*0.5);
    self.arrowImageView.center = self.indicatorView.center;
    
    self.indicatorView.tintColor = self.messageLabel.textColor;
}

- (void)setFreshTitle:(id)title forState:(BMFreshState)state
{
    [super setFreshTitle:title forState:state];
    
    if (state == self.freshState)
    {
        [self setNeedsLayout];
    }
}

- (void)setFreshState:(BMFreshState)freshState
{
    [super setFreshState:freshState];
    
    [self setNeedsLayout];
}

- (void)freshStateNoMoreData
{
    [self.indicatorView stopAnimating];
    
    self.arrowImageView.hidden = NO;
    [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    [super freshStateNoMoreData];
}

- (void)freshStateIdle
{
    [self.indicatorView stopAnimating];
    
    self.arrowImageView.hidden = NO;
    [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    [super freshStateIdle];
}

- (void)freshStateWillRefresh
{
    self.arrowImageView.hidden = NO;
    [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
    }];
    
    [super freshStateWillRefresh];
}

- (void)freshStateRefreshing
{
    self.arrowImageView.hidden = YES;
    [self.indicatorView startAnimating];
    
    [super freshStateRefreshing];
}

@end
