//
//  NSData+BMEncrypt.m
//  BMBasekit
//
//  Created by DennisDeng on 2017/5/2.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#if BMBasekit_Category_Encrypt

#import "NSData+BMEncrypt.h"
#import <zlib.h>

NSString * const kEncryptErrorDomain = @"kEncryptErrorDomain";

@implementation NSError (BMEncrypt)

+ (NSError *)bm_errorWithCCCryptorStatus:(CCCryptorStatus)status
{
    NSString *description = nil, *reason = nil;
    
    switch (status)
    {
        case kCCSuccess:
            description = NSLocalizedString(@"Success", @"Error description");
            break;
            
        case kCCParamError:
            description = NSLocalizedString(@"Parameter Error", @"Error description");
            reason = NSLocalizedString(@"Illegal parameter supplied to encryption/decryption algorithm", @"Error reason");
            break;
            
        case kCCBufferTooSmall:
            description = NSLocalizedString(@"Buffer Too Small", @"Error description");
            reason = NSLocalizedString(@"Insufficient buffer provided for specified operation", @"Error reason");
            break;
            
        case kCCMemoryFailure:
            description = NSLocalizedString(@"Memory Failure", @"Error description");
            reason = NSLocalizedString(@"Failed to allocate memory", @"Error reason");
            break;
            
        case kCCAlignmentError:
            description = NSLocalizedString(@"Alignment Error", @"Error description");
            reason = NSLocalizedString(@"Input size to encryption algorithm was not aligned correctly", @"Error reason");
            break;
            
        case kCCDecodeError:
            description = NSLocalizedString(@"Decode Error", @"Error description");
            reason = NSLocalizedString(@"Input data did not decode or decrypt correctly", @"Error reason");
            break;
            
        case kCCUnimplemented:
            description = NSLocalizedString(@"Unimplemented Function", @"Error description");
            reason = NSLocalizedString(@"Function not implemented for the current algorithm", @"Error reason");
            break;
            
        case -1:
            description = NSLocalizedString(@"Wrong algorithm", @"Error description");
            break;
            
        default:
            description = NSLocalizedString(@"Unknown Error", @"Error description");
            break;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
    
    if (reason != nil)
    {
        [userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    NSError *result = [NSError errorWithDomain:kEncryptErrorDomain code:status userInfo:userInfo];
    
    return result;
}

@end


@implementation NSData (BMEncrypt)

#pragma mark - Hash

+ (NSString *)stringFromBytes:(unsigned char *)bytes length:(NSUInteger)length
{
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++)
    {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}

- (NSString *)bm_md2String
{
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_MD2_DIGEST_LENGTH];
}

- (NSData *)bm_md2Data
{
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD2_DIGEST_LENGTH];
}

- (NSString *)bm_md4String
{
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_MD4_DIGEST_LENGTH];
}

- (NSData *)bm_md4Data
{
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD4_DIGEST_LENGTH];
}

- (NSString *)bm_md5String
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)bm_md5Data
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)bm_sha1String
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)bm_sha1Data
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)bm_sha224String
{
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_SHA224_DIGEST_LENGTH];
}

- (NSData *)bm_sha224Data
{
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)bm_sha256String
{
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

- (NSData *)bm_sha256Data
{
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)bm_sha384String
{
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_SHA384_DIGEST_LENGTH];
}

- (NSData *)bm_sha384Data
{
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)bm_sha512String
{
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    return [NSData stringFromBytes:result length:CC_SHA512_DIGEST_LENGTH];
}

- (NSData *)bm_sha512Data
{
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key
{
    size_t size;
    switch (alg)
    {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(alg, cKey, strlen(cKey), self.bytes, self.length, result);
    return [NSData stringFromBytes:result length:size];
}

- (NSData *)hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(NSData *)key
{
    size_t size;
    switch (alg)
    {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    CCHmac(alg, [key bytes], key.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}

- (NSString *)bm_hmacMD5StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSData *)bm_hmacMD5DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSString *)bm_hmacSHA1StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSData *)bm_hmacSHA1DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSString *)bm_hmacSHA224StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

- (NSData *)bm_hmacSHA224DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

- (NSString *)bm_hmacSHA256StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

- (NSData *)bm_hmacSHA256DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

- (NSString *)bm_hmacSHA384StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

- (NSData *)bm_hmacSHA384DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

- (NSString *)bm_hmacSHA512StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

- (NSData *)bm_hmacSHA512DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

- (NSString *)bm_crc32String
{
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    return [NSString stringWithFormat:@"%08x", (uint32_t)result];
}

- (uint32_t)bm_crc32
{
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    return (uint32_t)result;
}


