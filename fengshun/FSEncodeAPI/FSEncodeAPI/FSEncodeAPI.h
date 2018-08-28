//
//  FSEncodeAPI.h
//  FSEncodeAPI
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSEncodeAPI : NSObject

+ (NSString *)encode:(NSString *)api;

// 编码
+ (NSString *)encodeDES:(NSString *)plainText;
// 解码
+ (NSString *)decodeDES:(NSString *)plainText;

@end

NS_ASSUME_NONNULL_END
