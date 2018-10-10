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

#import "FSAlertView.h"

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
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor  = UI_COLOR_B6;

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
    
    // 1001     用户未登录
    // 1002     认证令牌失效 注：出现该错误时，需要调用刷新令牌接口，重新 获得有效令牌
    switch (statusCode)
    {
        // 未登录
        case 1001:
        case 1002:
            
            [MBProgressHUD showHUDAddedTo:GetAppDelegate.window animated:YES withText:@"登录信息已失效，请重新登录" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PROGRESSBOX_DEFAULT_HIDE_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [GetAppDelegate logOutQuit:quit showLogin:show];
            });

            
            return YES;

        // 强制更新
        case 1008:
        {
            NSDictionary *dataDic = [responseDic bm_dictionaryForKey:@"data"];
            NSString *downString;
            NSString *httpLink = [dataDic bm_stringTrimForKey:@"link"];
            NSString *appId = [dataDic bm_stringTrimForKey:@"appId"];
            if ([httpLink bm_isNotEmpty])
            {
                downString = httpLink;
            }
            else if ([appId bm_isNotEmpty])
            {
                downString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/%@", appId];
            }
            else
            {
                downString = APPSTORE_DOWNLOADAPP_ADDRESS;
            }
            
            FSAlertView *alertView = [FSAlertView showAlertWithTitle:message message:nil cancelTitle:@"立即更新" otherTitle:nil completion:^(BOOL cancelled, NSInteger buttonIndex) {
                //NSString *downString = APPSTORE_DOWNLOADAPP_ADDRESS;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downString]];
            }];
            alertView.showClose = NO;
            alertView.notDismissOnCancel = YES;

            return YES;
        }

        default:
            break;
    }
    
    return NO;
}

- (void)checkXMApiWithError:(NSError *)error
{
    if ([error.domain isEqualToString:FSAPIResponseErrorDomain])
    {
        [self checkRequestStatus:error.code message:error.userInfo[NSLocalizedDescriptionKey] responseDic:error.userInfo[NSHelpAnchorErrorKey] logOutQuit:YES showLogin:YES];
    }
}

#pragma mark -
#pragma mark Login

// 弹出登录
- (BOOL)showLogin
{
    if ([FSUserInfoModel isLogin])
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
    if ([FSUserInfoModel isCertification])
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
