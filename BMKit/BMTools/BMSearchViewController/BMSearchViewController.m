//
//  BMSearchViewController.m
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "BMSearchViewController.h"
#import "BMTableViewManager.h"
#import "TTGTagCollectionView.h"

#define SEARCH_HISTORY_MAXCACHECOUNT        4
#define SEARCH_HISTORY_CACHEFILE(searchKey) [[NSString bm_documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"searchhistory_%@.plist", searchKey]]

#define SearchBarGap            10.0f
#define SearchBarFont           [UIFont systemFontOfSize:12.0f]
#define SearchBarCornerRadius   6.0f

@interface BMSearchViewController ()
<
    UISearchBarDelegate,
    BMTableViewManagerDelegate,
    TTGTagCollectionViewDelegate,
    TTGTagCollectionViewDataSource
>

@property (nonatomic, strong) NSString *searchKey;

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITextField *searchTextField;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) TTGTagCollectionView *tagCollectionView;
@property (nonatomic, strong) NSMutableArray *hotTagArray;
@property (nonatomic, strong) NSMutableArray *tagViewArray;

@property (nonatomic, strong) UITableView *searchHistoriesTableView;
@property (nonatomic, strong) BMTableViewManager *manager;
@property (nonatomic, strong) BMTableViewSection *section;

@property (nonatomic, strong) NSMutableArray *searchHistories;

@end

@implementation BMSearchViewController

