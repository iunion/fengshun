//
//  FSMyCollectionTabVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionTabVC.h"
#import "BMScrollPageView.h"

#import "FSMyCollectionVC.h"


@interface FSMyCollectionTabVC ()
<
    BMScrollPageViewDelegate,
    BMScrollPageViewDataSource
>

@property (nonatomic, strong) BMScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) BMScrollPageView *m_ScrollPageView;

// 帖子
@property (nonatomic, strong) FSMyCollectionVC *m_TopicCollectVC;
// 法规
@property (nonatomic, strong) FSMyCollectionVC *m_StatuteCollectVC;
// 案例
@property (nonatomic, strong) FSMyCollectionVC *m_CaseCollectVC;
// 文书范本
@property (nonatomic, strong) FSMyCollectionVC *m_DocumentCollectVC;
// 课程
@property (nonatomic, strong) FSMyCollectionVC *m_CourseCollectVC;
// 专栏
@property (nonatomic, strong) FSMyCollectionVC *m_ColumnCollectVC;


@end

@implementation FSMyCollectionTabVC

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bm_NavigationShadowHidden   = NO;
    self.bm_NavigationShadowColor    = [UIColor bm_colorWithHex:0xD8D8D8];
    
    [self bm_setNavigationWithTitle:@"我的收藏" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)setupUI
{
    // 切换视图
    self.m_SegmentBar = [[BMScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [self.view addSubview:self.m_SegmentBar];
    self.m_SegmentBar.backgroundColor = [UIColor whiteColor];
    self.m_SegmentBar.showMore = NO;
    self.m_SegmentBar.equalDivide = YES;
    self.m_SegmentBar.moveLineColor = UI_COLOR_BL1;
    self.m_SegmentBar.showBottomLine = NO;
    self.m_SegmentBar.showGapLine = NO;
    self.m_SegmentBar.titleColor = UI_COLOR_B1;
    self.m_SegmentBar.titleSelectedColor = UI_COLOR_BL1;

    // 内容视图
    self.m_ScrollPageView = [[BMScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - 44)  withScrollPageSegment:self.m_SegmentBar];
    [self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate = self;

    [self.m_ScrollPageView reloadPages];
    [self.m_ScrollPageView scrollPageWithIndex:0];
    
    if (self.navigationController.interactivePopGestureRecognizer)
    {
        [self.m_ScrollPageView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    
    if (IS_IPHONE4 || IS_IPHONE5)
    {
        self.m_SegmentBar.titleFont = [UIFont systemFontOfSize:14.0f];
    }
}


#pragma mark - BMScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(BMScrollPageView *)scrollPageView
{
    return 6;
}

- (NSString *)scrollPageView:(BMScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 4:
            return @"帖子";
            break;
            
        case 0:
            return @"法规";
            break;
            
        case 1:
            return @"案例";
            break;
            
        case 3:
            return @"文书";
            break;
            
        case 2:
            return @"课程";
            break;
        case 5:
            return @"专栏";
            break;
        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(BMScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 4:
            self.m_TopicCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_POSTS];
            self.m_TopicCollectVC.m_PushVC = self;
            return self.m_TopicCollectVC.view;
            
        case 0:
            self.m_StatuteCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_STATUTE];
            self.m_StatuteCollectVC.m_PushVC = self;
            return self.m_StatuteCollectVC.view;

        case 1:
            self.m_CaseCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_CASE];
            self.m_CaseCollectVC.m_PushVC = self;
            return self.m_CaseCollectVC.view;
            
        case 3:
            self.m_DocumentCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_DOCUMENT];
            self.m_DocumentCollectVC.m_PushVC = self;
            return self.m_DocumentCollectVC.view;
            
        case 2:
            self.m_CourseCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_COURSE];
            self.m_CourseCollectVC.m_PushVC = self;
            return self.m_CourseCollectVC.view;
        case 5:
            self.m_ColumnCollectVC = [[FSMyCollectionVC alloc]initWithCollectionType:FSCollectionType_COLUMN];
            self.m_ColumnCollectVC.m_PushVC = self;
            return self.m_ColumnCollectVC.view;
        default:
            return nil;
    }
}

@end
