//
//  FSVideoMessageListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMessageListVC.h"
#import "FSVideoMessageCell.h"

@interface FSVideoMessageListVC ()

@end

@implementation FSVideoMessageListVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)viewDidLoad {
    _m_FreshViewType = BMFreshViewType_NONE;

    [super viewDidLoad];

    [self bm_setNavigationWithTitle:@"消息记录" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    [self loadApiData];
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getRoomMessageRecordList:0];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)data
{
    NSLog(@"%@",data);
//    NSArray *array = [FSMeetingDetailModel modelsWithDataArray:data[@"list"]];
//
//    if (array) {
//        [self.m_DataArray addObjectsFromArray:array];
//    }
//    
    if (self.m_DataArray.count == 0) {
        [self showEmptyViewWithStatus:BMEmptyViewStatus_NoData];
    }
    
    [self.m_TableView reloadData];
    
    return [super succeedLoadedRequestWithDic:data];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSVideoMessageCell";
    FSVideoMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[FSVideoMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellIdentifier];
    }
    
    
    return cell;
}


@end
