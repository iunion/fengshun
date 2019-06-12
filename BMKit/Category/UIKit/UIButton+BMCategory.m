//
//  UIButton+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 15/7/20.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import "UIButton+BMCategory.h"
#import "UIImage+BMCategory.h"


@implementation UIButton (BMCategory)

+ (instancetype)bm_buttonWithFrame:(CGRect)frame
{
    return [UIButton bm_buttonWithFrame:frame title:nil];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame title:(NSString *)title
{
    return [UIButton bm_buttonWithFrame:frame title:title backgroundImage:nil];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame title:(NSString *)title backgroundImage:(UIImage *)backgroundImage
{
    return [UIButton bm_buttonWithFrame:frame title:title backgroundImage:backgroundImage highlightedBackgroundImage:nil];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame title:(NSString *)title backgroundImage:(UIImage *)backgroundImage highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    
    return button;
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame title:(NSString *)title backgroundImage:(UIImage *)backgroundImage highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage  disableBackgroundImage:(UIImage *)disableBackgroundImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:disableBackgroundImage forState:UIControlStateDisabled];

    return button;
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIButton bm_buttonWithFrame:frame title:title backgroundImage:[UIImage imageWithColor:color] highlightedBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:components[0]-0.1 green:components[1]-0.1 blue:components[2]-0.1 alpha:1]]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor
{
    return [UIButton bm_buttonWithFrame:frame title:title backgroundImage:[UIImage imageWithColor:color] highlightedBackgroundImage:[UIImage imageWithColor:highlightedColor]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame color:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIButton bm_buttonWithFrame:frame title:nil backgroundImage:[UIImage imageWithColor:color] highlightedBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:components[0]-0.1 green:components[1]-0.1 blue:components[2]-0.1 alpha:1]]];
}

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color disableColor:(nonnull UIColor *)disableColor
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIButton bm_buttonWithFrame:frame title:nil backgroundImage:[UIImage imageWithColor:color] highlightedBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:components[0]-0.1 green:components[1]-0.1 blue:components[2]-0.1 alpha:1]] disableBackgroundImage:[UIImage imageWithColor:disableColor]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor
{
    return [UIButton bm_buttonWithFrame:frame title:nil backgroundImage:[UIImage imageWithColor:color] highlightedBackgroundImage:[UIImage imageWithColor:highlightedColor]];
}

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor disableColor:(nonnull UIColor *)disableColor
{
    return [UIButton bm_buttonWithFrame:frame title:nil backgroundImage:[UIImage imageWithColor:color] highlightedBackgroundImage:[UIImage imageWithColor:highlightedColor] disableBackgroundImage:[UIImage imageWithColor:disableColor]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    return [UIButton bm_buttonWithFrame:frame image:[UIImage imageNamed:imageName]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [UIButton bm_buttonWithFrame:frame image:image highlightedImage:nil];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName
{
    return [UIButton bm_buttonWithFrame:frame image:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:highlightedImageName]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    return button;
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImageName:(NSString *)imageName
{
    return [UIButton bm_buttonWithFrame:frame backgroundImage:[UIImage imageNamed:imageName]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImage:(UIImage *)image
{
    return [UIButton bm_buttonWithFrame:frame backgroundImage:image highlightedBackgroundImage:nil];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImageName:(NSString *)imageName highlightedBackgroundImageName:(NSString *)highlightedImageName
{
    return [UIButton bm_buttonWithFrame:frame backgroundImage:[UIImage imageNamed:imageName] highlightedBackgroundImage:[UIImage imageNamed:highlightedImageName]];
}

+ (instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImage:(UIImage *)image highlightedBackgroundImage:(UIImage *)highlightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    return button;
}

- (void)bm_setImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName
{
    [self bm_setImage:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:highlightedImageName]];
}

- (void)bm_setImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    [self bm_setImage:image highlightedImage:highlightedImage selectedImage:nil];
}

- (void)bm_setImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName selectedImageName:(NSString *)selectedImageName
{
    [self bm_setImage:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:highlightedImageName] selectedImage:[UIImage imageNamed:selectedImageName]];
}

- (void)bm_setImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (void)bm_setBackgroundImageName:(NSString *)imageName highlightedBackgroundImageName:(NSString *)highlightedImageName
{
    [self bm_setBackgroundImage:[UIImage imageNamed:imageName] highlightedBackgroundImage:[UIImage imageNamed:highlightedImageName]];
}

- (void)bm_setBackgroundImage:(UIImage *)image highlightedBackgroundImage:(UIImage *)highlightedImage
{
    [self bm_setBackgroundImage:image highlightedBackgroundImage:highlightedImage selectedBackgroundImage:nil];
}

- (void)bm_setBackgroundImageName:(NSString *)imageName highlightedBackgroundImageName:(NSString *)highlightedImageName selectedBackgroundImageName:(NSString *)selectedImageName
{
    [self bm_setBackgroundImage:[UIImage imageNamed:imageName] highlightedBackgroundImage:[UIImage imageNamed:highlightedImageName] selectedBackgroundImage:[UIImage imageNamed:selectedImageName]];
}

- (void)bm_setBackgroundImage:(UIImage *)image highlightedBackgroundImage:(UIImage *)highlightedImage selectedBackgroundImage:(UIImage *)selectedImage
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
}

- (void)bm_setTitleColor:(UIColor *)color
{
    [self bm_setTitleColor:color highlightedColor:[color colorWithAlphaComponent:0.4]];
}

- (void)bm_setTitleColor:(UIColor *)color highlightedColor:(UIColor *)highlightedColor
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
}

- (void)bm_setTitleColor:(UIColor *)color highlightedColor:(UIColor *)highlightedColor selectedColor:(UIColor *)selectedColor
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
}

- (void)bm_setBackgroundImageWithColor:(nonnull UIColor *)color
{
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
}

- (void)bm_setBackgroundImageWithColor:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor
{
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
}

- (void)bm_setBackgroundImageWithColor:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor selectedColor:(nonnull UIColor *)selectedColor
{
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:UIControlStateDisabled];
}

@end
