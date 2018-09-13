//
//  UIViewController+BMNavigationItem.m
//  BMNavigationBarSample
//
//  Created by DennisDeng on 2018/5/3.
//Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "UIViewController+BMNavigationItem.h"
#import <objc/runtime.h>
#import "BMNavigationBarDefine.h"
#import "BMNavigationController.h"
#import "BMNavigationTitleLabel.h"
#import "UIViewController+BMNavigationBar.h"
#import "NSObject+BMCategory.h"
#import "NSDictionary+BMCategory.h"

@implementation UIViewController (BMNavigationItem)

- (UIColor *)bm_NavigationBarTintColor
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return obj;
    }
    
    if ([UINavigationBar appearance].tintColor)
    {
        return [UINavigationBar appearance].tintColor;
    }
    
    return [UINavigationBar appearance].barStyle == UIBarStyleDefault ? [UIColor blackColor]: [UIColor whiteColor];
}

- (void)setBm_NavigationBarTintColor:(UIColor *)navigationBarTintColor
{
    objc_setAssociatedObject(self, @selector(bm_NavigationBarTintColor), navigationBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bm_NavigationTitleAlpha
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (self.bm_NavigationTitleHidden)
    {
        return 0.0f;
    }
    return obj ? [obj doubleValue] : 1.0f;
}

- (void)setBm_NavigationTitleAlpha:(CGFloat)alpha
{
    objc_setAssociatedObject(self, @selector(bm_NavigationTitleAlpha), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bm_NavigationTitleHidden
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : NO;
}

- (void)setBm_NavigationTitleHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(bm_NavigationTitleHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bm_NavigationTitleTintColor
{
    if (self.bm_NavigationTitleHidden)
    {
        return UIColor.clearColor;
    }
    
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return obj;
    }
    
    if ([UINavigationBar appearance].tintColor)
    {
        return [UINavigationBar appearance].tintColor;
    }
    
    return [UINavigationBar appearance].barStyle == UIBarStyleDefault ? [UIColor blackColor]: [UIColor whiteColor];
}

- (void)setBm_NavigationTitleTintColor:(UIColor *)tintColor
{
    objc_setAssociatedObject(self, @selector(bm_NavigationTitleTintColor), tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bm_NavigationItemAlpha
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (self.bm_NavigationItemHidden)
    {
        return 0.0f;
    }
    return obj ? [obj doubleValue] : 1.0f;
}

- (void)setBm_NavigationItemAlpha:(CGFloat)alpha
{
    objc_setAssociatedObject(self, @selector(bm_NavigationItemAlpha), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bm_NavigationItemHidden
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : NO;
}

- (void)setBm_NavigationItemHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(bm_NavigationItemHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bm_NavigationItemTintColor
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj)
    {
        return obj;
    }
    
    if ([UINavigationBar appearance].tintColor)
    {
        return [UINavigationBar appearance].tintColor;
    }
    
    return [UINavigationBar appearance].barStyle == UIBarStyleDefault ? [UIColor blackColor]: [UIColor whiteColor];
}

- (void)setBm_NavigationItemTintColor:(UIColor *)color
{
    objc_setAssociatedObject(self, @selector(bm_NavigationItemTintColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Actions

- (BMNavigationTitleLabel *)bm_getNavigationBarTitleLabel
{
    return [self bm_getNavigationBarTitleLabelAndCreate:YES];
}

- (BMNavigationTitleLabel *)bm_getNavigationBarTitleLabelAndCreate:(BOOL)createNew
{
    BMNavigationTitleLabel *titleLabel = nil;
    UIView *view = self.navigationItem.titleView;
    
    if ([view isKindOfClass:[BMNavigationTitleLabel class]])
    {
        titleLabel = (BMNavigationTitleLabel *)view;
    }
    else
    {
        if (createNew)
        {
            titleLabel = [[BMNavigationTitleLabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
            titleLabel.textColor = self.bm_NavigationTitleTintColor;
        
            self.navigationItem.titleView = titleLabel;
        }
    }
    
    return titleLabel;
}

- (void)bm_setNavigationBarTitle:(NSString *)title
{
    // 若使用BMTabBarController作为tab时，一级viewController不要设置title，否则tab文本重合
    // 可后续清空self.title = nil或调用tab的hideOriginTabBar
    self.title = title;
    
    BMNavigationTitleLabel *titleLabel = [self bm_getNavigationBarTitleLabel];
    
    // 设置标题
    titleLabel.text = title;
}

- (void)bm_setNeedsUpdateNavigationBarTintColor
{
    if (self.navigationController && [self.navigationController isKindOfClass:[BMNavigationController class]])
    {
        BMNavigationController *nav = (BMNavigationController *)self.navigationController;
        [nav updateNavigationBarTintColorForViewController:self];
    }
}

- (void)bm_setNeedsUpdateNavigationTitleAlpha
{
    BMNavigationTitleLabel *titleLabel = [self bm_getNavigationBarTitleLabelAndCreate:NO];
    titleLabel.alpha = self.bm_NavigationTitleAlpha;
}

- (void)bm_setNeedsUpdateNavigationTitleTintColor
{
    BMNavigationTitleLabel *titleLabel = [self bm_getNavigationBarTitleLabelAndCreate:NO];
    titleLabel.textColor = self.bm_NavigationTitleTintColor;
}

- (NSDictionary *)bm_makeBarButtonDictionaryWithTitle:(NSString *)title image:(id)image toucheEvent:(NSString *)selector buttonEdgeInsetsStyle:(BMButtonEdgeInsetsStyle)edgeInsetsStyle imageTitleGap:(CGFloat)gap
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([selector bm_isNotEmpty])
    {
        [dic setObject:selector forKey:BMNAVIGATION_BTNITEM_SELECTOR_KEY];
    }
    else
    {
        return nil;
    }

    if ([title bm_isNotEmpty])
    {
        [dic setObject:title forKey:BMNAVIGATION_BTNITEM_TITLE_KEY];
    }

    if ([image bm_isNotEmpty])
    {
        [dic setObject:image forKey:BMNAVIGATION_BTNITEM_IMAGE_KEY];
    }

    [dic setObject:@(edgeInsetsStyle) forKey:BMNAVIGATION_BTNITEM_EDGESTYLE_KEY];
    if (gap > 1.0f)
    {
        [dic setObject:@(gap) forKey:BMNAVIGATION_BTNITEM_GAP_KEY];
    }
    
    return dic;
}

- (UIBarButtonItem *)makeBarButton:(NSString *)title image:(id)image toucheEvent:(SEL)selector buttonEdgeInsetsStyle:(BMButtonEdgeInsetsStyle)edgeInsetsStyle imageTitleGap:(CGFloat)gap
{
// 直接使用UIBarButtonItem
//    if (selector != nil)
//    {
//        UIBarButtonItem * buttonItem = nil;
//        if (title != nil)
//        {
//            buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
//        }
//        else if (imageName)
//        {
//            buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:selector];
//        }
//
//        //buttonItem.tintColor = [UIColor whiteColor];
//
//        return buttonItem;
//    }
//    else
//    {
//        return nil;
//    }
//
//    return nil;
    
    if (edgeInsetsStyle > BMButtonEdgeInsetsStyleImageRight)
    {
        edgeInsetsStyle = BMButtonEdgeInsetsStyleImageLeft;
    }
    
    if (selector != nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        btn.exclusiveTouch = YES;
        
        btn.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        btn.tintColor = self.bm_NavigationItemTintColor;
        
        if (title != nil)
        {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            
            CGSize size = [title boundingRectWithSize:CGSizeMake(100.0f, 44.0f) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size;
            btn.frame = CGRectMake(0, 0, size.width, size.height);
            [btn setTitle:title forState:UIControlStateNormal];
            //[btn setTitleColor:self.bm_NavigationItemTintColor forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            
            if (image)
            {
                UIImage *itemImage = nil;
                
                if ([image isKindOfClass:[NSString class]])
                {
                    itemImage = [UIImage imageNamed:image];
                }
                else if ([image isKindOfClass:[UIImage class]])
                {
                    itemImage = image;
                }
                
                if (itemImage)
                {
                    // Set the rendering mode to respect tint color
                    UIImage *tintItemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
                    CGFloat width = itemImage.size.width+size.width+gap;
                    CGFloat height = itemImage.size.height>size.height ? itemImage.size.height  : size.height;
                    btn.frame = CGRectMake(0, 0, width, height);
                    [btn setImage:tintItemImage forState:UIControlStateNormal];
                    [btn setBackgroundImage:nil forState:UIControlStateNormal];
                    
                    [btn bm_layoutButtonWithEdgeInsetsStyle:edgeInsetsStyle imageTitleGap:gap];
                }
            }
        }
        else if (image)
        {
            UIImage *itemImage = nil;
            
            if ([image isKindOfClass:[NSString class]])
            {
                itemImage = [UIImage imageNamed:image];
            }
            else if ([image isKindOfClass:[UIImage class]])
            {
                itemImage = image;
            }
            
            if (itemImage)
            {
                // Set the rendering mode to respect tint color
                UIImage *tintItemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
                btn.frame = CGRectMake(0, 0, itemImage.size.width, itemImage.size.height);
                [btn setBackgroundImage:tintItemImage forState:UIControlStateNormal];
                [btn setImage:nil forState:UIControlStateNormal];
            }
        }
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        return buttonItem;
    }
    else
    {
        return nil;
    }
}

- (NSArray *)makeButtonItemsWithDicArray:(NSArray *)dicArray
{
    if ([dicArray bm_isNotEmpty])
    {
        NSMutableArray *btnArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in dicArray)
        {
            NSString *title = [dic objectForKey:BMNAVIGATION_BTNITEM_TITLE_KEY];
            NSString *imageName = [dic objectForKey:BMNAVIGATION_BTNITEM_IMAGE_KEY];
            SEL aSelector = NSSelectorFromString([dic objectForKey:BMNAVIGATION_BTNITEM_SELECTOR_KEY]);
            BMButtonEdgeInsetsStyle edgeInsetsStyle = [dic bm_uintForKey:BMNAVIGATION_BTNITEM_EDGESTYLE_KEY withDefault:BMButtonEdgeInsetsStyleImageRight];
            CGFloat gap = [dic bm_uintForKey:BMNAVIGATION_BTNITEM_GAP_KEY withDefault:2];
            
            UIBarButtonItem *buttonItem = [self makeBarButton:title image:imageName toucheEvent:aSelector buttonEdgeInsetsStyle:edgeInsetsStyle imageTitleGap:gap];
            [btnArray addObject:buttonItem];
        }
        
        if (btnArray.count)
        {
            return btnArray;
        }
        else
        {
            return nil;
        }
    }
    
    return nil;
}

- (void)bm_setNavigationLeftItemAlpha:(CGFloat)alpha
{
    for (UIBarButtonItem *buttonItem in self.navigationItem.leftBarButtonItems)
    {
        UIButton *btn = (UIButton *)buttonItem.customView;
        
        btn.alpha = alpha;
    }
}

- (void)bm_setNavigationRightItemAlpha:(CGFloat)alpha
{
    for (UIBarButtonItem *buttonItem in self.navigationItem.rightBarButtonItems)
    {
        UIButton *btn = (UIButton *)buttonItem.customView;
        
        btn.alpha = alpha;
    }
}

- (void)bm_setNeedsUpdateNavigationItemAlpha
{
    [self bm_setNavigationLeftItemAlpha:self.bm_NavigationItemAlpha];
    [self bm_setNavigationRightItemAlpha:self.bm_NavigationItemAlpha];
}

- (void)bm_setNavigationWithTitle:(NSString *)title barTintColor:(UIColor *)barTintColor leftItemTitle:(NSString *)lTitle leftItemImage:(id)lImage leftToucheEvent:(SEL)lSelector rightItemTitle:(NSString *)rTitle rightItemImage:(id)rImage rightToucheEvent:(SEL)rSelector
{
    [self bm_setNavigationBarTitle:title];
    
    [self bm_setNavigationWithTitleView:nil barTintColor:barTintColor leftItemTitle:lTitle leftItemImage:lImage leftToucheEvent:lSelector rightItemTitle:rTitle rightItemImage:rImage rightToucheEvent:rSelector];
}

- (void)bm_setNavigationWithTitleView:(UIView *)titleView barTintColor:(UIColor *)barTintColor leftItemTitle:(NSString *)lTitle leftItemImage:(id)lImage leftToucheEvent:(SEL)lSelector rightItemTitle:(NSString *)rTitle rightItemImage:(id)rImage rightToucheEvent:(SEL)rSelector
{
    [self.navigationItem setHidesBackButton:YES];
    
    // 设置标题
    if (titleView)
    {
        self.navigationItem.titleView = titleView;
    }
    
    if (barTintColor)
    {
        self.bm_NavigationBarBgTintColor = barTintColor;
        [self bm_setNeedsUpdateNavigationBarBgTintColor];
    }
    
    //self.bm_NavigationTitleTintColor = [UIColor whiteColor];
    //self.bm_NavigationItemTintColor = [UIColor whiteColor];
    [self bm_setNeedsUpdateNavigationTitleTintColor];
    [self bm_setNeedsUpdateNavigationItemTintColor];
    
    // 设置左按键
    UIBarButtonItem *lButtonItem = [self makeBarButton:lTitle image:lImage toucheEvent:lSelector buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:2.0f];
    self.navigationItem.leftBarButtonItem = lButtonItem;
    
    // 设置右按键
    UIBarButtonItem *rButtonItem = [self makeBarButton:rTitle image:rImage toucheEvent:rSelector buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:2.0f];
    self.navigationItem.rightBarButtonItem = rButtonItem;
}

- (void)bm_setNavigationWithTitle:(NSString *)title barTintColor:(UIColor *)barTintColor leftItemTitle:(NSString *)lTitle leftItemImage:(id)lImage leftToucheEvent:(SEL)lSelector rightDicArray:(NSArray *)rarray
{
    [self bm_setNavigationBarTitle:title];
    
    [self bm_setNavigationWithTitleView:nil barTintColor:barTintColor leftItemTitle:lTitle leftItemImage:lImage leftToucheEvent:lSelector rightDicArray:rarray];
}

- (void)bm_setNavigationWithTitleView:(UIView *)titleView barTintColor:(UIColor *)barTintColor leftItemTitle:(NSString *)lTitle leftItemImage:(id)lImage leftToucheEvent:(SEL)lSelector rightDicArray:(NSArray *)rarray
{
    [self.navigationItem setHidesBackButton:YES];
    
    // 设置标题
    if (titleView)
    {
        self.navigationItem.titleView = titleView;
    }
    
    if (barTintColor)
    {
        self.bm_NavigationBarBgTintColor = barTintColor;
        [self bm_setNeedsUpdateNavigationBarBgTintColor];
    }
    
    //self.bm_NavigationTitleTintColor = [UIColor whiteColor];
    //self.bm_NavigationItemTintColor = [UIColor whiteColor];
    [self bm_setNeedsUpdateNavigationTitleTintColor];
    [self bm_setNeedsUpdateNavigationItemTintColor];
    
    // 设置左按键
    UIBarButtonItem *lButtonItem = [self makeBarButton:lTitle image:lImage toucheEvent:lSelector buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:2.0f];
    self.navigationItem.leftBarButtonItem = lButtonItem;
    
    // 设置右Items
    if ([rarray bm_isNotEmpty])
    {
        NSArray *btnArray = [self makeButtonItemsWithDicArray:rarray];
        self.navigationItem.rightBarButtonItems = btnArray;
    }
}

- (void)bm_setNavigationWithTitle:(NSString *)title barTintColor:(UIColor *)barTintColor leftDicArray:(NSArray *)larray rightDicArray:(NSArray *)rarray
{
    [self bm_setNavigationBarTitle:title];
    
    [self bm_setNavigationWithTitleView:nil barTintColor:barTintColor leftDicArray:larray rightDicArray:rarray];
}

- (void)bm_setNavigationWithTitleView:(UIView *)titleView barTintColor:(UIColor *)barTintColor leftDicArray:(NSArray *)larray rightDicArray:(NSArray *)rarray
{
    [self.navigationItem setHidesBackButton:YES];
    
    // 设置标题
    if (titleView)
    {
        self.navigationItem.titleView = titleView;
    }
    
    if (barTintColor)
    {
        self.bm_NavigationBarBgTintColor = barTintColor;
        [self bm_setNeedsUpdateNavigationBarBgTintColor];
    }
    
    //self.bm_NavigationTitleTintColor = [UIColor whiteColor];
    //self.bm_NavigationItemTintColor = [UIColor whiteColor];
    [self bm_setNeedsUpdateNavigationTitleTintColor];
    [self bm_setNeedsUpdateNavigationItemTintColor];
    
    // 设置左Items
    if ([larray bm_isNotEmpty])
    {
        NSArray *btnArray = [self makeButtonItemsWithDicArray:larray];
        self.navigationItem.leftBarButtonItems = btnArray;
    }

    // 设置右Items
    if ([rarray bm_isNotEmpty])
    {
        NSArray *btnArray = [self makeButtonItemsWithDicArray:rarray];
        self.navigationItem.rightBarButtonItems = btnArray;
    }
}

- (UIButton *)bm_getNavigationLeftItemAtIndex:(NSUInteger)index
{
    if (index < self.navigationItem.leftBarButtonItems.count)
    {
        UIBarButtonItem *buttonItem = [self.navigationItem.leftBarButtonItems objectAtIndex:index];
        return (UIButton *)buttonItem.customView;
    }
    else
    {
        UIBarButtonItem *buttonItem = self.navigationItem.leftBarButtonItem;
        if ( buttonItem != nil)
        {
            return (UIButton *)buttonItem.customView;
        }
        
        return nil;
    }
}

- (UIButton *)bm_getNavigationRightItemAtIndex:(NSUInteger)index
{
    if (index < self.navigationItem.rightBarButtonItems.count)
    {
        UIBarButtonItem *buttonItem = [self.navigationItem.rightBarButtonItems objectAtIndex:index];
        return (UIButton *)buttonItem.customView;
    }
    else
    {
        UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItem;
        if ( buttonItem != nil)
        {
            return (UIButton *)buttonItem.customView;
        }
        
        return nil;
    }
}

- (void)bm_setNavigationLeftItemTintColor:(UIColor *)tintColor
{
    for (UIBarButtonItem *buttonItem in self.navigationItem.leftBarButtonItems)
    {
        UIButton *btn = (UIButton *)buttonItem.customView;
        
        btn.tintColor = tintColor;
    }
}

- (void)bm_setNavigationRightItemTintColor:(UIColor *)tintColor
{
    for (UIBarButtonItem *buttonItem in self.navigationItem.rightBarButtonItems)
    {
        UIButton *btn = (UIButton *)buttonItem.customView;
        
        btn.tintColor = tintColor;
    }
}

- (void)bm_setNavigationItemTintColor:(UIColor *)tintColor
{
    [self bm_setNavigationLeftItemTintColor:tintColor];
    [self bm_setNavigationRightItemTintColor:tintColor];
}

- (void)bm_setNeedsUpdateNavigationItemTintColor
{
    [self bm_setNavigationItemTintColor:self.bm_NavigationItemTintColor];
}

- (void)bm_setNavigationLeftItemEnable:(BOOL)enable
{
    for (UIBarButtonItem *buttonItem in self.navigationItem.leftBarButtonItems)
    {
        UIButton *btn = (UIButton *)buttonItem.customView;
        
        btn.enabled = enable;
    }
}

- (void)bm_setNavigationRightItemEnable:(BOOL)enable
{
    for (UIBarButtonItem *buttonItem in self.navigationItem.rightBarButtonItems)
    {
        UIButton *btn = (UIButton *)buttonItem.customView;
        
        btn.enabled = enable;
    }
}

- (void)bm_setNavigationItemEnable:(BOOL)enable
{
    [self bm_setNavigationLeftItemEnable:enable];
    [self bm_setNavigationRightItemEnable:enable];
}

@end
