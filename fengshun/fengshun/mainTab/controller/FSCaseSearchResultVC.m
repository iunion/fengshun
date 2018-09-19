//
//  FSCaseSearchResultVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCaseSearchResultVC.h"
#import "FSCaseSearchResultCell.h"
#import "FSApiRequest.h"
#import "FSSearchResultView.h"

@interface FSCaseSearchResultVC ()


@end

@implementation FSCaseSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_searchResultModel.m_resultDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCaseSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCaseSearchResultCell"];

    FSCaseResultModel *model = _m_searchResultModel.m_resultDataArray[indexPath.row];
    [cell setCaseResultModel:model attributed:YES];
    return cell;
}
- (BOOL)canLoadApiData
{
    return _m_searchResultModel?_m_searchResultModel.m_isMore:YES;
}
#pragma mark - NetWorking
- (NSMutableURLRequest *)setLoadDataRequest
{
    NSMutableArray *filters = [NSMutableArray array];
    if (_m_leftFilter) {
        [filters addObject:@{@"name":_m_leftFilter.m_name,
                             @"value":_m_leftFilter.m_value,
                             @"docCount":@(_m_leftFilter.m_docCount),
                             }];
    }
    if (_m_rightFilter) {
        [filters addObject:@{@"name":_m_rightFilter.m_name,
                             @"value":_m_rightFilter.m_value,
                             @"docCount":@(_m_rightFilter.m_docCount),
                             }];
    }
    return [FSApiRequest searchCaseWithKeywords:self.m_resultView.m_searchKeys start:_m_searchResultModel.m_resultDataArray.count size:self.m_CountPerPage filters:filters];
}
- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)responseObject
{
    FSCaseSearchResultModel *result = [FSCaseSearchResultModel modelWithParams:responseObject];
    if (!_m_searchResultModel) {
        self.m_searchResultModel = result;
    }
    else
    {
        _m_searchResultModel.m_resultDataArray = [_m_searchResultModel.m_resultDataArray arrayByAddingObjectsFromArray:result.m_resultDataArray];
    }
    self.m_searchResultModel.m_isMore         = result.m_isMore;
    self.m_searchResultModel.m_filterSegments = result.m_filterSegments;

    if (self.m_searchsucceed) self.m_searchsucceed(self.m_searchResultModel);
    self.m_DataArray = [_m_searchResultModel.m_resultDataArray mutableCopy];
    [self.m_TableView reloadData];
    
    return [super succeedLoadedRequestWithDic:responseObject];
}
- (BOOL)checkLoadFinish:(NSDictionary *)requestDic
{
    return !_m_searchResultModel.m_isMore;
}
@end
