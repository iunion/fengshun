//
//  FSMessageTabVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMessageTabVC.h"

#import "BMScrollPageView.h"
#import "FSMessageListVC.h"


@interface FSMessageTabVC ()
<
    BMScrollPageViewDelegate,
    BMScrollPageViewDataSource
>

@property (nonatomic, strong) BMScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) BMScrollPageView *m_ScrollPageView;

@property (nonatomic, strong) FSMessageListVC *m_CommentMessageVC;
@property (nonatomic, strong) FSMessageListVC *m_NoticeMessageVC;

@end


@implementation FSMessageTabVC

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationShadowHidden   = NO;
    self.bm_NavigationShadowColor    = [UIColor bm_colorWithHex:0xD8D8D8];
    
    [self bm_setNavigationWithTitle:@"消息" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self setupUI];
}


#pragma mark - UI

- (void)setupUI
{
    // 切换视图
    self.self.m_SegmentBar = [[BMScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [self.view addSubview:_m_SegmentBar];
    self.m_SegmentBar.backgroundColor = [UIColor whiteColor];
    self.m_SegmentBar.showMore = NO;
    self.m_SegmentBar.equalDivide = YES;
    self.m_SegmentBar.moveLineColor = UI_COLOR_BL1;
    self.m_SegmentBar.showBottomLine = NO;
    self.m_SegmentBar.titleColor = UI_COLOR_B1;
    self.m_SegmentBar.titleSelectedColor = UI_COLOR_BL1;

    // 内容视图
    self.m_ScrollPageView = [[BMScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - 44)  withScrollPageSegment:self.m_SegmentBar];
    [self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate = self;
    
    [self.m_ScrollPageView reloadPages];
    [self.m_ScrollPageView scrollPageWithIndex:_m_showNotificationTab ? 1 : 0];
    
    if (self.navigationController.interactivePopGestureRecognizer)
    {
        [self.m_ScrollPageView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BMScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(BMScrollPageView *)scrollPageView
{
    return 2;
}

- (NSString *)scrollPageView:(BMScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return @"评论";
            break;
            
        case 1:
            return @"通知";
            break;
            
        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(BMScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        self.m_CommentMessageVC = [[FSMessageListVC alloc] initWithMessageType:FSMessageType_COMMENT];
        self.m_CommentMessageVC.m_PushVC = self;
        return self.m_CommentMessageVC.view;
    }
    else if (index == 1)
    {
        self.m_NoticeMessageVC = [[FSMessageListVC alloc] initWithMessageType:FSMessageType_NOTICE];
        self.m_NoticeMessageVC.m_PushVC = self;
        return self.m_NoticeMessageVC.view;
    }
    return nil;
}

@end
