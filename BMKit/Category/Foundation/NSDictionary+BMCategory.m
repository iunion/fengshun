//
//  NSDictionary+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 16/1/21.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import "NSDictionary+BMCategory.h"
#import "NSArray+BMCategory.h"
#import "NSObject+BMCategory.h"
#import "NSDate+BMCategory.h"
#import "NSString+BMCategory.h"
#import "NSDecimalNumber+BMCategory.h"

// 默认转换浮点数，双精度数保留2位小数
#define BMDefaultRoundingScale  2

@implementation NSDictionary (BMCategory)

- (long long)bm_longForKey:(id)key
{
    return [self bm_longForKey:key withDefault:0];
}

- (long long)bm_longForKey:(id)key withDefault:(long long)theDefault
{
    return [self bm_longForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (long long)bm_longForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(long long)theDefault
{
    long long value = 0;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        if ([object isKindOfClass:[NSString class]])
        {
            // ((NSString *)object).longLongValue;
            // @"1,000" -> 1
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = numberStyle;
            object = [nf numberFromString:object];
        }
        
        if ([object isKindOfClass:[NSNumber class]])
        {
            value = [object longLongValue];
        }
    }
    
    return value;
}

- (NSInteger)bm_intForKey:(id)key
{
    return [self bm_intForKey:key withDefault:0];
}

- (NSInteger)bm_intForKey:(id)key withDefault:(NSInteger)theDefault
{
    return [self bm_intForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (NSInteger)bm_intForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSInteger)theDefault
{
    NSInteger value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = numberStyle;
            object = [nf numberFromString:object];
        }
        
        if ([object isKindOfClass:[NSNumber class]])
        {
            value = [object integerValue];
        }
    }
    
    return value;
}

- (NSUInteger)bm_uintForKey:(id)key
{
    return [self bm_uintForKey:key withDefault:0];
}

- (NSUInteger)bm_uintForKey:(id)key withDefault:(NSUInteger)theDefault
{
    return [self bm_uintForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (NSUInteger)bm_uintForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSUInteger)theDefault
{
    NSUInteger value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = numberStyle;
            object = [nf numberFromString:object];
        }
        
        if ([object isKindOfClass:[NSNumber class]])
        {
            return [object unsignedIntegerValue];
        }
    }
    
    return value;
}

- (BOOL)bm_boolForKey:(id)key
{
    return [self bm_boolForKey:key withDefault:NO];
}

- (BOOL)bm_boolForKey:(id)key withDefault:(BOOL)theDefault
{
    BOOL value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        value = [object boolValue];
    }
    
    return value;
}

- (float)bm_floatForKey:(id)key
{
    return [self bm_floatForKey:key withDefault:0.0f];
}

- (float)bm_floatForKey:(id)key withDefault:(float)theDefault
{
    return [self bm_floatForKey:key withDefault:theDefault roundingScale:BMDefaultRoundingScale roundingMode:NSRoundPlain];
}

- (float)bm_floatForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(float)theDefault
{
    return [self bm_floatForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:BMDefaultRoundingScale roundingMode:NSRoundPlain];
}

- (float)bm_floatForKey:(id)key withDefault:(float)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [self bm_floatForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault roundingScale:BMDefaultRoundingScale roundingMode:mode];
}

- (float)bm_floatForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(float)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    NSDecimalNumber *value = [self bm_numberForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:scale roundingMode:mode];
    
    return [value floatValue];
}

- (double)bm_doubleForKey:(id)key
{
    return [self bm_doubleForKey:key withDefault:0.0f];
}

