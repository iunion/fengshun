//
//  XMRequestManager.m
//  XMNetworkingDemo
//
//  Created by Aiwei on 2018/8/23.
//  Copyright © 2018 XMNetworking. All rights reserved.
//

#import "XMRequestManager.h"
#import "AFNetworking.h"

@implementation XMUploadFile

+ (instancetype)uploadFileWithName:(NSString *)fileName mimeType:(NSString *)mimeType andData:(NSData *)fileData
{
    XMUploadFile *file = [[super alloc] init];
    file.fileName = fileName;
    file.mimeType = mimeType;
    file.fileData = fileData;
    return file;
}

@end

@implementation XMRequestManager

+ (void)initialize
{
    // 网络请求的全局配置
    [self setupNetworkConfig];
}

+ (AFHTTPRequestSerializer *)httpRequestSerializer
{
    static AFHTTPRequestSerializer *mqRequestSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mqRequestSerializer = [AFHTTPRequestSerializer serializer];
        mqRequestSerializer.timeoutInterval = TIMEOUT_SECONDS;
        // 这儿可设置一些更基层的header
        [mqRequestSerializer setValue:@"iOS" forHTTPHeaderField:@"cType"];

    });

    return mqRequestSerializer;
}

+ (AFSecurityPolicy *)customSecurityPolicy
{
    static AFSecurityPolicy *mqSecurityPolicy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 先导入证书，找到证书的路径
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"你的证书名字" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];

        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        // validatesDomainName 是否需要验证域名，默认为YES；
        // 假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        // 置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        // 如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;

        NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
        securityPolicy.pinnedCertificates = set;

        mqSecurityPolicy = securityPolicy;
    });

    return mqSecurityPolicy;
}

+ (NSString *)publicErrorMessageWithCode:(NSInteger)code
{
    NSString *errorMessage;
    switch (code)
    {
        case 9999:
            errorMessage = @"服务器内部异常";
            break;
        case 1001:
            errorMessage = @"用户未登录";
            break;
        case 1002:
            errorMessage = @"认证令牌失效";
            break;
        case 1003:
            errorMessage = @"非法参数";
            break;
        case 1004:
            errorMessage = @"权限不足";
            break;
        case 1005:
            errorMessage = @"结果为空";
            break;
        case 1006:
            errorMessage = @"操作数据库失败";
            break;

        default:
            errorMessage = @"其他错误";
            break;
    }
    return errorMessage;
}

+ (void)setupNetworkConfig
{
    // 设置一些基础的header
    [XMEngine sharedEngine].afHTTPRequestSerializer = [self httpRequestSerializer];

    // SSL证书相关
    //    [XMCenter defaultCenter].engine.securitySessionManager.securityPolicy = [self customSecurityPolicy];

    // 设置公共的header和公共参数
    [XMCenter setupConfig:^(XMConfig *config) {
        config.generalServer = kGeneralServer;
        config.callbackQueue = dispatch_get_main_queue();
//        config.generalHeaders = nil;
//        config.generalParameters = nil;
#ifdef DEBUG
        config.consoleLog = YES;
#endif
    }];


    // 请求统一预处理插件
    [XMCenter setRequestProcessBlock:^(XMRequest *request){
        // 在这里对所有的请求进行统一的预处理，如业务数据加密等
    }];

    // 响应后统一处理插件
    [XMCenter setResponseProcessBlock:^id(XMRequest *request, id responseObject, NSError *__autoreleasing *error) {

        // 对所有请求的响应进行统一的处理,这儿有几点需要注意:
        // 1.此block的返回值如果不为空,后续回调中的responseObject会被替换为此返回值;
        // 2.网络请求出错会通过此处的error返回;
        // 3.网络请求正常返回,但如果为error自定义赋值,XMCenter的请求后续会走 failureBlock 回调.

        if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] count] > 0)
        {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code != 1000)
            {
                *error = [NSError errorWithDomain:@"com.bmsf.publicError" code:code userInfo:@{NSLocalizedDescriptionKey : [self publicErrorMessageWithCode:code]}];
            }
            else
            {
                // 返回的 Code 表示成功，对数据进行加工过滤，返回给上层业务
                NSDictionary *resultData = responseObject[@"data"];
                return resultData;
            }
        }

        return nil;
    }];

    // 错误统一处理
    [XMCenter setErrorProcessBlock:^(XMRequest *request, NSError *__autoreleasing *error){
        // 这儿的error的情况包括:网络请求出错、自定义error、responseObject解析出错等.

    }];
}

