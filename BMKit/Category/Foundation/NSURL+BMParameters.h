//
//  NSURL+BMParameters.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/4/1.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (BMParameters)

- (NSDictionary *)bm_queryDictionary;

- (NSURL *)bm_URLByAppendingQueryString:(NSString *)queryString;
- (NSURL *)bm_URLByAppendingQueryParameters:(NSDictionary *)parameters;
- (NSURL *)bm_URLByAppendingQueryParameters:(NSDictionary *)parameters usingEncoding:(NSStringEncoding)encoding;

@end
