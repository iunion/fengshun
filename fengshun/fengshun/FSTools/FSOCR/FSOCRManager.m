//
//  FSOCRManager.m
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSOCRManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import "AFNetworking.h"


static NSString *const kOCRAppId     = @"1255516392";
static NSString *const kOCRScreatId  = @"AKIDZ9YjhTPNTJuGNEoKWUEk25uUq43mKSP8";
static NSString *const kOCRScreatKey = @"bx33rQkqhKhoghTzFF0VjiSwAxWrxnNh";

static NSString *const kOCRHttpsUrl = @"https://recognition.image.myqcloud.com/ocr/general";
static NSString *const kOCRHost = @"recognition.image.myqcloud.com";

@interface
FSOCRManager ()

@property (nonatomic, copy) NSString *requestSign;

@end

@implementation FSOCRManager

+ (NSString *)p_hmacsha1:(NSString *)data secret:(NSString *)key
{
    NSData *secretData    = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [data dataUsingEncoding:NSUTF8StringEncoding];

    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);

    NSMutableData *mdata = [[NSMutableData alloc] initWithBytes:result length:sizeof(result)];
    [mdata appendData:clearTextData];
    return [mdata base64EncodedStringWithOptions:0];
}
+ (NSString *)p_resetRequestSign
{
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    long      expired  = (long)now + 2592000;
    long      current  = (long)now;
    int       rdm      = rand();
    NSString *parames  = [NSString stringWithFormat:@"a=%@&b=&k=%@&t=%ld&e=%ld&r=%d", kOCRAppId, kOCRScreatId, current, expired, rdm];
    return [self p_hmacsha1:parames secret:kOCRScreatKey];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self manager];
}
+ (instancetype)manager
{
    static FSOCRManager *  manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager             = [[super allocWithZone:NULL] init];
        manager.requestSign = [self p_resetRequestSign];
    });
    return manager;
}
- (NSDictionary *)p_ocrHeaders
{
    return @{ @"host" : kOCRHost,
              @"authorization" : _requestSign };
}
- (AFHTTPSessionManager *)p_AFManagerWithContentType:(BOOL)isJson
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    if (isJson)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return manager;
}
- (void)p_getTextWithImageObj:(UIImage *)imageObj succeed:(void (^)(NSString *))succeed failed:(void (^)(NSError *))failed
{
    AFHTTPSessionManager *manager    = [self p_AFManagerWithContentType:NO];
    [manager POST:kOCRHttpsUrl parameters:@{@"appid" : kOCRAppId} headers:[self p_ocrHeaders] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(imageObj);
        NSString *ext = @"png";
        if (!imageData) {
            imageData = UIImageJPEGRepresentation(imageObj, 1.0);
            ext = @"jpg";
        }
        [formData appendPartWithFileData:imageData name:@"image" fileName:[@"ocrImage" stringByAppendingPathExtension:ext] mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self p_callBackWithResponse:responseObject error:nil succeed:succeed failed:failed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self p_callBackWithResponse:nil error:error succeed:succeed failed:failed];
    }];
}
- (void)p_getTextWithImageUrl:(NSString *)imageUrl succeed:(void (^)(NSString *))succeed failed:(void (^)(NSError *))failed
{
    AFHTTPSessionManager *manager    = [self p_AFManagerWithContentType:YES];
    [manager POST:kOCRHttpsUrl
       parameters:@{ @"appid" : kOCRAppId,
                     @"url" : imageUrl }
        headers:[self p_ocrHeaders]
        progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [self p_callBackWithResponse:responseObject error:nil succeed:succeed failed:failed];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [self p_callBackWithResponse:nil error:error succeed:succeed failed:failed];
        }];
}
- (void)p_callBackWithResponse:(id)responseObject error:(NSError *)error succeed:(void (^)(NSString *))succeed failed:(void (^)(NSError *))failed
{
    NSDictionary *json = responseObject;
    if (error)
    {
        if(failed) failed(error);
    }
    else if ([json bm_intForKey:@"code"])
    {
        NSError *codeError = [NSError errorWithDomain:@"com.ocr.netError" code:[json bm_intForKey:@"code"] userInfo:@{ NSLocalizedDescriptionKey : [json bm_stringForKey:@"message"] }];
       if(failed) failed(codeError);
    }
    else
    {
        if (succeed) succeed([self p_textWithResponse:responseObject]);
    }
}
- (NSString *)p_textWithResponse:(NSDictionary *)responseObject
{
#if DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
    BMLog(@"+++++++++++++OCR 识别返回:%@", responseStr);
#endif
    NSDictionary *data = [responseObject bm_dictionaryForKey:@"data"];
    NSArray *items = [data bm_arrayForKey:@"items"];
    NSString *text = @"";
    for (NSDictionary *item in items) {
        text = [text stringByAppendingString:[item bm_stringForKey:@"itemstring\n"]];
    }
    return [text bm_isNotEmpty]?text:nil;
}
- (void)ocr_getTextWithImage:(id)image succeed:(void (^)(NSString *))succeed failed:(void (^)(NSError *))failed
{
    BMLog(@"+++++++++++++OCR RequestSign:%@", _requestSign);
    if ([image bm_isNotEmpty] && [image isKindOfClass:[UIImage class]])
    {
        [self p_getTextWithImageObj:image succeed:succeed failed:failed];
    }
    else if ([image bm_isNotEmpty] && [image isKindOfClass:[NSString class]])
    {
        [self p_getTextWithImageUrl:image succeed:succeed failed:failed];
    }
    else
    {
        if (failed)
        {
            NSError *error = [NSError errorWithDomain:@"com.ocr.netError" code:-1 userInfo:@{ NSLocalizedDescriptionKey : @"不支持的image类型" }];
            failed(error);
        }
    }
}
@end
