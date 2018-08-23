//
//  BMVeryifiTimeManager.m
//  BMBaseKit
//
//  Created by DennisDeng on 16/4/21.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import "BMVerifiTimeManager.h"
#import "NSDictionary+BMCategory.h"
#import "NSObject+BMCategory.h"


#define BMVerifiTime_Wait       (60.0f)


@interface BMVerifiTimeManager ()

@property (nonatomic, copy) BMVerifiTimeBlock verifiBlock;

@property (nonatomic, strong) NSMutableDictionary *timerDic;
@property (nonatomic, strong) NSMutableDictionary *blockDic;

@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CFTimeInterval durationTime;

@end

@implementation BMVerifiTimeManager

+ (BMVerifiTimeManager *)manager
{
    static BMVerifiTimeManager *timeManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        timeManager = [[self alloc] init];
    });
    
    return timeManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _timerDic = [[NSMutableDictionary alloc] init];
        _blockDic = [[NSMutableDictionary alloc] init];
        //_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifiTime:) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (NSInteger)getTicketWithType:(BMVerificationCodeType)type
{
    NSInteger tichet = [self.timerDic bm_intForKey:@(type) withDefault:0];
    
    return tichet;
}

- (NSInteger)startTimeWithType:(BMVerificationCodeType)type process:(BMVerifiTimeBlock)verifiBlock
{
    return [self startTimeWithType:type duration:BMVerifiTime_Wait process:verifiBlock];
}

- (NSInteger)startTimeWithType:(BMVerificationCodeType)type duration:(CFTimeInterval)duration process:(BMVerifiTimeBlock)verifiBlock
{
    if (duration <= 0)
    {
        return 0;
    }
    
    self.durationTime = duration;
    NSInteger tichet = [self getTicketWithType:type];
    
    if (tichet > 0)
    {
        BMVerifiTimeBlock oldVerifiBlock = [self.blockDic objectForKey:@(type)];
        if (oldVerifiBlock)
        {
            oldVerifiBlock(type, tichet, YES);
        }
        if (verifiBlock)
        {
            [self.blockDic setObject:verifiBlock forKey:@(type)];
            verifiBlock(type, tichet, NO);
        }
        return tichet;
    }
    
    [self.timerDic setObject:@(self.durationTime) forKey:@(type)];
    
    if (verifiBlock)
    {
        [self.blockDic setObject:verifiBlock forKey:@(type)];
        verifiBlock(type, self.durationTime, NO);
    }
    
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifiTime:) userInfo:nil repeats:YES];
//        NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    
    return self.durationTime;
}

- (void)stopTimeWithType:(BMVerificationCodeType)type
{
    [self stopTimeWithType:type stop:YES];
}

- (void)stopTimeWithType:(BMVerificationCodeType)type stop:(BOOL)stop
{
    [self.timerDic removeObjectForKey:@(type)];
    
    BMVerifiTimeBlock verifiBlock = [self.blockDic objectForKey:@(type)];
    if (verifiBlock)
    {
        verifiBlock(type, 0, stop);
    }
    
    [self.blockDic removeObjectForKey:@(type)];
    
    if (![self.timerDic.allKeys bm_isNotEmpty])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)removeBlockWithType:(BMVerificationCodeType)type
{
    [self.blockDic removeObjectForKey:@(type)];
}

- (void)verifiTime:(NSTimer *)theTimer
{
    for (NSNumber *key in self.timerDic.allKeys)
    {
        NSInteger tichet = [self.timerDic bm_intForKey:key withDefault:0];
        tichet--;
        
        BMLog(@"%@:%@", key, @(tichet));
        
        if (tichet <= 0)
        {
            [self stopTimeWithType:[key integerValue] stop:NO];
        }
        else
        {
            BMVerifiTimeBlock verifiBlock = [self.blockDic objectForKey:key];
            if (verifiBlock)
            {
                verifiBlock([key integerValue], tichet, NO);
            }
            [self.timerDic setObject:@(tichet) forKey:key];
        }
    }
    
    if (![self.timerDic.allKeys bm_isNotEmpty])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)stopAllType
{
    // 注意：这里没有调用block
    // 如果想调用block，请使用 stopTimeWithType:
    [self.timerDic removeAllObjects];
    [self.blockDic removeAllObjects];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (NSInteger)checkTimeWithType:(BMVerificationCodeType)type process:(BMVerifiTimeBlock)verifiBlock
{
    NSInteger tichet = [self getTicketWithType:type];
    
    if (tichet > 0)
    {
        BMVerifiTimeBlock oldVerifiBlock = [self.blockDic objectForKey:@(type)];
        if (oldVerifiBlock)
        {
            oldVerifiBlock(type, tichet, YES);
        }
        if (verifiBlock)
        {
            [self.blockDic setObject:verifiBlock forKey:@(type)];
            verifiBlock(type, tichet, NO);
        }
        return tichet;
    }

    if (verifiBlock)
    {
        verifiBlock(type, 0, YES);
    }
    
    return tichet;
}

@end
