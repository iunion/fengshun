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
#import "FSPageBannerView.h"

#import "BMVerifyField.h"

@interface FSMainVC ()
<
    FSBannerViewDelegate
>

@property (nonatomic, strong) FSPageBannerView *m_bannerView;

@end

@implementation FSMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"test";
    [GetAppDelegate.m_TabBarController hideOriginTabBar];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, 80, 40)];
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
    
    BMVerifyField *verifyField = [[BMVerifyField alloc] initWithFrame:CGRectMake(40, 200, UI_SCREEN_WIDTH-80, 40)];
    [self.view addSubview:verifyField];

    [self configBanner];
}

- (void)configBanner
{
    NSArray *dataArray = @[
        @"http://pic01.babytreeimg.com/foto3/photos/2014/0211/68/2/4170109a41ca935610bf8_b.png",
        @"http://pic01.babytreeimg.com/foto3/photos/2014/0127/19/9/4170109a267ca641c41ebb_b.png",
        @"http://pic02.babytreeimg.com/foto3/photos/2014/0207/59/4/4170109a17eca86465f8a4_b.jpg",
    ];
    self.m_bannerView = [[FSPageBannerView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 140) scrollDirection:FSBannerViewScrollDirectionLandscape images:dataArray pageWidth:UI_SCREEN_WIDTH - 80.0f padding:0 rollingScale:YES];
    [_m_bannerView setDelegate:self];
    [_m_bannerView setPageControlStyle:FSBannerViewPageStyle_Middle];
    _m_bannerView.showClose = NO;
    [_m_bannerView setCorner:8.0f];
    _m_bannerView.rollingDelayTime = 3.0;
    [self.view addSubview:_m_bannerView];
    [_m_bannerView startRolling];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)next:(id)sender
{
    FSSearchViewController *searchViewController = [[FSSearchViewController alloc] initWithSearchKey:@"test"
                                                                                       hotSearchTags:@[ @"1", @"2" ]
                                                                                       searchHandler:^(NSString *search) {
                                                                                           NSLog(@"search");
                                                                                       }];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


@end
