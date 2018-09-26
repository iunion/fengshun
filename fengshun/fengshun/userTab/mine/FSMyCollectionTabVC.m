//
//  FSMyCollectionTabVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionTabVC.h"
#import "FSScrollPageView.h"

#import "FSMyCollectionVC.h"


@interface FSMyCollectionTabVC ()
<
    FSScrollPageViewDelegate,
    FSScrollPageViewDataSource
>

@property (nonatomic, strong) FSScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *m_ScrollPageView;

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
    self.bm_NavigationShadowColor    = [UIColor bm_colorWithHexString:@"D8D8D8"];
    
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
    self.m_SegmentBar = [[FSScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44) titles:nil titleColor:nil selectTitleColor:nil showUnderLine:NO moveLineFrame:CGRectZero isEqualDivide:YES fresh:YES];
    [self.view addSubview:_m_SegmentBar];
    self.m_SegmentBar.backgroundColor = [UIColor whiteColor];
    
    // 内容视图
    self.m_ScrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 44) titleColor:UI_COLOR_B1 selectTitleColor:UI_COLOR_BL1 scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    [self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate = self;
    [self.m_ScrollPageView setM_MoveLineColor:UI_COLOR_BL1];
    [self.m_ScrollPageView reloadPage];
    [self.m_ScrollPageView scrollPageWithIndex:0];
}


#pragma mark - FSScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return 4;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return @"帖子";
            break;
            
        case 1:
            return @"法规";
            break;
            
        case 2:
            return @"案例";
            break;
            
        case 3:
            return @"文书范本";
            break;
            
        case 4:
            return @"课程";
            break;
            
        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            self.m_TopicCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_POSTS];
            return self.m_TopicCollectVC.view;
            break;
            
        case 1:
            self.m_StatuteCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_STATUTE];
            return self.m_StatuteCollectVC.view;
            break;

        case 2:
            self.m_CaseCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_CASE];
            return self.m_CaseCollectVC.view;
            break;
            
        case 3:
            self.m_DocumentCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_DOCUMENT];
            return self.m_DocumentCollectVC.view;
            break;
            
        case 4:
            self.m_CourseCollectVC = [[FSMyCollectionVC alloc] initWithCollectionType:FSCollectionType_COURSE];
            return self.m_CourseCollectVC.view;
            break;
            
        default:
            return nil;
    }
}

@end
