//
//  UIImageView+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 15-2-26.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (BMCategory)

+ (instancetype)bm_imageViewWithImageNamed:(NSString *)imageName;
+ (instancetype)bm_imageViewWithFrame:(CGRect)frame;
+ (instancetype)bm_imageViewWithStretchableImage:(NSString *)imageName Frame:(CGRect)frame;
+ (nullable instancetype)bm_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration;
+ (nullable instancetype)bm_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount;

- (void)bm_setImageWithStretchableImage:(NSString *)imageName;
- (void)bm_setImageWithStretchableImage:(NSString *)imageName atPoint:(CGPoint)point;

- (void)bm_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount;
- (void)bm_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount imageWithIndex:(NSUInteger)index;

// 画水印
// 图片水印
- (void)bm_setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect;
// 文字水印
- (void)bm_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;
- (void)bm_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;

@end
NS_ASSUME_NONNULL_END
