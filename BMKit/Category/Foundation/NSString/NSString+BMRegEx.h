//
//  NSString+BMRegEx.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/4/28.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRegularExpression+BMRegEx.h"

#define BMEMAIL_PATTERN                         @"^[A-Za-z0-9_\\.-]+@[0-9A-Za-z\\.-]+\\.[A-Za-z]{2,6}$"
#define BMPHONE_PATTERN                         @"^((\\+)|(00))[0-9]{6,15}$"
#define BMPHONE_PATTERN_CHINESE                 @"^(1[3-9])\\d{9}$"
#define BMIP_PATTERN                            @"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
#define BMMD5_32_PATTERN                        @"^[0-9A-Za-z]{32}$"
#define BMCHINESE_ID_NUMBER_PATTERN             @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$"
//#define BMPASSWORD_PATTERN                      @"^[0-9A-Za-z_\\.\\*\\&\\[\\]\\(\\)\%\\$#@]{6,16}$"
#define BMPASSWORD_PATTERN                      @"^[0-9A-Za-z]{8,16}$"
#define BMNICKNAME_PATTERN                      @"^(\\s*\\S+\\s*)+$"


@interface NSString (RegEx)

/**
 * Initialize an NSRegularExpression object from a string.
 *
 * ie.
 * NSRegularExpression* rx = [@"\d+" toRx];
 */

- (NSRegularExpression *)bm_toRx;


/**
 * Initialize an NSRegularExpression object from a string with
 * a flag denoting case-sensitivity. By default, NSRegularExpression
 * is case sensitive.
 *
 * ie.
 * NSRegularExpression* rx = [@"\d+" toRxIgnoreCase:YES];
 */

- (NSRegularExpression *)bm_toRxIgnoreCase:(BOOL)ignoreCase;


/**
 * Initialize an NSRegularExpression object from a string with options.
 *
 * ie.
 * NSRegularExpression* rx = [@"\d+" toRxWithOptions:NSRegularExpressionCaseInsensitive];
 */

- (NSRegularExpression *)bm_toRxWithOptions:(NSRegularExpressionOptions)options;


/**
 * Returns true if the string matches the regex. May also
 * be called as on Rx as [rx isMatch:@"some string"].
 *
 * ie.
 * BOOL isMatch = [@"Dog #1" isMatch:RX(@"\d+")]; // => true
 */

- (BOOL)bm_isMatch:(NSRegularExpression *)rx;


/**
 * Returns the index of the first match according to
 * the regex passed in.
 *
 * ie.
 * NSInteger i = [@"Buy 1 dog or buy 2?" indexOf:RX(@"\d+")]; // => 4
 */

- (NSInteger)bm_indexOf:(NSRegularExpression *)rx;


/**
 * Splits a string using the regex to identify delimeters. Returns
 * an NSArray of NSStrings.
 *
 * ie.
 * NSArray* pieces = [@"A dog,cat" split:RX(@"[ ,]")];
 *  => @[@"A", @"dog", @"cat"]
 */

- (NSArray <NSString *>*)bm_split:(NSRegularExpression *)rx;


/**
 * Replaces all occurrences of a regex with a replacement string.
 *
 * ie.
 * NSString *result = [@"ruf ruff!" replace:RX(@"ruf+") with:@"meow"];
 *  => @"meow meow!"
 */

- (NSString *)bm_replace:(NSRegularExpression *)rx with:(NSString *)replacement;


/**
 * Replaces all occurrences of a regex using a block. The block receives the match
 * and should return the replacement.
 *
 * ie.
 * NSString *result = [@"i love COW" replace:RX(@"[A-Z]+") withBlock:^(NSString *){ return @"lamp"; }];
 *  => @"i love lamp"
 */

- (NSString *)bm_replace:(NSRegularExpression *)rx withBlock:(NSString * (^)(NSString *match))replacer;


