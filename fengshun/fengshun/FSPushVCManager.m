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
#import "FSSendPostViewController.h"

@implementation FSPushVCManager

+ (void)showCommunitySecVCPushVC:(UIViewController *)pushVC
{
    FSCommunitySecVC *vc        = [[FSCommunitySecVC alloc] init];
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
    FSSendPostViewController *vc = [[FSSendPostViewController alloc] init];
    vc.sendPostsCallBack         = callBack;
    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showSendPostWithWithPushVC:(UIViewController *)pushVC callBack:(PushVCCallBack)callBack
{
    FSSendPostViewController *vc = [[FSSendPostViewController alloc] init];
    vc.sendPostsCallBack         = callBack;
    [pushVC.navigationController pushViewController:vc animated:YES];
}


@end
