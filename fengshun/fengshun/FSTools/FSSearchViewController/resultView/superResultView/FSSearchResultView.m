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
@property (nonatomic, strong) NSMutableArray *     m_searchArray;
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
    _m_tableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
}

- (NSArray *)m_searchKeys
{
    return [_m_searchArray copy];
}

- (void)setM_masterVC:(UIViewController *)m_masterVC
{
    _m_masterVC = m_masterVC;
    _m_resultVC.m_masterVC = m_masterVC;
}
- (void)showSecondView:(BOOL)showSecondView
{
    // do nothing
}
#pragma mark - search protocol

- (void)keysRemoveKey:(NSString *)key
{
    [_m_searchArray removeObject:key];
    [self searchAction];
}
- (void)cleanKeys
{
    [_m_searchArray removeAllObjects];
    [self searchAction];
}
- (void)searchWithKey:(NSString *)key
{
    self.m_searchKey = key;
    if (!_m_searchArray)
    {
        self.m_searchArray = [NSMutableArray array];
    }
    if (![_m_searchArray containsObject:key])
    {
        [_m_searchArray insertObject:key atIndex:0];
    }
    [self searchAction];
}
- (void)searchAction
{
    // search
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
