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


#define FSAPIResponseErrorDomain    @"com.bmsf.publicError"

@interface XMUploadFile : NSObject

@property (nonatomic, copy, nonnull) NSString * fileName;
@property (nonatomic, strong, nullable) NSData *fileData;

// text/xml, image/png等
@property (nonatomic, copy, nullable) NSString *mimeType;

+ (nonnull instancetype)uploadFileWithName:(nonnull NSString *)fileName mimeType:(nullable NSString *)mimeType andData:(nullable NSData *)fileData;

@end


@interface XMRequestManager : NSObject

// +(void)setupNetworkConfig方法中做网络请求的全局配置


// 发送网络请求的一般方法
+ (nonnull XMRequest *)rm_requestWithApi:(nonnull NSString *)api parameters:(nullable NSDictionary *)parameters
                         success:(nullable XMSuccessBlock)successBlock
                         failure:(nullable XMFailureBlock)failureBlock;
+ (nonnull XMRequest *)rm_getRequestWithApi:(nonnull NSString *)api parameters:(nullable NSDictionary *)parameters
                         success:(nullable XMSuccessBlock)successBlock
                         failure:(nullable XMFailureBlock)failureBlock;

// 发送网络请求的全能方法
+ (nonnull XMRequest *)rm_requestWithServer:(nullable NSString *)server api:(nonnull NSString *)api method:(XMHTTPMethodType)methodType parameters:(nullable NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval
                            success:(nullable XMSuccessBlock)successBlock
                            failure:(nullable XMFailureBlock)failureBlock;
// 上传请求的一般方法
+ (nonnull XMRequest *)rm_uploadFiles:(nonnull NSArray<XMUploadFile *> *)files forAPI:(nonnull NSString *)api dataKey:(nullable NSString *)dataKey parameters:(nullable NSDictionary *)parameters
                      success:(nullable XMSuccessBlock)successBlock
                      failure:(nullable XMFailureBlock)failureBlock;

// 上传请求的全能方法
+ (nonnull XMRequest *)rm_uploadFiles:(nonnull NSArray<XMUploadFile *> *)files withServer:(nullable NSString *)server api:(nonnull NSString *)api dataKey:(nullable NSString *)dataKey parameters:(nullable NSDictionary *)parameters
                      success:(nullable XMSuccessBlock)successBlock
                      failure:(nullable XMFailureBlock)failureBlock;
// 下载的一般方法
+ (nonnull XMRequest *)rm_downloadWithURL:(nonnull NSString *)url savePath:(nonnull NSString *)savePath
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;

// 下载的全能方法
+ (nonnull XMRequest *)rm_downloadWithURL:(nonnull NSString *)url savePath:(nonnull NSString *)savePath onProgress:(nullable XMProgressBlock)progressBlock
                          success:(nullable XMSuccessBlock)successBlock
                          failure:(nullable XMFailureBlock)failureBlock;


// 取消一个request,被取消的请求对象（如果存在）会以参数的形式传给 cancel block
// 如果取消一个已经结束的请求,该方法调用会被忽略
+ (void)rm_cancelRequest:(nonnull XMRequest *)request
               onCancel:(nullable XMCancelBlock)cancelBlock;

+ (void)rm_cancelRequest:(nonnull XMRequest *)request;

@end
