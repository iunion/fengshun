//
//  FSTableViewVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"

@interface FSTableViewVC ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FSTableView *m_TableView;

// 网络请求
@property (nonatomic, strong) NSURLSessionDataTask *m_DataTask;

// 内容数据
@property (nonatomic, strong) NSMutableArray *m_DataArray;

// 是否下拉刷新
@property (nonatomic, assign) BOOL m_IsLoadNew;

@end

@implementation FSTableViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
