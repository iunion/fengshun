//
//  DJFreshAutoNormalFooter.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/7/26.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshAutoNormalFooter.h"

@interface BMFreshAutoNormalFooter ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;

@end

@implementation BMFreshAutoNormalFooter

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
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.indicatorView.center = CGPointMake(self.containerSize.width*0.5, self.containerSize.height*0.5);
    
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
    
    [super freshStateNoMoreData];
}

- (void)freshStateIdle
{
    [self.indicatorView stopAnimating];
        
    [super freshStateIdle];
}

- (void)freshStateRefreshing
{
    [self.indicatorView startAnimating];
    
    [super freshStateRefreshing];
}

@end
