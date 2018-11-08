//
//  FSFilterHeaderResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSFilterHeaderResultView.h"
#import "TTGTagCollectionView.h"


@interface FSFilterBGManager : NSObject
<
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource
>
@property (nonatomic, strong) NSMutableArray *m_BGTagviews;

@end

@implementation FSFilterBGManager

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index
{
    UIView *tagView = _m_BGTagviews[index];
    return tagView.frame.size;
}
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView
{
    return _m_BGTagviews.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index
{
    return _m_BGTagviews[index];
}
@end

@interface
FSFilterHeaderResultView ()
<
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource
>
@property (nonatomic, strong) UIControl *           m_filterView;
@property (nonatomic, strong) UIView *              m_headerView;
@property (nonatomic, strong) TTGTagCollectionView *m_tagCollectionView;
@property (nonatomic, strong) NSMutableArray *      m_searchTagviews;

// 还有个二级搜索页面,我也很崩溃
@property (nonatomic, strong) UIView *              m_BGtagView;
@property (nonatomic, strong) TTGTagCollectionView *m_BGtagCollectionView;

@property (nonatomic, strong) FSFilterBGManager *m_bgManager;
@property (nonatomic, strong) UIButton *         m_cleanTagsButton;

@end

@implementation FSFilterHeaderResultView

- (instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC
{
    if (self = [super initWithFrame:frame andResultVC:resultVC])
    {
        [self setupUI];
        _m_manager = [[BMTableViewManager alloc] initWithTableView:_m_filterList];
        _m_section = [BMTableViewSection section];
        _m_section.headerHeight = 0;
        _m_section.footerHeight = 0;
        [_m_manager addSection:_m_section];
    }
    return self;
}
- (FSSearchViewController *)searchVC
{
    return (FSSearchViewController *)self.m_masterVC;
}
- (void)showSecondView:(BOOL)showSecondView
{
    _m_BGtagView.hidden = !showSecondView;
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
    _m_filterView = [[UIControl alloc] initWithFrame:CGRectMake(0, FILTER_HEADER_HEIGHT, self.bm_width, self.bm_height - FILTER_HEADER_HEIGHT)];
    [self addSubview:_m_filterView];
    _m_filterView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _m_filterView.hidden = YES;
    [_m_filterView addTarget:self action:@selector(filterViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    _m_tagCollectionView = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT)];
    _m_tagCollectionView.delegate = self;
    _m_tagCollectionView.dataSource = self;
    _m_tagCollectionView.numberOfLines = 0;
    _m_tagCollectionView.horizontalSpacing = 8.0f;
    _m_tagCollectionView.contentInset = UIEdgeInsetsMake(7, 14, 0, 14);
    _m_tagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;

    _m_tagCollectionView.showsHorizontalScrollIndicator = NO;
    _m_tagCollectionView.showsVerticalScrollIndicator = NO;
    [_m_headerView addSubview:_m_tagCollectionView];

    BMSingleLineView *hline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(0, 43, self.bm_width, 2) direction:SingleLineDirectionLandscape];
    hline.lineColor = UI_COLOR_B6;
    [_m_headerView addSubview:hline];
    BMSingleLineView *vline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(self.bm_centerX - 1, 52, 2, 25) direction:SingleLineDirectionPortait];
    vline.lineColor = UI_COLOR_B6;
    [_m_headerView addSubview:vline];
    // leftButton
    _m_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT, self.bm_width / 2-10, FILTER_BUTTON_HEIGHT)];
    [_m_headerView addSubview:_m_leftButton];
    _m_leftButton.hidden = YES;
    _m_leftButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_m_leftButton setImage:[UIImage imageNamed:@"search_closeFilters"] forState:UIControlStateNormal];
    _m_leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_m_leftButton setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
    [_m_leftButton addTarget:self action:@selector(showLeftFilters:) forControlEvents:UIControlEventTouchUpInside];

    // rightButton
    _m_rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bm_width / 2+5, FILTER_HEADER_HEIGHT - FILTER_BUTTON_HEIGHT, self.bm_width / 2-10, FILTER_BUTTON_HEIGHT)];
    [_m_headerView addSubview:_m_rightButton];
    _m_rightButton.hidden = YES;
    _m_rightButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_m_rightButton setImage:[UIImage imageNamed:@"search_closeFilters"] forState:UIControlStateNormal];
    _m_rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_m_rightButton setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
    [_m_rightButton addTarget:self action:@selector(showRightFilters:) forControlEvents:UIControlEventTouchUpInside];

    _m_filterList = [[FSTableView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 0) style:UITableViewStylePlain freshViewType:BMFreshViewType_NONE];
    _m_filterList.backgroundColor = [UIColor whiteColor];
    [_m_filterView addSubview:_m_filterList];

    _m_BGtagView = [[UIView alloc] initWithFrame:self.bounds];
    _m_BGtagView.backgroundColor = [UIColor whiteColor];
    _m_BGtagView.hidden = YES;
    [self addSubview:_m_BGtagView];

    _m_BGtagCollectionView = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 60)];
    _m_bgManager = [FSFilterBGManager new];
    _m_BGtagCollectionView.delegate = self.m_bgManager;
    _m_BGtagCollectionView.dataSource = self.m_bgManager;
    _m_BGtagCollectionView.horizontalSpacing = 8.0f;
    _m_BGtagCollectionView.verticalSpacing = 12.0f;
    _m_BGtagCollectionView.contentInset = UIEdgeInsetsMake(7, 14, 0, 14);
    _m_BGtagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionVertical;
    _m_BGtagCollectionView.showsHorizontalScrollIndicator = NO;
    _m_BGtagCollectionView.showsVerticalScrollIndicator = NO;
    
    [_m_BGtagView addSubview:_m_BGtagCollectionView];
    _m_cleanTagsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 38)];
    [_m_cleanTagsButton setTitle:@"清除" forState:UIControlStateNormal];
    [_m_cleanTagsButton setTitleColor:UI_COLOR_B4 forState:UIControlStateNormal];
    [_m_cleanTagsButton addTarget:self action:@selector(cleanTags:) forControlEvents:UIControlEventTouchUpInside];
    [_m_cleanTagsButton bm_roundedRect:19 borderWidth:0.5 borderColor:UI_COLOR_B4];
    _m_cleanTagsButton.bm_centerX = _m_BGtagView.bm_centerX;
    _m_cleanTagsButton.bm_top = _m_BGtagCollectionView.bm_bottom +25;
    [_m_BGtagView addSubview:_m_cleanTagsButton];
}
- (void)showLeftFilters:(id)sender
{
    if (_m_showList == FSSearchFilterShowList_Left) {
        [self hiddenFilterListWithIndex: -1];
    }
    else
    {
        self.m_showList = FSSearchFilterShowList_Left;
        [self showFilterList];
    }
}
- (void)showRightFilters:(id)sender
{
    if (_m_showList == FSSearchFilterShowList_Right) {
        [self hiddenFilterListWithIndex:-1];
    }
    else
    {
        self.m_showList = FSSearchFilterShowList_Right;
        [self showFilterList];
    }
    
}
- (void)filterViewClicked:(id)sender
{
    [self hiddenFilterListWithIndex:-1];
}
- (void)hiddenFilterListWithIndex:(NSInteger)index
{
    // -1表示全部
    if (self.m_showList == FSSearchFilterShowList_None) {
        return;
    }
    self.m_showList = FSSearchFilterShowList_None;
     [_m_leftButton setImage:[UIImage imageNamed:@"search_closeFilters"] forState:UIControlStateNormal];
    [_m_leftButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
     [_m_rightButton setImage:[UIImage imageNamed:@"search_closeFilters"] forState:UIControlStateNormal];
    [_m_rightButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
    [UIView animateWithDuration:FILTER_ANIM_DUR
        animations:^{
            self.m_filterList.frame = CGRectMake(0, 0, self.bm_width, 0);
            [self layoutIfNeeded];
        }
        completion:^(BOOL finished) {
            self.m_filterView.hidden = YES;
            [self.m_filterList setContentOffset:CGPointZero animated:NO];
        }];
}
- (void)showFilterList
{
    NSString *leftImage = @"search_closeFilters", *rightImage = @"search_closeFilters";
    switch (_m_showList)
    {
        case FSSearchFilterShowList_None:
            return;
            break;

        case FSSearchFilterShowList_Left:
            self.m_filterArray = _m_leftFilters;
            leftImage = @"search_openFilters";
            break;
        case FSSearchFilterShowList_Right:
            self.m_filterArray = _m_rightFilters;
            rightImage = @"search_openFilters";
            break;
    }
    [_m_leftButton setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
    [_m_leftButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
    [_m_rightButton setImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
    [_m_rightButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
    [self freshListViewWithSelectTitle:_m_showList == FSSearchFilterShowList_Left?_m_leftTitle:_m_rightTitle];
    // animation
    CGFloat listHeight = self.bm_height - 250;
    self.m_filterView.hidden = NO;
    [UIView animateWithDuration:FILTER_ANIM_DUR
                     animations:^{
                         self.m_filterList.frame = CGRectMake(0, 0, self.bm_width, listHeight);
                         [self layoutIfNeeded];
                     }];
}
- (void)freshListViewWithSelectTitle:(NSString *)selectTitle
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
                                                                   isLeftfilter:weakSelf.m_filterArray == weakSelf.m_leftFilters];
                                                   [weakSelf hiddenFilterListWithIndex:-1];
                                               }];
    item0.cellStyle = UITableViewCellStyleDefault;
    item0.textFont = [UIFont systemFontOfSize:14.0f];
    item0.textColor = [selectTitle bm_isNotEmpty]?UI_COLOR_B1:UI_COLOR_BL1;
    item0.cellHeight = FILTER_ROW_HEIGHT;
    [self.m_section addItem:item0];

    if ([_m_filterArray bm_isNotEmpty])
    {
        for (int index = 0; index < _m_filterArray.count; index++)
        {
            NSString *itemTitle = _m_filterArray[index];
            BMTableViewItem *item = [BMTableViewItem itemWithTitle:itemTitle
                                                          subTitle:nil
                                                         imageName:nil
                                                 underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset
                                                     accessoryView:nil
                                                  selectionHandler:^(BMTableViewItem *item) {
                                                      [weakSelf selectedRowAtIndex:index
                                                                      isLeftfilter:weakSelf.m_filterArray == weakSelf.m_leftFilters];
                                                      [weakSelf hiddenFilterListWithIndex:index];
                                                  }];
            item.cellStyle = UITableViewCellStyleDefault;
            item.textFont = [UIFont systemFontOfSize:14.0f];
            item.textColor = [itemTitle isEqualToString:selectTitle]?UI_COLOR_BL1:UI_COLOR_B1;
            item.cellHeight = FILTER_ROW_HEIGHT;
            [self.m_section addItem:item];
        }
    }

    [_m_filterList reloadData];
}
- (void)removeResultVC
{
    self.m_leftButton.hidden = YES;
    self.m_rightButton.hidden = YES;
    self.m_leftTitle = nil;
    self.m_rightTitle = nil;
    [self removeFromSuperview];
    [self searchVC].isShowSearchResult = NO;
}
#pragma mark - TTGTag Delegate & DataSource
- (UIView *)tagViewWithTag:(NSString *)tag
{
    CGFloat width = [tag bm_widthToFitHeight:28 withFont:[UIFont systemFontOfSize:14.0f]] + 22.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 26, 28)];
    view.backgroundColor = FS_VIEW_BGCOLOR;
    [view bm_roundedRect:5];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 28.0f)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = UI_COLOR_B1;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = tag;
    [view addSubview:label];
    BMSingleLineView *vline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(view.bm_right - 28, 7, 2, 14) direction:SingleLineDirectionPortait];
    vline.lineColor = UI_COLOR_B6;
    [view addSubview:vline];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(view.bm_right - 28, 0, 28, 28)];
    [deleteButton setImage:[UIImage imageNamed:@"bmsearch_close"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = [self.m_searchKeys indexOfObject:tag];
    [view addSubview:deleteButton];
    return view;
}
- (void)deleteButtonAction:(UIButton *)deleteButton
{
    [self hiddenFilterListWithIndex:-1];
    [self keysRemoveKey:self.m_searchKeys[deleteButton.tag]];
    [self freshTagView];
}
- (void)cleanTags:(UIButton *)sender
{
    [self hiddenFilterListWithIndex:-1];
    [self cleanKeys];
    [self freshTagView];
}
- (void)freshTagView
{
    self.m_searchTagviews = [NSMutableArray array];
    _m_bgManager.m_BGTagviews = [NSMutableArray array];
    for (NSString *key in self.m_searchKeys)
    {
        [_m_searchTagviews addObject:[self tagViewWithTag:key]];
        [_m_bgManager.m_BGTagviews addObject:[self tagViewWithTag:key]];
    }
    [_m_tagCollectionView reload];

    [_m_BGtagCollectionView reload];
    _m_BGtagCollectionView.bm_height = _m_BGtagCollectionView.contentSize.height;
    _m_cleanTagsButton.bm_top = _m_BGtagCollectionView.bm_bottom +25;
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
