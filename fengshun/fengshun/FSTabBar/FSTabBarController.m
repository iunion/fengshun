//
//  FSTabBarController.m
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTabBarController.h"
#import "FSMainVC.h"
#import "FSCommunityVC.h"
#import "FSUserMainVC.h"
//#import "FSH5DemoVC.h"
#import "FSCourseHomePageVC.h"
#import "UIViewController+FSPushVCAPI.h"

//正常色
#define ITEM_NOR_COLOR [UIColor bm_colorWithHex:0x979797]
//选中色
#define ITEM_SEL_COLOR [UIColor bm_colorWithHex:UI_NAVIGATION_BGCOLOR_VALU]

@interface FSTabBarController ()

@end

@implementation FSTabBarController

// 初始化所有Item
- (instancetype)initWithDefaultItems
{
    BMTabItemClass *tab1 = [[BMTabItemClass alloc] init];
    tab1.title = @"首页";
    tab1.normalColor = ITEM_NOR_COLOR;
    tab1.selectedColor = ITEM_SEL_COLOR;
    tab1.normalIcon = @"fstab_btn1_icon";
    tab1.selectedIcon = @"fstab_btn1_highIcon";

    BMTabItemClass *tab2 = [[BMTabItemClass alloc] init];
    tab2.title = @"课堂";
    tab2.normalColor = ITEM_NOR_COLOR;
    tab2.selectedColor = ITEM_SEL_COLOR;
    tab2.normalIcon = @"fstab_btn2_icon";
    tab2.selectedIcon = @"fstab_btn2_highIcon";

    BMTabItemClass *tab3 = [[BMTabItemClass alloc] init];
    tab3.title = @"社区";
    tab3.normalColor = ITEM_NOR_COLOR;
    tab3.selectedColor = ITEM_SEL_COLOR;
    tab3.normalIcon = @"fstab_btn3_icon";
    tab3.selectedIcon = @"fstab_btn3_highIcon";

    BMTabItemClass *tab4 = [[BMTabItemClass alloc] init];
    tab4.title = @"我的";
    tab4.normalColor = ITEM_NOR_COLOR;
    tab4.selectedColor = ITEM_SEL_COLOR;
    tab4.normalIcon = @"fstab_btn4_icon";
    tab4.selectedIcon = @"fstab_btn4_highIcon";
    
    return [self initWithArray:@[tab1, tab2, tab3, tab4]];
}

- (shouldPopOnBackButtonHandler)getPopOnBackButtonHandler
{
    shouldPopOnBackButtonHandler handler = ^BOOL(UIViewController *vc) {
        if ([vc isKindOfClass:[FSSuperVC class]])
        {
            FSSuperVC *superVC = (FSSuperVC *)vc;
            return [superVC shouldPopOnBackButton];
        }
        return YES;
    };
    
    return handler;
}

- (void)addViewControllers
{
    BMNavigationController *nav1 = [[BMNavigationController alloc] initWithRootViewController:[[FSMainVC alloc] initWithNibName:@"FSMainVC" bundle:nil freshViewType:BMFreshViewType_Head]];
    nav1.popOnBackButtonHandler = [self getPopOnBackButtonHandler];
    
    FSCourseHomePageVC *course =[[FSCourseHomePageVC alloc] initWithTitle:@"课堂" url:[NSString stringWithFormat:@"%@/course?Ctype=\"IOS\"", FS_H5_SERVER]];
//    FSCourseHomePageVC *course =[[FSCourseHomePageVC alloc] initWithTitle:@"课堂" url:[NSString stringWithFormat:@"baidu.com"]];
    //BMNavigationController *nav2 = [[BMNavigationController alloc] initWithRootViewController:[[WebViewVC alloc]initWithNibName:@"WebViewVC" bundle:nil]];//[[FSH5DemoVC alloc] init]
    BMNavigationController *nav2 = [[BMNavigationController alloc] initWithRootViewController:course];//[[FSH5DemoVC alloc] init]
    nav2.popOnBackButtonHandler = [self getPopOnBackButtonHandler];
    
    BMNavigationController *nav3 = [[BMNavigationController alloc] initWithRootViewController:[[FSCommunityVC alloc] initWithNibName:@"FSCommunityVC" bundle:nil]];
    nav3.popOnBackButtonHandler = [self getPopOnBackButtonHandler];
    
    BMNavigationController *nav4 = [[BMNavigationController alloc] initWithRootViewController:[[FSUserMainVC alloc] initWithNibName:@"FSUserMainVC" bundle:nil freshViewType:BMFreshViewType_Head]];
    nav4.popOnBackButtonHandler = [self getPopOnBackButtonHandler];
    
    [self setViewControllers:@[nav1, nav2, nav3, nav4]];
}

- (void)selectedTabWithIndex:(BMTabIndex)index
{
    [super selectedTabWithIndex:index];
    
    switch (index)
    {
        case BMTabIndex_Main:
            //[MobClick event:@"Tab_Events" label:@"首页_Tab"];
            break;
        case BMTabIndex_Class:
        {
            //[MobClick event:@"Tab_Events" label:@"活期_Tab"];
            BMNavigationController *nav = [self.viewControllers objectAtIndex:BMTabIndex_Class];
            
            FSCourseHomePageVC *vc = (FSCourseHomePageVC *)[nav.viewControllers firstObject];
            if (vc.m_WebView)
            {
                [vc refreshWebView];
            }
        }
            break;
        case BMTabIndex_Forum:
            //[MobClick event:@"Tab_Events" label:@"定期_Tab"];
            break;
        case BMTabIndex_User:
            //[MobClick event:@"Tab_Events" label:@"个人中心_Tab"];
            break;
        default:
            break;
    }
}

- (void)topVCPushWithModel:(FSPushVCModel *)pushModel
{
    UIViewController *vc = [self getCurrentViewController];
    [vc fspush_withModel:pushModel];
}

- (BOOL)topVCJumpWithUrl:(NSURL *)url
{
    UIViewController *vc = [self getCurrentViewController];
    return [vc fspush_withUrl:url];
}
@end
