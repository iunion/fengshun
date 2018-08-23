//
//  UILabel+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 15/7/20.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (BMCategory)

+ (instancetype)bm_labelWithFrame:(CGRect)frame text:(nullable NSString *)text fontSize:(CGFloat)fontSize color:(nullable UIColor *)color alignment:(NSTextAlignment)alignment lines:(NSInteger)lines;
+ (instancetype)bm_labelWithFrame:(CGRect)frame text:(nullable NSString *)text fontSize:(CGFloat)fontSize color:(nullable UIColor *)color alignment:(NSTextAlignment)alignment lines:(NSInteger)lines shadowColor:(nullable UIColor *)txtShadowColor;


- (CGSize)bm_attribSizeToFitWidth:(CGFloat)width;
- (CGSize)bm_attribSizeToFitHeight:(CGFloat)height;
- (CGSize)bm_attribSizeToFit:(CGSize)maxSize;

// 以下不支持attributedText带属性计算，只支持普通text
- (CGSize)bm_labelSizeToFitWidth:(CGFloat)width;
- (CGSize)bm_labelSizeToFitHeight:(CGFloat)height;
- (CGSize)bm_labelSizeToFit:(CGSize)maxSize;

- (CGFloat)bm_calculatedHeight;

@end

NS_ASSUME_NONNULL_END

