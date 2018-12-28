//
//  UIViewController+BMNavigationItem.h
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/5/3.
//Copyright © 2018年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+BMContentRect.h"

#define BMNAVIGATION_BTNITEM_IMAGE_KEY      @"image"
#define BMNAVIGATION_BTNITEM_TITLE_KEY      @"title"
#define BMNAVIGATION_BTNITEM_SELECTOR_KEY   @"selector"
#define BMNAVIGATION_BTNITEM_EDGESTYLE_KEY  @"edgeStyle"
#define BMNAVIGATION_BTNITEM_GAP_KEY        @"gap"
#define BMNAVIGATION_ITEM_MINWIDTH          (40.0f)

#pragma mark - NavigationItem

NS_ASSUME_NONNULL_BEGIN

@class BMNavigationTitleLabel;

@interface UIViewController (BMNavigationItem)

// NavigationBar barTintColor
// 控制系统title和btnItem颜色，使用本category请使用bm_NavigationTitleTintColor和bm_NavigationItemTintColor设置颜色
@property (nonatomic, strong) UIColor *bm_NavigationBarTintColor;

// Title透明度，注：push页面透明度设置，第一次显示请使用bm_NavigationTitleTintColor设置，TitleAlpha会有延时
@property (nonatomic, assign) CGFloat bm_NavigationTitleAlpha;
// Title是否隐藏
@property (nonatomic, assign) BOOL bm_NavigationTitleHidden;
// Title颜色
@property (nonatomic, strong) UIColor *bm_NavigationTitleTintColor;

// BarItem透明度
@property (nonatomic, assign) CGFloat bm_NavigationItemAlpha;
// BarItem是否隐藏
@property (nonatomic, assign) BOOL bm_NavigationItemHidden;
// BarItem tintColor
@property (nonatomic, strong) UIColor *bm_NavigationItemTintColor;


- (void)bm_setNeedsUpdateNavigationBarTintColor;

// NavigationTitle
- (void)bm_setNeedsUpdateNavigationTitleAlpha;
- (void)bm_setNeedsUpdateNavigationTitleTintColor;

- (BMNavigationTitleLabel *)bm_getNavigationBarTitleLabel;
- (nullable BMNavigationTitleLabel *)bm_getNavigationBarTitleLabelAndCreate:(BOOL)createNew;
- (void)bm_setNavigationBarTitle:(nullable NSString *)title;

// NavigationItem
- (void)bm_setNeedsUpdateNavigationItemAlpha;
- (void)bm_setNeedsUpdateNavigationItemTintColor;

- (void)bm_setNavigationWithTitle:(nullable NSString *)title barTintColor:(nullable UIColor *)barTintColor leftItemTitle:(nullable NSString *)lTitle leftItemImage:(nullable id)lImage leftToucheEvent:(nullable SEL)lSelector rightItemTitle:(nullable NSString *)rTitle rightItemImage:(nullable id)rImage rightToucheEvent:(nullable SEL)rSelector;
- (void)bm_setNavigationWithTitleView:(nullable UIView *)titleView barTintColor:(nullable UIColor *)barTintColor leftItemTitle:(nullable NSString *)lTitle leftItemImage:(nullable id)lImage leftToucheEvent:(nullable SEL)lSelector rightItemTitle:(nullable NSString *)rTitle rightItemImage:(nullable id)rImage rightToucheEvent:(nullable SEL)rSelector;

- (void)bm_setNavigationWithTitle:(nullable NSString *)title barTintColor:(nullable UIColor *)barTintColor leftItemTitle:(nullable NSString *)lTitle leftItemImage:(nullable id)lImage leftToucheEvent:(nullable SEL)lSelector rightDicArray:(nullable NSArray *)rarray;
- (void)bm_setNavigationWithTitleView:(nullable UIView *)titleView barTintColor:(nullable UIColor *)barTintColor leftItemTitle:(nullable NSString *)lTitle leftItemImage:(nullable id)lImage leftToucheEvent:(nullable SEL)lSelector rightDicArray:(nullable NSArray *)rarray;

- (void)bm_setNavigationWithTitle:(nullable NSString *)title barTintColor:(nullable UIColor *)barTintColor leftDicArray:(nullable NSArray *)larray rightDicArray:(nullable NSArray *)rarray;
- (void)bm_setNavigationWithTitleView:(nullable UIView *)titleView barTintColor:(nullable UIColor *)barTintColor leftDicArray:(nullable NSArray *)larray rightDicArray:(nullable NSArray *)rarray;

- (nullable NSDictionary *)bm_makeBarButtonDictionaryWithTitle:(nullable NSString *)title image:(nullable id)image toucheEvent:(NSString *)selector buttonEdgeInsetsStyle:(BMButtonEdgeInsetsStyle)edgeInsetsStyle imageTitleGap:(CGFloat)gap;

- (nullable UIButton *)bm_getNavigationLeftItemAtIndex:(NSUInteger)index;
- (nullable UIButton *)bm_getNavigationRightItemAtIndex:(NSUInteger)index;

- (void)bm_setNavigationLeftItemTintColor:(UIColor *)tintColor;
- (void)bm_setNavigationRightItemTintColor:(UIColor *)tintColor;
- (void)bm_setNavigationItemTintColor:(UIColor *)tintColor;

- (void)bm_setNavigationLeftItemEnable:(BOOL)enable;
- (void)bm_setNavigationRightItemEnable:(BOOL)enable;
- (void)bm_setNavigationItemEnable:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
