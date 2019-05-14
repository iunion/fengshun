//
//  BMFreshFooterView.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshFooterView.h"

const CGFloat DJFreshFooterHeight = 40.0f;

@implementation BMFreshFooterView

- (void)prepare
{
    [super prepare];
    
    // 设置高度
    self.bm_width = UI_SCREEN_WIDTH;
    self.bm_height = DJFreshFooterHeight;
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    self.pullMaxHeight = self.bm_height;
}

- (void)freshSubviews
{
    [super freshSubviews];
}

- (void)endReFreshingWithNoMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BMFreshState oldState = self.freshState;
        self.freshState = BMFreshStateNoMoreData;
        
        if (oldState == BMFreshStateRefreshing && self.endFreshingBlock)
        {
            self.endFreshingBlock(self);
        }
    });
}

@end
