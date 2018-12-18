//
//  BMTestGPSMocker.m
//  fengshun
//
//  Created by jiang deng on 2018/11/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestGPSMocker.h"
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>

static NSString * const kBMTestGPSMockCoordinateKey = @"bmtest_gpsmock_coordinate_key";

@interface BMTestGPSMocker()
<
    CLLocationManagerDelegate
>

@property (nonatomic, strong) NSMutableDictionary *locationMonitor;
@property (nonatomic, strong) CLLocation *oldLocation;
@property (nonatomic, strong) CLLocation *pointLocation;
@property (nonatomic, strong) NSTimer *simTimer;

@end

@interface CLLocationManager (BMTest)

- (void)bmtest_swizzleLocationDelegate:(id)delegate;

@end

@implementation BMTestGPSMocker

+ (BMTestGPSMocker *)sharedInstance
{
    static dispatch_once_t once;
    static BMTestGPSMocker *instance;
    dispatch_once(&once, ^{
        instance = [[BMTestGPSMocker alloc] init];
        
        [[CLLocationManager class] bm_swizzleMethod:@selector(setDelegate:) withMethod:@selector(bmtest_swizzleLocationDelegate:) error:nil];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.locationMonitor = [NSMutableDictionary new];
        self.isMocking = NO;
    }
    return self;
}

- (void)saveMockCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSDictionary *dic = @{
                          @"longitude" : @(coordinate.longitude),
                          @"latitude" : @(coordinate.latitude)
                          };
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dic forKey:kBMTestGPSMockCoordinateKey];
    [defaults synchronize];
}

- (CLLocationCoordinate2D)mockCoordinate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults valueForKey:kBMTestGPSMockCoordinateKey];
    CLLocationCoordinate2D coordinate ;
    if (dic[@"longitude"]) {
        coordinate.longitude = [dic[@"longitude"] doubleValue];
    }else{
        coordinate.longitude = -1.;
    }
    if (dic[@"latitude"]) {
        coordinate.latitude = [dic[@"latitude"] doubleValue];
    }else{
        coordinate.latitude = -1.;
    }
    
    return coordinate;
}

- (void)addLocationBinder:(id)binder delegate:(id)delegate
{
    NSString *binderKey = [NSString stringWithFormat:@"%p_binder", binder];
    NSString *delegateKey = [NSString stringWithFormat:@"%p_delegate", binder];
    [self.locationMonitor setObject:binder forKey:binderKey];
    [self.locationMonitor setObject:delegate forKey:delegateKey];
}

- (BOOL)mockPoint:(CLLocation*)location
{
    self.isMocking = YES;
    self.pointLocation = location;
    
    if (self.simTimer)
    {
        [self pointMock];
    }
    else
    {
        self.simTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pointMock) userInfo:nil repeats:YES];
        [self.simTimer fire];
    }
    
    return YES;
}

- (void)pointMock
{
    CLLocation *mockLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.pointLocation.coordinate.latitude, self.pointLocation.coordinate.longitude) altitude:0 horizontalAccuracy:5 verticalAccuracy:5 timestamp:[NSDate date]];

    [self dispatchLocationsToAll:@[mockLocation]];
}

- (void)dispatchLocationsToAll:(NSArray*)locations
{
    for (NSString *key in _locationMonitor.allKeys)
    {
        if ([key hasSuffix:@"_binder"])
        {
            NSString *binderKey = key;
            CLLocationManager *binderManager = [_locationMonitor objectForKey:binderKey];
            
            [self dispatchLocationUpdate:binderManager locations:locations];
        }
    }
}

- (void)stopMockPoint
{
    self.isMocking = NO;
    
    if(self.simTimer)
    {
        [self.simTimer invalidate];
        self.simTimer = nil;
    }
}

//if manager is nil.enum all manager.
- (void)enumDelegate:(CLLocationManager*)manager block:(void (^)(id<CLLocationManagerDelegate> delegate))block
{
    NSString *key = [NSString stringWithFormat:@"%p_delegate", manager];
    id <CLLocationManagerDelegate> delegate = [_locationMonitor objectForKey:key];
    if (delegate)
    {
        block(delegate);
    }
}


#pragma mark - CLLocationManagerDelegate

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    __block BOOL ret = NO;
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManagerShouldDisplayHeadingCalibration:)])
        {
            ret = [delegate locationManagerShouldDisplayHeadingCalibration:manager];
        }
    }];
    
    return ret;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)])
        {
            [delegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        }
    }];
}
#pragma clang diagnostic pop

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)])
        {
            [delegate locationManager:manager didChangeAuthorizationStatus:status];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManager:didFailWithError:)])
        {
            [delegate locationManager:manager didFailWithError:error];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.isMocking)
    {
        [self dispatchLocationUpdate:manager locations:locations];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)dispatchLocationUpdate:(CLLocationManager *)manager locations:(NSArray*)locations
{
    NSString *key = [NSString stringWithFormat:@"%p_delegate",manager];
    id <CLLocationManagerDelegate> delegate = [_locationMonitor objectForKey:key];
    if ([delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)])
    {
        [delegate locationManager:manager didUpdateLocations:locations];
    }
    else if ([delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)])
    {
        [delegate locationManager:manager didUpdateToLocation:locations.firstObject fromLocation:self.oldLocation];
        self.oldLocation = locations.firstObject;
    }
}
#pragma clang diagnostic pop

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateHeading:)])
        {
            [delegate locationManager:manager didUpdateHeading:newHeading];
        }
    }];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManagerDidPauseLocationUpdates:)])
        {
            [delegate locationManagerDidPauseLocationUpdates:manager];
        }
    }];
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManagerDidResumeLocationUpdates:)])
        {
            [delegate locationManagerDidResumeLocationUpdates:manager];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    [self enumDelegate:manager block:^(id<CLLocationManagerDelegate> delegate) {
        
        if ([delegate respondsToSelector:@selector(locationManager:didVisit:)])
        {
            [delegate locationManager:manager didVisit:visit];
        }
    }];
}

@end

@implementation CLLocationManager (BMTest)

- (void)bmtest_swizzleLocationDelegate:(id)delegate
{
    if (delegate)
    {
        //1、让所有的CLLocationManager的代理都设置为[DoraemonGPSMocker sharedInstance]，让他做中间转发
        [self bmtest_swizzleLocationDelegate:[BMTestGPSMocker sharedInstance]];
        //2、绑定所有CLLocationManager实例与delegate的关系，用于[DoraemonGPSMocker sharedInstance]做目标转发用。
        [[BMTestGPSMocker sharedInstance] addLocationBinder:self delegate:delegate];
        
        //3、处理[DoraemonGPSMocker sharedInstance]没有实现的selector，并且给用户提示。
        Protocol *proto = objc_getProtocol("CLLocationManagerDelegate");
        unsigned int count;
        struct objc_method_description *methods = protocol_copyMethodDescriptionList(proto, NO, YES, &count);
        for(unsigned i = 0; i < count; i++)
        {
            SEL sel = methods[i].name;
            if ([delegate respondsToSelector:sel])
            {
                if (![[BMTestGPSMocker sharedInstance] respondsToSelector:sel])
                {
                    NSAssert(NO, @"你在Delegate: %@ 中所使用的SEL: %@，暂不支持", delegate, NSStringFromSelector(sel));
                }
            }
        }
        free(methods);
    }
    else
    {
        [self bmtest_swizzleLocationDelegate:delegate];
    }
}

@end
