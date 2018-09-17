//
//  FSVideoMediateListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateListVC.h"
#import "FSHeaderCommonSelector.h"
#import "VideoMediateListCell.h"
#import "FSCreateVideoMediateVC.h"
#import "FSVideoMediateDetailVC.h"

@interface FSVideoMediateListVC ()
@property (nonatomic, strong) NSString *meetingTypeEnums;
@property (nonatomic, strong) NSString *meetingStatusEnums;
@end

@implementation FSVideoMediateListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_LoadDataType = FSAPILoadDataType_Page;

    [self bm_setNavigationWithTitle:@"视频调解" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
 
    [self buildUI];
    [self loadApiData];
}

-(void)buildUI
{
    FSHeaderCommonSelectorModel *left =
    [FSHeaderCommonSelectorModel modelWithTitle:@"类型"
                                      hiddenkey:@"meetingTypeEnums"
                                           list:[FSMeetingDataForm formMeetingDataToModelWithType:FSMeetingDataType_AllMeetingType]];

    FSHeaderCommonSelectorModel *right =
    [FSHeaderCommonSelectorModel modelWithTitle:@"状态"
                                      hiddenkey:@"meetingStatusEnums"
                                           list:[FSMeetingDataForm formMeetingDataToModelWithType:FSMeetingDataType_AllMeetingStatus]];

    
    FSHeaderCommonSelectorView *selector = [[FSHeaderCommonSelectorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bm_width, 42)];
    selector.m_DataArray = @[left, right];
    selector.selectorBlock = ^(FSHeaderCommonSelectorModel *hModel, FSSelectorListModel *lmodel) {
        NSLog(@"%@", hModel.title);
        NSLog(@"%@", lmodel.showName);
        [self setValue:lmodel.hiddenkey forKey:hModel.hiddenkey];
        [self loadApiData];
    };
    
    self.meetingTypeEnums = @"MEETING_TYPE_OR";
    self.meetingStatusEnums = @"MEETING_STATUS_OR";

    [self.view addSubview:selector];
    
    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48, self.view.bm_width, 48)
                                              title:@"发起视频调解"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(createVideoMediate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
    
    self.m_TableView.frame = CGRectMake(0, selector.bm_height, self.view.bm_width, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-selector.bm_height-bottom.bm_height);
}

- (void)createVideoMediate
{
    FSCreateVideoMediateVC *vc = [FSCreateVideoMediateVC new];
    BMWeakSelf
    vc.successBlock = ^{
        [weakSelf loadApiData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getMeetingListWithType:_meetingTypeEnums
                                         status:_meetingStatusEnums
                                      pageIndex:s_BakLoadedPage
                                       pageSize:self.m_CountPerPage];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)data
{
    NSLog(@"%@",data);
    NSArray *array = [FSMeetingDetailModel modelsWithDataArray:data[@"list"]];
    if (self.m_IsLoadNew) {
        [self.m_DataArray removeAllObjects];
    }
    if (array) {
        [self.m_DataArray addObjectsFromArray:array];
    }
    
    if (self.m_DataArray.count == 0) {
        [self showEmptyViewWithStatus:BMEmptyViewStatus_NoData];
    }
    
    [self.m_TableView reloadData];
    
    return [super succeedLoadedRequestWithDic:data];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"VideoMediateListCell";
    VideoMediateListCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[VideoMediateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellIdentifier];
    }
    
    [cell setModel:self.m_DataArray[indexPath.row]];
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSVideoMediateDetailVC *vc = [FSVideoMediateDetailVC new];
    FSMeetingDetailModel *model = self.m_DataArray[indexPath.row];
    vc.m_MeetingId = model.meetingId;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
