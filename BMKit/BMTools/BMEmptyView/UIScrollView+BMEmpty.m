//
//  UIScrollView+BMEmpty.m
//  fengshun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "UIScrollView+BMEmpty.h"
#import <objc/runtime.h>

@implementation UIScrollView (BMEmpty)

- (BOOL)bm_showEmptyView
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return  obj ? [obj boolValue] : YES;
}

- (void)setBm_showEmptyView:(BOOL)showEmptyView
{
    objc_setAssociatedObject(self, @selector(bm_showEmptyView), @(showEmptyView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BMEmptyView *)bm_emptyView
{
    BMEmptyView *emptyView = objc_getAssociatedObject(self, _cmd);
    return emptyView;
}

- (void)setBm_emptyView:(BMEmptyView *)emptyView
{
    objc_setAssociatedObject(self, @selector(bm_emptyView), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type
{
    [self showEmptyViewWithType:type action:nil];
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type action:(BMEmptyViewActionBlock)actionBlock
{
    if (!self.bm_showEmptyView)
    {
        return;
    }
    
    if (!self.bm_emptyView)
    {
        self.bm_emptyView = [BMEmptyView EmptyViewWith:self frame:self.bounds refreshBlock:actionBlock];
    }
    else
    {
        if (actionBlock)
        {
            [self.bm_emptyView setEmptyViewActionBlock:actionBlock];
        }
    }
    
    self.bm_emptyView.emptyViewType = type;
    
    self.bm_emptyView.hidden = NO;
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type customImageName:(NSString *)customImageName customMessage:(NSString *)customMessage customView:(UIView *)customView
{
    [self showEmptyViewWithType:type customImageName:customImageName customMessage:customMessage customView:customView action:nil];
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type customImageName:(NSString *)customImageName customMessage:(NSString *)customMessage customView:(UIView *)customView action:(BMEmptyViewActionBlock)actionBlock
{
    if (!self.bm_showEmptyView)
    {
        return;
    }
    
    if (!self.bm_emptyView)
    {
        self.bm_emptyView = [BMEmptyView EmptyViewWith:self frame:self.bounds refreshBlock:actionBlock];
    }
    else
    {
        if (actionBlock)
        {
            [self.bm_emptyView setEmptyViewActionBlock:actionBlock];
        }
    }
    
    self.bm_emptyView.customImageName = customImageName;
    self.bm_emptyView.customMessage = customMessage;
    
    self.bm_emptyView.emptyViewType = type;
    
    [self.bm_emptyView setCustomView:customView];
    
    self.bm_emptyView.hidden = NO;
}

- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock
{
    [self.bm_emptyView setEmptyViewActionBlock:actionBlock];
}

- (void)hideEmptyView
{
    self.bm_emptyView.hidden = YES;
}

@end
