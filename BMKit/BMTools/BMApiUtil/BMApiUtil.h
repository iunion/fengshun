//
//  BMApiUtil.h
//  fengshun
//
//  Created by jiang deng on 2018/12/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMApiUtil : NSObject

+ (NSString *)serializeJsonFromData:(nullable NSData *)data;

+ (NSUInteger)getHeadersLength:(NSDictionary *)headers;
+ (NSUInteger)getRequestLength:(NSURLRequest *)request;

+ (nullable NSData *)getHttpBodyFromRequest:(NSURLRequest *)request;

+ (nullable NSDictionary<NSString *, NSString *> *)getCookies:(NSURLRequest *)request;

+ (int64_t)getResponseLength:(NSHTTPURLResponse *)response data:(NSData *)responseData;

@end

NS_ASSUME_NONNULL_END
