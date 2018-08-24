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

- (BMEmptyView *)bm_emptyView
{
    BMEmptyView *emptyView = objc_getAssociatedObject(self, _cmd);
    return emptyView;
}

- (void)setBm_emptyView:(BMEmptyView *)emptyView
{
    objc_setAssociatedObject(self, @selector(bm_emptyView), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showNoDataViewWithState:(BMEmptyViewStatus)status action:(BMEmptyViewActionBlock)action
{
    if (!self.bm_emptyView)
    {
        self.bm_emptyView = [BMEmptyView EmptyViewWith:self frame:self.bounds refreshBlock:action];
    }
    
    self.bm_emptyView.emptyViewStatus = status;
    
    self.bm_emptyView.hidden = NO;
}

- (void)hideNoDataView
{
    self.bm_emptyView.hidden = YES;
}

@end
