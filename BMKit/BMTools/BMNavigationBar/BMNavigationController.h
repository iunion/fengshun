//
//  BMNavigationController.h
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/4/28.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^shouldPopOnBackButtonHandler)(UIViewController *vc);

@interface BMNavigationController : UINavigationController

@property (nonatomic, copy) shouldPopOnBackButtonHandler popOnBackButtonHandler;

// 刷新bar
- (void)updateNavigationBarForController:(UIViewController *)vc;
- (void)updateNavigationBarStyleForViewController:(UIViewController *)vc;

// 刷新bar背景
- (void)updateNavigationBarAlphaForViewController:(UIViewController *)vc;
- (void)updateNavigationBarBgTintColorForViewController:(UIViewController *)vc;
- (void)updateNavigationBarEffectForViewController:(UIViewController *)vc;
- (void)updateNavigationBarImageForViewController:(UIViewController *)vc;

// 刷新bar阴影
- (void)updateNavigationShadowAlphaForViewController:(UIViewController *)vc;
- (void)updateNavigationShadowColorForViewController:(UIViewController *)vc;

// 刷新tintColor title和btnItem颜色
- (void)updateNavigationBarTintColorForViewController:(UIViewController *)vc;

- (void)resetPushAnimation;

@end
