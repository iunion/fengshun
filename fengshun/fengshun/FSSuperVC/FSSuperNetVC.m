//
//  FSSuperNetVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperNetVC.h"

@interface FSSuperNetVC ()

// 网络请求
@property (nonatomic, strong) NSURLSessionDataTask *m_DataTask;

@end

@implementation FSSuperNetVC

- (void)dealloc
{
    [_m_DataTask cancel];
    _m_DataTask = nil;
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
#if DEBUG
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
    
    BMLog(@"API返回数据是:+++++%@", responseDic);
    
    NSInteger statusCode = [responseDic bm_intForKey:@"code"];
    if (statusCode == 0)
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
        if ([self checkRequestStatus:statusCode message:message responseDic:responseDic])
        {
            [self.m_ProgressHUD hideAnimated:YES];
        }
        else if (self.m_ShowResultHUD)
        {
#if DEBUG
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

- (void)failLoadedResponse:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic withErrorCode:(NSInteger)errorCode
{
    return;
}

@end
