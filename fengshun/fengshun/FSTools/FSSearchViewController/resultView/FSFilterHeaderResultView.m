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
FSFilterHeaderResultView ()
<
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource>

@property (nonatomic, strong) UIControl *           m_filterView;
@property (nonatomic, strong) UIView *              m_headerView;
@property (nonatomic, strong) TTGTagCollectionView *tagCollectionView;
@property (nonatomic, strong) NSMutableArray *      searchArray;
@property (nonatomic, strong) NSMutableArray *      searchTagviews;

@end

@implementation FSFilterHeaderResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
        [self configTableViewWithStartY:FILTER_HEADER_HEIGHT];

        _manager              = [[BMTableViewManager alloc] initWithTableView:_m_filterList];
        _section              = [BMTableViewSection section];
        _section.headerHeight = 0;
        _section.footerHeight = 0;
        [_manager addSection:_section];
    }
    return self;
}
- (NSArray *)searchKeys
{
    return [_searchArray copy];
}
- (void)setupUI
{
    _m_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, FILTER_HEADER_HEIGHT)];
    [self addSubview:_m_headerView];
    _m_headerView.backgroundColor = [UIColor whiteColor];
    _m_filterView                 = [[UIControl alloc] initWithFrame:CGRectMake(0, FILTER_HEADER_HEIGHT, self.bm_width, self.bm_height - FILTER_HEADER_HEIGHT)];
    [self addSubview:_m_filterView];
    _m_filterView.backgroundColor = [UIColor blackColor];
    _m_filterView.hidden          = YES;
    _m_filterView.alpha           = 0.7;
    [_m_filterView addTarget:self action:@selector(filterViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    _tagCollectionView                                = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT)];
    _tagCollectionView.delegate                       = self;
    _tagCollectionView.dataSource                     = self;
    _tagCollectionView.numberOfLines                  = 0;
    _tagCollectionView.horizontalSpacing              = 8.0f;
    _tagCollectionView.contentInset                   = UIEdgeInsetsMake(7, 14, 0, 14);
    _tagCollectionView.scrollDirection                = TTGTagCollectionScrollDirectionHorizontal;
    _tagCollectionView.showsHorizontalScrollIndicator = NO;
    [_m_headerView addSubview:_tagCollectionView];

    BMSingleLineView *hline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(0, 43, self.bm_width, 2) direction:SingleLineDirectionLandscape];
    hline.lineColor         = UI_COLOR_B6;
    [_m_headerView addSubview:hline];
    BMSingleLineView *vline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(self.bm_centerX - 1, 52, 2, 25) direction:SingleLineDirectionPortait];
    vline.lineColor         = UI_COLOR_B6;
    [_m_headerView addSubview:vline];
    // leftButton
    _m_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT, self.bm_width / 2, FILTER_BUTTON_HEIGHT)];
    [_m_headerView addSubview:_m_leftButton];
    [_m_leftButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
    _m_leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_m_leftButton setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
    [_m_leftButton addTarget:self action:@selector(showLeftFilters:) forControlEvents:UIControlEventTouchUpInside];

    // rightButton
    _m_rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bm_width / 2, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT, self.bm_width / 2, FILTER_BUTTON_HEIGHT)];
    [_m_headerView addSubview:_m_rightButton];
    [_m_rightButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
    _m_rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_m_rightButton setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
    [_m_rightButton addTarget:self action:@selector(showRightFilters:) forControlEvents:UIControlEventTouchUpInside];

    _m_filterList                 = [[FSTableView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 0) style:UITableViewStylePlain freshViewType:BMFreshViewType_NONE];
    _m_filterList.backgroundColor = [UIColor whiteColor];
    [_m_filterView addSubview:_m_filterList];
}
- (void)showLeftFilters:(id)sender
{
    self.m_filterArray = _m_leftFilters;
    self.m_showList    = FSFilterShowList_Left;
    [self showFilterList];
}
- (void)showRightFilters:(id)sender
{
    self.m_filterArray = _m_rightFilters;
    self.m_showList    = FSFilterShowList_Right;
    [self showFilterList];
}
- (void)filterViewClicked:(id)sender
{
    [self hiddenFilterListWithIndex:-1];
}
- (void)hiddenFilterListWithIndex:(NSInteger)index
{
    // -1表示全部
    self.m_showList    = FSFilterShowList_None;
    CGFloat listHeight = _m_filterList.bm_height;
    [UIView animateWithDuration:FILTER_ANIM_DUR * (listHeight / UI_SCREEN_HEIGHT)
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
    [self freshListView];
    // animation
    CGFloat maxHeight           = self.bm_height - FILTER_HEADER_HEIGHT;
    CGFloat contentHeight       = (1 + _m_filterArray.count) * FILTER_ROW_HEIGHT;
    _m_filterList.scrollEnabled = contentHeight > maxHeight;
    CGFloat listHeight          = (contentHeight > maxHeight) ? maxHeight : contentHeight;
    self.m_filterView.hidden    = NO;
    [UIView animateWithDuration:FILTER_ANIM_DUR * (listHeight / UI_SCREEN_HEIGHT)
                     animations:^{
                         self.m_filterList.frame = CGRectMake(0, 0, self.bm_width, listHeight);
                         [self layoutIfNeeded];
                     }];
}
- (void)freshListView
{
    [_section removeAllItems];
    BMWeakSelf
        BMTableViewItem *item0 = [BMTableViewItem itemWithTitle:@"全部"
                                                       subTitle:nil
                                                      imageName:nil
                                              underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset
                                                  accessoryView:nil
                                               selectionHandler:^(BMTableViewItem *_Nonnull item) {
                                                   BMStrongSelf
                                                       [self hiddenFilterListWithIndex:-1];
                                               }];
    item0.cellStyle  = UITableViewCellStyleDefault;
    item0.textFont   = [UIFont systemFontOfSize:14.0f];
    item0.textColor  = UI_COLOR_B1;
    item0.cellHeight = FILTER_ROW_HEIGHT;
    [self.section addItem:item0];

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
                                                      BMStrongSelf
                                                          [self hiddenFilterListWithIndex:index];
                                                  }];
            item.cellStyle  = UITableViewCellStyleDefault;
            item.textFont   = [UIFont systemFontOfSize:14.0f];
            item.textColor  = UI_COLOR_B1;
            item.cellHeight = FILTER_ROW_HEIGHT;
            [self.section addItem:item];
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
    NSUInteger index = [_searchTagviews indexOfObject:deleteButton.superview];
    [_searchArray removeObject:_searchArray[index]];
    [_searchTagviews removeObject:deleteButton.superview];
    [_tagCollectionView reload];
}

- (void)addSearchkey:(NSString *)searchkey
{
    if (!_searchArray)
    {
        self.searchArray     = [NSMutableArray array];
        self.searchTagviews = [NSMutableArray array];
    }
    if ([_searchArray containsObject:searchkey])
        return;
    [_searchArray insertObject:searchkey atIndex:0];
    [_searchTagviews insertObject:[self tagViewWithTag:searchkey] atIndex:0];
    [_tagCollectionView reload];
}
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index
{
    UIView *tagView = _searchTagviews[index];
    return tagView.frame.size;
}
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView
{
    return _searchTagviews.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index
{
    return _searchTagviews[index];
}

@end
