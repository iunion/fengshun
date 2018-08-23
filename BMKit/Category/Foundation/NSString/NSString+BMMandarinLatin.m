//
//  NSString+BMMandarinLatin.m
//  BMBasekit
//
//  Created by DennisDeng on 2017/5/2.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "NSString+BMMandarinLatin.h"

@implementation NSString (BMMandarinLatin)

- (NSString *)bm_stringByReplacingMandarinToLatinWithDiacritics:(BOOL)diacritics firstLetterCapitalizes:(BOOL)capitalizes
{
    NSMutableString *original = [NSMutableString stringWithString:self];
    // 转换为带变声符的拼音
    if (!CFStringTransform((CFMutableStringRef)original, NULL, kCFStringTransformMandarinLatin, NO))
    {
        return nil;
    }
    
    if (!diacritics)
    {
        // 去除变音符
        if (!CFStringTransform((CFMutableStringRef)original, NULL, kCFStringTransformStripDiacritics, NO))
        {
            return nil;
        }
    }
    
    if (capitalizes)
    {
        return [original capitalizedString];
    }
    else
    {
        return [original copy];
    }
}

- (NSString *)bm_mandarinLatinString
{
    return [self bm_stringByReplacingMandarinToLatinWithDiacritics:YES firstLetterCapitalizes:NO];
}

- (NSString *)bm_pinyinString
{
    return [self bm_stringByReplacingMandarinToLatinWithDiacritics:NO firstLetterCapitalizes:NO];
}

@end