#pragma mark - Encrypt and Decrypt

- (NSData *)bm_dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key
                                  error:(CCCryptorStatus *)error
{
    return [self bm_dataEncryptedUsingAlgorithm:algorithm
                                         key:key
                        initializationVector:nil
                                     options:0
                                       error:error];
}

- (NSData *)bm_dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    return [self bm_dataEncryptedUsingAlgorithm:algorithm
                                            key:key
                           initializationVector:nil
                                        options:options
                                          error:error];
}

- (NSData *)bm_dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                   initializationVector:(id)iv		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    return [self bm_dataUsingAlgorithm:algorithm
                      encryptOrDecrypt:kCCEncrypt
                                   key:key
                  initializationVector:iv
                               options:options
                                 error:error];
}

- (NSData *)bm_dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key
                                  error:(CCCryptorStatus *)error
{
    return [self bm_dataDecryptedUsingAlgorithm:algorithm
                                            key:key
                           initializationVector:nil
                                        options:0
                                          error:error];
}

- (NSData *)bm_dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    return [self bm_dataDecryptedUsingAlgorithm:algorithm
                                         key:key
                        initializationVector:nil
                                     options:options
                                       error:error];
}

- (NSData *)bm_dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                   initializationVector:(id)iv		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    return [self bm_dataUsingAlgorithm:algorithm
                   encryptOrDecrypt:kCCDecrypt
                                key:key
               initializationVector:iv
                            options:options
                              error:error];
}


- (NSData *)bm_dataUsingAlgorithm:(CCAlgorithm)algorithm
              encryptOrDecrypt:(CCOperation)encryptOrDecrypt
                           key:(id)key		// data or string
          initializationVector:(id)iv		// data or string
                       options:(CCOptions)options
                         error:(CCCryptorStatus *)error
{
    if (encryptOrDecrypt > kCCDecrypt)
    {
        return nil;
    }
    
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass: [NSData class]] || [iv isKindOfClass: [NSString class]]);
    
    NSMutableData *keyData, *ivData;
    if ([key isKindOfClass:[NSData class]])
    {
        keyData = [NSMutableData dataWithData:key];
    }
    else
    {
        keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    
    if ([iv isKindOfClass:[NSData class]])
    {
        ivData = (NSMutableData *)[iv mutableCopy];
    }
    else
    {
        ivData = [[iv dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    
    // ensure correct lengths for key and iv data, based on algorithms
    if (![self fixKeyLength:keyData ivLength:ivData withAlgorithm:algorithm])
    {
        if (error != NULL)
        {
            *error = -1;
        }
        return nil;
    }
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus ccStatus = kCCSuccess;
    
    ccStatus = CCCryptorCreate(encryptOrDecrypt, algorithm, options,
                               [keyData bytes], [keyData length], [ivData bytes],
                               &cryptor);
    
    if (ccStatus != kCCSuccess)
    {
        if (error != NULL)
        {
            *error = ccStatus;
        }
        return nil;
    }
    
    NSData *result = [self _runCryptor: cryptor result:&ccStatus];
    if ((result == nil) && (error != NULL))
    {
        *error = ccStatus;
    }
    
    CCCryptorRelease(cryptor);
    
    return result;
}

- (NSData *)bm_AES256EncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self bm_dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                       key:key
                                      initializationVector:iv
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];

    if (result != nil)
    {
        return result;
    }
    
    if (error != NULL)
    {
        *error = [NSError bm_errorWithCCCryptorStatus:status];
    }
    
    return nil;
}

- (NSData *)bm_AES256DecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self bm_dataDecryptedUsingAlgorithm:kCCAlgorithmAES128
                                                       key:key
                                      initializationVector:iv
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];

    if (result != nil)
    {
        return result;
    }
    
    if (error != NULL)
    {
        *error = [NSError bm_errorWithCCCryptorStatus:status];
    }
    
    return nil;
}

- (NSData *)bm_DESEncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self bm_dataEncryptedUsingAlgorithm:kCCAlgorithmDES
                                                       key:key
                                      initializationVector:iv
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];

    if (result != nil)
    {
        return result;
    }
    
    if (error != NULL)
    {
        *error = [NSError bm_errorWithCCCryptorStatus:status];
    }
    
    return nil;
}

- (NSData *)bm_DESDecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self bm_dataDecryptedUsingAlgorithm:kCCAlgorithmDES
                                                       key:key
                                      initializationVector:iv
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];

    if (result != nil)
    {
        return result;
    }
    
    if (error != NULL)
    {
        *error = [NSError bm_errorWithCCCryptorStatus:status];
    }
    
    return nil;
}

