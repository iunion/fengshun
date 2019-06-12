//
//  UIButton+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 15/7/20.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BMCategory)

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame title:(nullable NSString *)title;

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame title:(nullable NSString *)title backgroundImage:(nullable UIImage *)backgroundImage;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame title:(nullable NSString *)title backgroundImage:(nullable UIImage *)backgroundImage highlightedBackgroundImage:(nullable UIImage *)highlightedBackgroundImage;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame title:(nullable NSString *)title backgroundImage:(nullable UIImage *)backgroundImage highlightedBackgroundImage:(nullable UIImage *)highlightedBackgroundImage  disableBackgroundImage:(nullable UIImage *)disableBackgroundImage;

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame title:(nullable NSString *)title color:(nonnull UIColor *)color;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame title:(nullable NSString *)title color:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor;

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color disableColor:(nonnull UIColor *)disableColor;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor disableColor:(nonnull UIColor *)disableColor;

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame imageName:(nonnull NSString *)imageName;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame image:(nullable UIImage *)image;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame imageName:(nonnull NSString *)imageName highlightedImageName:(nonnull NSString *)highlightedImageName;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame image:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImageName:(nonnull NSString *)imageName;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImage:(nullable UIImage *)image;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImageName:(nonnull NSString *)imageName highlightedBackgroundImageName:(nonnull NSString *)highlightedImageName;
+ (nonnull instancetype)bm_buttonWithFrame:(CGRect)frame backgroundImage:(nullable UIImage *)image highlightedBackgroundImage:(nullable UIImage *)highlightedImage;

- (void)bm_setImageName:(nonnull NSString *)imageName highlightedImageName:(nonnull NSString *)highlightedImageName;
- (void)bm_setImage:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;
- (void)bm_setImageName:(nonnull NSString *)imageName highlightedImageName:(nonnull NSString *)highlightedImageName selectedImageName:(nonnull NSString *)selectedImageName;
- (void)bm_setImage:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage selectedImage:(nullable UIImage *)selectedImage;

- (void)bm_setBackgroundImageName:(nonnull NSString *)imageName highlightedBackgroundImageName:(nonnull NSString *)highlightedImageName;
- (void)bm_setBackgroundImage:(nullable UIImage *)image highlightedBackgroundImage:(nullable UIImage *)highlightedImage;
- (void)bm_setBackgroundImageName:(nonnull NSString *)imageName highlightedBackgroundImageName:(nonnull NSString *)highlightedImageName selectedBackgroundImageName:(nonnull NSString *)selectedImageName;
- (void)bm_setBackgroundImage:(nullable UIImage *)image highlightedBackgroundImage:(nullable UIImage *)highlightedImage selectedBackgroundImage:(nullable UIImage *)selectedImage;

- (void)bm_setTitleColor:(nonnull UIColor *)color;
- (void)bm_setTitleColor:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor;
- (void)bm_setTitleColor:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor selectedColor:(nonnull UIColor *)selectedColor;

- (void)bm_setBackgroundImageWithColor:(nonnull UIColor *)color;
- (void)bm_setBackgroundImageWithColor:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor;
- (void)bm_setBackgroundImageWithColor:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor selectedColor:(nonnull UIColor *)selectedColor;

@end
