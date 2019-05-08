//
//  BNTestNetFlowHttpModel.h
//  fengshun
//
//  Created by jiang deng on 2018/12/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMTestNetFlowHttpModel : NSObject

//@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *method;

@property (nullable, nonatomic, copy) NSString *requestBody;
@property (nonatomic, copy) NSString *statusCode;

@property (nullable, nonatomic, copy) NSData *responseData;
@property (nullable, nonatomic, copy) NSString *responseBody;
@property (nonatomic, copy) NSString *mineType;

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

@property (nonatomic, copy) NSString *totalDuration;

// 上行流量
@property (nonatomic, copy) NSString *uploadFlow;
// 下行流量
@property (nonatomic, copy) NSString *downFlow;

// 请求
@property (nonatomic, strong) NSURLRequest *request;
// 应答
@property (nonatomic, strong) NSURLResponse *response;

- (instancetype)initWithResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
