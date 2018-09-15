//
//  ASRManager.h
//  ODR
//
//  Created by Aiwei on 2018/8/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ASRConfig : NSObject


+(ASRConfig *)defaultConfig;

@property (nonatomic, assign)  NSTimeInterval silenceTime;//

@property (nonatomic,assign)   BOOL silenceEndDetection;//静音是否结束识别 ？ 。。。。。这里可以叫对语音识别模式和长语音识别模式
@property (nonatomic,assign)   BOOL openHTTPSrequset;//语言识别使用HTTPS
@property (nonatomic,assign)   uint sub_service_type;//子服务类型 0-全文转写 1 实时识别   默认：1
@end

typedef NS_ENUM(NSUInteger,ASRState)
{
    ASRStateOpen = 0,
    ASRStateClose,
    ASRStatePrivacyMic,//麦克风权限关闭
};

@protocol ASRDelegate<NSObject>

-(void)asrReceiveText:(NSString *)text;

@optional
-(void)asrFailedWithError:(NSError *)error;
-(void)asrStateChange:(ASRState)state;

@end

@interface ASRManager : NSObject
@property(nonatomic,weak)id<ASRDelegate> delegate;

+(ASRManager *)defaultManager;

-(void)start;

-(void)stop;

+(void)destroy;
@end

