//
//  NSData+BMEncrypt.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/5/2.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#if BMBasekit_Category_Encrypt

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

extern NSString * _Nonnull const kBMEncryptErrorDomain;

NS_ASSUME_NONNULL_BEGIN

@interface NSError (BMEncrypt)

+ (NSError *)bm_errorWithCCCryptorStatus:(CCCryptorStatus)status;

@end

@interface NSData (BMEncrypt)

#pragma mark - Hash

///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)bm_md2String;

/**
 Returns an NSData for md2 hash.
 */
- (NSData *)bm_md2Data;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)bm_md4String;

/**
 Returns an NSData for md4 hash.
 */
- (NSData *)bm_md4Data;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)bm_md5String;

/**
 Returns an NSData for md5 hash.
 */
- (NSData *)bm_md5Data;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)bm_sha1String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)bm_sha1Data;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)bm_sha224String;

/**
 Returns an NSData for sha224 hash.
 */
- (NSData *)bm_sha224Data;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)bm_sha256String;

/**
 Returns an NSData for sha256 hash.
 */
- (NSData *)bm_sha256Data;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)bm_sha384String;

/**
 Returns an NSData for sha384 hash.
 */
- (NSData *)bm_sha384Data;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)bm_sha512String;

/**
 Returns an NSData for sha512 hash.
 */
- (NSData *)bm_sha512Data;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSString *)bm_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSData *)bm_hmacMD5DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSString *)bm_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSData *)bm_hmacSHA1DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSString *)bm_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSData *)bm_hmacSHA224DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSString *)bm_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSData *)bm_hmacSHA256DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSString *)bm_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSData *)bm_hmacSHA384DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSString *)bm_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSData *)bm_hmacSHA512DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (NSString *)bm_crc32String;

/**
 Returns crc32 hash.
 */
- (uint32_t)bm_crc32;


#pragma mark - Encrypt and Decrypt

///=============================================================================
/// @name Encrypt and Decrypt
///=============================================================================

/**
 Returns an encrypted NSData using an algorithm.
 
 @param algorithm   An algorithm(AES, DES ...).

 @param key         A key length of 16, 24 or 32 (128, 192 or 256bits).
                    NSData or NSString.
 
 @param iv          An initialization vector length of 16(128bits).
                    Pass nil when you don't want to use iv.
                    NSData or NSString.
 
 @return            An NSData encrypted, or nil if an error occurs.
 */
- (nullable NSData *)bm_dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                                key:(id)key
                               initializationVector:(nullable id)iv
                                            options:(CCOptions)options
                                              error:(CCCryptorStatus *)error;
- (nullable NSData *)bm_dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                                key:(id)key
                                              error:(CCCryptorStatus *)error;
- (nullable NSData *)bm_dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                                key:(id)key
                                            options:(CCOptions)options
                                              error:(CCCryptorStatus *)error;

/**
 Returns an decrypted NSData using an algorithm.
 
 @param algorithm   An algorithm(AES, DES ...).
 
 @param key         A key length of 16, 24 or 32 (128, 192 or 256bits).
                    NSData or NSString.
 
 @param iv          An initialization vector length of 16(128bits).
                    Pass nil when you don't want to use iv.
                    NSData or NSString.
 
 @return            An NSData encrypted, or nil if an error occurs.
 */
- (nullable NSData *)bm_dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                                key:(id)key
                               initializationVector:(nullable id)iv
                                            options:(CCOptions)options
                                              error:(CCCryptorStatus *)error;
- (nullable NSData *)bm_dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                                key:(id)key
                                              error:(CCCryptorStatus *)error;
- (nullable NSData *)bm_dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                                key:(id)key
                                            options:(CCOptions)options
                                              error:(CCCryptorStatus *)error;

