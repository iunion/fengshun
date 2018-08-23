//
//  NSString+BMMandarinLatin.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/5/2.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BMMandarinLatin)

- (nullable NSString *)bm_stringByReplacingMandarinToLatinWithDiacritics:(BOOL)diacritics firstLetterCapitalizes:(BOOL)capitalizes;

- (nullable NSString *)bm_mandarinLatinString;
- (nullable NSString *)bm_pinyinString;

@end
