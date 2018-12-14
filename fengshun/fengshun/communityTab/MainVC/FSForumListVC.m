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
#import "FSCommunitySecVC.h"

#define SECTION_HEADER_HEIGHT 58  //section高度

@interface
FSForumListVC ()

@end

@implementation FSForumListVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:userInfoChangedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_LoadDataType = FSAPILoadDataType_Page;
    self.view.backgroundColor = [UIColor bm_colorWithHex:0xf5f6f7];
    self.m_TableView.tableFooterView = [UIView new];
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.m_TableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 24);
    [self loadApiData];
    
    // 登录状态改变刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadApiData) name:userInfoChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    return [FSApiRequest getForumListWithPageIndex:s_BakLoadedPage pageSize:self.m_CountPerPage];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    if (![requestDic bm_isNotEmptyDictionary]) {
        return NO;
    }
    NSArray *forumList = [FSCommunityForumModel plateModelWithArr:[requestDic bm_arrayForKey:@"list"]];
    if ([forumList bm_isNotEmpty])
    {
        if (self.m_IsLoadNew) {
            [self.m_DataArray removeAllObjects];
        }
        [self.m_DataArray addObjectsFromArray:forumList];
        [self.m_TableView reloadData];
        [self.m_ProgressHUD hideAnimated:NO];
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
    static NSString *         Identifier = @"FSForumSectionHeaderView";
    FSForumSectionHeaderView *aView      = [tableView dequeueReusableHeaderFooterViewWithIdentifier:Identifier];
    if (!aView)
    {
        aView = [[NSBundle mainBundle] loadNibNamed:@"FSForumSectionHeaderView" owner:self options:nil].firstObject;
        [aView setValue:Identifier forKey:@"reuseIdentifier"];
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
    return [FSForumListCell cellHeight];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSForumListCell";
    FSForumListCell *cell               = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FSForumListCell" owner:self options:nil].firstObject;
    }
    FSCommunityForumModel *model = self.m_DataArray[indexPath.section];
    // 判断是否是已关注section
    [cell showWithFSCommunityForumListModel:model.m_List[indexPath.row]];
    BMWeakSelf
    cell.attentionBtnClickBlock = ^(FSForumModel *model) {
        if (![FSUserInfoModel isLogin])
        {
            if (weakSelf.m_ShowLoginBlock)
            {
                weakSelf.m_ShowLoginBlock();
            }
            return ;
        }
        [weakSelf updateAttentionFlag:model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCommunityForumModel *model      = self.m_DataArray[indexPath.section];
    FSForumModel *         forumModel = model.m_List[indexPath.row];
    FSCommunitySecVC *vc = [FSPushVCManager showCommunitySecVCPushVC:[self.view.superview bm_viewController] FourmId:forumModel.m_Id];
    BMWeakSelf;
    vc.m_AttentionChangeBlock = ^{
        [weakSelf loadApiData];
    };
}

- (void)updateAttentionFlag:(FSForumModel *)model
{
    FSForumFollowState state = model.m_AttentionFlag;
    [FSApiRequest updateFourmAttentionStateWithFourmId:model.m_Id followStatus:!state success:^(id  _Nullable responseObject) {
        [self loadApiData];
    } failure:^(NSError * _Nullable error) {

    }];
#if 0
    if (![self.m_DataArray bm_isNotEmpty])
    {
        return;
    }
    FSCommunityForumModel *aModel = self.m_DataArray [0];
    // 已关注存在
    if ([aModel.m_Name isEqualToString:@"已关注"])
    {
        // 关注了
        if (model.m_AttentionFlag)
        {
            model.m_isAttentionSection = YES;
            [aModel.m_List addObject:model];
        }
        else
        {
            [aModel.m_List enumerateObjectsUsingBlock:^(FSForumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.m_Id == model.m_Id) {
                    [aModel.m_List removeObject:obj];
                }
            }];
            if (![aModel.m_List bm_isNotEmpty])
            {
                [self.m_DataArray removeObject:aModel];
                [self.m_TableView reloadData];
            }
        }
        [self.m_TableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        if (model.m_AttentionFlag)
        {
            FSCommunityForumModel *newModel = [FSCommunityForumModel new];
            newModel.m_Name = @"已关注";
            if (!newModel.m_List) {
                newModel.m_List = [NSMutableArray array];
            }
            model.m_isAttentionSection = YES;
            [newModel.m_List addObject:model];
            [self.m_DataArray insertObject:newModel atIndex:0];
        }
        [self.m_TableView reloadData];
    }
#endif
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
