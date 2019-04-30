//
//  FSMyCollectionVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionVC.h"
#import "FSMyCollectionCell.h"
#import "FSMyCourseCollectionCell.h"
#import "FSSpecialColumnCell.h"

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:refreshCollectionNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_LoadDataType = FSAPILoadDataType_Page;
    //self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.m_TableView.tableFooterView = [UIView new];
    self.m_TableView.estimatedRowHeight = 180;
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSSpecialColumnCell" bundle:nil] forCellReuseIdentifier:@"FSSpecialColumnCell"];
//    switch (self.m_CollectionType)
//    {
//        case FSCollectionType_POSTS:
//            break;
//        case FSCollectionType_STATUTE:
//            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSLawCell" bundle:nil] forCellReuseIdentifier:@"FSLawCell"];
//            break;
//        case FSCollectionType_CASE:
//            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCaseCell" bundle:nil] forCellReuseIdentifier:@"FSCaseCell"];
//            break;
//        case FSCollectionType_DOCUMENT:
//            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSTextCell" bundle:nil] forCellReuseIdentifier:@"FSTextCell"];
//            break;
//        case FSCollectionType_COURSE:
//            [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCollectionCourseCell" bundle:nil] forCellReuseIdentifier:@"FSCollectionCourseCell"];
//            break;
//    }
    [self loadApiData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:refreshCollectionNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshList
{
    s_BakLoadedPage = 0;
    [self loadApiData];
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    return [FSApiRequest getMyCollectionsWithPageIndex:s_BakLoadedPage pageSize:self.m_CountPerPage collectionType:self.m_CollectionType];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *dicArray = [requestDic bm_arrayForKey:@"list"];
    if (self.m_IsLoadNew)
    {
        [self.m_DataArray removeAllObjects];
    }
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
            FSMyCollectionModel *firstModel = [self.m_DataArray firstObject];
            if (!firstModel)
            {
                firstModel = [dataArray firstObject];
            }
            FSMyCollectionModel *oldLastModel = [self.m_DataArray lastObject];
            firstModel.m_PositionType |= BMTableViewCell_PositionType_First;
            oldLastModel.m_PositionType &= !BMTableViewCell_PositionType_Last;
            
            [self.m_DataArray addObjectsFromArray:dataArray];
            
            FSMyCollectionModel *lastModel = [self.m_DataArray lastObject];
            lastModel.m_PositionType |= BMTableViewCell_PositionType_Last;
        }
    }
    [self.m_TableView reloadData];
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
    //return [FSMyCollectionCell cellHeight];
    if (self.m_CollectionType == FSCollectionType_COURSE)
    {
        return [FSMyCourseCollectionCell cellHeight];
    }
    else if (self.m_CollectionType == FSCollectionType_COLUMN)
    {
        return [FSSpecialColumnCell cellHeight];
    }
    else
    {
        FSMyCollectionModel *model = self.m_DataArray[indexPath.row];
    
        return model.m_TitleHeight+76.0f+8.0f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *taskCellIdentifier;
    
    if (self.m_CollectionType == FSCollectionType_COURSE)
    {
        taskCellIdentifier = @"FSMyCourseCollectionCell";
        FSMyCourseCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FSMyCourseCollectionCell" owner:self options:nil] lastObject];
        }
        
        [cell drawCellWithModel:self.m_DataArray[indexPath.row]];
        return cell;
    }
    else if (self.m_CollectionType == FSCollectionType_COLUMN)
    {
        taskCellIdentifier = @"FSSpecialColumnCell";
        FSSpecialColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
        [cell showCollectionCellModel:self.m_DataArray[indexPath.row]];
        return cell;
    }
    else
    {
        taskCellIdentifier = @"FSMyCollectionCell";
        FSMyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FSMyCollectionCell" owner:self options:nil] lastObject];
        }
        
        [cell drawCellWithModel:self.m_DataArray[indexPath.row]];
        return cell;
    }
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    FSMyCollectionModel *model = self.m_DataArray[indexPath.row];
//    [FSPushVCManager showWebView:self url:model.m_JumpAddress title:nil];

    switch (self.m_CollectionType)
    {
        case FSCollectionType_POSTS:
        {
            [FSPushVCManager showTopicDetail:self.m_PushVC topicId:model.m_DetailId];
        }
            break;
        case FSCollectionType_STATUTE:
        {
            [FSPushVCManager viewController:self.m_PushVC pushToLawDetailWithId:model.m_DetailId keywords:@"NULL"];
        }
            break;
        case FSCollectionType_CASE:
        {
            [FSPushVCManager viewController:self.m_PushVC pushToCaseDetailWithId:model.m_DetailId isGuide:model.m_GuidingCase keywords:@"NULL"];
        }
            break;
        case FSCollectionType_DOCUMENT:
        {
            [FSPushVCManager pushToTextDetail:self.m_PushVC url:model.m_PreviewUrl withFileId:model.m_FiledId documentId:model.m_DetailId title:model.m_Title];
        }
            break;
        case FSCollectionType_COURSE:
        {
            [FSPushVCManager viewController:self.m_PushVC pushToCourseDetailWithId:model.m_DetailId andIsSerial:model.m_isSerial];
        }
            break;
            case  FSCollectionType_COLUMN:
        {
            [FSPushVCManager showWebView:self.m_PushVC url:model.m_JumpAddress title:nil];
        }
            break;
        default:
            return;
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
        case FSCollectionType_COLUMN:
            return BMEmptyViewType_NoData;
        default:
            return BMEmptyViewType_NoData;
    }
}

@end
