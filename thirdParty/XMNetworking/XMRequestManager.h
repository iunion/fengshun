//
//  XMRequestManager.h
//  XMNetworkingDemo
//
//  Created by Aiwei on 2018/8/23.
//  Copyright © 2018 XMNetworking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMNetworking.h"
#import "FSAPIMacros.h"



@interface XMUploadFile : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSData *fileData;

// text/xml, image/png等
@property (nonatomic, copy) NSString *mimeType;

+ (instancetype)uploadFileWithName:(NSString *)fileName mimeType:(NSString *)mimeType andData:(NSData *)fileData;

@end


@interface XMRequestManager : NSObject

// +(void)setupNetworkConfig方法中做网络请求的全局配置


// 发送网络请求的一般方法
+ (XMRequest *)rm_requestWithApi:(NSString *)api parameters:(NSDictionary *)parameters
                         success:(nullable XMSuccessBlock)successBlock
                         failure:(nullable XMFailureBlock)failureBlock;

// 发送网络请求的全能方法
+ (XMRequest *)rm_requestWithServer:(NSString *)server api:(NSString *)api method:(XMHTTPMethodType)methodType parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval
                            success:(nullable XMSuccessBlock)successBlock
                            failure:(nullable XMFailureBlock)failureBlock;
// 上传请求的一般方法
+ (XMRequest *)rm_uploadFiles:(NSArray<XMUploadFile *> *)files forAPI:(NSString *)api dataKey:(NSString *)dataKey parameters:(NSDictionary *)parameters
                      success:(nullable XMSuccessBlock)successBlock
                      failure:(nullable XMFailureBlock)failureBlock;

// 上传请求的全能方法
+ (XMRequest *)rm_uploadFiles:(NSArray<XMUploadFile *> *)files withServer:(NSString *)server api:(NSString *)api dataKey:(NSString *)dataKey parameters:(NSDictionary *)parameters
                      success:(nullable XMSuccessBlock)successBlock
                      failure:(nullable XMFailureBlock)failureBlock;
// 下载的一般方法
+ (XMRequest *)rm_downloadWithURL:(NSString *)url savePath:(NSString *)savePath
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;

// 下载的全能方法
+ (XMRequest *)rm_downloadWithURL:(NSString *)url savePath:(NSString *)savePath onProgress:(nullable XMProgressBlock)progressBlock
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;


// 取消一个request,被取消的请求对象（如果存在）会以参数的形式传给 cancel block
// 如果取消一个已经结束的请求,该方法调用会被忽略
+ (void)rm_cancelRequest:(XMRequest *)request
               onCancel:(nullable XMCancelBlock)cancelBlock;

+ (void)rm_cancelRequest:(XMRequest *)request;

@end
