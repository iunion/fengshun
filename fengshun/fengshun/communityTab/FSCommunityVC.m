//
//  FSCommunityVC.m
//  fengshun
//
//  Created by Aiwei on 2018/8/27.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCommunityVC.h"
#import "FSScrollPageView.h"
#import "AppDelegate.h"

@interface
FSCommunityVC () <
    FSScrollPageViewDelegate,
    FSScrollPageViewDataSource>

@property (nonatomic, strong) FSScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *m_ScrollPageView;

@end

@implementation FSCommunityVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"ScrollPageView";
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    [self setupUI];
}

- (void)setupUI
{
    self.m_SegmentBar = [[FSScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44) titles:nil titleColor:nil selectTitleColor:nil showUnderLine:NO moveLineFrame:CGRectZero isEqualDivide:YES fresh:YES];
    [self.view addSubview:_m_SegmentBar];

    self.m_ScrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 44) titleColor:[UIColor blackColor] selectTitleColor:[UIColor redColor] scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    [self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate = self;
    [self.m_ScrollPageView reloadPage];
    [self.m_ScrollPageView scrollPageWithIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FSScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return 3;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return @"红";
            break;
        case 1:
            return @"黄";
            break;
        case 2:
            return @"蓝";
            break;

        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT)];
    switch (index)
    {
        case 0:
            view.backgroundColor = [UIColor redColor];
            break;

        case 1:
            view.backgroundColor = [UIColor yellowColor];
            break;

        case 2:
            view.backgroundColor = [UIColor blueColor];
            break;
    }

    return view;
}
@end
