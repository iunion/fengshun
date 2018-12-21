//
//  FSComTopicListVC.m
//  fengshun
//
//  Created by jiang deng on 2018/12/21.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSComTopicListVC.h"
#import "FSForumDetailListCell.h"
#import "FSCommunityModel.h"
#import "FSPushVCManager.h"

@interface FSComTopicListVC ()
<
    UIScrollViewDelegate
>
{
    NSInteger _currentPages;
    BOOL _isLoadFinish;
}

// 排序类型
@property (nonatomic, strong) NSString *m_SortType;
// 板块id
@property (nonatomic, assign) NSInteger m_ForumId;

@end

@implementation FSComTopicListVC

- (instancetype)initWithTopicSortType:(NSString *)sortType formId:(NSInteger)formId
{
    if (self = [super init])
    {
        self.m_SortType = sortType;
        self.m_ForumId  = formId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.m_LoadDataType = FSAPILoadDataType_Page;
    _currentPages = 1;
    [self createUI];
    [self loadApiData];
}

- (void)refreshVC
{
    _currentPages = 1;
    [self loadApiData];
}

- (void)createUI
{
    self.m_TableView.tableFooterView = [UIView new];
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.m_TableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.m_TableView.estimatedRowHeight = 114;
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    if (isLoadNew)
    {
        _currentPages = 1;
    }
    return [FSApiRequest getTopicListWithType:self.m_SortType forumId:self.m_ForumId pageIndex:_currentPages pageSize:10];
}

- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray
{
    if (![requestArray bm_isNotEmpty])
    {
        return NO;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in requestArray)
    {
        FSTopicTypeModel *model = [FSTopicTypeModel topicTypeModelWithDic:dic];
        if (model && model.m_IsActive)
        {
            NSArray *list = [[dic bm_dictionaryForKey:@"postInfo"] bm_arrayForKey:@"list"];
            NSInteger totalPages = [[dic bm_dictionaryForKey:@"postInfo"]bm_intForKey:@"totalPages"];
            _isLoadFinish = _currentPages >= totalPages;
            if (!_isLoadFinish)
            {
                _currentPages ++;
            }
            if (self.m_IsLoadNew)
            {
                [self.m_DataArray removeAllObjects];
            }
            if ([list bm_isNotEmpty])
            {
                for (NSDictionary *data in list)
                {
                    FSTopicModel *topicModel = [FSTopicModel topicWithServerDic:data];
                    if (topicModel)
                    {
                        [arr addObject:topicModel];
                    }
                }
            }
        }
    }
    [self.m_DataArray addObjectsFromArray:arr];
    [self.m_TableView reloadData];
    [self.m_ProgressHUD hideAnimated:YES];
    return YES;
}

- (BOOL)checkLoadFinish:(NSDictionary *)requestDic
{
    return _isLoadFinish;
}


#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"FSForumDetailListCell";
    FSForumDetailListCell *cell= [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FSForumDetailListCell" owner:self options:nil].firstObject;
    }
    [cell showWithTopicModel:self.m_DataArray[indexPath.row]];
    [cell hiddenTopTag:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FSTopicModel *model = self.m_DataArray[indexPath.row];
    [FSPushVCManager showTopicDetail:[self.view.superview bm_viewController]  topicId:model.m_Id];
}



@end
