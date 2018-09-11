//
//  FSCaseSearchResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCaseSearchResultView.h"
#import "FSCaseSearchResultModel.h"
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
            BMStrongSelf
            self.m_searchResultModel = resultModel;
            [self setupFilterHeader];
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
    [self.m_tableView registerNib:[UINib nibWithNibName:@"FSCaseSearchResultCell" bundle:nil] forCellReuseIdentifier:@"FSCaseSearchResultCell"];
    self.m_tableView.estimatedRowHeight = 180;
}
- (NSInteger)m_totalCount
{
    return _m_searchResultModel.m_totalCount;
}
- (NSArray *)setupButton:(UIButton *)bt withSegment:(FSCaseFilterSegment *)segment
{
    bt.hidden = NO;
    [bt setTitle:segment.m_title forState:UIControlStateNormal];
    NSMutableArray *filters = [NSMutableArray array];
    for (FSCaseFilter *filter in segment.m_filters) {
        [filters addObject:filter.m_name];
    }
    return [filters copy];
}
- (void)setupFilterHeader
{
    if (_m_searchResultModel.m_filterSegments.count >0) {
        FSCaseFilterSegment *segment = _m_searchResultModel.m_filterSegments[0];
        self.m_leftFilters = [self setupButton:self.m_leftButton withSegment:segment];
    }
    if (_m_searchResultModel.m_filterSegments.count >1) {
        FSCaseFilterSegment *segment = _m_searchResultModel.m_filterSegments[1];
        self.m_rightFilters = [self setupButton:self.m_rightButton withSegment:segment];
    }
    [self showFilterList];
}

- (void)searchWithKey:(NSString *)key
{
    [super searchWithKey:key];
    _m_caseResultVC.m_searchResultModel = nil;
    self.m_searchResultModel = nil;
    if ([self.m_searchKeys bm_isNotEmpty]) {
        [self.m_resultVC loadApiData];
    }
}
- (void)selectedRowAtIndex:(NSInteger)index isLeftfilter:(BOOL)isLeft
{
    if (isLeft) {
        FSCaseFilterSegment *segment = _m_searchResultModel.m_filterSegments[0];
        _m_caseResultVC.m_leftFilter = index >= 0 ?segment.m_filters[index] :nil;
    }
    else
    {
        FSCaseFilterSegment *segment = _m_searchResultModel.m_filterSegments[1];
        _m_caseResultVC.m_rightFilter = index >= 0 ?segment.m_filters[index] :nil;
    }
    _m_caseResultVC.m_searchResultModel = nil;
    self.m_searchResultModel = nil;
    [_m_caseResultVC loadApiData];
}

@end
