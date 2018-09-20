//
//  FSRecommendListVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSRecommendListVC.h"
#import "FSTopicListCell.h"

@interface FSRecommendListVC ()

@end

@implementation FSRecommendListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_LoadDataType = FSAPILoadDataType_Page;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 8)];
    self.m_TableView.tableHeaderView = headerView;
    [self loadApiData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    return [FSApiRequest getPlateRecommendPostListWithPageIndex:s_BakLoadedPage pageSize:self.m_CountPerPage];
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
            if (self.m_IsLoadNew)
            {
                [self.m_DataArray removeAllObjects];
            }
            
            FSTopicModel *firstTopic = [self.m_DataArray firstObject];
            if (!firstTopic)
            {
                firstTopic = [topicArray firstObject];
            }
            FSTopicModel *oldLastTopic = [self.m_DataArray lastObject];
            firstTopic.m_PositionType |= BMTableViewCell_PositionType_First;
            oldLastTopic.m_PositionType &= !BMTableViewCell_PositionType_Last;

            [self.m_DataArray addObjectsFromArray:topicArray];
            
            FSTopicModel *lastTopic = [self.m_DataArray lastObject];
            lastTopic.m_PositionType |= BMTableViewCell_PositionType_Last;

            [self.m_TableView reloadData];
        }
        
        return YES;
    }
    
    return NO;
}


#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FSTopicListCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSCell";
    FSTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
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
    FSTopicModel *model = self.m_DataArray[indexPath.row];
    [FSPushVCManager showTopicDetail:[self.view.superview bm_viewController] topicId:model.m_Id];
}

@end
