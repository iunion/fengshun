//
//  NSString+BMURLEncode.h
//  BMBasekit
//
//  Created by Scott James Remnant on 6/1/11.
//  Copyright 2011 Scott James Remnant <scott@netsplit.com>. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (BMURLEncode)

- (NSString *)bm_URLEncode;
- (NSString *)bm_URLEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)bm_URLDecode;
- (NSString *)bm_URLDecodeUsingEncoding:(NSStringEncoding)encoding;

+ (NSString *)bm_URLString:(NSString *)URLString appendingQueryString:(NSString *)queryString;
+ (NSString *)bm_URLString:(NSString *)URLString appendingQueryParameters:(NSDictionary *)parameters usingEncoding:(NSStringEncoding)encoding;

- (NSString *)bm_URLStringByAppendingQueryString:(NSString *)queryString;
- (NSString *)bm_URLStringByAppendingQueryParameters:(NSDictionary *)parameters usingEncoding:(NSStringEncoding)encoding;

@end
