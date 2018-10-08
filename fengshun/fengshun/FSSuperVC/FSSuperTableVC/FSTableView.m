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

- (void)dealloc
{
    
}

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
        BMFreshGifHeader *refreshHeaderView = [[BMFreshGifHeader alloc] init];
        self.bm_freshHeaderView = refreshHeaderView;

        [refreshHeaderView setFreshTitles:nil];
        refreshHeaderView.bm_height = 300.0f;
        refreshHeaderView.pullMaxHeight = 80.0f;
        refreshHeaderView.containerSize = CGSizeMake(50.0f, 50.0f);
        refreshHeaderView.containerYOffset = 105.0f;
 
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=26; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fsfreshidle_icon%@", @(i)]];
            [idleImages addObject:image];
        }
        // 设置普通状态的动画图片
        [refreshHeaderView setImages:idleImages forState:BMFreshStateIdle];

        NSMutableArray *willfreshingImages = [NSMutableArray array];
        [willfreshingImages addObject:[UIImage imageNamed:@"fsfreshidle_icon27"]];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [refreshHeaderView setImages:willfreshingImages forState:BMFreshStateWillRefresh];

        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=8; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fsfreshfreshing_icon%@", @(i)]];
            [refreshingImages addObject:image];
        }
        // 设置正在刷新状态的动画图片
        [refreshHeaderView setImages:refreshingImages forState:BMFreshStateRefreshing];

        refreshHeaderView.beginFreshingBlock = ^(BMFreshBaseView *freshView) {
            [weakSelf.tableViewDelegate freshDataWithTableView:weakSelf];
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
            [weakSelf.tableViewDelegate loadNextDataWithTableView:weakSelf];
        };
        refreshFooterView.endFreshingBlock = ^(BMFreshBaseView *freshView) {
            if ([weakSelf.tableViewDelegate respondsToSelector:@selector(resetTableViewFreshState:)])
            {
                [weakSelf.tableViewDelegate resetTableViewFreshState:weakSelf.bm_freshFooterView];
            }
        };
        self.bm_freshFooterView.hidden = YES;
    }
    
    [self bringSomeViewToFront];
    
    // 初始化无数据
    self.bm_showEmptyView = YES;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.bm_emptyView.frame = self.bounds;
    [self.bm_emptyView updateViewFrame];
}


- (void)bringSomeViewToFront
{
    [self.bm_emptyView bm_bringToFront];
}

- (void)freshView:(BMFreshBaseView *)freshView changeState:(BMFreshState)state
{
    
}

@end
