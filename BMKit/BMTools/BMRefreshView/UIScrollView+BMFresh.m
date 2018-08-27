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

- (BMFreshHeaderView *)bm_freshHeaderView
{
    BMFreshHeaderView *freshHeaderView = objc_getAssociatedObject(self, _cmd);
    return freshHeaderView;
}

- (void)setBm_freshHeaderView:(BMFreshHeaderView *)freshHeaderView
{
    if (freshHeaderView != self.bm_freshHeaderView)
    {
        if (self.bm_freshHeaderView.superview)
        {
            [self.bm_freshHeaderView removeFromSuperview];
        }

        [self insertSubview:freshHeaderView atIndex:0];
        
        // KVO
        [self willChangeValueForKey:@"dj_freshHeaderView"];
        objc_setAssociatedObject(self, @selector(bm_freshHeaderView), freshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"dj_freshHeaderView"];
    }
}

- (BMFreshFooterView *)bm_freshFooterView
{
    BMFreshFooterView *freshFooterView = objc_getAssociatedObject(self, _cmd);
    return freshFooterView;
}

- (void)setBm_freshFooterView:(BMFreshFooterView *)freshFooterView
{
    if (freshFooterView != self.bm_freshFooterView)
    {
        if (self.bm_freshFooterView.superview)
        {
            [self.bm_freshFooterView removeFromSuperview];
        }
        
        [self insertSubview:freshFooterView atIndex:0];
        
        // KVO
        [self willChangeValueForKey:@"dj_freshFooterView"];
        objc_setAssociatedObject(self, @selector(bm_freshFooterView), freshFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"dj_freshFooterView"];
    }
}

- (void)resetFreshHeaderState
{
    [self.bm_freshHeaderView endReFreshing];
}

- (void)resetFreshFooterState
{
    [self.bm_freshFooterView endReFreshing];
}

- (void)resetFreshFooterStateWithNoMoreData
{
    [self.bm_freshFooterView endReFreshingWithNoMoreData];
}

- (void)setFreshTitles:(NSDictionary *)titles
{
    [self.bm_freshHeaderView setFreshTitles:titles];
    [self.bm_freshFooterView setFreshTitles:titles];
}

- (void)setHeaderFreshTitles:(NSDictionary *)titles
{
    [self.bm_freshHeaderView setFreshTitles:titles];
}

- (void)setFooterFreshTitles:(NSDictionary *)titles
{
    [self.bm_freshFooterView setFreshTitles:titles];
}


@end