- (NSData *)bm_TripleDESEncryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self bm_dataEncryptedUsingAlgorithm:kCCAlgorithm3DES
                                                       key:key
                                      initializationVector:iv
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];

    if (result != nil)
    {
        return result;
    }
    
    if (error != NULL)
    {
        *error = [NSError bm_errorWithCCCryptorStatus:status];
    }
    
    return nil;
}

- (NSData *)bm_TripleDESDecryptedDataUsingKey:(id)key iv:(id)iv error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self bm_dataDecryptedUsingAlgorithm:kCCAlgorithm3DES
                                                       key:key
                                      initializationVector:iv
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];

    if (result != nil)
    {
        return result;
    }
    
    if (error != NULL)
    {
        *error = [NSError bm_errorWithCCCryptorStatus:status];
    }
    
    return nil;
}


#pragma mark - private

- (NSData *)_runCryptor:(CCCryptorRef)cryptor result:(CCCryptorStatus *)status
{
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[self length], true);
    void *buf = malloc(bufsize);
    size_t bufused = 0;
    size_t bytesTotal = 0;
    
    *status = CCCryptorUpdate(cryptor, [self bytes], (size_t)[self length],
                              buf, bufsize, &bufused);
    if (*status != kCCSuccess)
    {
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    *status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    if (*status != kCCSuccess)
    {
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    NSData *data = [NSData dataWithBytesNoCopy:buf length:bytesTotal];
    
    return data;
}

- (BOOL)fixKeyLength:(NSMutableData *)keyData ivLength:(NSMutableData *)ivData withAlgorithm:(CCAlgorithm)algorithm
{
    NSUInteger keyLength = keyData.length;
    
    NSUInteger CCKeySize, CCBlockSize;
    switch (algorithm)
    {
        case kCCAlgorithmAES128:
        {
            if (keyLength < kCCKeySizeAES128)
            {
                CCKeySize = kCCKeySizeAES128;
            }
            else if (keyLength < kCCKeySizeAES192)
            {
                CCKeySize = kCCKeySizeAES192;
            }
            else
            {
                CCKeySize = kCCKeySizeAES256;
            }
            CCBlockSize = kCCBlockSizeAES128;
            
            break;
        }
            
        case kCCAlgorithmDES:
        {
            CCKeySize = kCCKeySizeDES;
            CCBlockSize = kCCBlockSizeDES;
            break;
        }
            
        case kCCAlgorithm3DES:
        {
            CCKeySize = kCCKeySize3DES;
            CCBlockSize = kCCBlockSize3DES;
            break;
        }
            
        case kCCAlgorithmCAST:
        {
            if (keyLength < kCCKeySizeMinCAST)
            {
                CCKeySize = kCCKeySizeMinCAST;
            }
            else if (keyLength > kCCKeySizeMaxCAST)
            {
                CCKeySize = kCCKeySizeMaxCAST;
            }
            else
            {
                CCKeySize = keyLength;
            }
            CCBlockSize = kCCBlockSizeCAST;
            
            break;
        }
            
        case kCCAlgorithmRC4:
        {
            if ( keyLength < kCCKeySizeMinRC4 )
            {
                CCKeySize = kCCKeySizeMinRC4;
            }
            else if ( keyLength > kCCKeySizeMaxRC4 )
            {
                CCKeySize = kCCKeySizeMaxRC4;
            }
            else
            {
                CCKeySize = keyLength;
            }
            CCBlockSize = kCCBlockSizeRC2;
            
            break;
        }
            
        case kCCAlgorithmRC2:
        {
            if ( keyLength < kCCKeySizeMinRC2 )
            {
                CCKeySize = kCCKeySizeMinRC2;
            }
            else if ( keyLength > kCCKeySizeMaxRC2 )
            {
                CCKeySize = kCCKeySizeMaxRC2;
            }
            else
            {
                CCKeySize = keyLength;
            }
            CCBlockSize = kCCBlockSizeRC2;
            
            break;
        }
            
        case kCCAlgorithmBlowfish:
        {
            if ( keyLength < kCCKeySizeMinBlowfish )
            {
                CCKeySize = kCCKeySizeMinBlowfish;
            }
            else if ( keyLength > kCCKeySizeMaxBlowfish )
            {
                CCKeySize = kCCKeySizeMaxBlowfish;
            }
            else
            {
                CCKeySize = keyLength;
            }
            CCBlockSize = kCCBlockSizeBlowfish;
            
            break;
        }
            
        default:
            return NO;
    }
    
    [keyData setLength:CCKeySize];
    [ivData setLength:CCBlockSize];
    
    return YES;
}


#pragma mark - Encode and decode

- (NSString *)bm_utf8String
{
    if (self.length > 0)
    {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    return @"";
}

- (NSString *)bm_hexString
{
    NSUInteger length = self.length;
    NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *byte = self.bytes;
    for (int i = 0; i < length; i++, byte++)
    {
        [result appendFormat:@"%02X", *byte];
    }
    return result;
}

- (NSString *)bm_lowerHexString
{
    NSUInteger length = self.length;
    NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *byte = self.bytes;
    for (int i = 0; i < length; i++, byte++)
    {
        [result appendFormat:@"%02x", *byte];
    }
    return result;
}

+ (NSData *)bm_dataWithHexString:(NSString *)hexStr
{
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    hexStr = [hexStr lowercaseString];
    NSUInteger len = hexStr.length;
    if (!len) return nil;
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return nil;
    [hexStr getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableData *result = [NSMutableData data];
    unsigned char bytes;
    char str[3] = { '\0', '\0', '\0' };
    int i;
    for (i = 0; i < len / 2; i++)
    {
        str[0] = buf[i * 2];
        str[1] = buf[i * 2 + 1];
        bytes = strtol(str, NULL, 16);
        [result appendBytes:&bytes length:1];
    }
    free(buf);
    return result;
}


#pragma mark - Inflate and deflate

- (NSData *)bm_gzipInflate
{
    if ([self length] == 0) return self;
    
    unsigned full_length = (unsigned)[self length];
    unsigned half_length = (unsigned)[self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData
                                   dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (unsigned)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15 + 32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy:half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd(&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    } else return nil;
}

- (NSData *)bm_gzipDeflate
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
// Compresssion Levels:
//   Z_NO_COMPRESSION
//   Z_BEST_SPEED
//   Z_BEST_COMPRESSION
//   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15 + 16),
                     8, Z_DEFAULT_STRATEGY) != Z_OK)
        return nil;
    
    // 16K chunks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do
    {
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy:16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
    }
    while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}

- (NSData *)bm_zlibInflate
{
    if ([self length] == 0) return self;
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData
                                   dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)full_length;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit(&strm) != Z_OK) return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy:half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd(&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    } else return nil;
}

