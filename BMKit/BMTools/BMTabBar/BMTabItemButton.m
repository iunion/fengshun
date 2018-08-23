//
//  BMTabItemButton.m
//  BMBaseKit
//
//  Created by DennisDeng on 15/8/19.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import "BMTabItemButton.h"
#import "BMkit.h"
#import "UIButton+WebCache.h"

#define ITEM_ICON_WIDTH        (24.0f)

#define ITEM_NORMAL_COLOR       [UIColor bm_colorWithHex:0x666666]
#define ITEM_HIGHLIGHT_COLOR    [UIColor redColor]
#define ITEM_SELECTED_COLOR     [UIColor redColor]


@implementation BMTabItemClass

@end


@interface BMTabItemButton ()

@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) CGRect imageRect;

@end

@implementation BMTabItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.titleRect = CGRectMake(0, frame.size.height-20, frame.size.width, 15);

        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleNormalColor = ITEM_NORMAL_COLOR;
        self.titleSelectedColor = ITEM_SELECTED_COLOR;
        self.titleHighlightColor = nil;
        
        self.imageRect = CGRectMake((frame.size.width-ITEM_ICON_WIDTH)*0.5f, 5, ITEM_ICON_WIDTH, ITEM_ICON_WIDTH);
    }
    
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero))
    {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero))
    {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}

- (void)setItemTitle:(NSString *)title
{
    if ([title isEqual:_itemTitle])
    {
        return;
    }
    
    _itemTitle = title;
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    if ([titleNormalColor isEqual:_titleNormalColor])
    {
        return;
    }
    
    _titleNormalColor = titleNormalColor;
    [self setTitleColor:titleNormalColor forState:UIControlStateNormal];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    if ([titleSelectedColor isEqual:_titleSelectedColor])
    {
        return;
    }
    
    _titleSelectedColor = titleSelectedColor;
    [self setTitleColor:titleSelectedColor forState:UIControlStateSelected];
}

- (void)setTitleHighlightColor:(UIColor *)titleHighlightColor
{
    if ([titleHighlightColor isEqual:_titleHighlightColor])
    {
        return;
    }
    
    _titleHighlightColor = titleHighlightColor;
    [self setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
}

- (void)setNormalIcon:(NSString *)normalIcon
{
    if ([normalIcon isEqual:_normalIcon])
    {
        return;
    }
    
    _normalIcon = normalIcon;
    UIImage *image = [UIImage imageNamed:normalIcon];
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setSelectedIcon:(NSString *)selectedIcon
{
    if ([selectedIcon isEqual:_selectedIcon])
    {
        return;
    }
    
    _selectedIcon = selectedIcon;
    UIImage *image = [UIImage imageNamed:selectedIcon];
    [self setImage:image forState:UIControlStateSelected];
}

- (void)setHighlightIcon:(NSString *)highlightIcon
{
    if ([highlightIcon isEqual:_highlightIcon])
    {
        return;
    }
    
    _highlightIcon = highlightIcon;
    UIImage *image = [UIImage imageNamed:highlightIcon];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setNormalIconUrl:(NSString *)normalIconUrl
{
    if ([normalIconUrl isEqual:_normalIconUrl])
    {
        return;
    }
    
    _normalIconUrl = normalIconUrl;
    
    NSString *newURL;
    if (@available(iOS 9.0, *))
    {
        newURL = [normalIconUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        newURL = [normalIconUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
#pragma clang diagnostic pop
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:newURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:self.normalIcon]];
}

- (void)setSelectedIconUrl:(NSString *)selectedIconUrl
{
    if ([selectedIconUrl isEqual:_selectedIconUrl])
    {
        return;
    }
    
    _selectedIconUrl = selectedIconUrl;
    
    NSString *newURL;
    if (@available(iOS 9.0, *))
    {
        newURL = [selectedIconUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        newURL = [selectedIconUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
#pragma clang diagnostic pop
    }

    [self sd_setImageWithURL:[NSURL URLWithString:newURL] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:self.selectedIcon]];
}

- (void)setHighlightIconUrl:(NSString *)highlightIconUrl
{
    if ([highlightIconUrl isEqual:_highlightIconUrl])
    {
        return;
    }
    
    _highlightIconUrl = highlightIconUrl;
    
    NSString *newURL;
    if (@available(iOS 9.0, *))
    {
        newURL = [highlightIconUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        newURL = [highlightIconUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
#pragma clang diagnostic pop
    }

    [self sd_setImageWithURL:[NSURL URLWithString:newURL] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:self.highlightIcon]];
}

// 设置图标背景图组
- (void)setNormalIconName:(NSString *)normal
        highLightIconName:(NSString *)high
         selectedIconName:(NSString *)selected
{
    self.normalIcon = normal;
    self.highlightIcon = high;
    self.selectedIcon = selected;
}

- (void)setNormalIconUrl:(NSString *)normal
        highLightIconUrl:(NSString *)high
         selectedIconUrl:(NSString *)selected
{
    self.normalIconUrl = normal;
    self.highlightIconUrl = high;
    self.selectedIconUrl = selected;
    
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title
     normalColor:(UIColor *)normalColor
  highLightColor:(UIColor *)highLightColor
   selectedColor:(UIColor *)selectedColor
{
    if ([title bm_isNotEmpty])
    {
        self.itemTitle = title;
    }
    self.titleNormalColor = normalColor;
    self.titleHighlightColor = highLightColor;
    self.titleSelectedColor = selectedColor;
    
    [self setNeedsDisplay];
}

- (void)freshWithTabItem:(BMTabItemClass *)tabItem
{
    self.itemTitle = tabItem.title;
    self.titleNormalColor = tabItem.normalColor;
    //self.titleHighlightColor = nil;
    self.titleSelectedColor = tabItem.selectedColor;
    
    self.normalIcon = tabItem.normalIcon;
    //self.highlightIcon = high;
    self.selectedIcon = tabItem.selectedIcon;

    self.normalIconUrl = tabItem.normalIconUrl;
    //self.highlightIconUrl = high;
    self.selectedIconUrl = tabItem.selectedIconUrl;
    
    if (!(tabItem.selectedIcon || tabItem.selectedIconUrl))
    {
        if (tabItem.selectedColor)
        {
            UIImage *image = [self imageForState:UIControlStateNormal];
            if (image)
            {
                UIImage *simage = [image bm_imageWithTintColor:tabItem.selectedColor];
                [self setImage:simage forState:UIControlStateSelected];
            }
        }
    }
    
    [self setNeedsDisplay];
}

@end
