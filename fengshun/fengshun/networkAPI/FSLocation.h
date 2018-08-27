//
//  FSLocation.h
//  miqian
//
//  Created by dengjiang on 15/8/28.
//  Copyright (c) 2015年 ShiCaiDai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOCATION_BEIJING @"北京"

@interface FSLocation : NSObject

+ (void)setGPSLoaction:(CLLocation *)gps;
+ (CLLocation *)GPSLoaction;
+ (CLLocationDegrees)userLocationLongitude;
+ (CLLocationDegrees)userLocationLatitude;

+ (double)distanceToLocationLa:(double)la Lo:(double)lo;
+ (double)distanceToLocation:(CLLocation *)location;

@end

