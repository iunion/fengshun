//
//  ASRManager.m
//  ODR
//
//  Created by Aiwei on 2018/8/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "ASRManager.h"
#import "base64.h"
#import "QCloudAAIClient.h"
#import <CommonCrypto/CommonHMAC.h>
#import <ILiveSDK/ILiveCoreHeader.h>

static NSString *const kASRsid = @"AKIDlfdHxN0ntSVt4KPH0xXWnGl21UUFNoO5";
static NSString *const kASRskey = @"oaYWFO70LGDmcpfwo8uF1IInayysGtgZ";
static NSString *const kASRappid = @"1251000004";
static NSString *const kASRprojectId = @"1013976";

@interface ASRConfig()


@end
@implementation ASRConfig


+(ASRConfig *)defaultConfig
{
    ASRConfig *config = [[ASRConfig alloc]init];
    config.silenceTime = 5;
    config.openHTTPSrequset = YES;
    config.silenceEndDetection = NO;
    config.sub_service_type = 1;
    return config;
}

@end


@interface ASRManager()<QCloudAAIGetSignDelegate>

@property(nonatomic,strong)QCloudAAIClient *client;

@end

@implementation ASRManager
+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key
{
    NSData *secretData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength,YES);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    return base64EncodedResult;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self defaultManager];
}
static ASRManager *manager;
static dispatch_once_t onceToken;
+(ASRManager *)defaultManager
{
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL]init];
    });
    if(!manager.client)[manager p_setConfig:[ASRConfig defaultConfig]];
    return manager;
}

-(void)p_setConfig:(ASRConfig *)config
{
    [_client stop];
    self.client = [[QCloudAAIClient alloc] initWithAppid:kASRappid  secretid:kASRsid projectId:kASRprojectId];
    _client.delegate = self;
    _client.res_type = 1;
    [_client setSilenceTime:config.silenceTime];
    [_client openHTTPSrequset:config.openHTTPSrequset];
    [_client setSilenceEndDetection:config.silenceEndDetection];

}

-(NSString *)getRequestSign:(NSString *)param
{
    return [ASRManager hmacsha1:param secret:kASRskey];
}

-(void)start
{
    if(![_client microphoneAccessRights])
    {
        if ([_delegate respondsToSelector:@selector(asrFailedWithError:)]) {
            [_delegate asrFailedWithError:[NSError errorWithDomain:@"ASRManager" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"未开启麦克风权限"}]];
        }
        return;
    }
    [_client stop];
    
    __block NSString * t  = @"";
    __weak typeof(self) weakSelf = self;
    [_client startDetectionWihtCompletionHandle:^(QCloudAAIRsp *rsp) {
        __strong typeof(weakSelf) self = weakSelf;
        if (rsp.retCode == 0) {
            if (![[ILiveRoomManager getInstance] getCurMicState])
            {
                NSLog(@"麦克风关闭状态");
                return;
            }
            if (![t isEqualToString:rsp.voiceId])
            {
                t = rsp.voiceId;
            }
            
            NSLog(@"监听到语音识别消息：%@", rsp.text);

            if(rsp.text.length&&[self.delegate respondsToSelector:@selector(asrReceiveText:)])[self.delegate asrReceiveText:rsp.text];
        }else{
            NSLog(@"语音识别失败code= %dmsg:%@",rsp.retCode,rsp.descMsg);
            if ([self.delegate respondsToSelector:@selector(asrFailedWithError:)]) {
                [self.delegate asrFailedWithError:[NSError errorWithDomain:@"ASRManager" code:rsp.retCode userInfo:@{NSLocalizedDescriptionKey:rsp.descMsg?rsp.descMsg:@"ASR SDK error!"}]];
            }
        }
    } stateChange:^(QCloudAAIState state) {
        
        __strong typeof(weakSelf) self = weakSelf;
        if([self.delegate respondsToSelector:@selector(asrStateChange:)])[self.delegate asrStateChange:(ASRState)state];
        
    }];
}
-(void)stop
{
    [_client stop];
}
-(void)dealloc
{
    [_client stop];
    _client = nil;
}

+(void)destroy
{
    manager = nil;
    onceToken = 0;
}
@end