- (NSData *)bm_zlibDeflate
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
// Compresssion Levels:
//   Z_NO_COMPRESSION
//   Z_BEST_SPEED
//   Z_BEST_COMPRESSION
//   Z_DEFAULT_COMPRESSION
    
    if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;
    
    // 16K chuncks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do
    {
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy:16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
    }
    while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}


#pragma mark - File hash

#define FileHashDefaultChunkSizeForReadingData 4096

+ (id)getFileMD5Hash:(NSString *)filePath returnData:(BOOL)returnData
{
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (fp == nil)
    {
        return nil;
    }
    
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES)
    {
        @autoreleasepool
        {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0)
            {
                break;
            }
        }
    }
    [fp closeFile];
    
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    
    if (returnData)
    {
        return [NSData dataWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
    }
    else
    {
        return [NSData stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
    }
}

+ (NSData *)bm_getFileMD5HashData:(NSString *)filePath
{
    return [NSData getFileMD5Hash:filePath returnData:YES];
}

+ (NSString *)bm_getFileMD5HashString:(NSString *)filePath
{
    return [NSData getFileMD5Hash:filePath returnData:NO];
}

+ (id)getFileSHA1Hash:(NSString *)filePath returnData:(BOOL)returnData
{
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (fp == nil)
    {
        return nil;
    }
    
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES)
    {
        @autoreleasepool
        {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0)
            {
                break;
            }
        }
    }
    [fp closeFile];
    
    unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    
    if (returnData)
    {
        return [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    }
    else
    {
        return [NSData stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    }
}

+ (NSData *)bm_getFileSHA1HashData:(NSString *)filePath
{
    return [NSData getFileSHA1Hash:filePath returnData:YES];
}

+ (NSString *)bm_getFileSHA1HashString:(NSString *)filePath
{
    return [NSData getFileSHA1Hash:filePath returnData:NO];
}

+ (id)getFileSHA256Hash:(NSString *)filePath returnData:(BOOL)returnData
{
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (fp == nil)
    {
        return nil;
    }
    
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES)
    {
        @autoreleasepool
        {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0)
            {
                break;
            }
        }
    }
    [fp closeFile];
    
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    
    if (returnData)
    {
        return [NSData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
    }
    else
    {
        return [NSData stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
    }
}

+ (NSData *)bm_getFileSHA256HashData:(NSString *)filePath
{
    return [NSData getFileSHA256Hash:filePath returnData:YES];
}

+ (NSString *)bm_getFileSHA256HashString:(NSString *)filePath
{
    return [NSData getFileSHA256Hash:filePath returnData:NO];
}

+ (id)getFileSHA512Hash:(NSString *)filePath returnData:(BOOL)returnData
{
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (fp == nil)
    {
        return nil;
    }
    
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES)
    {
        @autoreleasepool
        {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0)
            {
                break;
            }
        }
    }
    [fp closeFile];
    
    unsigned char buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    
    if (returnData)
    {
        return [NSData dataWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
    }
    else
    {
        return [NSData stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
    }
}

+ (NSData *)bm_getFileSHA512HashData:(NSString *)filePath
{
    return [NSData getFileSHA512Hash:filePath returnData:YES];
}

+ (NSString *)bm_getFileSHA512HashString:(NSString *)filePath
{
    return [NSData getFileSHA512Hash:filePath returnData:NO];
}

+ (NSArray *)sharedCRCTables
{
    static NSMutableArray *sharedCRC_Tables = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedCRC_Tables = [[NSMutableArray alloc] initWithCapacity:256];
        
        unsigned long ploy = 0xEDB88320;
        unsigned long crc;
        
        for (int i = 0; i <= 255; i ++)
        {
            crc = i;
            for (int j = 8; j >= 1; j --)
            {
                if ((crc & 1) == 1)
                {
                    crc = (crc >> 1) ^ ploy;
                }
                else
                {
                    crc = (crc >> 1);
                }
            }
            [sharedCRC_Tables addObject:[NSNumber numberWithLong:crc]];
        }
    });
    
    return sharedCRC_Tables;
}

