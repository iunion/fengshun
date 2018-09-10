//
//  FSRecommendListVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSRecommendListVC.h"
#import "FSTopicListCell.h"

@interface
FSRecommendListVC ()
{
    NSInteger _currentPages;
}
@end

@implementation FSRecommendListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPages = 1;
    [self loadApiData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    if (isLoadNew)
    {
        _currentPages = 1;
    }
    return [FSApiRequest getPlateRecommendPostListWithPageIndex:_currentPages pageSize:10];
}


- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *topicDicArray = [requestDic bm_arrayForKey:@"list"];
    if ([topicDicArray bm_isNotEmpty])
    {
        NSMutableArray *topicArray = [[NSMutableArray alloc] initWithCapacity:0];

        for (NSDictionary *dic in topicDicArray)
        {
            FSTopicModel *topic = [FSTopicModel topicWithServerDic:dic];
            if ([topic bm_isNotEmpty])
            {
                [topicArray addObject:topic];
            }
        }
        if ([topicArray bm_isNotEmpty])
        {
            if (_currentPages == 1)
            {
                [self.m_TableView.bm_freshHeaderView endReFreshing];
                [self.m_DataArray removeAllObjects];
            }
            [self.m_DataArray addObjectsFromArray:topicArray];
            [self.m_TableView reloadData];
        }
        if ([requestDic bm_boolForKey:@"hasNextPage"])
        {
            _currentPages++;
            [self.m_TableView.bm_freshFooterView endReFreshing];
        }
        else
        {
            [self.m_TableView.bm_freshFooterView endReFreshingWithNoMoreData];
        }
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 152.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSCell";
    FSTopicListCell *cell               = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FSTopicListCell" owner:self options:nil] lastObject];
    }
    [cell drawCellWithModle:self.m_DataArray[indexPath.row]];
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
