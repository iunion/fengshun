//
//  QCloudAAIClient.h
//  QCloudAAIClient
//
//  Created by 贾立飞 on 2017/2/20.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @enum  enum
 @abstract 文件上传过程中的状态.
 */
typedef NS_ENUM(NSInteger, QCloudAAIState)
{
    /*! 语音识别打开  */
    QCloudAAIStateOpen = 0,
    /*! 语音识别关闭  */
    QCloudAAIStateClose,
    /*! 语音识别失败，麦克风权限没有开启  */
    QCloudAAIStateFail,
};

/***************************** 后台回包信息 ********************************/
/**
 * 语音识别请求回包的基类
 */
@interface QCloudAAIRsp : NSObject
/** 任务描述代码，为retCode = 0时标示成功，其他表示为失败 */
@property (nonatomic, assign)    int                    retCode;
/** 任务描述信息 */
@property (nonatomic, strong)    NSString               *descMsg;
/** 语音流的识别id */
@property (nonatomic, strong)    NSString               *voiceId;
/** 语音流的识别结果 */
@property (nonatomic, strong)    NSString               *text;
@end


/***************************** 回包block ********************************/
/*!
 * @brief 文件上传完成回调
 * @param resp 识别语音上传回包  @see <QCloudAAIRsp>
 */
typedef void (^QCloudAAICompletionHandler)(QCloudAAIRsp  *resp);


/*!
 * @brief 识别状态的变化回调
 * @param state 识别语音状态的  @see <QCloudAAIState>
 */
typedef void (^QCloudAAIChangeHandler)(QCloudAAIState state);


/***************************** 请求签名的delegate ********************************/

@protocol QCloudAAIGetSignDelegate <NSObject>

@required
// 获取请求的签名
- (NSString *)getRequestSign:(NSString*)param;

@end

@class QCloudAudioRecord;
@class QCloudAAIVoiceDetection;
@class QCloudAAIRequestManager;
@class QCloudAAIStreamManager;

/*****************************识别请求的Client ********************************/
@interface QCloudAAIClient : NSObject
{
    @private
    
     QCloudAudioRecord *audioRecord;
     QCloudAAIVoiceDetection *detection;
     QCloudAAIStreamManager *requsetManager;
}

@property (nonatomic,assign)   id<QCloudAAIGetSignDelegate> delegate;//获取签名的delegate，获取签名的必须是同步的

@property(nonatomic,strong)    QCloudAAICompletionHandler completionHandler;//识别的结果

@property(nonatomic,strong)    QCloudAAIChangeHandler stateChange;//状态变化

@property (nonatomic,copy)     NSString *secretid;//

@property (nonatomic,copy)     NSString *projectid;//项目ID

@property (nonatomic, assign)  NSTimeInterval silenceTime;//

@property (nonatomic,assign)   BOOL silenceEndDetection;//静音是否结束识别 ？ 。。。。。这里可以叫对语音识别模式和长语音识别模式

@property (nonatomic,assign)   BOOL audioVolumeDetection;//声音音量监听

@property (nonatomic, assign)  double audioVolume;//声音音量

@property (nonatomic,assign)   uint res_type;//结果返回方式0：同步(sync)  1 尾包返回(end) 默认：0

@property (nonatomic,assign)   uint sub_service_type;//子服务类型 0-全文转写 1 实时识别   默认：1

@property (nonatomic,assign)   uint engine_model_type;//目前实时的引擎编号只支持1和16k_0 默认：1

@property (nonatomic,assign)   uint result_text_format;//识别结果文本编码方式0：utf8  1：gb2312 2：gbk 3：big5  默认：0

-(BOOL)microphoneAccessRights;//判断是否有麦克风权限

-(id)initWithAppid:(NSString *)appid secretid:(NSString *)sid  projectId:(NSString *)pid;

-(void)startDetectionWihtCompletionHandle:(QCloudAAICompletionHandler)handler stateChange:(QCloudAAIChangeHandler)stateChange;

-(void)stop;

-(double)getAudioVolume;

/*!
 @abstract 开启设置后上传和下载将使用https 请求
 */
-(void)openHTTPSrequset:(BOOL)open;

@end


