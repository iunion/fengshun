//
//  FSSearchViewController.m
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSearchViewController.h"
#import "BMTableViewManager.h"
#import "TTGTagCollectionView.h"
#import "FSCaseSearchResultView.h"
#import "FSLawSearchResultView.h"
#import "FSTextSearchResultView.h"

#define SEARCH_HISTORY_MAXCACHECOUNT        10

#define SearchBarGap            5.0f
#define SearchBarFont           [UIFont systemFontOfSize:16.0f]
#define SearchBarCornerRadius   5.0f
#define OCRSearchButtonBottonGap 50.0f

@interface FSSearchViewController ()
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
@property (nonatomic, strong) FSSearchResultView *resultView;

@property (nonatomic, assign) FSSearchResultType resultType;

@property (nonatomic, strong) UIButton *m_OCRButton;

@end

@implementation FSSearchViewController

#pragma mark - init&懒加载
- (instancetype)initWithSearchKey:(NSString *)searchKey resultType:(FSSearchResultType)resultType hotSearchTags:(NSArray *)hotSearchTags searchHandler:(searchViewSearchHandler)searchHandler
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
        _resultType = resultType;
    }
    return self;
}
- (FSSearchResultView *)resultView
{
    if (!_resultView) {
        switch (_resultType) {
            case FSSearchResultType_laws:
                _resultView = [[FSLawSearchResultView alloc]initWithFrame:self.view.bounds];
                break;
            case FSSearchResultType_case:
                _resultView = [[FSCaseSearchResultView alloc] initWithFrame:self.view.bounds];
                break;
            case FSSearchResultType_text:
                _resultView = [[FSTextSearchResultView alloc] initWithFrame:self.view.bounds];
                break;
        }
        _resultView.m_masterVC = self;
        _resultView.hidden     = YES;
    }
    return _resultView;
}
#pragma mark - view&UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showSearchHistory = YES;
    self.addHotTagSearchHistory = YES;
    
    [self makeSearchBar];

    [self makeSearchHistoriesView];

    [self moreUISetup];
    
    [self freshItems];
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
    UIView *searchBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
    searchBarBgView.backgroundColor = [UIColor clearColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(18.0f, SearchBarGap, UI_SCREEN_WIDTH-36.0f, UI_NAVIGATION_BAR_HEIGHT-SearchBarGap*2)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [searchBarBgView addSubview:searchBar];
    searchBar.backgroundImage = [UIImage imageNamed:@"navigationbar_clearImage"];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入关键字";
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitleView:searchBarBgView barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:@"取消" rightItemImage:nil rightToucheEvent:@selector(cancelSearch:)];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    self.searchTextField = (UITextField *)[searchBar bm_viewOfClass:[UITextField class]];
    self.searchTextField.font = SearchBarFont;
    self.searchTextField.backgroundColor = FS_VIEW_BGCOLOR;
    self.searchBarCornerRadius = SearchBarCornerRadius;
}

- (void)makeSearchHistoriesView
{
    self.searchHistoriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    self.searchHistoriesTableView.backgroundColor = [UIColor whiteColor];
    self.searchHistoriesTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchHistoriesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchHistoriesTableView];

    self.manager = [[BMTableViewManager alloc] initWithTableView:self.searchHistoriesTableView];
    self.manager.delegate = self;
    BMTableViewSection *section = [BMTableViewSection section];
    section.footerHeight = 0;
    [self.manager addSection:section];
    self.section = section;
    
    self.searchHistories = [NSMutableArray arrayWithArray:[FSUserInfoDB getSearchHistoryWithUserId:[FSUserInfoModel userInfo].m_UserBaseInfo.m_UserId key:self.searchKey]];
}
- (void)moreUISetup
{
    if (_resultType)
    {
        [self makeHeaderTagView];
        self.m_OCRButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 135, 40)];
        [_m_OCRButton bm_roundedRect:20];
        _m_OCRButton.backgroundColor = UI_COLOR_BL1;
        _m_OCRButton.bm_centerX      = self.view.bm_centerX;
    
        _m_OCRButton.layer.masksToBounds = NO;
        _m_OCRButton.layer.shadowOffset = CGSizeMake(0, 5);//阴影的偏移量
        _m_OCRButton.layer.shadowRadius = 10;
        _m_OCRButton.layer.shadowOpacity = 0.9;                        //阴影的不透明度
        _m_OCRButton.layer.shadowColor = [_m_OCRButton backgroundColor].CGColor;
//        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_m_OCRButton.bounds cornerRadius:20];
        //阴影路径
