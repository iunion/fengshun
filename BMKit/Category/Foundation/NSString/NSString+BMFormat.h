//
//  NSString+BMFormat.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/4/14.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BMFormat)

- (nullable NSString *)bm_formatWithPattern:(nullable NSString *)pattern;
- (nullable NSString *)bm_formatWithPattern:(nullable NSString *)pattern placeholder:(nullable NSString *)placeholder;
- (nullable NSString *)bm_formatWithPattern:(nullable NSString *)pattern placeholder:(nullable NSString *)placeholder errorContinue:(BOOL)errorContinue;

- (nullable NSString *)bm_formatWithRegex:(nullable NSRegularExpression *)regex;
- (nullable NSString *)bm_formatWithRegex:(nullable NSRegularExpression *)regex placeholder:(nullable NSString *)placeholder;
- (nullable NSString *)bm_formatWithRegex:(nullable NSRegularExpression *)regex placeholder:(nullable NSString *)placeholder errorContinue:(BOOL)errorContinue;

- (nullable NSString *)bm_validCharactersWithRegex:(nullable NSRegularExpression *)regex errorContinue:(BOOL)errorContinue;

@end

@interface NSString (BMPhoneNumber)

- (nonnull NSString *)bm_maskPhoneNumber:(NSRange)maskRang withMask:(char)maskChar;
- (nonnull NSString *)bm_maskAtRang:(NSRange)maskRang withMask:(char)maskChar;

@end
