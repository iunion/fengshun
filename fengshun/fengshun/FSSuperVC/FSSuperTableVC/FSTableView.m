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
    }
    
    // 初始化上拉刷新
    if (_m_FreshViewType & BMFreshViewType_Bottom)
    {
        BMFreshAutoNormalFooter *refreshFooterView = [[BMFreshAutoNormalFooter alloc] init];
        refreshFooterView.containerSize = CGSizeMake(28.0f, 28.0f);
        refreshFooterView.beginFreshingBlock = ^(BMFreshBaseView *freshView) {
            [weakSelf.tableViewDelegate loadNextDataWithTableView:self];
        };
        self.bm_freshFooterView = refreshFooterView;
    }
    
    [self bringSomeViewToFront];
    
    // 初始化无数据
    self.bm_showEmptyView = YES;

#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *))
    {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
}

- (void)bringSomeViewToFront
{
    [self.bm_emptyView bm_bringToFront];
}


@end