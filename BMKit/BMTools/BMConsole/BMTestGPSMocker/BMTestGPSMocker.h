//
//  BMTestGPSMocker.h
//  fengshun
//
//  Created by jiang deng on 2018/11/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMTestGPSMocker : NSObject

+ (BMTestGPSMocker *)sharedInstance;

- (void)saveMockCoordinate:(CLLocationCoordinate2D)coordinate;

- (CLLocationCoordinate2D)mockCoordinate;

- (void)addLocationBinder:(id)binder delegate:(id)delegate;

- (BOOL)mockPoint:(CLLocation *)location;

- (void)stopMockPoint;

@property (nonatomic, assign) BOOL isMocking;

@end

NS_ASSUME_NONNULL_END
