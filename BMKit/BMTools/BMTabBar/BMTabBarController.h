//
//  BMTabBarController.h
//  BMBaseKit
//
//  Created by DennisDeng on 15/8/19.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNavigationController.h"
#import "BMTabItemButton.h"

typedef NS_ENUM(NSUInteger, BMTabIndex)
{
    BMTabIndex_Main,
    BMTabIndex_Class,
    BMTabIndex_Forum,
    BMTabIndex_User
};

@interface BMTabBarController : UITabBarController

@property (nonatomic, strong) NSArray<__kindof BMTabItemClass *> *tab_ItemArray;

- (instancetype)initWithArray:(NSArray<__kindof BMTabItemClass *> *)itemArray;

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers;

- (void)freshTabItemWithArray:(NSArray<__kindof BMTabItemClass *> *)itemArray;

- (void)hideOriginTabBar;

// 选中某个Tab
- (void)selectedTabWithIndex:(BMTabIndex)index;

- (void)beforeSelectedIndexChangedFrom:(BMTabIndex)findex to:(BMTabIndex)tindex;
- (void)endSelectedIndexChangedFrom:(BMTabIndex)findex to:(BMTabIndex)tindex;

// 某个Tab上可能push了很多层，回到初始页面
- (void)backTopLeverView:(BMTabIndex)index animated:(BOOL)animated;

- (BMNavigationController *)getCurrentNavigationController;
- (BMNavigationController *)getNavigationControllerAtTabIndex:(BMTabIndex)index;

// 返回当前tab的RootVC
- (UIViewController *)getCurrentRootViewController;
// 返回当前tab的首层VC
- (UIViewController *)getCurrentViewController;
// 根据索引找到VC
- (UIViewController *)getRootViewControllerAtTabIndex:(BMTabIndex)index;
- (UIViewController *)getViewControllerAtTabIndex:(BMTabIndex)index;

@end
