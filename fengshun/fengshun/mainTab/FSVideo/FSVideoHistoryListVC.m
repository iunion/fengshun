//
//  FSVideoHistoryListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoHistoryListVC.h"
#import "FSVideoHistoryCell.h"

@interface FSVideoHistoryListVC ()

@end

@implementation FSVideoHistoryListVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)viewDidLoad {

    _m_FreshViewType = BMFreshViewType_NONE;

    [super viewDidLoad];

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"视频回放" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
   
    [self loadApiData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getMeetingVideoList:self.meetingId];
}

- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray;
{
    for (NSDictionary *dic in requestArray) {
        FSVideoRecordModel *model = [FSVideoRecordModel modelWithParams:dic];
        if (model) {
            [self.m_DataArray addObject:model];
        }
    }
    [self.m_TableView reloadData];

    return YES;
}


#pragma mark -
#pragma mark Table Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_DataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSVideoHistoryCell";
    FSVideoHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[FSVideoHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellIdentifier];
    }
    
    [cell setModel:self.m_DataArray[indexPath.section]];
    
    return cell;
}


@end
