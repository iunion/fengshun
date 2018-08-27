//
//  UIViewController+BMNavigationBar.m
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/4/28.
//Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "UIViewController+BMNavigationBar.h"
#import <objc/runtime.h>
#import "BMNavigationBarDefine.h"
#import "BMNavigationController.h"

@implementation UIViewController (BMNavigationBar)

- (UIBarStyle)bm_NavigationBarStyle
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return [obj integerValue];
    }
    return [UINavigationBar appearance].barStyle;
}

- (void)setBm_NavigationBarStyle:(UIBarStyle)navigationBarStyle
{
    objc_setAssociatedObject(self, @selector(bm_NavigationBarStyle), @(navigationBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bm_NavigationBarAlpha
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (self.bm_NavigationBarHidden)
    {
        return 0.0f;
    }
    return obj ? [obj doubleValue] : 1.0f;
}

- (void)setBm_NavigationBarAlpha:(CGFloat)alpha
{
    objc_setAssociatedObject(self, @selector(bm_NavigationBarAlpha), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bm_NavigationBarHidden
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : NO;
}

- (void)setBm_NavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(bm_NavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bm_NavigationBarBgTintColor
{
    if (self.bm_NavigationBarHidden)
    {
        return UIColor.clearColor;
    }
    
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return obj;
    }
    
    if ([UINavigationBar appearance].barTintColor)
    {
        return [UINavigationBar appearance].barTintColor;
    }
    
    return (self.bm_NavigationBarStyle == UIBarStyleDefault) ? [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0.8]: [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:0.729];
}

- (void)setBm_NavigationBarBgTintColor:(UIColor *)navigationBarBgTintColor
{
    objc_setAssociatedObject(self, @selector(bm_NavigationBarBgTintColor), navigationBarBgTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIVisualEffect *)bm_NavigationBarEffect
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? obj : BMNavigationBar_DefaultEffect;
}

- (void)setBm_NavigationBarEffect:(UIVisualEffect *)navigationBarEffect
{
    objc_setAssociatedObject(self, @selector(bm_NavigationBarEffect), navigationBarEffect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)bm_NavigationBarImage
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setBm_NavigationBarImage:(UIImage *)navigationBarImage
{
    objc_setAssociatedObject(self, @selector(bm_NavigationBarImage), navigationBarImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bm_NavigationShadowAlpha
{
    return  self.bm_NavigationShadowHidden ? 0.0f : self.bm_NavigationBarAlpha;
}

- (BOOL)bm_NavigationShadowHidden
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return  self.bm_NavigationBarHidden || obj ? [obj boolValue] : NO;
}

- (void)setBm_NavigationShadowHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(bm_NavigationShadowHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bm_NavigationShadowColor
{
    if (self.bm_NavigationShadowHidden)
    {
        return UIColor.clearColor;
    }
    
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return obj;
    }
    
    return [UINavigationBar appearance].barStyle == UIBarStyleDefault ? [UIColor blackColor]: [UIColor whiteColor];
}

- (void)setBm_NavigationShadowColor:(UIColor *)color
{
    objc_setAssociatedObject(self, @selector(bm_NavigationShadowColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bm_CanBackInteractive
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : YES;
}

- (void)setBm_CanBackInteractive:(BOOL)interactive
{
    objc_setAssociatedObject(self, @selector(bm_CanBackInteractive), @(interactive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bm_NavigationBarTranslationY
{
    return self.navigationController.navigationBar.transform.ty;
}

- (void)setBm_NavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}



#pragma mark -
#pragma mark Navigation Actions

- (void)bm_setNeedsUpdateNavigationBar
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationBarForController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationBarStyle
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationBarStyleForViewController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationBarAlpha
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationBarAlphaForViewController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationBarBgTintColor
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationBarBgTintColorForViewController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationBarEffect
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationBarEffectForViewController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationBarImage
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationBarImageForViewController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationShadowAlpha
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationShadowAlphaForViewController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationShadowColor
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationShadowColorForViewController:self];
    }
}

@end
