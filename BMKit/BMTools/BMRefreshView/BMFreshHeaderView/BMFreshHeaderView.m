//
//  BMFreshHeaderView.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshHeaderView.h"

const CGFloat BMFreshHeaderHeight = 48.0f;

@interface BMFreshHeaderView ()

@property (nonatomic, strong) NSDate *lastUpdatedTime;

@end

@implementation BMFreshHeaderView

- (void)prepare
{
    [super prepare];
    
    // 设置高度
    self.bm_width = UI_SCREEN_WIDTH;
    self.bm_height = BMFreshHeaderHeight;
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    self.pullMaxHeight = self.bm_height + self.topOffset;
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.bm_top = - self.bm_height - self.topOffset;
}

- (void)setTopOffset:(CGFloat)topOffset
{
    _topOffset = topOffset;
    
    self.bm_top = - self.bm_height - topOffset;
    self.pullMaxHeight = self.bm_height + topOffset;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    //NSLog(@"scrollView.contentOffset.y : %@", @(self.scrollView.contentOffset.y));
    
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.freshState == BMFreshStateRefreshing)
    {
        //        CGFloat offset = MAX(-self.scrollView.contentOffset.y, self.scrollViewOriginalInset.top);
        //        offset = MIN(offset, self.pullMaxHeight);
        //        self.scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        
        return;
    }
    
    _scrollViewOriginalInset = self.scrollView.contentInset;
    //NSLog(@"scrollViewInset : %@", @(self.scrollViewOriginalInset.top));
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY >= happenOffsetY)
    {
        return;
    }
    
    CGFloat normal2pullingOffsetY = happenOffsetY - self.pullMaxHeight;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.pullMaxHeight;
    
    if (self.scrollView.isDragging)
    {
        // 拉动幅度
        self.pullingPercent = pullingPercent;
        
        if (self.freshState == BMFreshStateWillRefresh && offsetY < happenOffsetY && offsetY > normal2pullingOffsetY)
        {
            //NSLog(@"DJFreshStateIdle");
            self.freshState = BMFreshStateIdle;
        }
        else if ((self.freshState == BMFreshStateIdle || self.freshState == BMFreshStateError) && offsetY <= normal2pullingOffsetY)
        {
            //NSLog(@"offsetY : %@, normal2pullingOffsetY: %@", @(offsetY), @(normal2pullingOffsetY));
            //NSLog(@"DJFreshStateWillRefresh");
            self.freshState = BMFreshStateWillRefresh;
        }
    }
    else
    {
        // 拖动放手后，offsetY回弹变小(+15)
        //if (self.freshState == DJFreshStateWillRefresh && offsetY <= normal2pullingOffsetY+15)
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
            case BMFreshStateIdle:
        {
            if (oldState == BMFreshStateRefreshing)
            {
                self.lastUpdatedTime = [NSDate date];
                
                [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
                    self.scrollView.contentInset = self.scrollViewOriginalInset;
                    if (self.isAutomaticallyChangeAlpha)
                    {
                        self.alpha = 0.0f;
                    }
                } completion:^(BOOL finished) {
                    self.pullingPercent = 0.0f;
                    [self freshStateIdle];
                }];
            }
            else
            {
                [self freshStateIdle];
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
            contentInset.top += self.pullMaxHeight;
            [UIView animateWithDuration:BMFreshAnimationDuration animations:^{
                // 增加滚动区域top
                self.scrollView.contentInset = contentInset;
                // 设置滚动位置
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = -contentInset.top;
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
