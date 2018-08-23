//
//  NSString+BMRoundNumber.m
//  miaoqian
//
//  Created by DennisDeng on 2017/5/26.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "NSString+BMRoundNumber.h"
#import "NSDecimalNumber+BMCategory.h"

@implementation NSString (BMRoundNumber)

+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale
{
    return [NSString bm_stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain];
}

+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [NSString bm_stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:NO];
}

+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded
{
    return [NSString bm_stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:NO decimalStyle:NO];
}

+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded decimalStyle:(BOOL)isDecimalStyle
{
    if (isPadded)
    {
        return [NSString bm_stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain maximumFractionDigits:scale minimumFractionDigits:scale decimalStyle:isDecimalStyle];
    }
    
    NSDecimalNumber *decimalNumber = [NSDecimalNumber bm_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString stringWithFormat:@"%@", decimalNumber];
}

+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits
{
    return [NSString bm_stringFromFloat:value roundingScale:scale roundingMode:mode maximumFractionDigits:maximumFractionDigits minimumFractionDigits:minimumFractionDigits decimalStyle:NO];
}

+ (NSString *)bm_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits decimalStyle:(BOOL)isDecimalStyle
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber bm_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString bm_stringFromNumber:decimalNumber maximumFractionDigits:maximumFractionDigits minimumFractionDigits:minimumFractionDigits decimalStyle:isDecimalStyle];
}

+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale
{
    return [NSString bm_stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain];
}

+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [NSString bm_stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:NO];
}

+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded
{
    return [NSString bm_stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:NO decimalStyle:NO];
}

+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded decimalStyle:(BOOL)isDecimalStyle
{
    if (isPadded)
    {
        return [NSString bm_stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain maximumFractionDigits:scale minimumFractionDigits:scale decimalStyle:isDecimalStyle];
    }
    
    NSDecimalNumber *decimalNumber = [NSDecimalNumber bm_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString stringWithFormat:@"%@", decimalNumber];
}

+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits
{
    return [NSString bm_stringFromDouble:value roundingScale:scale roundingMode:mode maximumFractionDigits:maximumFractionDigits minimumFractionDigits:minimumFractionDigits decimalStyle:NO];
}

+ (NSString *)bm_stringFromDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits decimalStyle:(BOOL)isDecimalStyle
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber bm_decimalNumberWithDouble:value roundingScale:scale roundingMode:mode];
    return [NSString bm_stringFromNumber:decimalNumber maximumFractionDigits:maximumFractionDigits minimumFractionDigits:minimumFractionDigits decimalStyle:isDecimalStyle];
}

+ (NSString *)bm_stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits
{
    return [NSString bm_stringFromNumber:number maximumFractionDigits:fractionDigits minimumFractionDigits:fractionDigits];
}

+ (NSString *)bm_stringFromNumber:(NSNumber *)number maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits
{
    return [NSString bm_stringFromNumber:number maximumFractionDigits:maximumFractionDigits minimumFractionDigits:minimumFractionDigits decimalStyle:NO];
}

+ (NSString *)bm_stringFromNumber:(NSNumber *)number maximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits decimalStyle:(BOOL)isDecimalStyle
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setMaximumFractionDigits:maximumFractionDigits];
    [numberFormatter setMinimumFractionDigits:minimumFractionDigits];
    if (isDecimalStyle)
    {
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    
    return [numberFormatter stringFromNumber:number];
}

@end
