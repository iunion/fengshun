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

- (void)showEmptyViewWithStatus:(BMEmptyViewStatus)status;
// 清空action使用setEmptyViewActionBlock
- (void)showEmptyViewWithStatus:(BMEmptyViewStatus)status action:(BMEmptyViewActionBlock)actionBlock;
- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock;

- (void)hideEmptyView;

@end
