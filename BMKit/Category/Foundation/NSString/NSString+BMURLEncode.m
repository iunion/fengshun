//
//  NSString+BMURLEncode.m
//  BMBasekit
//
//  Created by Scott James Remnant on 6/1/11.
//  Copyright 2011 Scott James Remnant <scott@netsplit.com>. All rights reserved.
//

#import "NSString+BMURLEncode.h"


@implementation NSString (BMURLEncode)

- (NSString *)bm_URLEncode
{
    return [self bm_URLEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)bm_URLEncodeUsingEncoding:(NSStringEncoding)encoding
{
    BMLog(@"原url: %@", self);
//    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, CFStringConvertNSStringEncodingToEncoding(encoding)));
    //NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    //NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    BMLog(@"转码url: %@", encodedString);

    return encodedString;
}

- (NSString *)bm_URLDecode
{
    return [self bm_URLDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)bm_URLDecodeUsingEncoding:(NSStringEncoding)encoding
{
    BMLog(@"转码url: %@", self);
//    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *decodedString = [self stringByRemovingPercentEncoding];
    BMLog(@"还原url: %@", decodedString);
    
    return decodedString;
}

+ (NSString *)bm_URLString:(NSString *)URLString appendingQueryString:(NSString *)queryString
{
    return [URLString bm_URLStringByAppendingQueryString:queryString];
}

+ (NSString *)bm_URLString:(NSString *)URLString appendingQueryParameters:(NSDictionary *)parameters usingEncoding:(NSStringEncoding)encoding
{
    return [URLString bm_URLStringByAppendingQueryParameters:parameters usingEncoding:encoding];
}

- (NSString *)bm_URLStringByAppendingQueryString:(NSString *)queryString
{
    if (![queryString length])
    {
        return self;
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", self, [self rangeOfString:@"?"].location == NSNotFound ? @"&" : @"?", queryString];
    return URLString;
}

- (NSString *)bm_URLStringByAppendingQueryParameters:(NSDictionary *)parameters usingEncoding:(NSStringEncoding)encoding
{
    if (!parameters.count)
    {
        return self;
    }
    
    __block NSString *queryString = nil;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *escapedKey = key;
        if (encoding >= NSASCIIStringEncoding)
        {
            //escapedKey = [key stringByAddingPercentEscapesUsingEncoding:encoding];
            NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
            escapedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        }
        NSString *escapedValue = value;
        if (encoding >= NSASCIIStringEncoding)
        {
            //escapedValue = [value stringByAddingPercentEscapesUsingEncoding:encoding];
            NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
            escapedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        }
        if (!queryString)
        {
            queryString = [NSString stringWithFormat:@"%@=%@", escapedKey, escapedValue];
        }
        else
        {
            queryString = [queryString stringByAppendingFormat:@"&%@=%@", escapedKey, escapedValue];
        }
    }];
    
    return [self bm_URLStringByAppendingQueryString:queryString];
}

@end
