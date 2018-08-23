//
//  NSDecimalNumber+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 16/7/2.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (BMCategory)

+ (NSDecimalNumber *)bm_rounding:(double)value withScale:(short)scale mode:(NSRoundingMode)roundingMode;
+ (NSDecimalNumber *)bm_roundingNumber:(NSDecimalNumber *)ouncesDecimal withScale:(short)scale mode:(NSRoundingMode)roundingMode;

+ (NSDecimalNumber *)bm_decimalNumberWithFloat:(float)value;
+ (NSDecimalNumber *)bm_decimalNumberWithDouble:(double)value;
+ (NSDecimalNumber *)bm_decimalNumberWithBool:(BOOL)value;
+ (NSDecimalNumber *)bm_decimalNumberWithInteger:(NSInteger)value NS_AVAILABLE(10_5, 2_0);
+ (NSDecimalNumber *)bm_decimalNumberWithUnsignedInteger:(NSUInteger)value NS_AVAILABLE(10_5, 2_0);

/**
 *  Return a decimal number from float value, and rounds it off in the way specified by scale. The rounding mode is NSRoundPlain.
 *
 *  @param value Float value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 */
+ (NSDecimalNumber *)bm_decimalNumberWithFloat:(float)value roundingScale:(short)scale;

/**
 *  Return a decimal number from float value, and rounds it off in the way specified by scale and roundingMode.
 *
 *  @param value Float value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 *  @param mode  The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 */
+ (NSDecimalNumber *)bm_decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

/**
 *  Return a decimal number from double value, and rounds it off in the way specified by scale. The rounding mode is NSRoundPlain.
 *
 *  @param value Double value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 */
+ (NSDecimalNumber *)bm_decimalNumberWithDouble:(double)value roundingScale:(short)scale;

/**
 *  Return a decimal number from double value, and rounds it off in the way specified by scale and roundingMode.
 *
 *  @param value Double value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 *  @param mode  The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 */
+ (NSDecimalNumber *)bm_decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

#pragma mark - Round
/**
 *  Rounds a decimal number off in the way specified by scale. The rounding mode is NSRoundPlain.
 *
 *  @param scale The number of digits a rounded value should have after its decimal point.
 */
- (NSDecimalNumber *)bm_roundToScale:(short)scale;

/**
 *  Rounds a decimal number off in the way specified by scale and roundingMode.
 *
 *  @param scale        The number of digits a rounded value should have after its decimal point.
 *  @param roundingMode The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 */
- (NSDecimalNumber *)bm_roundToScale:(short)scale mode:(NSRoundingMode)roundingMode;


- (BOOL)bm_isEqualToDecimalNumber:(NSDecimalNumber *)number;
- (BOOL)bm_isGreaterThanDecimalnumber:(NSDecimalNumber *)number;
- (BOOL)bm_isGreaterThanOrEqualToDecimalnumber:(NSDecimalNumber *)number;
- (BOOL)bm_isLessThanDecimalnumber:(NSDecimalNumber *)number;
- (BOOL)bm_isLessThanOrEqualToDecimalnumber:(NSDecimalNumber *)number;

@end

NS_ASSUME_NONNULL_END

