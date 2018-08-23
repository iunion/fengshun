//
//  BMFreshNormalHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshNormalHeader.h"

@interface BMFreshNormalHeader ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) UIImageView *arrowImageView;

@end

@implementation BMFreshNormalHeader

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
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bmfresh_arrow"]];
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

- (void)freshStateIdle
{
    [self.indicatorView stopAnimating];
    
    self.arrowImageView.hidden = NO;
    [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
    }];
    
    [super freshStateIdle];
}

- (void)freshStateWillRefresh
{
    self.arrowImageView.hidden = NO;
    [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
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
