//
//  FSForumListVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSForumListVC.h"
#import "FSForumListCell.h"
#import "FSForumSectionHeaderView.h"
#import "FSPushVCManager.h"

#define SECTION_HEADER_HEIGHT 50  //section高度

@interface
FSForumListVC ()
{
    NSInteger _currentPages;
}
@end

@implementation FSForumListVC

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
    return [FSApiRequest getForumListWithPageIndex:_currentPages pageSize:10];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *forumList = [FSCommunityForumModel plateModelWithArr:[requestDic bm_arrayForKey:@"list"]];
    if ([forumList bm_isNotEmpty])
    {
        if (_currentPages == 1)
        {
            [self.m_DataArray removeAllObjects];
            [self.m_TableView.bm_freshHeaderView endReFreshing];
        }
        [self.m_DataArray addObjectsFromArray:forumList];
        [self.m_TableView reloadData];
        // 判断是否还有数据
        NSInteger totalPage = [requestDic bm_intForKey:@"totalPages"];
        if (_currentPages >= totalPage)
        {
            [self.m_TableView.bm_freshFooterView endReFreshingWithNoMoreData];
        }
        else
        {
            _currentPages++;
            [self.m_TableView.bm_freshFooterView endReFreshing];
        }
        return YES;
    }
    return NO;
}


#pragma mark - m_TableView
// 去除tableview  section悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.m_TableView)
    {
        CGFloat sectionHeaderHeight = SECTION_HEADER_HEIGHT;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *         Identifier = @"Header";
    FSForumSectionHeaderView *aView      = [tableView dequeueReusableHeaderFooterViewWithIdentifier:Identifier];
    if (!aView)
    {
        aView = [[NSBundle mainBundle] loadNibNamed:@"FSForumSectionHeaderView" owner:self options:nil].firstObject;
    }
    [aView showWithFSCommunityForumModel:self.m_DataArray[section]];
    return aView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_DataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FSCommunityForumModel *model = self.m_DataArray[section];
    return model.m_List.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSCell";
    FSForumListCell *cell               = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FSForumListCell" owner:self options:nil].firstObject;
    }
    FSCommunityForumModel *model = self.m_DataArray[indexPath.section];
    [cell showWithFSCommunityForumListModel:model.m_List[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCommunityForumModel *model      = self.m_DataArray[indexPath.section];
    FSForumModel *         forumModel = model.m_List[indexPath.row];
    [FSPushVCManager showCommunitySecVCPushVC:[self.view.superview bm_viewController] FourmId:forumModel.m_Id];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
