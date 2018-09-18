//
//  FSMyCollectionVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionVC.h"
#import "FSTopicListCell.h"

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
    NSArray *topicDicArray = [requestDic bm_arrayForKey:@"list"];
    if ([topicDicArray bm_isNotEmpty])
    {
        NSMutableArray *topicArray = [[NSMutableArray alloc] initWithCapacity:0];
        
#warning CollectionType
        for (NSDictionary *dic in topicDicArray)
        {
            switch (self.m_CollectionType)
            {
                case FSCollectionType_POSTS:
                {
                    FSTopicModel *topic = [FSTopicModel topicWithServerDic:dic];
                    if ([topic bm_isNotEmpty])
                    {
                        [topicArray addObject:topic];
                    }
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
                    
                default:
                    break;
            }
        }
        
        if ([topicArray bm_isNotEmpty])
        {
            if (self.m_IsLoadNew)
            {
                [self.m_DataArray removeAllObjects];
            }
            [self.m_DataArray addObjectsFromArray:topicArray];
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