//        _m_OCRButton.layer.shadowPath = path.CGPath;

        
        CGFloat viewHeight           = UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT;
        _m_OCRButton.bm_bottom       = viewHeight - OCRSearchButtonBottonGap;
        [self.view addSubview:_m_OCRButton];
        UIImageView *buttonTag = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11.5f, 20, 17)];
        buttonTag.image        = [UIImage imageNamed:@"scanfile_camera"];
        [_m_OCRButton addSubview:buttonTag];
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(buttonTag.bm_right + 10, 10, 0.5, 20)];
        line.backgroundColor = [UIColor whiteColor];
        [_m_OCRButton addSubview:line];
        UILabel *label   = [[UILabel alloc] initWithFrame:CGRectMake(line.bm_right + 9, 0, _m_OCRButton.bm_width - line.bm_right - 9, 20)];
        label.bm_centerY = buttonTag.bm_centerY;
        label.font       = [UIFont boldSystemFontOfSize:16];
        label.textColor  = [UIColor whiteColor];
        label.text       = @"拍照识别";
        [_m_OCRButton addSubview:label];
        [_m_OCRButton addTarget:self action:@selector(pushToOCRSearchVC) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}
#pragma mark - OCR Search
- (void)pushToOCRSearchVC
{
    if (_resultType == FSSearchResultType_case) {
        [FSPushVCManager searchVCPushtToCaseOCrSearchVC:self];
    }
    else if (_resultType == FSSearchResultType_laws)
    {
        [FSPushVCManager searchVCPushtToLawsOCrSearchVC:self];
    }
}
#pragma mark - keyboard notification
- (void)keyBoardWillShow:(NSNotification *)sender
{
    if (_isShowSearchResult) {
        [self.view bringSubviewToFront:_m_OCRButton];
        [self.resultView showSecondView:YES];
    }
    NSValue *value      = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoarFrame = [value CGRectValue];
    CGFloat viewHeight  = UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT;
    [UIView animateWithDuration:[sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.m_OCRButton.bm_bottom = viewHeight - keyBoarFrame.size.height - OCRSearchButtonBottonGap +5;
    }];
    
}
-(void)keyBoardWillHide:(NSNotification *)sender
{
    
     CGFloat viewHeight  = UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT;
    [UIView animateWithDuration:[sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
         self.m_OCRButton.bm_bottom = viewHeight - OCRSearchButtonBottonGap;
    } completion:^(BOOL finished) {
        if (_isShowSearchResult) {
            [self.view bringSubviewToFront:self.resultView];
            [self.resultView showSecondView:NO];
        }
    }];
}
- (void)dealloc
{
    if (_resultType) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}
- (void)makeTagViewArray
{
    self.tagViewArray = [NSMutableArray arrayWithCapacity:0];

//    NSArray *tags = @[@"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索", @"热门", @"热门搜索", @"热门搜", @"热门搜1", @"热门134索"];
//    self.hotTagArray = [NSMutableArray arrayWithArray:tags];
    if (_resultType == FSSearchResultType_case) {
        for (NSString *tag in self.hotTagArray)
        {
            CGFloat width = (UI_SCREEN_WIDTH-5*10)/4;
//            CGFloat width = [tag bm_widthToFitHeight:20 withFont:[UIFont systemFontOfSize:14.0f]] + 24.0f;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 28.0f)];
            label.backgroundColor = FS_VIEW_BGCOLOR;
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = UI_COLOR_B1;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = tag;
            [label bm_roundedRect:14.0f];
            [self.tagViewArray addObject:label];
        }
    }
    else if (_resultType == FSSearchResultType_laws)
    {
        for (NSDictionary *lawTopicInfo in self.hotTagArray)
        {
//            CGSize  itemSize = CGSizeMake(80, 66);
            CGSize  itemSize = CGSizeMake((UI_SCREEN_WIDTH-5*10)/4, 57);
            UIView *view     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
            UIImageView *iv  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
            iv.image         = [UIImage imageNamed:[lawTopicInfo bm_stringForKey:@"iconName"]];
            [view addSubview:iv];
            iv.bm_centerX       = itemSize.width / 2;
            UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, itemSize.height - 14, itemSize.width, 14)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font          = [UIFont systemFontOfSize:14];
            label.textColor     = UI_COLOR_B1;
            label.text          = [lawTopicInfo bm_stringForKey:@"name"];
            [view addSubview:label];
            [self.tagViewArray addObject:view];
            
        }
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
    view.backgroundColor = [UIColor whiteColor];
    self.headerView      = view;

    CGFloat topGap = (_resultType == FSSearchResultType_case)?27:20;
    if (_resultType == FSSearchResultType_case)
    {
        CGFloat labelHeight = 30.0f;
        UIImageView *hotTag = [[UIImageView alloc] initWithFrame:CGRectMake(15, topGap / 2, 11, labelHeight)];
        hotTag.contentMode  = UIViewContentModeLeft;
        hotTag.image        = [UIImage imageNamed:@"search_hotKey"];
        [view addSubview:hotTag];

        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(37, topGap / 2, UI_SCREEN_WIDTH - 37, labelHeight)];
        label.font      = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.text = @"热门关键词";
        [view addSubview:label];
        topGap += labelHeight - 11;
    }
  
    TTGTagCollectionView *tagCollectionView = [[TTGTagCollectionView alloc] initWithFrame:CGRectMake(12, topGap, UI_SCREEN_WIDTH-24, 60.0f)];
    tagCollectionView.delegate = self;
    tagCollectionView.dataSource = self;
    tagCollectionView.horizontalSpacing = 7.0f;
    tagCollectionView.verticalSpacing = (_resultType == FSSearchResultType_case)?10.0f:20.0f;
    tagCollectionView.bm_height = tagCollectionView.contentSize.height;
    [view addSubview:tagCollectionView];
    view.bm_height = tagCollectionView.bm_bottom + 20.0f;
    self.tagCollectionView = tagCollectionView;
    
    self.searchHistoriesTableView.tableHeaderView = self.headerView;
    [self.tagCollectionView reload];
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
        
        [FSUserInfoDB saveSearchHistoryWithUserId:[FSUserInfoModel userInfo].m_UserBaseInfo.m_UserId key:self.searchKey searchHistories:self.searchHistories];
        
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
        [FSUserInfoDB saveSearchHistoryWithUserId:[FSUserInfoModel userInfo].m_UserBaseInfo.m_UserId key:self.searchKey searchHistories:self.searchHistories];

        [self freshItems];
    }
}

