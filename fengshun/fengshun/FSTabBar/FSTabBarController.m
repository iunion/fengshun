//
//  FSTabBarController.m
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTabBarController.h"
#import "FSMainVC.h"

@interface FSTabBarController ()

@end

@implementation FSTabBarController

// 初始化所有Item
- (instancetype)initWithDefaultItems
{
    BMTabItemClass *tab1 = [[BMTabItemClass alloc] init];
    tab1.title = @"首页";
    tab1.normalColor = [UIColor bm_colorWithHex:0x666666];
    tab1.selectedColor = [UIColor blueColor];
    tab1.normalIcon = @"fstab_btn1_icon";
    tab1.selectedIcon = @"fstab_btn1_highIcon";

    BMTabItemClass *tab2 = [[BMTabItemClass alloc] init];
    tab2.title = @"课堂";
    tab2.normalColor = [UIColor bm_colorWithHex:0x666666];
    tab2.selectedColor = [UIColor blueColor];
    tab2.normalIcon = @"fstab_btn2_icon";
    tab2.selectedIcon = @"fstab_btn2_highIcon";

    BMTabItemClass *tab3 = [[BMTabItemClass alloc] init];
    tab3.title = @"社区";
    tab3.normalColor = [UIColor bm_colorWithHex:0x666666];
    tab3.selectedColor = [UIColor blueColor];
    tab3.normalIcon = @"fstab_btn3_icon";
    tab3.selectedIcon = @"fstab_btn3_highIcon";

    BMTabItemClass *tab4 = [[BMTabItemClass alloc] init];
    tab4.title = @"我的";
    tab4.normalColor = [UIColor bm_colorWithHex:0x666666];
    tab4.selectedColor = [UIColor blueColor];
    tab4.normalIcon = @"fstab_btn4_icon";
    tab4.selectedIcon = @"fstab_btn4_highIcon";
    
    return [self initWithArray:@[tab1, tab2, tab3, tab4]];
}

- (void)addViewControllers
{
    BMNavigationController *nav1 = [[BMNavigationController alloc] initWithRootViewController:[[FSMainVC alloc] init]];
    BMNavigationController *nav2 = [[BMNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    BMNavigationController *nav3 = [[BMNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    BMNavigationController *nav4 = [[BMNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];

    [self setViewControllers:@[nav1, nav2, nav3, nav4]];
}

@end
