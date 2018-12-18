//
//  BNTestNetFlowHttpModel.m
//  fengshun
//
//  Created by jiang deng on 2018/12/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestNetFlowHttpModel.h"
#import "BMApiUtil.h"

@implementation BMTestNetFlowHttpModel

- (instancetype)initWithResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(NSURLRequest *)request
{
    self = [super init];
    if (self)
    {
        self.request = request;
        //self.requestId = request.requestId;
        self.url = [request.URL absoluteString];
        self.method = request.HTTPMethod;
        
        NSData *httpBody = [BMApiUtil getHttpBodyFromRequest:request];
        self.requestBody = [BMApiUtil serializeJsonFromData:httpBody];
        
        self.uploadFlow = [NSString bm_storeStringWithBitSize:[BMApiUtil getRequestLength:request]];
        
        // response
        self.mineType = response.MIMEType;
        self.response = response;
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        self.statusCode = [NSString stringWithFormat:@"%@", @(httpResponse.statusCode)];
        self.responseData = responseData;
        self.responseBody = [BMApiUtil serializeJsonFromData:responseData];

        if ([response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
            self.downFlow = [NSString bm_storeStringWithBitSize:[BMApiUtil getResponseLength:httpresponse data:responseData]];
        }
    }
        
    return self;
}

@end