- (double)bm_doubleForKey:(id)key withDefault:(double)theDefault
{
    return [self bm_doubleForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (double)bm_doubleForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault
{
    return [self bm_doubleForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:BMDefaultRoundingScale roundingMode:NSRoundPlain];
}

- (double)bm_2PointDoubleForKey:(id)key
{
    return [self bm_2PointDoubleForKey:key withDefault:0.0f];
}

- (double)bm_2PointDoubleForKey:(id)key withDefault:(double)theDefault
{
    return [self bm_2PointDoubleForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (double)bm_2PointDoubleForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault
{
    return [self bm_doubleForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:2 roundingMode:NSRoundPlain];
}

- (double)bm_doubleForKey:(id)key withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [self bm_doubleForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault roundingScale:scale roundingMode:mode];
}

- (double)bm_doubleForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    NSDecimalNumber *value = [self bm_numberForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:scale roundingMode:mode];
    
    return [value doubleValue];
}

- (NSDecimalNumber *)bm_numberForKey:(id)key
{
    return [self bm_numberForKey:key withDefault:0.0f];
}

- (NSDecimalNumber *)bm_numberForKey:(id)key withDefault:(double)theDefault
{
    return [self bm_numberForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (NSDecimalNumber *)bm_numberForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault
{
    return [self bm_numberForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:BMDefaultRoundingScale roundingMode:NSRoundPlain];
}

- (NSDecimalNumber *)bm_numberForKey:(id)key withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [self bm_numberForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault  roundingScale:scale roundingMode:mode];
}

- (NSDecimalNumber *)bm_numberForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [self bm_numberForKey:key formatNumberStyle:numberStyle withDefault:@(theDefault) roundingScale:scale roundingMode:mode isDouble:YES];
}


- (NSDecimalNumber *)bm_2PointNumberForKey:(id)key
{
    return [self bm_numberForKey:key withDefault:0.0f roundingScale:2 roundingMode:NSRoundPlain];
}

- (NSDecimalNumber *)bm_2PointNumberForKey:(id)key withDefault:(double)theDefault
{
    return [self bm_2PointNumberForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (NSDecimalNumber *)bm_2PointNumberForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(double)theDefault
{
    return [self bm_numberForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:2 roundingMode:NSRoundPlain];
}

- (NSDecimalNumber *)bm_2PointNumberForKey:(id)key withDefaultDecimalNumber:(NSDecimalNumber *)theDefault
{
    return [self bm_2PointNumberForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefaultDecimalNumber:theDefault];
}

- (NSDecimalNumber *)bm_2PointNumberForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefaultDecimalNumber:(NSDecimalNumber *)theDefault
{
    return [self bm_numberForKey:key formatNumberStyle:numberStyle withDefault:theDefault roundingScale:2 roundingMode:NSRoundPlain isDouble:NO];
}

- (NSDecimalNumber *)bm_numberForKey:(id)key withDefault:(id)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode isDouble:(BOOL)isDouble
{
    return [self bm_numberForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault roundingScale:scale roundingMode:mode isDouble:isDouble];
}

- (NSDecimalNumber *)bm_numberForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(id)theDefault roundingScale:(short)scale roundingMode:(NSRoundingMode)mode isDouble:(BOOL)isDouble
{
    NSDecimalNumber *value = isDouble ? [[NSDecimalNumber alloc] initWithDouble:[theDefault doubleValue]] : theDefault;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided])
    {
        if ([object isKindOfClass:[NSNumber class]])
        {
            value = [[NSDecimalNumber alloc] initWithDecimal:[((NSNumber *)object) decimalValue]];
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = numberStyle;
            NSNumber *number = [nf numberFromString:object];
            
            if ([number isKindOfClass:[NSNumber class]])
            {
                value = [[NSDecimalNumber alloc] initWithDecimal:[number decimalValue]];
            }
            else
            {
                value = [NSDecimalNumber decimalNumberWithString:(NSString *)object];
            }
            
            if ([value isEqualToNumber:[NSDecimalNumber notANumber]])
            {
                value = isDouble ? [[NSDecimalNumber alloc] initWithDouble:[theDefault doubleValue]] : theDefault;
            }
        }
    }
    
    if (scale < 0)
    {
        return value;
    }
    
    NSDecimalNumber *rounded = [NSDecimalNumber bm_roundingNumber:value withScale:scale mode:mode];
    
    return rounded;
};

- (NSDate *)bm_dateForKey:(id)key
{
    return [self bm_dateForKey:key withDefault:nil format:nil];
}

- (NSDate *)bm_dateForKey:(id)key withFormat:(NSString *)format
{
    return [self bm_dateForKey:key withDefault:nil format:format];
}

- (NSDate *)bm_dateForKey:(id)key withDefault:(NSDate *)theDefault format:(NSString *)format
{
    NSDate *value = theDefault;
    
    id object = [self objectForKey:key];
    
    if ([object bm_isValided])
    {
        if ([object isKindOfClass:[NSDate class]])
        {
            return (NSDate *)object;
        }
        
        if (![format bm_isNotEmpty])
        {
            if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]])
            {
                value = [NSDate dateWithTimeIntervalSince1970:[object doubleValue]];
            }
        }
        else
        {
            if ([object isKindOfClass:[NSString class]])
            {
                value = [NSDate bm_dateFromString:object withFormat:format];
            }
        }
    }
    
    return value;
}

