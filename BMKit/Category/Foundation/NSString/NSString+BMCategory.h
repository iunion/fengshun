//
//  NSString+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 12-1-6.
//  Copyright (c) 2012年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (BMCategory)

// 删除空白字符
+ (NSString *)bm_stringTrim:(NSString *)str;
+ (NSString *)bm_stringTrimStart:(NSString *)str;
+ (NSString *)bm_stringTrimEnd:(NSString *)str;
// 删除首尾和中间的空白字符
+ (NSString *)bm_stringTrimAllSpace:(NSString *)trimmingStr;

- (NSString *)bm_trim;
- (NSString *)bm_trimSpace;
- (NSString *)bm_trimWithCharacters:(NSString *)characters;
- (NSString *)bm_trimAllSpace;

- (BOOL)bm_containString:(NSString *)string;
- (BOOL)bm_containString:(NSString *)string options:(NSStringCompareOptions)mask;

// 添加随机数
+ (NSString *)bm_string:(NSString *)str appendRandom:(NSUInteger)ram;
+ (NSString *)bm_string:(NSString *)str appendRandom:(NSUInteger)ram startFrom:(NSUInteger)start;

- (NSInteger)bm_indexOfCharacter:(char)character;

- (NSString *)bm_subStringFromCharacter:(char)character;
- (NSString *)bm_subStringToCharacter:(char)character;

- (NSString *)bm_subStringFromChar:(char)charStart toChar:(char)charEnd;

// 从bit转化为KB、MB、GB
+ (NSString *)bm_storeStringWithBitSize:(double)bsize;
+ (NSString *)bm_countStringWithCount:(NSUInteger)count;

// 得到一个时间格式为:02天 14时 49分 16秒
+ (NSString *)bm_dayHourMinuteSecondStringWithSecond:(NSUInteger)second;
+ (NSString *)bm_secondStringWithSecond:(NSTimeInterval)second;

// 判断是否为整形
- (BOOL)bm_isPureInt;
// 判断是否为浮点形
- (BOOL)bm_isPureFloat;

+ (NSUInteger)bm_integerFromStr:(NSString *)string withBase:(NSInteger)base;
// 转换16进制字符串为10进制数字
+ (NSUInteger)bm_integerFromHexStr:(NSString *)hexString;
- (NSUInteger)bm_hexStrToInteger;
// 转换10进制数字为大写16进制字符串
+ (NSString *)bm_hexStrFromInteger:(NSUInteger)intNum;

- (NSString *)bm_toJsonString;

// json转NSArray、NSDictionary
+ (id)bm_jsonToObject:(NSString *)jsonStr;
- (id)bm_jsonToObject;

- (NSString *)bm_escapeHTML;

- (NSURL *)bm_toURL;

+ (NSString *)bm_convertUnicode:(NSString *)aString;
- (NSString *)bm_convertUnicode;

@end


#pragma mark - Size

@interface NSString (BMSize)

/**
 Returns the size of the string if it were rendered with the specified constraints.
 
 @param font          The font to use for computing the string size.
 
 @param size          The maximum acceptable size for the string. This value is
 used to calculate where line breaks and wrapping would occur.
 
 @param lineBreakMode The line break options for computing the size of the string.
 For a list of possible values, see NSLineBreakMode.
 
 @return              The width and height of the resulting string's bounding box.
 These values may be rounded up to the nearest whole number.
 */
//- (CGSize)bm_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
//- (CGFloat)bm_widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
//- (CGFloat)bm_heightForFont:(UIFont *)font width:(CGFloat)width;


- (CGFloat)bm_heightToFitWidth:(CGFloat)width withFont:(UIFont *)font;
- (CGSize)bm_sizeToFitWidth:(CGFloat)width withFont:(UIFont *)font;
- (CGFloat)bm_widthToFitHeight:(CGFloat)height withFont:(UIFont *)font;
- (CGSize)bm_sizeToFitHeight:(CGFloat)height withFont:(UIFont *)font;
- (CGSize)bm_sizeToFit:(CGSize)maxSize withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)bm_sizeToFitWidth:(CGFloat)width withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
- (CGSize)bm_sizeToFitHeight:(CGFloat)height withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
- (CGSize)bm_sizeToFit:(CGSize)maxSize withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

@end


#pragma mark - paths

/**
 A collection of useful additions for `NSString` to deal with paths.
 */

@interface NSString (BMpaths)

/**-------------------------------------------------------------------------------------
 @name Getting Standard Paths
 ---------------------------------------------------------------------------------------
 */

/** Determines the path to the Library/Caches folder in the current application's sandbox.
 
 The return value is cached on the first call.
 
 @return The path to the app's Caches folder.
 */
+ (NSString *)bm_cachesPath;


/** Determines the path to the Documents folder in the current application's sandbox.
 
 The return value is cached on the first call.
 
 @return The path to the app's Documents folder.
 */
+ (NSString *)bm_documentsPath;

+ (NSString *)bm_libraryPath;
+ (NSString *)bm_bundlePath;

+ (NSString *)bm_applicationPath;
+ (NSString *)bm_applicationName;

/**-------------------------------------------------------------------------------------
 @name Getting Temporary Paths
 ---------------------------------------------------------------------------------------
 */

/** Determines the path for temporary files in the current application's sandbox.
 
 The return value is cached on the first call. This value is different in Simulator than on the actual device. In Simulator you get a reference to /tmp wheras on iOS devices it is a special folder inside the application folder.
 
 @return The path to the app's folder for temporary files.
 */
+ (NSString *)bm_temporaryPath;


/** Creates a unique filename that can be used for one temporary file or folder.
 
 The returned string is different on every call. It is created by combining the result from temporaryPath with a unique UUID.
 
 @return The generated temporary path.
 */
+ (NSString *)bm_pathForTemporaryFile;


/**-------------------------------------------------------------------------------------
 @name Working with Paths
 ---------------------------------------------------------------------------------------
 */
/*!
 Path extension with . or "" as before.
 
 "spliff.tiff" => ".tiff"
 "spliff" => ""
 
 @result Full path extension with .
 */
- (NSString *)bm_getFullFileExtension;

/** Appends or Increments a sequence number in brackets
 
 If the receiver already has a number suffix then it is incremented. If not then (1) is added.
 
 @return The incremented path
 */
- (NSString *)bm_pathByIncrementingSequenceNumber;


/** Removes a sequence number in brackets
 
 If the receiver number suffix then it is removed. If not the receiver is returned.
 
 @return The modified path
 */
- (NSString *)bm_pathByDeletingSequenceNumber;

// 目录存储空间
+ (unsigned long long)bm_sizeOfFolder:(NSString *)folderPath;

@end

