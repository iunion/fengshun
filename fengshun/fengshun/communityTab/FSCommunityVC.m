//
//  FSCommunityVC.m
//  fengshun
//
//  Created by Aiwei on 2018/8/27.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCommunityVC.h"
#import "MQScrollPageView.h"
#import "AppDelegate.h"

@interface FSCommunityVC ()
<MQScrollPageViewDelegate,MQScrollPageViewDataSource>

@property(nonatomic,strong)MQScrollPageSegment *m_SegmentBar;
@property(nonatomic,strong)MQScrollPageView *m_ScrollPageView;

@end

@implementation FSCommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ScrollPageView";
    [GetAppDelegate.tabBarController hideOriginTabBar];
    [self setupUI];
}
-(void)setupUI
{
    self.m_SegmentBar = [[MQScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44) titles:nil titleColor:nil selectTitleColor:nil showUnderLine:NO moveLineFrame:CGRectZero isEqualDivide:YES fresh:YES];
    [self.view addSubview:_m_SegmentBar];
    self.m_ScrollPageView = [[MQScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_TAB_BAR_HEIGHT-44) titleColor:[UIColor blackColor] selectTitleColor:[UIColor redColor] scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    [self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate = self;
    [self.m_ScrollPageView reloadPage];
    [self.m_ScrollPageView scrollPageWithIndex:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MQScrollPageView Delegate & DataSource
- (NSUInteger)scrollPageViewNumberOfPages:(MQScrollPageView *)scrollPageView
{
 
    return 3;
}

- (NSString *)scrollPageView:(MQScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index) {
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
-(id)scrollPageView:(MQScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_TAB_BAR_HEIGHT)];
    switch (index) {
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
