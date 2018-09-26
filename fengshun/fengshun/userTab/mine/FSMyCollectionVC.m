//
//  FSMyCollectionVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionVC.h"
#import "FSMyCollectionCell.h"


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
            FSMyCollectionModel *collection = [FSMyCollectionModel collectionModelWithDic:dic];
            if ([collection bm_isNotEmpty])
            {
                collection.m_CollectionType = self.m_CollectionType;
                if (collection.m_CollectionType == FSCollectionType_DOCUMENT)
                {
                    if (![collection.m_FiledId bm_isNotEmpty])
                    {
                        break;
                    }
                }
                [dataArray addObject:collection];
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
    return [FSMyCollectionCell cellHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *taskCellIdentifier = @"FSCell";
        FSMyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FSMyCollectionCell" owner:self options:nil] lastObject];
        }
    
        [cell drawCellWithModel:self.m_DataArray[indexPath.row]];
        return cell;
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
            FSMyCollectionModel *model = self.m_DataArray[indexPath.row];
            [FSPushVCManager showTopicDetail:[self.view.superview bm_viewController] topicId:model.m_DetailId];
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
            return BMEmptyViewType_CollectCOURSE;
        default:
            return BMEmptyViewType_NoData;
    }
}

@end
