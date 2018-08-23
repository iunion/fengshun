//
//  NSDecimalNumber+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 16/7/2.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import "NSDecimalNumber+BMCategory.h"


@implementation NSDecimalNumber (BMCategory)

+ (NSDecimalNumber *)bm_rounding:(double)value withScale:(short)scale mode:(NSRoundingMode)roundingMode
{
    NSDecimalNumber *ouncesDecimal;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:value];
    return [NSDecimalNumber bm_roundingNumber:ouncesDecimal withScale:scale mode:roundingMode];
}

+ (NSDecimalNumber *)bm_roundingNumber:(NSDecimalNumber *)ouncesDecimal withScale:(short)scale mode:(NSRoundingMode)roundingMode
{
    return [ouncesDecimal bm_roundToScale:scale mode:roundingMode];
}

+ (NSDecimalNumber *)bm_decimalNumberWithFloat:(float)value
{
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithFloat:value];

    return decimalNumber;
}

+ (NSDecimalNumber *)bm_decimalNumberWithFloat:(float)value roundingScale:(short)scale
{
    return [[[NSDecimalNumber alloc] initWithFloat:value] bm_roundToScale:scale];
}

+ (NSDecimalNumber *)bm_decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [[[NSDecimalNumber alloc] initWithFloat:value] bm_roundToScale:scale mode:mode];
}

+ (NSDecimalNumber *)bm_decimalNumberWithDouble:(double)value
{
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithDouble:value];
    
    return decimalNumber;
}

+ (NSDecimalNumber *)bm_decimalNumberWithDouble:(double)value roundingScale:(short)scale
{
    return [[[NSDecimalNumber alloc] initWithDouble:value] bm_roundToScale:scale];
}

+ (NSDecimalNumber *)bm_decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [[[NSDecimalNumber alloc] initWithDouble:value] bm_roundToScale:scale mode:mode];
}

+ (NSDecimalNumber *)bm_decimalNumberWithBool:(BOOL)value
{
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithBool:value];
    
    return decimalNumber;
}

+ (NSDecimalNumber *)bm_decimalNumberWithInteger:(NSInteger)value
{
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithInteger:value];
    
    return decimalNumber;
}

+ (NSDecimalNumber *)bm_decimalNumberWithUnsignedInteger:(NSUInteger)value
{
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithUnsignedInteger:value];
    
    return decimalNumber;
}


#pragma mark - Round

- (NSDecimalNumber *)bm_roundToScale:(short)scale
{
    return [self bm_roundToScale:scale mode:NSRoundPlain];
}

- (NSDecimalNumber *)bm_roundToScale:(short)scale mode:(NSRoundingMode)roundingMode
{
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    
    return [self decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
}


#pragma mark -
#pragma mark compare
// NSOrderedAscending, NSOrderedSame, NSOrderedDescending
- (BOOL)bm_isEqualToDecimalNumber:(NSDecimalNumber *)number
{
    BOOL result = ([self compare:number] == NSOrderedSame);
    return result;
}

- (BOOL)bm_isGreaterThanDecimalnumber:(NSDecimalNumber *)number
{
    BOOL result = ([self compare:number] == NSOrderedDescending);
    return result;
}

- (BOOL)bm_isGreaterThanOrEqualToDecimalnumber:(NSDecimalNumber *)number
{
    BOOL result = ([self compare:number] != NSOrderedAscending);
    return result;
}

- (BOOL)bm_isLessThanDecimalnumber:(NSDecimalNumber *)number
{
    BOOL result = ([self compare:number] == NSOrderedAscending);
    return result;
}

- (BOOL)bm_isLessThanOrEqualToDecimalnumber:(NSDecimalNumber *)number
{
    BOOL result = ([self compare:number] != NSOrderedDescending);
    return result;
}

@end