+ (unsigned long)bm_getFileCRC32:(NSString *)filePath
{
    unsigned long crc = 0xFFFFFFFF;
    
    //创建文件管理器
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath])
    {
        BMLog(@"文件不存在");
        return 0;
    }
    
    //得到文件大小
    NSError *error = nil;
    NSDictionary* dictFile = [fm attributesOfItemAtPath:filePath error:&error];
    if (error)
    {
        BMLog(@"GetFileSize error: %@", error);
        //break;
        return 0;
    }
    unsigned long long len = [dictFile fileSize];
    //BMLog(@"file size=%d", nFileSize);
    
    NSFileHandle *inFile;
    inFile = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (inFile == nil)
    {
        BMLog(@"open file for reading failed");
        return 0;
    }
    
    //设置当前偏移量
    [inFile seekToFileOffset:0];
    
    unsigned long long bufferSize;
    unsigned long long j;
    
    while (YES)
    {
        if (len <= 0)  break;
        if (len >= 10240)
            bufferSize = 10240;
        else
            bufferSize = len;
        
        NSData *data = [inFile readDataOfLength:(NSUInteger)bufferSize];
        Byte *byteData = (Byte *)[data bytes];
        
        j = 0;
        while (j < bufferSize)
        {
            NSInteger iIndex = (crc ^ byteData[j]) & 0xFF;
            NSNumber *num = [[NSData sharedCRCTables] objectAtIndex:iIndex];
            crc = ((crc >> 8) & 0xFFFFFF) ^ [num unsignedLongValue];
            j++;
        }
        len -= bufferSize;
    }
    
    [inFile closeFile];
    
    BMLog(@"result = %lu", crc ^ 0xFFFFFFFF);
    
    return (crc ^ 0xFFFFFFFF);
}

//- (unsigned long)getCRC
//{
//    unsigned long crc = 0xFFFFFFFF;
//    
//    NSInteger bufferSize;
//    int j;
//    
//    bufferSize = self.length;
//    Byte *byteData = (Byte *)[self bytes];
//    
//    j = 0;
//    
//    while (j < bufferSize)
//    {
//        int iIndex = (crc ^ byteData[j]) & 0xFF;
//        NSNumber *num = [[NSData sharedCRCTables] objectAtIndex:iIndex];
//        crc = ((crc >> 8) & 0xFFFFFF) ^ [num unsignedLongValue];
//        j++;
//    }
//    
//    BMLog(@"result = %lu", crc ^ 0xFFFFFFFF);
//    
//    return (crc ^ 0xFFFFFFFF);
//}

+ (NSString *)bm_getFileCRC32String:(NSString *)filePath
{
    unsigned long result = [NSData bm_getFileCRC32:filePath];
    return [NSString stringWithFormat:@"%08lx", result];
}


#pragma mark - Others

+ (NSData *)bm_dataNamed:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    if (!path) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

@end

#endif