+ (void)p_setupPostRequest:(XMRequest *)request withServer:(NSString *)server API:(NSString *)api methd:(XMHTTPMethodType)methodType parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSAssert(api.length, @"参数不能为空!");
    request.requestType = kXMRequestNormal;
    request.server = server;
    request.httpMethod = methodType;
    request.api = api;
    request.parameters = parameters;
    request.timeoutInterval = timeoutInterval;
}

+ (XMRequest *)rm_requestWithApi:(NSString *)api parameters:(NSDictionary *)parameters success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    return [self rm_requestWithServer:kGeneralServer api:api method:kXMHTTPMethodPOST parameters:parameters timeoutInterval:TIMEOUT_SECONDS success:successBlock failure:failureBlock];
}

+ (XMRequest *)rm_requestWithServer:(NSString *)server api:(NSString *)api method:(XMHTTPMethodType)methodType parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    __block XMRequest *r = nil;
    [[XMCenter defaultCenter] sendRequest:^(XMRequest *_Nonnull request) {
        [self p_setupPostRequest:request withServer:server API:api methd:methodType parameters:parameters timeoutInterval:timeoutInterval];
        r = request;
    }
                               onProgress:nil
                                onSuccess:successBlock
                                onFailure:failureBlock
                               onFinished:nil];
    return r;
}


+ (void)p_setupUploadRequst:(XMRequest *)request withServer:(NSString *)server API:(NSString *)api parameters:(NSDictionary *)parameters dataKey:(NSString *)dataKey andFiles:(NSArray<XMUploadFile *> *)files
{
    NSAssert(api.length && dataKey.length && files.count, @"文件、dataKey、API不能为空!");
    request.requestType = kXMRequestUpload;
    request.server = server;
    request.api = api;
    request.parameters = parameters;
    for (XMUploadFile *file in files)
    {
        [request addFormDataWithName:dataKey fileName:file.fileName mimeType:file.mimeType fileData:file.fileData];
    }
}

+ (XMRequest *)rm_uploadFiles:(NSArray<XMUploadFile *> *)files forAPI:(NSString *)api dataKey:(NSString *)dataKey parameters:(NSDictionary *)parameters success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    return [self rm_uploadFiles:files withServer:kGeneralServer api:api dataKey:dataKey parameters:parameters success:successBlock failure:failureBlock];
}

+ (XMRequest *)rm_uploadFiles:(NSArray<XMUploadFile *> *)files withServer:(NSString *)server api:(NSString *)api dataKey:(NSString *)dataKey parameters:(NSDictionary *)parameters success:(nullable XMSuccessBlock)successBlock failure:(nullable XMFailureBlock)failureBlock
{
    __block XMRequest *r = nil;
    [[XMCenter defaultCenter] sendRequest:^(XMRequest *_Nonnull request) {
        [self p_setupUploadRequst:request withServer:server API:api parameters:parameters dataKey:dataKey andFiles:files];
        r = request;
    }
                               onProgress:nil
                                onSuccess:successBlock
                                onFailure:failureBlock
                               onFinished:nil];
    return r;
}

+ (XMRequest *)rm_downloadWithURL:(NSString *)url savePath:(NSString *)savePath success:(nullable XMSuccessBlock)successBlock failure:(nullable XMFailureBlock)failureBlock
{
    return [self rm_downloadWithURL:url savePath:savePath onProgress:nil success:successBlock failure:failureBlock];
}

+(XMRequest *)rm_downloadWithURL:(NSString *)url savePath:(NSString *)savePath onProgress:(XMProgressBlock)progressBlock success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    __block XMRequest *r = nil;
    [[XMCenter defaultCenter] sendRequest:^(XMRequest * _Nonnull request) {
        request.url = url;
        request.downloadSavePath = savePath;
        request.requestType = kXMRequestDownload;
        r = request;
    } onProgress:progressBlock onSuccess:successBlock onFailure:failureBlock];
    
    return r;
}
+(void)rm_cancelRequest:(XMRequest *)request onCancel:(XMCancelBlock)cancelBlock
{
    XMRequest *r = [[XMCenter defaultCenter].engine cancelRequestByIdentifier:request.identifier];
    XM_SAFE_BLOCK(cancelBlock,r);
    
}

+(void)rm_cancelRequest:(XMRequest *)request
{
    [self rm_cancelRequest:request onCancel:nil];
}

@end
