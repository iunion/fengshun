//
//  FSCourseHomePageVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCourseHomePageVC.h"
#import "FSWebView.h"
#import "AppDelegate.h"
#import "NSDictionary+BMCategory.h"

@interface FSCourseHomePageVC ()
<
    FSWebViewDelegate
>

@end

@implementation FSCourseHomePageVC

- (void)viewDidLoad
{
    self.m_ShowNavBack = NO;

    [super viewDidLoad];

    [self bm_setNavigationWithTitle:self.m_Title barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];
    [self setWebFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(FSWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *encodingUrlString = [self.m_UrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([request.URL.absoluteString isEqualToString:encodingUrlString])
    {
        return YES;
    }
    else
    {
        [FSPushVCManager showWebView:self url:request.URL.absoluteString title:nil];
        return NO;
    }
}

@end
