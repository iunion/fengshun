//
//  FSCaseSearchResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCaseSearchResultView.h"
#import "FSSearchResultModel.h"
#import "FSCaseSearchResultVC.h"

@interface FSCaseSearchResultView()

@property(nonatomic, strong)FSCaseSearchResultModel *m_searchResultModel;
@property(nonatomic, weak) FSCaseSearchResultVC *m_caseResultVC;

@end


@implementation FSCaseSearchResultView


-(instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC
{
    self = [super initWithFrame:frame andResultVC:resultVC];
    if (self) {
        _m_caseResultVC = (FSCaseSearchResultVC *)resultVC;
        BMWeakSelf
        resultVC.m_searchsucceed = ^(id resultModel) {
            weakSelf.m_searchResultModel = resultModel;
            [weakSelf setupFilterHeader];
        };
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andResultVC:[[FSCaseSearchResultVC alloc] initWithNibName:nil bundle:nil freshViewType:BMFreshViewType_Bottom]];
}
- (void)configTableView
{
    [super configTableView];
    [self.m_tableView registerNib:[UINib nibWithNibName:@"FSCaseCell" bundle:nil] forCellReuseIdentifier:@"FSCaseCell"];
    self.m_tableView.estimatedRowHeight = 180;
}

- (NSArray *)filtersWithSegment:(FSSearchFilterSegment *)segment
{
    NSMutableArray *filters = [NSMutableArray array];
    for (FSSearchFilter *filter in segment.m_filters) {
        [filters addObject:filter.m_value];
    }
    return [filters copy];
}
- (void)setupButton:(UIButton *)bt withTitle:(NSString *)title
{
    bt.hidden = NO;
    [bt setTitle:title forState:UIControlStateNormal];
    [bt bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
}
// 更新筛选条件
- (void)setupFilterHeader
{
    if (_m_searchResultModel.m_filterSegments.count >0) {
        FSSearchFilterSegment *segment = _m_searchResultModel.m_filterSegments[0];
        FSSearchFilter *filter = _m_caseResultVC.m_leftFilter;
        [self setupButton:self.m_leftButton withTitle:filter?filter.m_value:segment.m_title];
        self.m_leftFilters = [self filtersWithSegment: segment];
    }
    if (_m_searchResultModel.m_filterSegments.count >1) {
        FSSearchFilterSegment *segment = _m_searchResultModel.m_filterSegments[1];
        FSSearchFilter *filter = _m_caseResultVC.m_rightFilter;
        [self setupButton:self.m_rightButton withTitle:filter?filter.m_value:segment.m_title];
        self.m_rightFilters = [self filtersWithSegment: segment];
    }
    [self showFilterList];
}
// 数据条目
- (NSInteger)m_totalCount
{
    return _m_searchResultModel.m_totalCount;
}
- (void)searchAction
{
    [super searchAction];
    if ([self.m_searchKeys bm_isNotEmpty]) {
        _m_caseResultVC.m_searchResultModel = nil;
        self.m_searchResultModel = nil;
        [self.m_resultVC loadApiData];
    }
    else
    {
        // 在关键字删完后会将resultView从父视图移除
        _m_caseResultVC.m_searchResultModel  = nil;
        self.m_searchResultModel = nil;
        _m_caseResultVC.m_leftFilter = nil;
        _m_caseResultVC.m_rightFilter = nil;
        [_m_caseResultVC.m_TableView reloadData];
        [self removeResultVC];
    }
}
// 选择了筛选条件
- (void)selectedRowAtIndex:(NSInteger)index isLeftfilter:(BOOL)isLeft
{
    if (isLeft)
    {
        FSSearchFilterSegment *segment = _m_searchResultModel.m_filterSegments[0];
        FSSearchFilter *filter  = index >= 0 ? segment.m_filters[index] : nil;
        _m_caseResultVC.m_leftFilter = filter;
        self.m_leftTitle = filter.m_value;
        [self setupButton:self.m_leftButton withTitle:filter ? filter.m_value : segment.m_title];
    }
    else
    {
        FSSearchFilterSegment *segment = _m_searchResultModel.m_filterSegments[1];
        FSSearchFilter *filter = index >= 0 ? segment.m_filters[index] : nil;
        _m_caseResultVC.m_rightFilter  = filter;
         self.m_rightTitle = filter.m_value;
        [self setupButton:self.m_rightButton withTitle:filter ? filter.m_value : segment.m_title];
    }
    _m_caseResultVC.m_searchResultModel = nil;
    self.m_searchResultModel = nil;
    [_m_caseResultVC loadApiData];
}

@end