/**
 * Replaces all occurrences of a regex using a block. The block receives an MXRxMatch
 * object which contains all of the details for each match and should return a string
 * which is what the match is replaced with.
 *
 * ie.
 * NSString *result = [@"hi bud" replace:RX(@"\\w+") withDetailsBlock:^(MXRxMatch* match){ return [NSString stringWithFormat:@"%i", match.value.length]; }];
 *  => @"2 3"
 */

- (NSString *)bm_replace:(NSRegularExpression *)rx withDetailsBlock:(NSString * (^)(RxMatch *match))replacer;


/**
 * Returns an array of matched root strings with no other match information.
 *
 * ie.
 * NSString *str = @"My email is me@example.com and yours is you@example.com";
 * NSArray* matches = [str matches:RX(@"\\w+[@]\\w+[.](\\w+)")];
 *  => @[ @"me@example.com", @"you@example.com" ]
 */

- (NSArray <NSString *>*)bm_matches:(NSRegularExpression *)rx;


/**
 * Returns a string which is the first match of the NSRegularExpression.
 *
 * ie.
 * NSString *str = @"My email is me@example.com and yours is you@example.com";
 * NSString *match = [str firstMatch:RX(@"\\w+[@]\\w+[.](\\w+)")];
 *  => @"me@example.com"
 */

- (NSString *)bm_firstMatch:(NSRegularExpression *)rx;


/**
 * Returns an NSArray of MXRxMatch* objects. Each match contains the matched
 * value, range, groups, etc.
 *
 * ie.
 * NSString *str = @"My email is me@example.com and yours is you@example.com";
 * NSArray* matches = [str matchesWithDetails:RX(@"\\w+[@]\\w+[.](\\w+)")];
 */

- (NSArray <RxMatch *>*)bm_matchesWithDetails:(NSRegularExpression *)rx;


/**
 * Returns an the first match as an MXRxMatch* object.
 *
 * ie.
 * NSString *str = @"My email is me@example.com and yours is you@example.com";
 * MXRxMatch* match = [str firstMatchWithDetails:RX(@"\\w+[@]\\w+[.](\\w+)")];
 */

- (RxMatch *)bm_firstMatchWithDetails:(NSRegularExpression *)rx;

#pragma mark Vaild

- (BOOL)bm_isValidPhoneNumber;
- (BOOL)bm_isValidPassword;
- (BOOL)bm_isValidChinesePhoneNumber;
- (BOOL)bm_isValidEMailAddress;
- (BOOL)bm_isValidIPAddress;
- (BOOL)bm_isValidMD532String;
- (BOOL)bm_isValidChineseIDNumberString;
- (BOOL)bm_isValidNickName;

#pragma mark - Tools
/**
 * 返回一个包含全部匹配结果的数组，无匹配则返回空数组
 */
- (NSArray <NSString *>*)bm_matchesWithPattern:(NSString *)pattern;
/**
 * 返回第一个匹配的字符串，无匹配则返回空
 */
- (NSString *)bm_firstMatchWithPattern:(NSString *)pattern;
/**
 * 返回是否匹配的布尔值
 */
- (BOOL)bm_isMatchWithPattern:(NSString *)pattern;
/**
 * 返回第一个匹配的字符串在整体字符串中的位置，location in NSRange，无匹配则返回-1
 */
- (NSRange)bm_rangOfFirstMatchWithPattern:(NSString *)pattern;
- (NSInteger)bm_indexOfFirstMatchWithPattern:(NSString *)pattern;
/**
 * 通过表达式替换字符串，返回替换后的结果
 */
- (NSString *)bm_stringByReplacingOccurrencesOfPattern:(NSString *)pattern withString:(NSString *)string;

- (NSString *)bm_replaceWithPattern:(NSString *)pattern to:(NSString *)replacement;

- (NSArray <NSString *>*)bm_splitWithPattern:(NSString *)pattern;

@end