- (NSString *)bm_stringForKey:(id)key
{
    return [self bm_stringForKey:key withDefault:nil];
}

- (NSString *)bm_DJStringForKey:(id)key
{
    return [self bm_DJStringForKey:key withDefault:nil];
}


- (NSString *)bm_stringForKey:(id)key withDefault:(NSString *)theDefault
{
    NSString *value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided])
    {
        if ([object isKindOfClass:[NSString class]])
        {
            value = (NSString *)object;
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            value = ((NSNumber *)object).stringValue;
        }
        else if ([object isKindOfClass:[NSURL class]])
        {
            value = ((NSURL *)object).absoluteString;
        }
    }
    
    return value;
}

- (NSString *)bm_DJStringForKey:(id)key withDefault:(NSString *)theDefault
{
    NSString *value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided])
    {
        if ([object isKindOfClass:[NSString class]])
        {
            value = (NSString *)object;
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            value = ((NSNumber *)object).stringValue;
        }
        else if ([object isKindOfClass:[NSURL class]])
        {
            value = ((NSURL *)object).absoluteString;
        }
    }
    
    return value;
}


- (NSString *)bm_stringTrimForKey:(id)key
{
    return [self bm_stringTrimForKey:key withDefault:nil];
}

- (NSString *)bm_stringTrimForKey:(id)key withDefault:(NSString *)theDefault
{
    NSString *value = [self bm_stringForKey:key withDefault:theDefault];
    
    return [value bm_trim];
}

- (CGPoint)bm_pointForKey:(id)key
{
    CGPoint point = CGPointZero;
    NSDictionary *dictionary = [self valueForKey:key];
    
    if ([dictionary bm_isValided] && [dictionary isKindOfClass:[NSDictionary class]])
    {
        BOOL success = CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)dictionary, &point);
        if (success)
            return point;
        else
            return CGPointZero;
    }
    
    return CGPointZero;
}

- (CGSize)bm_sizeForKey:(id)key
{
    CGSize size = CGSizeZero;
    NSDictionary *dictionary = [self valueForKey:key];
    
    if ([dictionary bm_isValided] && [dictionary isKindOfClass:[NSDictionary class]])
    {
        BOOL success = CGSizeMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)dictionary, &size);
        if (success)
            return size;
        else
            return CGSizeZero;
    }
    
    return CGSizeZero;
}

- (CGRect)bm_rectForKey:(id)key
{
    CGRect rect = CGRectZero;
    NSDictionary *dictionary = [self valueForKey:key];
    
    if ([dictionary bm_isValided] && [dictionary isKindOfClass:[NSDictionary class]])
    {
        BOOL success = CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)dictionary, &rect);
        if (success)
            return rect;
        else
            return CGRectZero;
    }
    
    return CGRectZero;
}

- (NSArray *)bm_arrayForKey:(id)key
{
    NSArray *value = nil;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided] && [object isKindOfClass:[NSArray class]])
    {
        value = (NSArray *)object;
    }
    
    return value;
}

- (NSDictionary *)bm_dictionaryForKey:(id)key
{
    NSDictionary *value = nil;
    
    id object = [self objectForKey:key];
    if ([object bm_isValided] && [object isKindOfClass:[NSDictionary class]])
    {
        value = (NSDictionary *)object;
    }
    
    return value;
}

