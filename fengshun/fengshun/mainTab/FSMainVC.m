//
//  FSMainVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMainVC.h"
#import "AppDelegate.h"
#import "FSSearchViewController.h"
#import "FSMainHeaderView.h"
#import "FSCourseTableCell.h"

#import "FSApiRequest+HomePage.h"


@interface
FSMainVC ()
<
    FSBannerViewDelegate,
    FSMainHeaderDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FSMainHeaderView *m_headerView;

@end

@implementation FSMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    [self setupUI];
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSCourseTableCell" bundle:nil] forCellReuseIdentifier:@"FSCourseTableCell"];
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [FSApiRequest getHomeDataSuccess:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}
- (void)setupUI
{
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    [self bm_setNavigationWithTitle:@"主页" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:[UIImage imageNamed:@"navigationbar_message_icon.png"] rightToucheEvent:@selector(popMessageVC:)];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    self.edgesForExtendedLayout                   = UIRectEdgeTop;
    self.m_TableView.showsVerticalScrollIndicator = NO;
    self.m_TableView.frame                        = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT);
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self setBm_NavigationBarAlpha:0];
    self.m_headerView = [[FSMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 261.0 / 667 * UI_SCREEN_HEIGHT + 391) andDelegate:self];
    BMLog(@"+++++++++screen width:%f,screen height:%f", UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    self.m_TableView.tableHeaderView = _m_headerView;
    NSArray *dataArray               = @[
        @"http://pic01.babytreeimg.com/foto3/photos/2014/0211/68/2/4170109a41ca935610bf8_b.png",
        @"http://pic01.babytreeimg.com/foto3/photos/2014/0127/19/9/4170109a267ca641c41ebb_b.png",
        @"http://pic02.babytreeimg.com/foto3/photos/2014/0207/59/4/4170109a17eca86465f8a4_b.jpg",
    ];
    [_m_headerView reloadBannerWithUrlArray:dataArray];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - banner,header,scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY   = scrollView.contentOffset.y;
    CGFloat maxOffset = (261.0 / 667 * UI_SCREEN_HEIGHT - 97) / 2;
    if (offsetY <= 0)
    {
        self.bm_NavigationBarAlpha = 0;
        [self bm_setNeedsUpdateNavigationBarAlpha];
    }
    else if (offsetY >= maxOffset)
    {
        self.bm_NavigationBarAlpha = 1.0;
        [self bm_setNeedsUpdateNavigationBarAlpha];
    }
    else
    {
        self.bm_NavigationBarAlpha = offsetY / maxOffset;
        [self bm_setNeedsUpdateNavigationBarAlpha];
    }
}
- (void)bannerView:(UIView *)bannerView didScrollToIndex:(NSUInteger)index
{
    _m_headerView.m_pageControl.currentPage = index;
}
- (void)headerButtonClikedAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            // 视频调解
            break;

        case 6:
            // 智能咨询

            break;
    }
}
-(void)popMessageVC:(id)sender
{
    
}
#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COURSE_CELL_HEGHT;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSCourseTableCell"];
    
    return cell;
}
@end
