//
//  UIViewController+BMNavigationBar.h
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/4/28.
//Copyright © 2018年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - NavigationBar

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BMNavigationBar)

// UIBarStyle
// 'View controller-based status bar appearance' set YES

@property (nonatomic, assign) UIBarStyle bm_NavigationBarStyle;

// NavigationBar透明度
@property (nonatomic, assign) CGFloat bm_NavigationBarAlpha;
// NavigationBar是否隐藏
@property (nonatomic, assign) BOOL bm_NavigationBarHidden;
// NavigationBar背景色
@property (nonatomic, strong) UIColor *bm_NavigationBarBgTintColor;
// NavigationBar背景效果
@property (nonatomic, strong) UIVisualEffect *bm_NavigationBarEffect;
// NavigationBar背景图
@property (nullable, nonatomic, strong) UIImage *bm_NavigationBarImage;

// NavigationBar阴影线条透明度
@property (nonatomic, assign, readonly) CGFloat bm_NavigationShadowAlpha;
// NavigationBar阴影线条是否隐藏
@property (nonatomic, assign) BOOL bm_NavigationShadowHidden;
// NavigationBar阴影线条背景色
@property (nonatomic, strong) UIColor *bm_NavigationShadowColor;

// 是否支持右滑返回
@property (nonatomic, assign) BOOL bm_CanBackInteractive;

// 垂直方向偏移
@property (nonatomic, assign) CGFloat bm_NavigationBarTranslationY;

// NavigationBar
- (void)bm_setNeedsUpdateNavigationBar;
- (void)bm_setNeedsUpdateNavigationBarStyle;

- (void)bm_setNeedsUpdateNavigationBarAlpha;
- (void)bm_setNeedsUpdateNavigationBarBgTintColor;
- (void)bm_setNeedsUpdateNavigationBarEffect;
- (void)bm_setNeedsUpdateNavigationBarImage;

- (void)bm_setNeedsUpdateNavigationShadowAlpha;
- (void)bm_setNeedsUpdateNavigationShadowColor;

@end

NS_ASSUME_NONNULL_END