- (void)removeAllSearchHistory
{
    [self.searchHistories removeAllObjects];
    [FSUserInfoDB saveSearchHistoryWithUserId:[FSUserInfoModel userInfo].m_UserBaseInfo.m_UserId key:self.searchKey searchHistories:self.searchHistories];

    [self freshItems];
}

- (void)freshItems
{
    [self.section removeAllItems];
    if (_resultType &&[self.searchHistories bm_isNotEmpty]) {
        self.section.headerHeight = 11.0f;
    }
    else
    {
        self.section.headerHeight = 0;
    }
    if (!self.showSearchHistory || ![self.searchHistories bm_isNotEmpty])
    {
        [self.searchHistoriesTableView reloadData];
        return;
    }
    
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [clearButton setImage:[UIImage imageNamed:@"search_delKey"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(removeAllSearchHistory) forControlEvents:UIControlEventTouchUpInside];

    BMTableViewItem *item0 = [BMTableViewItem itemWithTitle:@"搜索记录" subTitle:nil imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorInset accessoryView:clearButton selectionHandler:nil];
    [self.section addItem:item0];
    item0.cellStyle = UITableViewCellStyleDefault;
    item0.textFont = [UIFont systemFontOfSize:12.0f];
    item0.textColor = UI_COLOR_B4;
    item0.cellHeight = 40.0f;
    item0.highlightBgColor = [UIColor clearColor];
    item0.underLineDrawType=BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset;
    
    // 这儿有循环引用的问题
    BMWeakSelf
    for (NSUInteger index = 0; index < self.searchHistories.count; index++)
    {
        NSString *search = self.searchHistories[index];
        UIButton *deleteBtn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, 30, 30) imageName:@"bmsearch_close"];
        deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        deleteBtn.tag = index;
        deleteBtn.exclusiveTouch = YES;
        [deleteBtn addTarget:self action:@selector(deleteSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        BMTableViewItem *item = [BMTableViewItem itemWithTitle:search subTitle:nil imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset accessoryView:deleteBtn selectionHandler:^(BMTableViewItem *item) {
            [weakSelf searchWithKey:search];
        }];
        [self.section addItem:item];
        item.cellStyle = UITableViewCellStyleDefault;
        item.textFont = [UIFont systemFontOfSize:14.0f];
        item.textColor = UI_COLOR_B1;
        item.cellHeight = 48.0f;
    }
    
//    BMTableViewItem *item1 = [BMTableViewItem itemWithTitle:@"清空搜索历史" subTitle:nil imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:nil selectionHandler:^(BMTableViewItem *item) {
//        BMStrongSelf
//        [self removeAllSearchHistory];
//    }];
//    [self.section addItem:item1];
//    item1.cellStyle = UITableViewCellStyleDefault;
//    item1.textFont = [UIFont systemFontOfSize:12.0f];
//    item1.textAlignment = NSTextAlignmentCenter;
//    item1.cellHeight = 50.0f;
//    item1.isShowHighlightBg = NO;
    
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
    if (_resultType == FSSearchResultType_laws)
    {
        NSDictionary *info = self.hotTagArray[index];
        [FSPushVCManager viewController:self pushToLawTopicVCWithLawTopic:[info bm_stringForKey:@"name"]];
    }
    else
    {
        NSString *tag = self.hotTagArray[index];
        [self searchWithKey:tag];
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

- (void)cancelSearch:(id)sender
{
    [_searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchWithKey:searchBar.text];
    if ([searchBar.text bm_isNotEmpty]) searchBar.text = [searchBar.text bm_trim];
    
}
- (void)searchWithKey:(NSString *)searchKey
{
    NSString *search = [searchKey bm_trim];
//    [_searchTextField resignFirstResponder];
    if ([search bm_isNotEmpty])
    {
        _searchTextField.text = search;
        [self addSearchHistory:search];
        
        if(!self.resultView.superview)
        {
            [self.view addSubview:self.resultView];
            self.isShowSearchResult = YES;
            [self.resultView showSecondView:NO];
        }
        [self.resultView searchWithKey:search];
        self.resultView.hidden = NO;

        if (self.searchHandler) self.searchHandler(search);
    }
}


@end
