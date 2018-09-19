//
//  FSMyCollectionVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionVC.h"
#import "FSTopicListCell.h"
#import "FSCourseTableCell.h"
#import "FSLawSearchResultCell.h"
#import "FSCaseSearchResultCell.h"
#import "FSTextListCell.h"


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
    self.m_TableView.estimatedRowHeight = 180;
    switch (self.m_CollectionType)
    {
        case FSCollectionType_POSTS:
            break;
        case FSCollectionType_STATUTE:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSLawSearchResultCell" bundle:nil] forCellReuseIdentifier:@"FSLawSearchResultCell"];
            break;
        case FSCollectionType_CASE:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCaseSearchResultCell" bundle:nil] forCellReuseIdentifier:@"FSCaseSearchResultCell"];
            break;
        case FSCollectionType_DOCUMENT:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSTextListCell" bundle:nil] forCellReuseIdentifier:@"FSTextListCell"];
            break;
        case FSCollectionType_COURSE:
            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCourseTableCell" bundle:nil] forCellReuseIdentifier:@"FSCourseTableCell"];
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
                    FSTopicModel *topic = [FSTopicModel topicWithServerDic:dic];
                    if ([topic bm_isNotEmpty])
                    {
                        [dataArray addObject:topic];
                    }
                }
                    break;
                    
                case FSCollectionType_STATUTE:
                {
                    // 法规
                    FSLawResultModel *model = [FSLawResultModel modelWithParams:dic];
                    if ([model bm_isNotEmpty]) {
                        [dataArray addObject:model];
                    }
                }
                    break;
                    
                case FSCollectionType_CASE:
                {
                    // 案例
                    FSCaseSearchResultModel *model = [FSCaseSearchResultModel modelWithParams:dic];
                    if ([model bm_isNotEmpty]) {
                        [dataArray addObject:model];
                    }
                }
                    break;
                    
                case FSCollectionType_DOCUMENT:
                {
                    // 文书
                    FSListTextModel *model = [FSListTextModel modelWithParams:dic];
                    if ([model bm_isNotEmpty]) {
                        [dataArray addObject:model];
                    }
                }
                    break;
                    
                case FSCollectionType_COURSE:
                {
                    // 课程
                    FSCourseModel *model = [FSCourseModel modelWithParams:dic];
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
    return 8.0f;
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
            
            [cell drawCellWithModle:self.m_DataArray[indexPath.row]];
            
            return cell;
        }
        case FSCollectionType_STATUTE:
        {
            FSLawSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLawSearchResultCell"];
            
            FSLawResultModel *model = self.m_DataArray[indexPath.row];
            [cell setLawResultModel:model attributed:NO];
            return cell;
        }
        case FSCollectionType_CASE:
        {
            FSCaseSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCaseSearchResultCell"];
            
            FSCaseReultModel *model = self.m_DataArray[indexPath.row];
            [cell setCaseResultModel:model attributed:NO];
            return cell;
        }
        case FSCollectionType_DOCUMENT:
        {
            FSTextListCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"FSTextListCell"];
            FSListTextModel *model = self.m_DataArray[indexPath.row];
            [cell setTextModel:model colors:NO];
            return cell;
        }
        case FSCollectionType_COURSE:
        {
            FSCourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCourseTableCell"];
            
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
