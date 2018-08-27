//
//  UIScrollView+DJFresh.h
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/7/26.
//Copyright © 2018年 DJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMFreshHeaderView.h"
#import "BMFreshFooterView.h"


@interface UIScrollView (BMFresh)

@property (nonatomic, strong) BMFreshHeaderView *bm_freshHeaderView;
@property (nonatomic, strong) BMFreshFooterView *bm_freshFooterView;

- (void)resetFreshHeaderState;
- (void)resetFreshFooterState;
- (void)resetFreshFooterStateWithNoMoreData;

- (void)setFreshTitles:(NSDictionary *)titles;
- (void)setHeaderFreshTitles:(NSDictionary *)titles;
- (void)setFooterFreshTitles:(NSDictionary *)titles;

@end
