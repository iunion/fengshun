//
//  FSTableView.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableView.h"

@interface FSTableView ()

// 上拉下拉类型
@property (nonatomic, assign) BMFreshViewType m_RefreshType;

@end

@implementation FSTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    return [self initWithFrame:frame refreshType:BMFreshViewType_Head | BMFreshViewType_Bottom tableViewStyle:style];
}

- (instancetype)initWithFrame:(CGRect)frame refreshType:(BMFreshViewType)refreshType tableViewStyle:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        _m_RefreshType = refreshType;
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
    if (_m_RefreshType & BMFreshViewType_Head)
    {
        BMFreshFiveStarHeader *refreshHeaderView = [[BMFreshFiveStarHeader alloc] init];
        self.bm_freshHeaderView = refreshHeaderView;
        refreshHeaderView.starWidth = 40;
        refreshHeaderView.beginFreshingBlock = ^(BMFreshBaseView *freshView) {
            [weakSelf.tableViewDelegate freshDataWithTableView:self];
        };
    }
    
    // 初始化上拉刷新
    if (_m_RefreshType & BMFreshViewType_Bottom)
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
    self.m_ShowEmptyView = YES;
    
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
