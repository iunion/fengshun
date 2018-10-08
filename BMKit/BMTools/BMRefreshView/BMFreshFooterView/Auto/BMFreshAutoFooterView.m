//
//  DJFreshAutoFooterView.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/8/6.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshAutoFooterView.h"

#define MinTriggerAutomaticallyRefreshPercent  0.5f

@implementation BMFreshAutoFooterView

- (void)prepare
{
    [super prepare];
    
    self.automaticallyRefresh = YES;
    self.triggerAutomaticallyRefreshPercent = 1.0f;
}

- (void)setTriggerAutomaticallyRefreshPercent:(CGFloat)triggerAutomaticallyRefreshPercent
{
    if (triggerAutomaticallyRefreshPercent > 1.0f)
    {
        triggerAutomaticallyRefreshPercent = 1.0f;
    }
    else if (triggerAutomaticallyRefreshPercent < MinTriggerAutomaticallyRefreshPercent)
    {
        triggerAutomaticallyRefreshPercent = MinTriggerAutomaticallyRefreshPercent;
    }
    _triggerAutomaticallyRefreshPercent = triggerAutomaticallyRefreshPercent;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // content高度
    CGFloat contentHeight = self.scrollView.contentSize.height;
    self.bm_top = contentHeight;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.freshState == BMFreshStateRefreshing)
    {
        return;
    }

    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat insetTop = self.scrollView.contentInset.top;
    CGFloat insetBottom = self.scrollView.contentInset.bottom;
    CGFloat contentHeight = self.scrollView.contentSize.height;
    
    CGFloat scrollPullHeight = offsetY + insetTop + insetBottom;
    CGFloat pullingPercent = scrollPullHeight / self.pullMaxHeight;
    CGFloat pullMaxHeight = self.pullMaxHeight;
    if (scrollPullHeight < pullMaxHeight*MinTriggerAutomaticallyRefreshPercent)
    {
        // 拉动幅度
        self.pullingPercent = pullingPercent;
        return;
    }
    
    pullMaxHeight = self.pullMaxHeight*self.triggerAutomaticallyRefreshPercent;

    if (self.scrollView.isDragging)
    {
        // 拉动幅度
        self.pullingPercent = pullingPercent;
        
        // 满一屏
        if (contentHeight >= self.scrollView.bm_height-pullMaxHeight)
        {
            if (self.freshState == BMFreshStateIdle || self.freshState == BMFreshStateError)
            {
                if (scrollPullHeight + self.scrollView.bm_height >= contentHeight + pullMaxHeight)
                {
                    if (self.isAutomaticallyRefresh)
                    {
                        [self beginReFreshing];
                    }
                    else
                    {
                        self.freshState = BMFreshStateWillRefresh;
                    }
                }
            }
            else if (self.freshState == BMFreshStateWillRefresh)
            {
                if (scrollPullHeight + self.scrollView.bm_height < contentHeight + pullMaxHeight)
                {
                    self.freshState = BMFreshStateIdle;
                }
            }
        }
        else
        {
            if (self.freshState == BMFreshStateIdle || self.freshState == BMFreshStateError)
            {
                if (scrollPullHeight >= 1)
                {
                    if (self.isAutomaticallyRefresh)
                    {
                        [self beginReFreshing];
                    }
                }
            }
            else if (self.freshState == BMFreshStateWillRefresh)
            {
                self.freshState = BMFreshStateIdle;
            }
        }
    }
    else
    {
        if (self.freshState == BMFreshStateWillRefresh)
        {
            [self beginReFreshing];
        }
        else if (pullingPercent < 1)
        {
            self.pullingPercent = pullingPercent;
        }
    }
}

- (void)setFreshState:(BMFreshState)freshState
{
    BMFreshState oldState = self.freshState;
    if (freshState == oldState)
    {
        return;
    }
    
    [super setFreshState:freshState];
    
    switch (freshState)
    {
        case BMFreshStateError:
        {
            [self freshStateError];
            break;
        }
        case BMFreshStateNoMoreData:
        case BMFreshStateIdle:
        {
            if (oldState == BMFreshStateRefreshing)
            {
                [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
                    self.scrollView.contentInset = self.scrollViewOriginalInset;
                    if (self.isAutomaticallyChangeAlpha)
                    {
                        self.alpha = 0.0f;
                    }
                } completion:^(BOOL finished) {
                    self.pullingPercent = 0.0f;
                    if (freshState == BMFreshStateIdle)
                    {
                        [self freshStateIdle];
                    }
                    else
                    {
                        [self freshStateNoMoreData];
                    }
                }];
            }
            else
            {
                self.pullingPercent = 0.0f;
                if (freshState == BMFreshStateIdle)
                {
                    [self freshStateIdle];
                }
                else
                {
                    [self freshStateNoMoreData];
                }
            }
            break;
        }
        case BMFreshStateWillRefresh:
        {
            [self freshStateWillRefresh];
            break;
        }
        case BMFreshStateRefreshing:
        {
            UIEdgeInsets contentInset = self.scrollViewOriginalInset;
            contentInset.bottom += self.pullMaxHeight;
            [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
                // 增加滚动区域top
                self.scrollView.contentInset = contentInset;
            } completion:^(BOOL finished) {
                if (self.freshState == BMFreshStateRefreshing)
                {
                    [self freshStateRefreshing];
                }
            }];
            break;
        }
            
        default:
            break;
    }
}


@end
