//
//  DJFreshBackFooterView.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/7/27.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshBackFooterView.h"

@implementation BMFreshBackFooterView

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
    // scroll高度
    CGFloat scrollHeight = self.scrollView.bm_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    
    CGFloat height = MAX(contentHeight, scrollHeight) + self.bottomOffset;
    self.bm_top = height;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    //NSLog(@"scrollViewContentOffsetDidChange  %@", NSStringFromCGPoint(self.acrollView.contentOffset));
    //NSLog(@"%@  %@", @(self.acrollView.contentSize.height), @(self.acrollView.frame.size.height - self.pullMaxHeight));
    
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.freshState == BMFreshStateRefreshing)
    {
        return;
    }
    
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat happenOffsetY = [self happenOffsetY];
    
    if (offsetY - happenOffsetY <= 0)
    {
        return;
    }
    
    CGFloat pullingPercent = (offsetY - happenOffsetY) / self.pullMaxHeight;
    
    if (self.freshState == BMFreshStateNoMoreData)
    {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging)
    {
        // 拉动幅度
        self.pullingPercent = pullingPercent;
        
        CGFloat normal2pullingOffsetY = happenOffsetY + self.pullMaxHeight;
        
        if (self.freshState == BMFreshStateWillRefresh && offsetY <= normal2pullingOffsetY)
        {
            self.freshState = BMFreshStateIdle;
        }
        else if ((self.freshState == BMFreshStateIdle || self.freshState == BMFreshStateError) && offsetY > normal2pullingOffsetY)
        {
            self.freshState = BMFreshStateWillRefresh;
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

// content超出scrollView视图可视区高度
// 负数时，content不满一屏
- (CGFloat)heightForContentBreakView
{
    // 可视区高度
    CGFloat viewHeight = self.scrollView.bm_height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - viewHeight;
}

- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0)
    {
        return deltaH - self.scrollViewOriginalInset.top;
    }
    else
    {
        // 不满一屏
        return -self.scrollViewOriginalInset.top;
    }
}

- (void)beginReFreshing
{
    [super beginReFreshing];
}

- (void)endReFreshing
{
    [super endReFreshing];
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
                // 设置滚动位置
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = [self happenOffsetY] + self.pullMaxHeight;
                [self.scrollView setContentOffset:offset animated:NO];
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
