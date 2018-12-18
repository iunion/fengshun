//
//  BMTestNetFlowSummaryVC.m
//  fengshun
//
//  Created by jiang deng on 2018/12/6.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestNetFlowSummaryVC.h"
#import "BMTestNetFlowManager.h"
#import "BMTestNetFlowCell.h"
#import "BMTestNetFlowDetailVC.h"

@interface BMTestNetFlowSummaryVC ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation BMTestNetFlowSummaryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS_VERSION >= 7.0f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // 隐藏系统的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationTitleTintColor = [UIColor blackColor];
    self.bm_NavigationItemTintColor = [UIColor blackColor];
    self.bm_NavigationShadowHidden = YES;
    
    self.view.backgroundColor = [UIColor bm_colorWithHex:0xEEEEEE];
    
    [self bm_setNavigationWithTitle:@"流量监控" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_close_icon" leftToucheEvent:@selector(close) rightItemTitle:nil rightItemImage:@"navigationbar_fresh_icon" rightToucheEvent:@selector(freshViews)];
    
    [self makeUI];
    
    [self freshViews];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)makeUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)freshViews
{
    NSArray *dataArray = [BMTestNetFlowManager sharedInstance].httpModelArray;
    self.dataArray = [NSArray arrayWithArray:dataArray];

    [self.tableView reloadData];
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMTestNetFlowHttpModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return [BMTestNetFlowCell cellHeightWithModel:model];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"BMTestNetFlowCell";
    BMTestNetFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BMTestNetFlowCell" owner:self options:nil] lastObject];
    }
    BMTestNetFlowHttpModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell drawCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BMTestNetFlowHttpModel *model = [self.dataArray objectAtIndex:indexPath.row];

    BMTestNetFlowDetailVC *detailVc = [[BMTestNetFlowDetailVC alloc] init];
    detailVc.httpModel = model;

    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
