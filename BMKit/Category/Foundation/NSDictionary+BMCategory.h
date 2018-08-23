//
//  NSDictionary+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 16/1/21.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (BMCategory)

- (long long)bm_longForKey:(nonnull id)key;
- (long long)bm_longForKey:(nonnull id)key withDefault:(long long)theDefault;
- (long long)bm_longForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(long long)theDefault;
- (NSInteger)bm_intForKey:(nonnull id)key;
- (NSInteger)bm_intForKey:(nonnull id)key withDefault:(NSInteger)theDefault;
- (NSInteger)bm_intForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSInteger)theDefault;
- (NSUInteger)bm_uintForKey:(nonnull id)key;
- (NSUInteger)bm_uintForKey:(nonnull id)key withDefault:(NSUInteger)theDefault;
- (NSUInteger)bm_uintForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSUInteger)theDefault;

- (BOOL)bm_boolForKey:(nonnull id)key;
- (BOOL)bm_boolForKey:(nonnull id)key withDefault:(BOOL)theDefault;

- (float)bm_floatForKey:(nonnull id)key;
- (float)bm_floatForKey:(nonnull id)key withDefault:(float)theDefault;
- (float)bm_floatForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(float)theDefault;
- (float)bm_floatForKey:(nonnull id)key withDefault:(float)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
- (float)bm_floatForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(float)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

- (double)bm_doubleForKey:(nonnull id)key;
- (double)bm_doubleForKey:(nonnull id)key withDefault:(double)theDefault;
- (double)bm_doubleForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault;
- (double)bm_2PointDoubleForKey:(nonnull id)key;
- (double)bm_2PointDoubleForKey:(nonnull id)key withDefault:(double)theDefault;
- (double)bm_2PointDoubleForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault;
- (double)bm_doubleForKey:(nonnull id)key withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
- (double)bm_doubleForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

- (nullable NSDecimalNumber *)bm_numberForKey:(nonnull id)key;
- (nullable NSDecimalNumber *)bm_numberForKey:(nonnull id)key withDefault:(double)theDefault;
- (nullable NSDecimalNumber *)bm_numberForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault;
- (nullable NSDecimalNumber *)bm_2PointNumberForKey:(nonnull id)key;
- (nullable NSDecimalNumber *)bm_2PointNumberForKey:(nonnull id)key withDefault:(double)theDefault;
- (nullable NSDecimalNumber *)bm_2PointNumberForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault;
- (nullable NSDecimalNumber *)bm_2PointNumberForKey:(nonnull id)key withDefaultDecimalNumber:(nullable NSDecimalNumber *)theDefault;
- (nullable NSDecimalNumber *)bm_2PointNumberForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefaultDecimalNumber:(nullable NSDecimalNumber *)theDefault;
- (nullable NSDecimalNumber *)bm_numberForKey:(nonnull id)key withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
- (nullable NSDecimalNumber *)bm_numberForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

- (nullable NSDate *)bm_dateForKey:(nonnull id)key;
- (nullable NSDate *)bm_dateForKey:(nonnull id)key withFormat:(nullable NSString *)format;
- (nullable NSDate *)bm_dateForKey:(nonnull id)key withDefault:(nullable NSDate *)theDefault format:(nullable NSString *)format;

- (nullable NSString *)bm_stringForKey:(nonnull id)key;
- (nullable NSString *)bm_stringForKey:(nonnull id)key withDefault:(nullable NSString *)theDefault;
// 由于第三方库的问题,字典获取string使用以下方法.
- (nullable NSString *)bm_DJStringForKey:(nonnull id)key;
- (nullable NSString *)bm_DJStringForKey:(nonnull id)key withDefault:(nullable NSString *)theDefault;

- (nullable NSString *)bm_stringTrimForKey:(nonnull id)key;
- (nullable NSString *)bm_stringTrimForKey:(nonnull id)key withDefault:(nullable NSString *)theDefault;

- (CGPoint)bm_pointForKey:(nonnull id)key;
- (CGSize)bm_sizeForKey:(nonnull id)key;
- (CGRect)bm_rectForKey:(nonnull id)key;

- (nullable NSArray *)bm_arrayForKey:(nonnull id)key;
- (nullable NSDictionary *)bm_dictionaryForKey:(nonnull id)key;

- (BOOL)bm_containsObjectForKey:(nonnull id)key;

// 排序key
- (nonnull NSArray *)bm_allKeysSorted;
// 按key排序排列值
- (nonnull NSArray *)bm_allValuesSortedByKeys;

- (nullable NSString *)bm_toJSON;
- (nullable NSString *)bm_toJSONWithOptions:(NSJSONWritingOptions)options;
+ (nullable NSDictionary *)bm_dictionaryWithJsonString:(nullable NSString *)jsonString;

@end

@interface NSDictionary (BMDeepMutableCopy)

- (nullable NSMutableDictionary *)bm_deepMutableCopy;

@end

@interface NSMutableDictionary (BMSetCategory)

- (void)bm_setInteger:(NSInteger)value forKey:(nonnull id)key;
- (void)bm_setUInteger:(NSUInteger)value forKey:(nonnull id)key;
- (void)bm_setBool:(BOOL)value forKey:(nonnull id)key;
- (void)bm_setFloat:(float)value forKey:(nonnull id)key;
- (void)bm_setDouble:(double)value forKey:(nonnull id)key;
- (void)bm_setString:(nullable NSString *)value forKey:(nonnull id)key;

- (void)bm_setPoint:(CGPoint)value forKey:(nonnull id)key;
- (void)bm_setSize:(CGSize)value forKey:(nonnull id)key;
- (void)bm_setRect:(CGRect)value forKey:(nonnull id)key;

@end
