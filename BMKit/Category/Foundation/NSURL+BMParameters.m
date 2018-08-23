//
//  NSURL+BMParameters.m
//  BMBasekit
//
//  Created by DennisDeng on 2017/4/1.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "NSURL+BMParameters.h"
#import "NSObject+BMCategory.m"

@implementation NSURL (BMParameters)

- (NSDictionary *)bm_queryDictionary
{
    NSString *keyValues = self.query;
    if (![keyValues bm_isNotEmpty]) return nil;
    
    return [self queryDictionaryWithKeysValues:keyValues];
}

// 从k=v中获取键值
- (NSString *)valueFromKeyValue:(NSString *)keyValue atIndex:(NSUInteger)index
{
    return [[keyValue componentsSeparatedByString:@"="] objectAtIndex:index];
}

- (NSDictionary *)queryDictionaryWithKeysValues:(NSString *)keyValues
{
    if (!(keyValues.length > 0)) return @{};
    
    NSArray *pairArray = [keyValues componentsSeparatedByString:@"&"];  //键值对字符串
    NSMutableDictionary *queryDic= [NSMutableDictionary dictionaryWithCapacity:pairArray.count];
    NSString *key = nil;
    NSString *obj = nil;
    if (pairArray.count > 1)
    {
        for (NSString *pair in pairArray)
        {
            key = [self valueFromKeyValue:pair atIndex:0];
            obj = [self valueFromKeyValue:pair atIndex:1];
            [queryDic setObject:[obj stringByRemovingPercentEncoding] forKey:key];
        }
    }
    else if (pairArray.count == 1)
    {
        key = [self valueFromKeyValue:keyValues atIndex:0];
        obj = [self valueFromKeyValue:keyValues atIndex:1];
        [queryDic setObject:[obj stringByRemovingPercentEncoding] forKey:key];
    }
    
    return queryDic;
}

- (NSURL *)bm_URLByAppendingQueryString:(NSString *)queryString
{
    if (![queryString length])
    {
        return self;
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", [self absoluteString], [self query] ? @"&" : @"?", queryString];
    return [NSURL URLWithString:URLString];
}

- (NSURL *)bm_URLByAppendingQueryParameters:(NSDictionary *)parameters
{
    return [self bm_URLByAppendingQueryParameters:parameters usingEncoding:NSUTF8StringEncoding];
}

- (NSURL *)bm_URLByAppendingQueryParameters:(NSDictionary *)parameters usingEncoding:(NSStringEncoding)encoding
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
    
    return [self bm_URLByAppendingQueryString:queryString];
}

@end
