//
//  UIScrollView+DJFresh.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/7/26.
//Copyright © 2018年 DJ. All rights reserved.
//

#import "UIScrollView+BMFresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (BMFresh)

- (BMFreshHeaderView *)dj_freshHeaderView
{
    BMFreshHeaderView *freshHeaderView = objc_getAssociatedObject(self, _cmd);
    return freshHeaderView;
}

- (void)setDj_freshHeaderView:(BMFreshHeaderView *)freshHeaderView
{
    if (freshHeaderView != self.dj_freshHeaderView)
    {
        if (self.dj_freshHeaderView.superview)
        {
            [self.dj_freshHeaderView removeFromSuperview];
        }

        [self insertSubview:freshHeaderView atIndex:0];
        
        // KVO
        [self willChangeValueForKey:@"dj_freshHeaderView"];
        objc_setAssociatedObject(self, @selector(dj_freshHeaderView), freshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"dj_freshHeaderView"];
    }
}

- (BMFreshFooterView *)dj_freshFooterView
{
    BMFreshFooterView *freshFooterView = objc_getAssociatedObject(self, _cmd);
    return freshFooterView;
}

- (void)setDj_freshFooterView:(BMFreshFooterView *)freshFooterView
{
    if (freshFooterView != self.dj_freshFooterView)
    {
        if (self.dj_freshFooterView.superview)
        {
            [self.dj_freshFooterView removeFromSuperview];
        }
        
        [self insertSubview:freshFooterView atIndex:0];
        
        // KVO
        [self willChangeValueForKey:@"dj_freshFooterView"];
        objc_setAssociatedObject(self, @selector(dj_freshFooterView), freshFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"dj_freshFooterView"];
    }
}

- (void)resetFreshHeaderState
{
    [self.dj_freshHeaderView endReFreshing];
}

- (void)resetFreshFooterState
{
    [self.dj_freshFooterView endReFreshing];
}

- (void)resetFreshFooterStateWithNoMoreData
{
    [self.dj_freshFooterView endReFreshingWithNoMoreData];
}

@end
