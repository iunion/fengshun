//
//  FSTableViewVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperNetVC.h"
#import "FSTableView.h"

@interface FSTableViewVC : FSSuperNetVC
<
    UITableViewDelegate,
    UITableViewDataSource,
    FSTableViewDelegate
>
{
    // 当前页
    NSUInteger s_LoadedPage;
    // 备份当前页，用于发请求
    NSUInteger s_BakLoadedPage;
    // 总页数
    NSUInteger s_TotalPage;
    // 读取完全
    BOOL s_IsNoMorePage;
}

// 每页项数/每次读取个数，默认: 20
@property (nonatomic, assign) NSUInteger m_CountPerPage;

// 用于初始化
@property (nonatomic, assign) UITableViewStyle m_TableViewStyle;

// 上拉下拉类型
@property (nonatomic, assign, readonly) BMFreshViewType m_FreshViewType;

@property (nonatomic, strong, readonly) FSTableView *m_TableView;

// 内容数据
@property (nonatomic, strong) NSMutableArray *m_DataArray;

// 是否刷新数据
@property (nonatomic, assign, readonly) BOOL m_IsLoadNew;
// 显示空数据页
@property (nonatomic, assign) BOOL m_showEmptyView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil freshViewType:(BMFreshViewType)freshViewType;

- (void)setFreshTitles:(NSDictionary *)titles;
- (void)setHeaderFreshTitles:(NSDictionary *)titles;
- (void)setFooterFreshTitles:(NSDictionary *)titles;

- (void)showEmptyViewWithStatus:(BMEmptyViewStatus)status;
- (void)showEmptyViewWithStatus:(BMEmptyViewStatus)status action:(BMEmptyViewActionBlock)actionBlock;
- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock;

- (void)hideEmptyView;

// 获取api成功时无数据类型
- (BMEmptyViewStatus)getNoDataEmptyViewStatus;

@end
