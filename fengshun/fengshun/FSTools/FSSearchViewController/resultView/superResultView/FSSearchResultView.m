//
//  FSSearchResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchResultView.h"


@interface
FSSearchResultView ()

@property (nonatomic, copy, readwrite) NSString *m_searchKey;
@property (nonatomic, readwrite) FSSearchResultVC *m_resultVC;
@property (nonatomic, readwrite) FSTableView *     m_tableView;
@property (nonatomic, strong) NSMutableArray *      m_searchArray;
@end

@implementation FSSearchResultView

- (instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = FS_VIEW_BGCOLOR;
        if (!resultVC)
        {
            _m_resultVC = [[FSSearchResultVC alloc] initWithNibName:nil bundle:nil freshViewType:BMFreshViewType_Bottom];
        }
        else
        {
            _m_resultVC = resultVC;
        }
        resultVC.m_LoadDataType = FSAPILoadDataType_Page;
        resultVC.m_resultView   = self;
        [self addSubview:_m_resultVC.view];
        _m_tableView = _m_resultVC.m_TableView;

        [self configTableView];
        _m_tableView.frame = _m_resultVC.view.bounds;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andResultVC:nil];
}
- (void)configTableView
{
    _m_resultVC.view.frame = CGRectMake(0, 0, self.bm_width, self.bm_height);
    _m_tableView.tableFooterView   = [UIView new];
    // 由resultVC管理结果列表的data,由resultView管理结果列表的交互
    _m_tableView.delegate          = self;
    _m_tableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
}

- (NSArray *)m_searchKeys
{
    return [_m_searchArray copy];
}
#pragma mark - tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view         = [UIView new];
    view.backgroundColor = FS_VIEW_BGCOLOR;
    UILabel *label       = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.bm_width - 32, SEARCH_HEADER_HEIGHT)];
    label.font           = [UIFont systemFontOfSize:12];
    label.textColor      = UI_COLOR_B4;
    label.text           = [NSString stringWithFormat:@"共%ld条", (long)self.m_totalCount];
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SEARCH_HEADER_HEIGHT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - search protocol

- (void)keysRemoveKey:(NSString *)key
{
    [_m_searchArray removeObject:key];
    [self searchAction];
}
- (void)searchWithKey:(NSString *)key
{
    self.m_searchKey = key;
    if (!_m_searchArray)
    {
        self.m_searchArray    = [NSMutableArray array];
    }
    if ([_m_searchArray containsObject:key]) return;
    [_m_searchArray insertObject:key atIndex:0];
    [self searchAction];
}
- (void)searchAction
{
    // search
}

@end