- (BOOL)bm_containsObjectForKey:(id)key
{
    return [[self allKeys] containsObject:key];
}

- (NSArray *)bm_allKeysSorted
{
    return [[self allKeys] bm_sortedArray];
}

- (NSArray *)bm_allValuesSortedByKeys
{
    NSArray *sortedKeys = [self bm_allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys)
    {
        [arr addObject:self[key]];
    }
    return arr;
}

- (NSString *)bm_toJSON
{
    // NSJSONWritingPrettyPrinted
    return [self bm_toJSONWithOptions:0];
}

- (NSString *)bm_toJSONWithOptions:(NSJSONWritingOptions)options
{
    NSString *json = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    
    if (!jsonData)
    {
        return @"{}";
    }
    else if (!error)
    {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    else
    {
        BMLog(@"%@", error.localizedDescription);
    }
    
    return nil;
}

+ (NSDictionary *)bm_dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        BMLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end


@implementation NSDictionary (BMDeepMutableCopy)


- (NSMutableDictionary *)bm_deepMutableCopy
{
    NSMutableDictionary *newDictionary;
    NSEnumerator *keyEnumerator;
    id anObject;
    id aKey;
	
    newDictionary = [self mutableCopy];
    // Run through the new dictionary and replace any objects that respond to -deepMutableCopy or -mutableCopy with copies.
    keyEnumerator = [[newDictionary allKeys] objectEnumerator];
    while ((aKey = [keyEnumerator nextObject])) {
        anObject = [newDictionary objectForKey:aKey];
        if ([anObject respondsToSelector:@selector(bm_deepMutableCopy)]) {
            anObject = [anObject bm_deepMutableCopy];
            [newDictionary setObject:anObject forKey:aKey];
            //[anObject ah_release];
        } else if ([anObject respondsToSelector:@selector(mutableCopyWithZone:)]) {
            anObject = [anObject mutableCopyWithZone:nil];
            [newDictionary setObject:anObject forKey:aKey];
            //[anObject ah_release];
        } else {
			[newDictionary setObject:anObject forKey:aKey];
		}
    }
	
    return newDictionary;
}

@end


@implementation NSMutableDictionary (BMSetCategory)

- (void)bm_setInteger:(NSInteger)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithInteger:value];
    [self setObject:number forKey:key];    
}

- (void)bm_setUInteger:(NSUInteger)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithUnsignedInteger:value];
    [self setObject:number forKey:key];
}

- (void)bm_setBool:(BOOL)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithBool:value];
    [self setObject:number forKey:key];    
}

- (void)bm_setFloat:(float)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithFloat:value];
    [self setObject:number forKey:key];
}

- (void)bm_setDouble:(double)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithDouble:value];
    [self setObject:number forKey:key];
}

- (void)bm_setString:(NSString *)value forKey:(id)key
{
    if (!value)
    {
       return;
    }
    [self setObject:value forKey:key];
}

- (void)bm_setPoint:(CGPoint)value forKey:(id)key
{
    CFDictionaryRef dictionary = CGPointCreateDictionaryRepresentation(value);
    NSDictionary *pointDict = [NSDictionary dictionaryWithDictionary:
                               (__bridge NSDictionary *)dictionary]; // autoreleased
    CFRelease(dictionary);
    
    [self setValue:pointDict forKey:key];
}

- (void)bm_setSize:(CGSize)value forKey:(id)key
{
    CFDictionaryRef dictionary = CGSizeCreateDictionaryRepresentation(value);
    NSDictionary *sizeDict = [NSDictionary dictionaryWithDictionary:
                               (__bridge NSDictionary *)dictionary]; // autoreleased
    CFRelease(dictionary);
    
    [self setValue:sizeDict forKey:key];
}

- (void)bm_setRect:(CGRect)value forKey:(id)key
{
    CFDictionaryRef dictionary = CGRectCreateDictionaryRepresentation(value);
    NSDictionary *rectDict = [NSDictionary dictionaryWithDictionary:
                              (__bridge NSDictionary *)dictionary]; // autoreleased
    CFRelease(dictionary);
    
    [self setValue:rectDict forKey:key];
}

@end
