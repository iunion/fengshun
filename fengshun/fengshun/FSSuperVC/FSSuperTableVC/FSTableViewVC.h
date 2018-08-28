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

// 用于初始化
@property (nonatomic, assign) UITableViewStyle m_TableViewStyle;

// 上拉下拉类型
@property (nonatomic, assign, readonly) BMFreshViewType m_FreshViewType;

@property (nonatomic, strong, readonly) FSTableView *m_TableView;

// 内容数据
@property (nonatomic, strong, readonly) NSMutableArray *m_DataArray;

// 是否下拉刷新
@property (nonatomic, assign, readonly) BOOL m_IsLoadNew;

// 加载数据模式：按页加载/按个数
@property (nonatomic, assign) FSAPILoadDataType m_LoadDataType;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil freshViewType:(BMFreshViewType)freshViewType;

@end