- (instancetype)initWithSearchKey:(NSString *)searchKey hotSearchTags:(NSArray *)hotSearchTags searchHandler:(searchViewSearchHandler)searchHandler
{
    self = [super init];
    if (self)
    {
        self.searchKey = searchKey;
        if ([hotSearchTags bm_isNotEmpty])
        {
            self.hotTagArray = [NSMutableArray arrayWithArray:hotSearchTags];
        }
        self.searchHandler = searchHandler;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showSearchHistory = YES;
    self.addHotTagSearchHistory = YES;
    
    [self makeSearchBar];

    [self makeSearchHistoriesView];

    [self makeHeaderTagView];
    
    [self freshItems];
}

- (void)backAction:(id)sender
{
    //if ([self shouldPopOnBackButton])
    {
        [self.view endEditing:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setSearchBarPplaceholder:(NSString *)searchBarPplaceholder
{
    self.searchBar.placeholder = searchBarPplaceholder;
}

- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor
{
    self.searchTextField.backgroundColor = searchBarBackgroundColor;
}

- (void)setSearchBarCornerRadius:(CGFloat)searchBarCornerRadius
{
    for (UIView *subView in self.searchTextField.subviews)
    {
        if ([NSStringFromClass([subView class]) isEqualToString:@"_UISearchBarSearchFieldBackgroundView"])
        {
            subView.layer.cornerRadius = searchBarCornerRadius;
            subView.clipsToBounds = YES;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeSearchBar
{
    self.bm_NavigationShadowHidden = YES;
    
    self.bm_NavigationItemTintColor = [UIColor whiteColor];
    UIView *searchBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
    searchBarBgView.backgroundColor = [UIColor clearColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0f, SearchBarGap, UI_SCREEN_WIDTH-20.0f, UI_NAVIGATION_BAR_HEIGHT-SearchBarGap*2)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [searchBarBgView addSubview:searchBar];
    searchBar.backgroundImage = [UIImage imageNamed:@"navigationbar_clearImage"];
    searchBar.delegate = self;
    searchBar.placeholder = @"查找";
    [self bm_setNavigationWithTitleView:searchBarBgView barTintColor:[UIColor redColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    self.searchTextField = (UITextField *)[searchBar bm_viewOfClass:[UITextField class]];
    self.searchTextField.font = SearchBarFont;
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchBarCornerRadius = SearchBarCornerRadius;
}

- (void)makeSearchHistoriesView
{
    self.searchHistoriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    self.searchHistoriesTableView.backgroundColor = [UIColor clearColor];
    self.searchHistoriesTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchHistoriesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchHistoriesTableView];

    self.manager = [[BMTableViewManager alloc] initWithTableView:self.searchHistoriesTableView];
    self.manager.delegate = self;
    BMTableViewSection *section = [BMTableViewSection section];
    [self.manager addSection:section];
    self.section = section;
    
    self.searchHistories = [NSMutableArray arrayWithArray:[self getSearchHistory]];
}

- (void)makeTagViewArray
{
    self.tagViewArray = [NSMutableArray arrayWithCapacity:0];

//    NSArray *tags = @[@"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索", @"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索"];
//    self.hotTagArray = [NSMutableArray arrayWithArray:tags];
    for (NSString *tag in self.hotTagArray)
    {
        CGFloat width = [tag bm_widthToFitHeight:20 withFont:[UIFont systemFontOfSize:10.0f]] + 12.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 26.0f)];
        label.backgroundColor = [UIColor bm_colorWithHex:0xF0F0F0];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = tag;
        [label bm_roundedRect:4.0f];
        [self.tagViewArray addObject:label];
    }
}

- (void)makeHeaderTagView
{
    [self makeTagViewArray];
    
    if (![self.tagViewArray bm_isNotEmpty])
    {
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor clearColor];
    self.headerView = view;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, UI_SCREEN_WIDTH, 20)];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor bm_colorWithHex:0x666666];
    label.text = @"热门搜索";
    [view addSubview:label];
    
    TTGTagCollectionView *tagCollectionView = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(15, 36, UI_SCREEN_WIDTH-30, 60.0f)];
    tagCollectionView.delegate = self;
    tagCollectionView.dataSource = self;
    tagCollectionView.horizontalSpacing = 12.0f;
    tagCollectionView.verticalSpacing = 6.0f;
    tagCollectionView.bm_height = tagCollectionView.contentSize.height;
    [view addSubview:tagCollectionView];
    view.bm_height = tagCollectionView.bm_bottom + 4.0f;
    self.tagCollectionView = tagCollectionView;
    
    self.searchHistoriesTableView.tableHeaderView = self.headerView;
    [self.tagCollectionView reload];
}

- (NSArray *)getSearchHistory
{
    NSString *plistPath = SEARCH_HISTORY_CACHEFILE(self.searchKey);
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    
    return array;
}

- (void)saveSearchHistory
{
    NSString *plistPath = SEARCH_HISTORY_CACHEFILE(self.searchKey);
    [self.searchHistories writeToFile:plistPath atomically:NO];
}

- (void)addSearchHistory:(NSString *)search
{
    if ([search bm_isNotEmpty])
    {
        [self.searchHistories removeObject:search];
        [self.searchHistories insertObject:search atIndex:0];
        
        if (self.searchHistories.count > SEARCH_HISTORY_MAXCACHECOUNT)
        {
            [self.searchHistories removeLastObject];
        }
        
        [self saveSearchHistory];
        
        [self freshItems];
    }
}

- (void)deleteSearchHistory:(UIButton *)btn
{
    NSLog(@"deleteSearchHistory");
    
    if (btn.tag < self.searchHistories.count)
    {
        NSString *search = [self.searchHistories objectAtIndex:btn.tag];
        [self.searchHistories removeObject:search];
        [self saveSearchHistory];

        [self freshItems];
    }
}

- (void)removeAllSearchHistory
{
    [self.searchHistories removeAllObjects];
    [self saveSearchHistory];
    
    [self freshItems];
}

- (void)freshItems
{
    [self.section removeAllItems];
    
    if (!self.showSearchHistory || ![self.searchHistories bm_isNotEmpty])
    {
        [self.searchHistoriesTableView reloadData];
        return;
    }
    
    BMTableViewItem *item0 = [BMTableViewItem itemWithTitle:@"搜索历史" subTitle:nil imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:nil selectionHandler:nil];
    [self.section addItem:item0];
    item0.cellStyle = UITableViewCellStyleDefault;
    item0.textFont = [UIFont systemFontOfSize:12.0f];
    item0.cellHeight = 40.0f;
    item0.enabled = NO;
    
    // 这儿容易造成循环引用
    BMWeakSelf
    for (NSUInteger index = 0; index < self.searchHistories.count; index++)
    {
        NSString *search = self.searchHistories[index];
        UIButton *deleteBtn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, 30, 30) imageName:@"bmsearch_close"];
        deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        deleteBtn.tag = index;
        deleteBtn.exclusiveTouch = YES;
        [deleteBtn addTarget:self action:@selector(deleteSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        BMTableViewItem *item = [BMTableViewItem itemWithTitle:search subTitle:nil imageName:@"bmsearch_history" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset accessoryView:deleteBtn selectionHandler:^(BMTableViewItem *item) {
            if (weakSelf.searchHandler)
            {
                weakSelf.searchHandler(item.title);
            }
        }];
        [self.section addItem:item];
        item.cellStyle = UITableViewCellStyleDefault;
        item.imageH = 16.0f;
        item.imageW = 16.0f;
        item.textFont = [UIFont systemFontOfSize:12.0f];
        item.cellHeight = 36.0f;
    }
   
    BMTableViewItem *item1 = [BMTableViewItem itemWithTitle:@"清空搜索历史" subTitle:nil imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:nil selectionHandler:^(BMTableViewItem *item) {
        [weakSelf removeAllSearchHistory];
    }];
    [self.section addItem:item1];
    item1.cellStyle = UITableViewCellStyleDefault;
    item1.textFont = [UIFont systemFontOfSize:12.0f];
    item1.textAlignment = NSTextAlignmentCenter;
    item1.cellHeight = 50.0f;
    item1.isShowHighlightBg = NO;
    
    [self.searchHistoriesTableView reloadData];
}


#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index
{
    UIView *view = self.tagViewArray[index];
    return view.frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index
{
    //_logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld", tagView.class, (long) index];
    NSLog(@"Tap tag: %@, at: %ld", tagView.class, (long)index);
    
    UILabel *label = (UILabel *)tagView;
    if (self.addHotTagSearchHistory)
    {
        [self addSearchHistory:label.text];
    }
    
    if (self.searchHandler)
    {
        self.searchHandler(label.text);
    }
}


#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView
{
    return self.tagViewArray.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index
{
    return self.tagViewArray[index];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *search = [searchBar.text bm_trim];
    
    if ([search bm_isNotEmpty])
    {
        searchBar.text = search;
        [self addSearchHistory:search];
        
        if (self.searchHandler)
        {
            self.searchHandler(search);
        }
    }
}

@end
