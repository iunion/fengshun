//
//  FSFilterHeaderResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSFilterHeaderResultView.h"
#import "TTGTagCollectionView.h"


@interface
FSFilterHeaderResultView () <
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource>

@property (nonatomic, strong) UIControl *           m_filterView;
@property (nonatomic, strong) UIView *              m_headerView;
@property (nonatomic, strong) TTGTagCollectionView *m_tagCollectionView;
@property (nonatomic, strong) NSMutableArray *      m_searchTagviews;

@end

@implementation FSFilterHeaderResultView

- (instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC
{
    if (self = [super initWithFrame:frame andResultVC:resultVC])
    {
        [self setupUI];
        _m_manager              = [[BMTableViewManager alloc] initWithTableView:_m_filterList];
        _m_section              = [BMTableViewSection section];
        _m_section.headerHeight = 0;
        _m_section.footerHeight = 0;
        [_m_manager addSection:_m_section];
    }
    return self;
}
- (void)configTableView
{
    [super configTableView];
    self.m_resultVC.view.frame = CGRectMake(0, FILTER_HEADER_HEIGHT, self.bm_width, self.bm_height - FILTER_HEADER_HEIGHT);
}

- (void)setupUI
{
    _m_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, FILTER_HEADER_HEIGHT)];
    [self addSubview:_m_headerView];
    _m_headerView.backgroundColor = [UIColor whiteColor];
    _m_filterView                 = [[UIControl alloc] initWithFrame:CGRectMake(0, FILTER_HEADER_HEIGHT, self.bm_width, self.bm_height - FILTER_HEADER_HEIGHT)];
    [self addSubview:_m_filterView];
    _m_filterView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _m_filterView.hidden          = YES;
    [_m_filterView addTarget:self action:@selector(filterViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    _m_tagCollectionView                                = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT)];
    _m_tagCollectionView.delegate                       = self;
    _m_tagCollectionView.dataSource                     = self;
    _m_tagCollectionView.numberOfLines                  = 0;
    _m_tagCollectionView.horizontalSpacing              = 8.0f;
    _m_tagCollectionView.contentInset                   = UIEdgeInsetsMake(7, 14, 0, 14);
    _m_tagCollectionView.scrollDirection                = TTGTagCollectionScrollDirectionHorizontal;
    _m_tagCollectionView.showsHorizontalScrollIndicator = NO;
    [_m_headerView addSubview:_m_tagCollectionView];

    BMSingleLineView *hline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(0, 43, self.bm_width, 2) direction:SingleLineDirectionLandscape];
    hline.lineColor         = UI_COLOR_B6;
    [_m_headerView addSubview:hline];
    BMSingleLineView *vline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(self.bm_centerX - 1, 52, 2, 25) direction:SingleLineDirectionPortait];
    vline.lineColor         = UI_COLOR_B6;
    [_m_headerView addSubview:vline];
    // leftButton
    _m_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT, self.bm_width / 2, FILTER_BUTTON_HEIGHT)];
    [_m_headerView addSubview:_m_leftButton];
    _m_leftButton.hidden = YES;
    [_m_leftButton setImage:[UIImage imageNamed:@"search_openFilters"] forState:UIControlStateNormal];
    _m_leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_m_leftButton setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
    [_m_leftButton addTarget:self action:@selector(showLeftFilters:) forControlEvents:UIControlEventTouchUpInside];

    // rightButton
    _m_rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bm_width / 2, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT, self.bm_width / 2, FILTER_BUTTON_HEIGHT)];
    [_m_headerView addSubview:_m_rightButton];
    _m_rightButton.hidden = YES;

    [_m_rightButton setImage:[UIImage imageNamed:@"search_openFilters"] forState:UIControlStateNormal];
    _m_rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_m_rightButton setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
    [_m_rightButton addTarget:self action:@selector(showRightFilters:) forControlEvents:UIControlEventTouchUpInside];

    _m_filterList                 = [[FSTableView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 0) style:UITableViewStylePlain freshViewType:BMFreshViewType_NONE];
    _m_filterList.backgroundColor = [UIColor whiteColor];
    [_m_filterView addSubview:_m_filterList];
}
- (void)showLeftFilters:(id)sender
{
    self.m_showList = FSSearchFilterShowList_Left;
    [self showFilterList];
}
- (void)showRightFilters:(id)sender
{
    self.m_showList = FSSearchFilterShowList_Right;
    [self showFilterList];
}
- (void)filterViewClicked:(id)sender
{
    [self hiddenFilterListWithIndex:-1];
}
- (void)hiddenFilterListWithIndex:(NSInteger)index
{
    // -1表示全部
    self.m_showList    = FSSearchFilterShowList_None;
    [UIView animateWithDuration:FILTER_ANIM_DUR
        animations:^{
            self.m_filterList.frame = CGRectMake(0, 0, self.bm_width, 0);
            [self layoutIfNeeded];
        }
        completion:^(BOOL finished) {
            self.m_filterView.hidden = YES;
        }];
}
- (void)showFilterList
{
    switch (_m_showList)
    {
        case FSSearchFilterShowList_None:
            return;
            break;

        case FSSearchFilterShowList_Left:
            self.m_filterArray = _m_leftFilters;
            break;
        case FSSearchFilterShowList_Right:
            self.m_filterArray = _m_rightFilters;
            break;
    }
    [self freshListView];
    // animation
    CGFloat maxHeight           = self.bm_height - FILTER_HEADER_HEIGHT;
    CGFloat contentHeight       = (1 + _m_filterArray.count) * FILTER_ROW_HEIGHT;
    _m_filterList.scrollEnabled = contentHeight > maxHeight;
    CGFloat listHeight          = (contentHeight > maxHeight) ? maxHeight : contentHeight;
    self.m_filterView.hidden    = NO;
    [UIView animateWithDuration:FILTER_ANIM_DUR
                     animations:^{
                         self.m_filterList.frame = CGRectMake(0, 0, self.bm_width, listHeight);
                         [self layoutIfNeeded];
                     }];
}
- (void)freshListView
{
    [_m_section removeAllItems];
    BMWeakSelf
    BMTableViewItem *item0 = [BMTableViewItem itemWithTitle:@"全部"
                                                       subTitle:nil
                                                      imageName:nil
                                              underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset
                                                  accessoryView:nil
                                               selectionHandler:^(BMTableViewItem *_Nonnull item) {
                                                   [weakSelf selectedRowAtIndex:-1
                                                                   isLeftfilter:self.m_filterArray == self.m_leftFilters];
                                                   [weakSelf hiddenFilterListWithIndex:-1];
                                               }];
    item0.cellStyle  = UITableViewCellStyleDefault;
    item0.textFont   = [UIFont systemFontOfSize:14.0f];
    item0.textColor  = UI_COLOR_B1;
    item0.cellHeight = FILTER_ROW_HEIGHT;
    [self.m_section addItem:item0];

    if ([_m_filterArray bm_isNotEmpty])
    {
        for (int index = 0; index < _m_filterArray.count; index++)
        {
            BMTableViewItem *item = [BMTableViewItem itemWithTitle:_m_filterArray[index]
                                                          subTitle:nil
                                                         imageName:nil
                                                 underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset
                                                     accessoryView:nil
                                                  selectionHandler:^(BMTableViewItem *item) {
                                                      [weakSelf selectedRowAtIndex:index
                                                                      isLeftfilter:self.m_filterArray == self.m_leftFilters];
                                                      [weakSelf hiddenFilterListWithIndex:index];
                                                  }];
            item.cellStyle  = UITableViewCellStyleDefault;
            item.textFont   = [UIFont systemFontOfSize:14.0f];
            item.textColor  = UI_COLOR_B1;
            item.cellHeight = FILTER_ROW_HEIGHT;
            [self.m_section addItem:item];
        }
    }

    [_m_filterList reloadData];
}
#pragma mark - TTGTag Delegate & DataSource
- (UIView *)tagViewWithTag:(NSString *)tag
{
    CGFloat width        = [tag bm_widthToFitHeight:28 withFont:[UIFont systemFontOfSize:14.0f]] + 22.0f;
    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 26, 28)];
    view.backgroundColor = FS_VIEW_BGCOLOR;
    [view bm_roundedRect:5];
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 28.0f)];
    label.font          = [UIFont systemFontOfSize:14.0f];
    label.textColor     = UI_COLOR_B1;
    label.textAlignment = NSTextAlignmentCenter;
    label.text          = tag;
    [view addSubview:label];
    BMSingleLineView *vline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(view.bm_right - 28, 7, 2, 14) direction:SingleLineDirectionPortait];
    vline.lineColor         = UI_COLOR_B6;
    [view addSubview:vline];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(view.bm_right - 28, 0, 28, 28)];
    [deleteButton setImage:[UIImage imageNamed:@"bmsearch_close"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteButton];
    return view;
}
- (void)deleteButtonAction:(UIButton *)deleteButton
{
    NSUInteger index = [_m_searchTagviews indexOfObject:deleteButton.superview];
    [self keysRemoveKey:self.m_searchKeys[index]];
    [self freshTagView];
}

- (void)freshTagView
{
    self.m_searchTagviews = [NSMutableArray array];
    for (NSString *key in self.m_searchKeys)
    {
        UIView *tagView = [self tagViewWithTag:key];
        [_m_searchTagviews addObject:tagView];
    }
    [_m_tagCollectionView reload];
}
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index
{
    UIView *tagView = _m_searchTagviews[index];
    return tagView.frame.size;
}
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView
{
    return _m_searchTagviews.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index
{
    return _m_searchTagviews[index];
}

- (void)searchWithKey:(NSString *)key
{
    [super searchWithKey:key];
    [self freshTagView];
}
- (void)selectedRowAtIndex:(NSInteger)index isLeftfilter:(BOOL)isLeft
{
    
}
@end
