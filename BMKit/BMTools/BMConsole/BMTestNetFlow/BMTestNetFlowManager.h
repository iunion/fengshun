//
//  BMTestNetFlowManager.h
//  fengshun
//
//  Created by jiang deng on 2018/12/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMTestNetFlowHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionConfiguration (BMTest)

@end

@interface BMTestNetFlowManager : NSObject

+ (BMTestNetFlowManager *)sharedInstance;

@property (nullable, nonatomic, strong) NSDate *startInterceptDate;
@property (nonatomic, assign) BOOL canIntercept;

@property (nonatomic, strong) NSMutableArray<BMTestNetFlowHttpModel *> *httpModelArray;

+ (void)setEnabled:(BOOL)enabled forSessionConfiguration:(NSURLSessionConfiguration *)sessionConfig;

- (void)canInterceptNetFlow:(BOOL)enable;

- (void)addHttpModel:(BMTestNetFlowHttpModel *)httpModel;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
