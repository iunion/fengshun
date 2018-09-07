//
//  FSTableView.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableView.h"

@interface FSTableView ()

@end

@implementation FSTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    return [self initWithFrame:frame style:style freshViewType:BMFreshViewType_Head | BMFreshViewType_Bottom];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style freshViewType:(BMFreshViewType)freshViewType
{
    if (self = [super initWithFrame:frame style:style])
    {
        _m_FreshViewType = freshViewType;
        [self setupTableView];
    }
    
    return self;
}

- (void)setupTableView
{
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bounces = YES;
//    self.tableFooterView = [UIView new];

#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *))
    {
        // 默认 UIScrollViewContentInsetAdjustmentAutomatic
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif

    //self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    BMWeakSelf
    // 初始化下拉刷新
    if (_m_FreshViewType & BMFreshViewType_Head)
    {
        BMFreshFiveStarHeader *refreshHeaderView = [[BMFreshFiveStarHeader alloc] init];
        self.bm_freshHeaderView = refreshHeaderView;

        refreshHeaderView.starWidth = 40;
        refreshHeaderView.beginFreshingBlock = ^(BMFreshBaseView *freshView) {
            [weakSelf.tableViewDelegate freshDataWithTableView:self];
        };
        refreshHeaderView.endFreshingBlock = ^(BMFreshBaseView *freshView) {
            if ([weakSelf.tableViewDelegate respondsToSelector:@selector(resetTableViewFreshState:)])
            {
                [weakSelf.tableViewDelegate resetTableViewFreshState:weakSelf.bm_freshHeaderView];
            }
        };
    }
    
    // 初始化上拉刷新
    if (_m_FreshViewType & BMFreshViewType_Bottom)
    {
        BMFreshAutoNormalFooter *refreshFooterView = [[BMFreshAutoNormalFooter alloc] init];
        self.bm_freshFooterView = refreshFooterView;

        refreshFooterView.containerSize = CGSizeMake(28.0f, 28.0f);
        refreshFooterView.beginFreshingBlock = ^(BMFreshBaseView *freshView) {
            [weakSelf.tableViewDelegate loadNextDataWithTableView:self];
        };
        refreshFooterView.endFreshingBlock = ^(BMFreshBaseView *freshView) {
            if ([weakSelf.tableViewDelegate respondsToSelector:@selector(resetTableViewFreshState:)])
            {
                [weakSelf.tableViewDelegate resetTableViewFreshState:weakSelf.bm_freshFooterView];
            }
        };
    }
    
    [self bringSomeViewToFront];
    
    // 初始化无数据
    self.bm_showEmptyView = YES;
}

- (void)bringSomeViewToFront
{
    [self.bm_emptyView bm_bringToFront];
}

- (void)freshView:(BMFreshBaseView *)freshView changeState:(BMFreshState)state
{
    
}

@end
