//
//  NSNumber+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 16/1/21.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (BMCategory)

// 0 --> 0.00
- (nullable NSString *)bm_stringWithDecimalStyle;

// 0 --> 0
- (nullable NSString *)bm_stringWithNormalDecimalStyle;

// 转换数字保留scale位小数
- (nullable NSString *)bm_stringWithNoStyleDecimalScale:(short)scale;
- (nullable NSString *)bm_stringWithNoStyleDecimalNozeroScale:(short)scale;
- (nullable NSString *)bm_stringWithDecimalStyleDecimalScale:(short)scale;

- (nullable NSString *)bm_stringWithNoStyleMaximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;
- (nullable NSString *)bm_stringWithDecimalStyleMaximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;

- (nullable NSString *)bm_stringWithNumberFormatUsePositiveFormat:(nullable NSString *)positiveFormat;

- (nullable NSString *)bm_stringWithNumberFormat:(nullable NSNumberFormatter *)formatter;

@end
