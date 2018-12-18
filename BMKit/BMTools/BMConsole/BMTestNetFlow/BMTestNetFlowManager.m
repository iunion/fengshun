//
//  BMTestNetFlowManager.m
//  fengshun
//
//  Created by jiang deng on 2018/12/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestNetFlowManager.h"
#import "BMTestNSURLProtocol.h"

@implementation NSURLSessionConfiguration (Doraemon)

#ifdef DEBUG
+ (void)load
{
    [[self class] bm_swizzleClassMethod:@selector(defaultSessionConfiguration) withClassMethod:@selector(bmtest_defaultSessionConfiguration) error:nil];
    
    [[self class] bm_swizzleClassMethod:@selector(ephemeralSessionConfiguration) withClassMethod:@selector(bmtest_ephemeralSessionConfiguration) error:nil];
}
#endif

+ (NSURLSessionConfiguration *)bmtest_defaultSessionConfiguration
{
    NSURLSessionConfiguration *configuration = [self bmtest_defaultSessionConfiguration];
    [BMTestNetFlowManager setEnabled:YES forSessionConfiguration:configuration];
    return configuration;
}

+ (NSURLSessionConfiguration *)bmtest_ephemeralSessionConfiguration
{
    NSURLSessionConfiguration *configuration = [self bmtest_ephemeralSessionConfiguration];
    [BMTestNetFlowManager setEnabled:YES forSessionConfiguration:configuration];
    return configuration;
}

@end

@implementation BMTestNetFlowManager
{
    dispatch_semaphore_t semaphore;
}

+ (BMTestNetFlowManager *)sharedInstance
{
    static dispatch_once_t once;
    static BMTestNetFlowManager *instance;
    dispatch_once(&once, ^{
        instance = [[BMTestNetFlowManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.httpModelArray = [NSMutableArray array];
        semaphore = dispatch_semaphore_create(1);
    }
    
    return self;
}

+ (void)setEnabled:(BOOL)enabled forSessionConfiguration:(NSURLSessionConfiguration *)sessionConfig
{
    if ( [sessionConfig respondsToSelector:@selector(protocolClasses)]
        && [sessionConfig respondsToSelector:@selector(setProtocolClasses:)])
    {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray:sessionConfig.protocolClasses];
        Class protoCls = BMTestNSURLProtocol.class;
        if (enabled && ![urlProtocolClasses containsObject:protoCls])
        {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        else if (!enabled && [urlProtocolClasses containsObject:protoCls])
        {
            [urlProtocolClasses removeObject:protoCls];
        }
        sessionConfig.protocolClasses = urlProtocolClasses;
    }
}

- (void)canInterceptNetFlow:(BOOL)enable
{
    self.canIntercept = enable;
    if (enable)
    {
        [NSURLProtocol registerClass:[BMTestNSURLProtocol class]];
        self.startInterceptDate = [NSDate date];
    }
    else
    {
        [NSURLProtocol unregisterClass:[BMTestNSURLProtocol class]];
        self.startInterceptDate = nil;
        [self clear];
    }
}

- (void)addHttpModel:(BMTestNetFlowHttpModel *)httpModel
{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.httpModelArray insertObject:httpModel atIndex:0];
    dispatch_semaphore_signal(semaphore);
}

- (void)clear
{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.httpModelArray removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

@end
