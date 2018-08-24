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

static void * bm_emptyViewKey = "key";

- (BMEmptyView *)bm_emptyView{
    BMEmptyView *emptyView = objc_getAssociatedObject(self, bm_emptyViewKey);
    return emptyView;
}

- (void)setBm_emptyView:(BMEmptyView *)bm_emptyView{
    objc_setAssociatedObject(self, bm_emptyViewKey , bm_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showNoDataView:(BOOL)isShow state:(BMEmptyViewStatus)status  action:(BMEmptyViewActionBlock)action{
    if (!self.bm_emptyView) {
        self.bm_emptyView = [BMEmptyView EmptyViewWith:self frame:self.bounds refreshBlock:^(BMEmptyView *emptyView, BMEmptyViewStatus state) {
            action(emptyView,status);
        }];
    }
    [self.bm_emptyView setEmptyViewStatus:status];
    self.bm_emptyView.hidden = !isShow;
}

@end
