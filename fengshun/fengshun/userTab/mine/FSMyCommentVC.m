//
//  FSMyCommentVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCommentVC.h"
#import "FSMyCommentCell.h"

@interface FSMyCommentVC ()

@end

@implementation FSMyCommentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self bm_setNavigationWithTitle:@"我的评论" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    self.m_LoadDataType = FSAPILoadDataType_Page;
    
    //self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.m_TableView.separatorInset = UIEdgeInsetsMake(0, 14, 0, 14);
    //self.m_TableView.tableFooterView = [UIView new];
    
    [self loadApiData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    return [FSApiRequest getMyCommentsWithPageIndex:s_BakLoadedPage pageSize:self.m_CountPerPage];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *topicDicArray = [requestDic bm_arrayForKey:@"list"];
    if ([topicDicArray bm_isNotEmpty])
    {
        NSMutableArray *topicArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSDictionary *dic in topicDicArray)
        {
            FSMyCommentModel *message = [FSMyCommentModel myCommentModelWithDic:dic];
            if ([message bm_isNotEmpty])
            {
                [topicArray addObject:message];
            }
        }
        if ([topicArray bm_isNotEmpty])
        {
            if (self.m_IsLoadNew)
            {
                [self.m_DataArray removeAllObjects];
            }
            
            FSMyCommentModel *firstModel = [self.m_DataArray firstObject];
            if (!firstModel)
            {
                firstModel = [topicArray firstObject];
            }
            FSMyCommentModel *oldLastModel = [self.m_DataArray lastObject];
            firstModel.m_PositionType |= BMTableViewCell_PositionType_First;
            oldLastModel.m_PositionType &= !BMTableViewCell_PositionType_Last;
            
            [self.m_DataArray addObjectsFromArray:topicArray];
            
            FSMyCommentModel *lastModel = [self.m_DataArray lastObject];
            lastModel.m_PositionType |= BMTableViewCell_PositionType_Last;
            
            [self.m_TableView reloadData];
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSMyCommentModel *model = self.m_DataArray[indexPath.row];
    return [FSMyCommentCell cellHeightWithContent:model.m_Content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSCell";
    FSMyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FSMyCommentCell" owner:self options:nil] lastObject];
    }
    [cell drawCellWithModel:self.m_DataArray[indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 8)];
    return view;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FSMyCommentModel *model = self.m_DataArray[indexPath.row];
    if (model.m_CommentType == FSCommentType_POSTS) // 帖子做特殊处理
    {
        [FSPushVCManager showTopicDetail:self  topicId:model.m_DetailId];
    }
    else
    {
        [FSPushVCManager showWebView:self url:model.m_JumpAddress title:nil];
    }
}

- (BMEmptyViewType)getNoDataEmptyViewType
{
    return BMEmptyViewType_Comment;
}

@end
