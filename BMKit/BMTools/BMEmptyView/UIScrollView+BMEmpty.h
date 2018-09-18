//
//  UIScrollView+BMEmpty.h
//  fengshun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMEmptyView.h"

@interface UIScrollView (BMEmpty)

// 显示无数据页面, 默认: YES
@property (nonatomic, assign) BOOL bm_showEmptyView;
@property (nonatomic, strong) BMEmptyView *bm_emptyView;

// 清空action使用setEmptyViewActionBlock
- (void)showEmptyViewWithType:(BMEmptyViewType)type;
- (void)showEmptyViewWithType:(BMEmptyViewType)type action:(BMEmptyViewActionBlock)actionBlock;
- (void)showEmptyViewWithType:(BMEmptyViewType)type customImageName:(NSString *)customImageName customMessage:(NSString *)customMessage customView:(UIView *)customView;
- (void)showEmptyViewWithType:(BMEmptyViewType)type customImageName:(NSString *)customImageName customMessage:(NSString *)customMessage customView:(UIView *)customView action:(BMEmptyViewActionBlock)actionBlock;
- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock;

- (void)hideEmptyView;

@end
