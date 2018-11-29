//
//  NSNumber+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 16/1/21.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import "NSNumber+BMCategory.h"


@implementation NSNumber (BMCategory)

- (NSString *)bm_stringWithDecimalStyle
{
    if ([self compare:[NSDecimalNumber zero]] == NSOrderedSame)
    {
        return @"0.00";
    }
    else
    {
        return [self bm_stringWithNormalDecimalStyle];
    }
}

- (NSString *)bm_stringWithNormalDecimalStyle
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.maximumFractionDigits = 2;
    numberFormatter.minimumFractionDigits = 0;
    
    return [self bm_stringWithNumberFormat:numberFormatter];
}

- (NSString *)bm_stringWithNoStyleDecimalScale:(short)scale
{
    return [self bm_stringWithNoStyleMaximumFractionDigits:scale minimumFractionDigits:scale];
}

- (NSString *)bm_stringWithNoStyleDecimalNozeroScale:(short)scale
{
    return [self bm_stringWithNoStyleMaximumFractionDigits:scale minimumFractionDigits:0];
}

- (NSString *)bm_stringWithNoStyleMaximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.minimumIntegerDigits = 1;
    numberFormatter.maximumFractionDigits = maximumFractionDigits;
    numberFormatter.minimumFractionDigits = minimumFractionDigits;
    
    return [self bm_stringWithNumberFormat:numberFormatter];
}

- (NSString *)bm_stringWithDecimalStyleDecimalScale:(short)scale
{
    return [self bm_stringWithDecimalStyleMaximumFractionDigits:scale minimumFractionDigits:scale];
}

- (NSString *)bm_stringWithDecimalStyleMaximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.maximumFractionDigits = maximumFractionDigits;
    numberFormatter.minimumFractionDigits = minimumFractionDigits;
    
    return [self bm_stringWithNumberFormat:numberFormatter];
}

- (NSString *)bm_stringWithNumberFormatUsePositiveFormat:(NSString *)positiveFormat
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;//kCFNumberFormatterNoStyle;
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;

    numberFormatter.positiveFormat = positiveFormat;
    
    //numberFormatter.positiveFormat = @"#,##0.00";
    //numberFormatter.formatWidth = 20; // 数据宽度为20，
    //numberFormatter.paddingCharacter = @"a"; // 不足前面补 a
    
    //numberFormatter.locale = [NSLocale currentLocale]; // 本地化
    //numberFormatter.generatesDecimalNumbers = NO; // 默认 NO,YES-转换成 NSNumber 方法会转换成 NSDecimalNumber
//    if ([[numberFormatter numberFromString:str] isKindOfClass:[NSDecimalNumber class]]) {
//        BMLog(@"NSDecimalNumber");
//    } else if ([[numberFormatter numberFromString:str] isKindOfClass:[NSNumber class]]) {
//        BMLog(@"NSNumber");
//    }
//    NSDecimalNumber *dnumber = (NSDecimalNumber *)[numberFormatter numberFromString:str];

    return [self bm_stringWithNumberFormat:numberFormatter];
}

- (NSString *)bm_stringWithNumberFormat:(NSNumberFormatter *)formatter
{
    NSString *formattedNumberString = [formatter stringFromNumber:self];
    
    //LLog(@"formattedNumberString: %@", formattedNumberString);
    
    return formattedNumberString;
}

// 123456789

// NSNumberFormatterNoStyle -> 123456789,
// NSNumberFormatterDecimalStyle -> 123,456,789,
// NSNumberFormatterCurrencyStyle -> ￥123,456,789.00/US$123,456,789.00,
// NSNumberFormatterPercentStyle -> -2,147,483,648%,
// NSNumberFormatterScientificStyle -> 1.23456789E8,
// NSNumberFormatterSpellOutStyle -> 一亿二千三百四十五万六千七百八十九/one hundred twenty-three million four hundred fifty-six thousand seven hundred eighty-nine,
// NSNumberFormatterOrdinalStyle -> 第1,2345,6789/123,456,789th,
// NSNumberFormatterCurrencyISOCodeStyle -> USD123,456,789.00,
// NSNumberFormatterCurrencyPluralStyle -> 123,456,789.00美元/123,456,789.00 US dollars,
// NSNumberFormatterCurrencyAccountingStyle -> US$123,456,789.00,


@end
