//
//  BMTestNSURLProtocol.m
//  fengshun
//
//  Created by jiang deng on 2018/12/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestNSURLProtocol.h"
#import "BMTestNetFlowManager.h"

static NSString * const kBMTestProtocolKey = @"bmtest_protocol_key";

@interface BMTestNSURLProtocol ()
<
    NSURLConnectionDelegate,
    NSURLConnectionDataDelegate
>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;

@end

@implementation BMTestNSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    // 判断开关
    if (![BMTestNetFlowManager sharedInstance].canIntercept)
    {
        return NO;
    }

    // 只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) )
    {
        // 看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:kBMTestProtocolKey inRequest:request])
        {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
//    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
//    mutableReqeust = [self redirectHostInRequset:mutableReqeust];
//    return mutableReqeust;
    return request;
}

+ (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    if ([request.URL host].length == 0)
    {
        return request;
    }
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound)
    {
        return request;
    }
    
    // 定向到服务器
    NSString *ip = @"cn.bing.com";
    
    // 替换域名
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:ip];
    NSURL *url = [NSURL URLWithString:urlString];
    request.URL = url;
    
    return request;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    // 标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:kBMTestProtocolKey inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    [self.connection start];
    
    self.data = [NSMutableData data];
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)stopLoading
{
    //NSLog(@"stopLoading");
    
    [self.connection cancel];
    
    BMTestNetFlowHttpModel *httpModel = [[BMTestNetFlowHttpModel alloc] initWithResponseData:self.data response:self.response request:self.request];
    
    if (!self.response)
    {
        httpModel.statusCode = self.error.localizedDescription;
    }
    
    httpModel.startTime = self.startTime;
    httpModel.endTime = [[NSDate date] timeIntervalSince1970];
    
    httpModel.totalDuration = [NSString bm_secondStringWithSecond:httpModel.endTime - httpModel.startTime];
    
    [[BMTestNetFlowManager sharedInstance] addHttpModel:httpModel];
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    self.error = error;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}
#pragma clang diagnostic pop


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self.data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
}

@end
