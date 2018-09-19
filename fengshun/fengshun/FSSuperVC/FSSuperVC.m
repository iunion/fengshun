//
//  FSSuperVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"
#import "AppDelegate.h"
#import "FSLoginVC.h"
#import "FSAuthenticationVC.h"

@interface FSSuperVC ()
<
    FSAuthenticationDelegate,
    FSLoginDelegate
>

@end

@implementation FSSuperVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IOS_VERSION >= 7.0f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    // 隐藏系统的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
//    temporaryBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = FS_NAVIGATION_BGCOLOR;
    self.bm_NavigationItemTintColor = FS_NAVIGATION_ITEMCOLOR;
    self.bm_NavigationShadowHidden = YES;
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Navigation Action

- (BOOL)shouldPopOnBackButton
{
    return YES;
}

- (void)backAction:(id)sender
{
    if ([self shouldPopOnBackButton])
    {
        [self.view endEditing:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backRootAction:(id)sender
{
    if ([self shouldPopOnBackButton])
    {
        [self.view endEditing:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)backToViewController:(UIViewController *)viewController
{
    if ([self shouldPopOnBackButton])
    {
        [self.view endEditing:YES];
        
        [self.navigationController popToViewController:viewController animated:YES];
    }
}


#pragma mark -
#pragma mark checkRequestStatus

- (BOOL)checkRequestStatus:(NSInteger)statusCode message:(NSString *)message responseDic:(NSDictionary *)responseDic logOutQuit:(BOOL)quit showLogin:(BOOL)show
{
    if (!quit && !show)
    {
        show = YES;
    }
    
    switch (statusCode)
    {
        case 1001:
            [GetAppDelegate logOutQuit:quit showLogin:show];
            break;
            
        default:
            break;
    }
    
    return NO;
}



#pragma mark -
#pragma mark Login

// 弹出登录
- (BOOL)showLogin
{
    if ([FSUserInfoModle isLogin])
    {
        return NO;
    }
    
    FSLoginVC *loginVC = [[FSLoginVC alloc] init];
    loginVC.delegate = self;
    
    BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:loginVC];
    //nav.modalPresentationStyle = UIModalPresentationPopover;
    //nav.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:nav animated:YES completion:^{
    }];
    
    return YES;
}

// 隐藏登录
- (void)hideLogin
{
    if (self.presentedViewController)
    {
        UIViewController *vc = ((BMNavigationController *)self.presentedViewController).topViewController;
        if ([vc isKindOfClass:[FSLoginVC class]])
        {
            FSLoginVC *loginVC = (FSLoginVC *)vc;
            [loginVC backAction:nil];
        }
    }
}

// 弹出认证
- (void)pushAuthentication
{
    if ([FSUserInfoModle isCertification])
    {
        return;
    }

    FSAuthenticationVC *vc = [[FSAuthenticationVC alloc] init];
    vc.delegate = self;
    BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)loginFinished
{
    
}

- (void)loginFailed
{
    
}

- (void)loginClosed
{
    
}

- (void)authenticationFinished
{
    
}


#pragma mark -
#pragma mark FSLoginDelegate

- (void)loginProgressStateChanged:(FSLoginProgressState)progressState
{
    if (progressState == FSLoginProgress_FinishLogin || progressState == FSLoginProgress_FinishRegist)
    {
        [self loginFinished];
    }
}

- (void)loginFailedWithProgressState:(FSLoginProgressState)progressState
{
    [self loginFailed];
}

- (void)loginClosedWithProgressState:(FSLoginProgressState)progressState
{
    [self loginClosed];
}

#pragma mark FSAuthenticationDelegate
- (void)authenticationFinished:(FSAuthenticationVC *)vc
{
    [self authenticationFinished];
}

@end