/**
 Returns an encrypted NSData or an decrypted NSData using an algorithm.
 
 @param algorithm           Defines the encryption algorithm(AES, DES ...).
 
 @param encryptOrDecrypt    Defines the basic operation: kCCEncrypt or kCCDecrypt.
 
 @param key                 A key length of 16, 24 or 32 (128, 192 or 256bits).
                            NSData or NSString.
 
 @param iv                  An initialization vector length of 16(128bits).
                            Pass nil when you don't want to use iv.
                            NSData or NSString.
 
 @param options             A word of flags defining options.
 
 @return                    An NSData encrypted, or nil if an error occurs.
 */
- (nullable NSData *)bm_dataUsingAlgorithm:(CCAlgorithm)algorithm
                          encryptOrDecrypt:(CCOperation)encryptOrDecrypt
                                       key:(id)key
                      initializationVector:(nullable id)iv
                                   options:(CCOptions)options
                                     error:(CCCryptorStatus *)error;

// AES
- (nullable NSData *)bm_AES256EncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSData *)bm_AES256DecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
// DES
- (nullable NSData *)bm_DESEncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSData *)bm_DESDecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSData *)bm_TripleDESEncryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;
- (nullable NSData *)bm_TripleDESDecryptedDataUsingKey:(id)key iv:(nullable id)iv error:(NSError * _Nullable * _Nullable)error;


#pragma mark - Encode and decode

///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns string decoded in UTF8.
 */
- (NSString *)bm_utf8String;

/**
 Returns a uppercase NSString in HEX.
 */
- (NSString *)bm_hexString;

/**
 Returns a lowercase NSString in HEX.
 */
- (NSString *)bm_lowerHexString;

/**
 Returns an NSData from hex string.
 
 @param hexString   The hex string which is case insensitive.
 
 @return a new NSData, or nil if an error occurs.
 */
+ (nullable NSData *)bm_dataWithHexString:(NSString *)hexString;


#pragma mark - Inflate and deflate
///=============================================================================
/// @name Inflate and deflate
///=============================================================================

/**
 Decompress data from gzip data.
 @return Inflated data.
 */
- (nullable NSData *)bm_gzipInflate;

/**
 Comperss data to gzip in default compresssion level.
 @return Deflated data.
 */
- (nullable NSData *)bm_gzipDeflate;

/**
 Decompress data from zlib-compressed data.
 @return Inflated data.
 */
- (nullable NSData *)bm_zlibInflate;

/**
 Comperss data to zlib-compressed in default compresssion level.
 @return Deflated data.
 */
- (nullable NSData *)bm_zlibDeflate;


#pragma mark - File hash

/**
 Returns a NSData for md5 hash of the file.
 
 @param filePath   The file.
 */
+ (nullable NSData *)bm_getFileMD5HashData:(NSString *)filePath;
/**
 Returns a lowercase string for md5 hash of the file.
 
 @param filePath   The file.
 */
+ (nullable NSString *)bm_getFileMD5HashString:(NSString *)filePath;

+ (nullable NSData *)bm_getFileSHA1HashData:(NSString *)filePath;
+ (nullable NSString *)bm_getFileSHA1HashString:(NSString *)filePath;

+ (nullable NSData *)bm_getFileSHA256HashData:(NSString *)filePath;
+ (nullable NSString *)bm_getFileSHA256HashString:(NSString *)filePath;

+ (nullable NSData *)bm_getFileSHA512HashData:(NSString *)filePath;
+ (nullable NSString *)bm_getFileSHA512HashString:(NSString *)filePath;

/**
 Returns crc32 hash of a file.

 @param filePath   The file.
 */
+ (unsigned long)bm_getFileCRC32:(NSString *)filePath;
+ (NSString *)bm_getFileCRC32String:(NSString *)filePath;


#pragma mark - Others

///=============================================================================
/// @name Others
///=============================================================================

/**
 Create data from the file in main bundle (similar to [UIImage imageNamed:]).
 
 @param name The file name (in main bundle).
 
 @return A new data create from the file.
 */
+ (nullable NSData *)bm_dataNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

#endif

