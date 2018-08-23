//
//  NSString+BMEncrypt.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/5/2.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//
#if BMBasekit_Category_Encrypt

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BMEncrypt)

/**
 Returns a NSString for base64 encoded.
 */
+ (NSString *)bm_base64EncodeData:(NSData *)data;

/**
 Returns a NSData for base64 decoded.
 */
+ (NSData *)bm_base64DecodeString:(NSString *)base64Str;

#pragma mark - 散列函数
/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)bm_md2String;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)bm_md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)bm_md5String;
- (NSString *)bm_md5HexDigest16;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)bm_sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)bm_sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)bm_sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)bm_sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)bm_sha512String;

#pragma mark - HMAC 散列函数
/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key The hmac key.
 */
- (NSString *)bm_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key The hmac key.
 */
- (NSString *)bm_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key The hmac key.
 */
- (NSString *)bm_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key The hmac key.
 */
- (NSString *)bm_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key The hmac key.
 */
- (NSString *)bm_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key The hmac key.
 */
- (NSString *)bm_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (NSString *)bm_crc32String;

#pragma mark - Encrypt and Decrypt

// DES+base64
// key为24位 kCCKeySize3DES
// 编码
+ (NSString *)bm_encodeDES:(NSString *)plainText key:(NSString *)key;
// 解码
+ (NSString *)bm_decodeDES:(NSString *)plainText key:(NSString *)key;

/**
 Returns an encrypted lowercase NSString in hex using an algorithm(AES, DES ...).
 
  @param key        A key length of 16, 24 or 32 (128, 192 or 256bits).
                    NSData or NSString.
 
 @param iv          An initialization vector length of 16(128bits).
                    Pass nil when you don't want to use iv.
                    NSData or NSString.
 
 @return            An NSData encrypted, or nil if an error occurs.
 */
- (nullable NSString *)bm_AES256EncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_AES256DecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_DESEncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_DESDecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_TripleDESEncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_TripleDESDecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;

/**
 Returns an encrypted base64 encoded NSString using an algorithm(AES, DES ...).
 
 @param key         A key length of 16, 24 or 32 (128, 192 or 256bits).
                    NSData or NSString.
 
 @param iv          An initialization vector length of 16(128bits).
                    Pass nil when you don't want to use iv.
                    NSData or NSString.
 
 @return            An NSData encrypted, or nil if an error occurs.
 */
- (nullable NSString *)bm_base64AES256EncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_base64AES256DecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_base64DESEncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_base64DESDecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_base64TripleDESEncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)bm_base64TripleDESDecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;


#pragma mark - 文件散列函数

- (nullable NSString *)bm_fileMD5Hash;

- (nullable NSString *)bm_fileSHA1Hash;

- (nullable NSString *)bm_fileSHA256Hash;

- (nullable NSString *)bm_fileSHA512Hash;

- (nullable NSString *)bm_fileCRC32SHash;


@end

NS_ASSUME_NONNULL_END

#endif
