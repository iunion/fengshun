//
//  FSMyCollectionVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionVC.h"
#import "FSTopicListCell.h"
#import "FSCollectionCourseCell.h"
#import "FSLawCell.h"
#import "FSCaseCell.h"
#import "FSTextCell.h"


@interface FSMyCollectionVC ()

@property (nonatomic, assign) FSCollectionType m_CollectionType;

@end

@implementation FSMyCollectionVC

- (instancetype)initWithCollectionType:(FSCollectionType)collectionType
{
    self = [self init];
    
    if (self)
    {
        _m_CollectionType = collectionType;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_LoadDataType = FSAPILoadDataType_Page;
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.m_TableView.tableFooterView = [UIView new];
    self.m_TableView.estimatedRowHeight = 180;
    switch (self.m_CollectionType)
    {
        case FSCollectionType_POSTS:
            break;
        case FSCollectionType_STATUTE:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSLawCell" bundle:nil] forCellReuseIdentifier:@"FSLawCell"];
            break;
        case FSCollectionType_CASE:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCaseCell" bundle:nil] forCellReuseIdentifier:@"FSCaseCell"];
            break;
        case FSCollectionType_DOCUMENT:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSTextCell" bundle:nil] forCellReuseIdentifier:@"FSTextCell"];
            break;
        case FSCollectionType_COURSE:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCollectionCourseCell" bundle:nil] forCellReuseIdentifier:@"FSCollectionCourseCell"];
            break;
    }
    [self loadApiData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    return [FSApiRequest getMyCollectionsWithPageIndex:s_BakLoadedPage pageSize:self.m_CountPerPage collectionType:self.m_CollectionType];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *dicArray = [requestDic bm_arrayForKey:@"list"];
    if ([dicArray bm_isNotEmpty])
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
        for (NSDictionary *dic in dicArray)
        {
            switch (self.m_CollectionType)
            {
                case FSCollectionType_POSTS:
                {
                    FSTopicCollectModel *topic = [FSTopicCollectModel collectTopicModelWithDic:dic];
                    if ([topic bm_isNotEmpty])
                    {
                        [dataArray addObject:topic];
                    }
                }
                    break;
                    
                case FSCollectionType_STATUTE:
                {
                    // 法规
                    FSLawCollectionModel *model = [FSLawCollectionModel modelWithParams:dic];
                    if ([model bm_isNotEmpty]) {
                        [dataArray addObject:model];
                    }
                }
                    break;
                case FSCollectionType_CASE:
                {
                    // 案例
                    FSCaseCollectionModel *model = [FSCaseCollectionModel modelWithParams:dic];
                    if ([model bm_isNotEmpty]) {
                        [dataArray addObject:model];
                    }
                }
                    break;
                    
                case FSCollectionType_DOCUMENT:
                {
                    // 文书
                    FSCollectionTextModel *model = [FSCollectionTextModel modelWithParams:dic];
                    if ([model bm_isNotEmpty]) {
                        [dataArray addObject:model];
                    }
                }
                    break;
                case FSCollectionType_COURSE:
                {
                    // 课程
                    FSCourseCollectionModel *model = [FSCourseCollectionModel modelWithParams:dic];
                    if ([model bm_isNotEmpty]) {
                        [dataArray addObject:model];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        if ([dataArray bm_isNotEmpty])
        {
            if (self.m_IsLoadNew)
            {
                [self.m_DataArray removeAllObjects];
            }
            [self.m_DataArray addObjectsFromArray:dataArray];
            [self.m_TableView reloadData];
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.m_CollectionType == FSCollectionType_POSTS)
    {
        return [FSTopicListCell cellHeight];
    }
    
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.m_CollectionType)
    {
        case FSCollectionType_POSTS:
        {
            static NSString *taskCellIdentifier = @"FSCell";
            FSTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FSTopicListCell" owner:self options:nil] lastObject];
            }
            
            [cell drawCellWithCollectionModel:self.m_DataArray[indexPath.row]];
            return cell;
        }
        case FSCollectionType_STATUTE:
        {
            FSLawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLawCell"];
            
            FSLawCollectionModel *model = self.m_DataArray[indexPath.row];
            [cell setLawCollectionModel:model];
            return cell;
        }
        case FSCollectionType_CASE:
        {
            FSCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCaseCell"];
            
            FSCaseCollectionModel *model = self.m_DataArray[indexPath.row];
            [cell setCaseCollectionModel:model];
            return cell;
        }
        case FSCollectionType_DOCUMENT:
        {
            FSTextCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"FSTextCell"];
            FSCollectionTextModel *model = self.m_DataArray[indexPath.row];
            [cell setCollectionTextModel:model];
            return cell;
        }
        case FSCollectionType_COURSE:
        {
            FSCollectionCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCollectionCourseCell"];
            
            cell.m_course = self.m_DataArray[indexPath.row];
            return cell;
        }

    }
    
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (self.m_CollectionType)
    {
#warning CollectionType
        case FSCollectionType_POSTS:
        {
            FSTopicModel *model = self.m_DataArray[indexPath.row];
            [FSPushVCManager showTopicDetail:[self.view.superview bm_viewController] topicId:model.m_Id];
        }
            break;
        case FSCollectionType_STATUTE:
            break;
        case FSCollectionType_CASE:
            break;
        case FSCollectionType_DOCUMENT:
            break;
        case FSCollectionType_COURSE:
            break;
    }
    
}

- (BMEmptyViewType)getNoDataEmptyViewType
{
    switch (self.m_CollectionType)
    {
        case FSCollectionType_POSTS:
            return BMEmptyViewType_CollectPOSTS;
        case FSCollectionType_STATUTE:
            return BMEmptyViewType_CollectSTATUTE;
        case FSCollectionType_CASE:
            return BMEmptyViewType_CollectCASE;
        case FSCollectionType_DOCUMENT:
            return BMEmptyViewType_CollectDOCUMENT;
        case FSCollectionType_COURSE:
        default:
            return BMEmptyViewType_NoData;
    }
}

@end
