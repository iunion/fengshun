//
//  FSTableView.h
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMFreshGifHeader.h"
#import "BMFreshAutoNormalFooter.h"
#import "UIScrollView+BMEmpty.h"
#import "UIScrollView+BMFresh.h"

@protocol FSTableViewDelegate;

@interface FSTableView : UITableView

@property (nonatomic, weak) id <FSTableViewDelegate> tableViewDelegate;

// 上拉下拉类型
@property (nonatomic, assign, readonly) BMFreshViewType m_FreshViewType;

// 允许同时识别多个手势，默认NO
@property (nonatomic, assign) BOOL m_MultiResponse;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style freshViewType:(BMFreshViewType)freshViewType;
- (void)bringSomeViewToFront;

@end

@protocol FSTableViewDelegate <NSObject>

- (void)freshDataWithTableView:(FSTableView *)tableView;

- (void)loadNextDataWithTableView:(FSTableView *)tableView;

@optional

- (void)resetTableViewFreshState:(BMFreshBaseView *)freshView;

- (void)tableViewFreshFromNoDataView:(FSTableView *)tableView;

@end
