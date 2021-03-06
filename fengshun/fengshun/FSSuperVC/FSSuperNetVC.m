//
//  FSSuperNetVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperNetVC.h"

#import "FSAlertView.h"

@interface FSSuperNetVC ()

// 网络请求
@property (nonatomic, strong) NSURLSessionDataTask *m_DataTask;

// 分享数据获取
@property (nonatomic, strong) NSURLSessionDataTask *m_ShareTask;

@end

@implementation FSSuperNetVC

- (void)dealloc
{
    [_m_DataTask cancel];
    _m_DataTask = nil;

    [_m_ShareTask cancel];
    _m_ShareTask = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // MBProgressHUD显示等待框
    self.m_ProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.m_ProgressHUD.animationType = MBProgressHUDAnimationFade;
    [self.view addSubview:self.m_ProgressHUD];
    
    self.m_ShowProgressHUD = YES;
    self.m_ShowResultHUD = YES;

    self.m_AllowEmptyJson = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bringSomeViewToFront
{
    [self.m_ProgressHUD bm_bringToFront];
}


#pragma mark -
#pragma mark fresh

- (BOOL)canLoadApiData
{
    return YES;
}

- (void)loadApiData
{
    if (![self canLoadApiData])
    {
        return;
    }
    
    if (self.m_ShowProgressHUD)
    {
#if (PROGRESSHUD_UESGIF)
        [self.m_ProgressHUD showWait:YES backgroundColor:nil text:nil useHMGif:YES];
#else
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
#endif
    }
    
    //[self.m_DataTask cancel];
    //self.m_DataTask = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [self setLoadDataRequest];
    
    if (self.m_DataTask)
    {
        request = nil;
    }
    
    if (request)
    {
        BMWeakSelf
        self.m_DataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf loadDataResponseFailed:response error:error];
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf loadDataResponseFinished:response responseDic:responseObject];
            }
            weakSelf.m_DataTask = nil;
        }];
        [self.m_DataTask resume];
    }
    else
    {
        [self.m_ProgressHUD hideAnimated:YES];
    }
}


#pragma mark -
#pragma mark API Request

- (NSMutableURLRequest *)setLoadDataRequest
{
    return nil;
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    // 无用
    return nil;
}

- (void)loadDataResponseFinished:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic
{
    if (!self.m_ShowResultHUD)
    {
        [self.m_ProgressHUD hideAnimated:NO];
    }
    
    if (![responseDic bm_isNotEmptyDictionary])
    {
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:FSAPI_JSON_ERRORCODE];
        
        if (self.m_ShowResultHUD)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", responseDic] bm_convertUnicode];
    BMLog(@"API返回数据是:+++++%@", responseStr);
#endif

    NSInteger statusCode = [responseDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        if (self.m_ShowResultHUD)
        {
            [self.m_ProgressHUD hideAnimated:NO];
        }
        
        BOOL succeed = NO;
        
        NSDictionary *dataDic = [responseDic bm_dictionaryForKey:@"data"];
        succeed = [self succeedLoadedRequestWithDic:dataDic];
        NSArray *dataArray = nil;
        if (!succeed)
        {
            dataArray = [responseDic bm_arrayForKey:@"data"];
            succeed = [self succeedLoadedRequestWithArray:dataArray];
            if (!succeed)
            {
                NSString *requestStr = [responseDic bm_stringTrimForKey:@"data"];
                succeed = [self succeedLoadedRequestWithString:requestStr];
            }
        }
        
        if (succeed)
        {
            return;
        }
        
        if (![dataDic bm_isNotEmptyDictionary] && ![dataArray bm_isNotEmpty])
        {
            // 允许"data"为空
            if (self.m_AllowEmptyJson)
            {
                return;
            }
        }
        
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:FSAPI_DATA_ERRORCODE];
        
        if (self.m_ShowResultHUD)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
    }
    else
    {
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:statusCode];
        
        NSString *message = [responseDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
        if ([self checkRequestStatus:statusCode message:message responseDic:responseDic logOutQuit:YES showLogin:YES])
        {
            [self.m_ProgressHUD hideAnimated:YES];
        }
        else if (self.m_ShowResultHUD)
        {
#ifdef DEBUG
            [self.m_ProgressHUD showAnimated:YES withDetailText:[NSString stringWithFormat:@"%@:%@", @(statusCode), message] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
#else
            [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
#endif
        }
    }
}

- (void)loadDataResponseFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"API失败的错误:++++网络超时");
    [self failLoadedResponse:response responseDic:nil withErrorCode:FSAPI_NET_ERRORCODE];
    
    if (self.m_ShowResultHUD)
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    else
    {
        [self.m_ProgressHUD hideAnimated:YES];
    }
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    if ([requestDic bm_isNotEmptyDictionary])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray
{
    if ([requestArray bm_isNotEmpty])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)succeedLoadedRequestWithString:(NSString *)requestStr
{
    if ([requestStr bm_isNotEmpty])
    {
        return YES;
    }
    
    return NO;
}

- (void)failLoadedResponse:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic withErrorCode:(NSInteger)errorCode
{
    return;
}


#pragma mark -
#pragma mark checkRequestStatus

- (void)checkXMApiWithError:(NSError *)error
{
    if ([error.domain isEqualToString:FSAPIResponseErrorDomain])
    {
        if ([self checkRequestStatus:error.code message:error.userInfo[NSLocalizedDescriptionKey] responseDic:error.userInfo[NSHelpAnchorErrorKey] logOutQuit:YES showLogin:YES])
        {
            [self.m_ProgressHUD hideAnimated:YES];
        }
        else
        {
            if (error.code == 1005)//结果为空时不展示弹窗
            {
                return;
            }
            [self.m_ProgressHUD showAnimated:YES withDetailText:[NSString stringWithFormat:@"%@", [error.userInfo bm_stringForKey:@"NSLocalizedDescription"]] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
    }
}


#pragma mark -
#pragma mark share

- (void)sendGetShareDataWithShareItemId:(NSString *)shareItemId shareType:(NSString *)shareType
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest getShareDataWithShareItemId:shareItemId shareType:shareType];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_ShareTask cancel];
        self.m_ShareTask = nil;
        
        BMWeakSelf
        self.m_ShareTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf getShareDataRequestFailed:response error:error];
                
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf getShareDataRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_ShareTask resume];
    }
}

- (void)getShareDataRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"获取分享返回数据是:+++++%@", responseStr);
#endif
    
    [FSAlertView showAlertWithTitle:@"分享数据" message:[[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode] cancelTitle:@"确定" otherTitle:nil completion:^(BOOL cancelled, NSInteger buttonIndex) {
    }];

    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

- (void)getShareDataRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"获取分享失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

@end
