//
//  NSString+BMEncrypt.m
//  BMBasekit
//
//  Created by DennisDeng on 2017/5/2.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//
#if BMBasekit_Category_Encrypt

#import "NSString+BMEncrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+BMEncrypt.h"

@implementation NSString (BMEncrypt)

+ (NSString *)bm_base64EncodeData:(NSData *)data
{
    NSData *encodeData = [data base64EncodedDataWithOptions:0];
    NSString *base64Str = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    return base64Str;
}

+ (NSData *)bm_base64DecodeString:(NSString *)base64Str
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}


#pragma mark - Hash

- (NSString *)bm_md2String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_md2String];
}

- (NSString *)bm_md4String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_md4String];
}

- (NSString *)bm_md5String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_md5String];
}

- (NSString *)bm_md5HexDigest16
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 4; i < 12; i++)
    {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSString *)bm_sha1String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_sha1String];
}

- (NSString *)bm_sha224String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_sha224String];
}

- (NSString *)bm_sha256String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_sha256String];
}

- (NSString *)bm_sha384String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_sha384String];
}

- (NSString *)bm_sha512String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_sha512String];
}

- (NSString *)bm_hmacMD5StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            bm_hmacMD5StringWithKey:key];
}

- (NSString *)bm_hmacSHA1StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            bm_hmacSHA1StringWithKey:key];
}

- (NSString *)bm_hmacSHA224StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            bm_hmacSHA224StringWithKey:key];
}

- (NSString *)bm_hmacSHA256StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            bm_hmacSHA256StringWithKey:key];
}

- (NSString *)bm_hmacSHA384StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            bm_hmacSHA384StringWithKey:key];
}

- (NSString *)bm_hmacSHA512StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            bm_hmacSHA512StringWithKey:key];
}

- (NSString *)bm_crc32String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] bm_crc32String];
}

#pragma mark - Encrypt and Decrypt

+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key
{
    return [NSString TripleDES:plainText encryptOrDecrypt:encryptOrDecrypt key:key iv:@"init Vec"];
}

+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key iv:(NSString *)iv
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [NSString bm_base64DecodeString:plainText];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
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
    NSString *initVec = iv;//@"init Vec";
    //const void *keyPtr = (const void *) [key UTF8String];
    //const void *ivPtr = (const void *) [initVec UTF8String];
    
    char keyPtr[kCCKeySize3DES+1];
    //char keyPtr[kCCKeySize3DES];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSize3DES+1];
    //char ivPtr[kCCBlockSize3DES];
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
    //if (ccStatus == kCCSuccess) BMLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [NSString bm_base64EncodeData:myData];
    }
    
    free(bufferPtr);
    return result;
}

// 编码
+ (NSString *)bm_encodeDES:(NSString *)plainText key:(NSString *)key
{
    NSString* ret = [NSString TripleDES:plainText encryptOrDecrypt:kCCEncrypt key:key];
    NSLog(@"3DES/Base64 Encode Result=%@", ret);
    
    return ret;
}

// 解码
+ (NSString *)bm_decodeDES:(NSString *)plainText key:(NSString *)key
{
    NSString* ret = [NSString TripleDES:plainText encryptOrDecrypt:kCCDecrypt key:key];
    NSLog(@"3DES/Base64 Decode Result=%@", ret);
    
    return ret;
}

- (NSString *)bm_AES256EncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [data bm_AES256EncryptedDataUsingKey:key iv:iv error:error];
    
    return [result bm_lowerHexString];
}

- (NSString *)bm_AES256DecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [NSData bm_dataWithHexString:self];
    NSData *result = [data bm_AES256DecryptedDataUsingKey:key iv:iv error:error];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

- (NSString *)bm_DESEncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [data bm_DESEncryptedDataUsingKey:key iv:iv error:error];
    
    return [result bm_lowerHexString];
}

- (NSString *)bm_DESDecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [NSData bm_dataWithHexString:self];
    NSData *result = [data bm_DESDecryptedDataUsingKey:key iv:iv error:error];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

- (NSString *)bm_TripleDESEncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [data bm_TripleDESEncryptedDataUsingKey:key iv:iv error:error];
    
    return [result bm_lowerHexString];
}

- (NSString *)bm_TripleDESDecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [NSData bm_dataWithHexString:self];
    NSData *result = [data bm_TripleDESDecryptedDataUsingKey:key iv:iv error:error];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

- (NSString *)bm_base64AES256EncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [data bm_AES256EncryptedDataUsingKey:key iv:iv error:error];
    
    return [NSString bm_base64EncodeData:result];
}

- (NSString *)bm_base64AES256DecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [NSString bm_base64DecodeString:self];
    NSData *result = [data bm_AES256DecryptedDataUsingKey:key iv:iv error:error];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

- (NSString *)bm_base64DESEncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [data bm_DESEncryptedDataUsingKey:key iv:iv error:error];
    
    return [NSString bm_base64EncodeData:result];
}

- (NSString *)bm_base64DESDecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [NSString bm_base64DecodeString:self];
    NSData *result = [data bm_DESDecryptedDataUsingKey:key iv:iv error:error];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

- (NSString *)bm_base64TripleDESEncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [data bm_TripleDESEncryptedDataUsingKey:key iv:iv error:error];
    
    return [NSString bm_base64EncodeData:result];
}

- (NSString *)bm_base64TripleDESDecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    NSData *data = [NSString bm_base64DecodeString:self];
    NSData *result = [data bm_TripleDESDecryptedDataUsingKey:key iv:iv error:error];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}


#pragma mark - 文件散列函数

- (NSString *)bm_fileMD5Hash
{
    return [NSData bm_getFileMD5HashString:self];
}

- (NSString *)bm_fileSHA1Hash
{
    return [NSData bm_getFileSHA1HashString:self];
}

- (NSString *)bm_fileSHA256Hash
{
    return [NSData bm_getFileSHA256HashString:self];
}

- (NSString *)bm_fileSHA512Hash
{
    return [NSData bm_getFileSHA512HashString:self];
}

- (NSString *)bm_fileCRC32SHash
{
    return [NSData bm_getFileCRC32String:self];
}

@end

#endif
