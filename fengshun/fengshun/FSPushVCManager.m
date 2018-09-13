//
//  FSVCShow.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSPushVCManager.h"
#import "FSWebViewController.h"
#import "FSCommunitySecVC.h"
#import "FSSendTopicVC.h"

#import "FSVideoMediateListVC.h"
#import "FSWebViewController.h"

#import "FSSearchViewController.h"

@implementation FSPushVCManager

+ (void)showCommunitySecVCPushVC:(UIViewController *)pushVC FourmId:(NSInteger)fourId
{
    FSCommunitySecVC *vc        = [[FSCommunitySecVC alloc] initWithFourmId:fourId];
    vc.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showPostDetailVCWithPushVC:(UIViewController *)pushVC url:(NSString *)url
{
    FSWebViewController *vc = [[FSWebViewController alloc] initWithTitle:@"" url:url];
    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showEditPostWithWithPushVC:(UIViewController *)pushVC callBack:(PushVCCallBack)callBack
{
    FSSendTopicVC *vc = [[FSSendTopicVC alloc] init];
    vc.sendPostsCallBack         = callBack;
    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showSendPostWithWithPushVC:(UIViewController *)pushVC callBack:(PushVCCallBack)callBack
{
    FSSendTopicVC *vc = [[FSSendTopicVC alloc] init];
    vc.sendPostsCallBack         = callBack;
    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title
{
    return [FSPushVCManager showWebView:pushVC url:url title:title animated:YES];
}

+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title animated:(BOOL)animated
{
    return [FSPushVCManager showWebView:pushVC url:url title:title showLoadingBar:YES loadingBarColor:nil animated:YES];
}

+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color animated:(BOOL)animated
{
    return [FSPushVCManager showWebView:pushVC url:url title:title showLoadingBar:YES loadingBarColor:nil delegate:nil animated:YES];
}

+ (FSWebViewController *)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color delegate:(id<FSWebViewControllerDelegate>)delegate animated:(BOOL)animated
{
    if (![url bm_isNotEmpty])
    {
        return nil;
    }
    
    FSWebViewController *vc = [[FSWebViewController alloc] initWithTitle:title url:url showLoadingBar:showLoadingBar loadingBarColor:color delegate:delegate];

    vc.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:vc animated:animated];
    
    return vc;
}

+ (void)homePage:(UIViewController *)mainVC pushToCaseSearchWithHotKeys:(NSArray *)hotKeys
{
    // 搜索热词做份缓存,以应对网络添加较差的情况
    if (!hotKeys) {
        hotKeys = [NSArray arrayWithContentsOfFile:SEARCH_CASEHOTKEY_CACHEFILE];
    }
    else
    {
        [hotKeys writeToFile:SEARCH_CASEHOTKEY_CACHEFILE atomically:NO];
    }
    FSSearchViewController *searchViewController = [[FSSearchViewController alloc] initWithSearchKey:@"caseSearch" resultType:FSSearchResultType_case hotSearchTags:hotKeys searchHandler:nil];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [mainVC.navigationController pushViewController:searchViewController animated:YES];
}
+ (void)homePage:(UIViewController *)mainVC pushToLawSearchWithTopics:(NSArray *)topics
{
    // 做个备份吧
    if (!topics) {
        topics = [NSArray arrayWithContentsOfFile:SEARCH_LAWTOPIC_CACHEFILE];
    }
    else
    {
        [topics writeToFile:SEARCH_LAWTOPIC_CACHEFILE atomically:NO];
    }
    FSSearchViewController *searchViewController = [[FSSearchViewController alloc] initWithSearchKey:@"lawsSearch" resultType:FSSearchResultType_laws hotSearchTags:topics searchHandler:nil];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [mainVC.navigationController pushViewController:searchViewController animated:YES];
}

+ (void)pushVideoMediateList:(UINavigationController *)nav;
{
    FSVideoMediateListVC *vc = [FSVideoMediateListVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
}

@end
