//
//  NSData+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 12-6-11.
//  Copyright (c) 2012年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSDataBmLogType)
{
    NSDataBmLogType_LowerCaseHex,
    NSDataBmLogType_UpperCaseHex,
    NSDataBmLogType_Num
};

@interface NSData (BMCategory)

// 输出16进制
@property (nonatomic, readonly, nonnull) NSString *bm_hexStringValue;

- (void)bm_logWithType:(NSDataBmLogType)type;

// 由16进制字符串生成data，本函数会去除内部空格
+ (nonnull NSData *)bm_dataFromHexString:(nonnull NSString *)hexString;

@end


@interface NSData (BMRSHexDump)

//- (NSString *)description;

// startOffset may be negative, indicating offset from end of data
- (nonnull NSString *)bm_descriptionFromOffset:(NSInteger)startOffset;
- (nonnull NSString *)bm_descriptionFromOffset:(NSInteger)startOffset limitingToByteCount:(NSUInteger)maxBytes;

@end
