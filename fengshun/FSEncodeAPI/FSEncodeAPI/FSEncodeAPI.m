//
//  FSEncodeAPI.m
//  FSEncodeAPI
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "FSEncodeAPI.h"

#define FSEncodeAPI_ADDKEY  @"key=jwoxoWHeauio"

#define FSDES_CodeKey   @"fengshun_FS_DES_CodeKey"

// 8位
#define FSDES_IvKey     @"fengtiao"

@interface NSString (base64)

+ (NSString *)base64EncodeData:(NSData *)data;
+ (NSData *)base64DecodeString:(NSString *)base64Str;

@end

@implementation NSString (base64)

+ (NSString *)base64EncodeData:(NSData *)data
{
    if (!data)
    {
        return nil;
    }
    NSData *encodeData = [data base64EncodedDataWithOptions:0];
    NSString *base64Str = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    return base64Str;
}

+ (NSData *)base64DecodeString:(NSString *)base64Str
{
    if (!base64Str)
    {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

@end

@implementation FSEncodeAPI

+ (NSString *)md5WithApi:(NSString *)api
{
    const char *original_str = [api UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02x", result[i]];
    
    return hash;
}

+ (NSString *)encode:(NSString *)api
{
    if (api)
    {
        NSString *apiAdd = [NSString stringWithFormat:@"%@%@", api, FSEncodeAPI_ADDKEY];
        
        NSString *md5 = [FSEncodeAPI md5WithApi:apiAdd];
        
        return md5;
    }
    
    return nil;
}

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [NSString base64DecodeString:plainText];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //NSString *key = @"123456789012345678901234";
    NSString *initVec = FSDES_IvKey;//@"init Vec";
    //const void *keyPtr = (const void *) [key UTF8String];
    //const void *ivPtr = (const void *) [initVec UTF8String];
    
    char keyPtr[kCCKeySize3DES+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSize3DES+1];
    bzero(ivPtr, sizeof(ivPtr));
    [initVec getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       keyPtr, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       ivPtr, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (kCCSuccess != ccStatus)
    {
        free(bufferPtr);
        return @"";
    }
    
    id result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:bufferPtr length:(NSUInteger)movedBytes];
        result = [NSString base64EncodeData:myData];
    }
    
    free(bufferPtr);
    return result;
}

// 编码
+ (NSString *)encodeDES:(NSString *)plainText
{
    NSString *ret = [FSEncodeAPI TripleDES:plainText encryptOrDecrypt:kCCEncrypt key:FSDES_CodeKey];
    NSLog(@"3DES/Base64 MQEncode Result=%@", ret);
    
    return ret;
}

// 解码
+ (NSString *)decodeDES:(NSString *)plainText
{
    NSString *ret = [FSEncodeAPI TripleDES:plainText encryptOrDecrypt:kCCDecrypt key:FSDES_CodeKey];
    NSLog(@"3DES/Base64 MQDecode Result=%@", ret);
    
    return ret;
}

@end
