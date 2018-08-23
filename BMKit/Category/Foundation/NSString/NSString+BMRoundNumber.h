//
//  NSString+BMRoundNumber.h
//  miaoqian
//
//  Created by DennisDeng on 2017/5/26.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BMRoundNumber)

+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale;
+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded;
+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded decimalStyle:(BOOL)isDecimalStyle;
+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;
+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits decimalStyle:(BOOL)isDecimalStyle;

+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale;
+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded;
+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded decimalStyle:(BOOL)isDecimalStyle;
+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;
+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits decimalStyle:(BOOL)isDecimalStyle;

+ (NSString *)bm_stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;
+ (NSString *)bm_stringFromNumber:(NSNumber *)number maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;
+ (NSString *)bm_stringFromNumber:(NSNumber *)number maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits decimalStyle:(BOOL)isDecimalStyle;

@end

NS_ASSUME_NONNULL_END
