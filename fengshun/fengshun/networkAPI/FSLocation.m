//
//  MQLocation.m
//  miqian
//
//  Created by dengjiang on 15/8/28.
//  Copyright (c) 2015年 ShiCaiDai. All rights reserved.
//

#import "FSLocation.h"

#define USER_LOCATION_GPS           @"user_location_gps"
#define USER_LOCATION_GPS_LAT       @"user_location_gps_latitude"
#define USER_LOCATION_GPS_LON       @"user_location_gps_longitude"

#define kBEIJING_LATITUDE_MAX       (40.234699)
#define kBEIJING_LATITUDE_MIN       (39.702297)
#define kBEIJING_LONGITUDE_MAX      (116.740097)
#define kBEIJING_LONGITUDE_MIN      (116.133179)

#define kCHINA_LATITUDE_MAX         (55.8271)
#define kCHINA_LATITUDE_MIN         (0.8293)
#define kCHINA_LONGITUDE_MAX        (137.8347)
#define kCHINA_LONGITUDE_MIN        (72.004)


@implementation FSLocation

+ (void)setGPSLoaction:(CLLocation *)gps
{
    NSNumber *lat = [NSNumber numberWithDouble:gps.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:gps.coordinate.longitude];
    NSNumber *altitude = [NSNumber numberWithDouble:gps.altitude];
    NSNumber *hAccuracy = [NSNumber numberWithDouble:gps.horizontalAccuracy];
    NSNumber *vAccuracy = [NSNumber numberWithDouble:gps.verticalAccuracy];
    NSNumber *course = [NSNumber numberWithDouble:gps.course];
    NSNumber *speed = [NSNumber numberWithDouble:gps.speed];
    NSDate *timestamp = gps.timestamp;

    NSDictionary *userLocation = @{@"lat":lat, @"long":lon, @"altitude":altitude, @"hAccuracy":hAccuracy, @"vAccuracy":vAccuracy, @"course":course, @"speed":speed, @"timestamp":timestamp};

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userLocation forKey:USER_LOCATION_GPS];

    [defaults setObject:lon forKey:USER_LOCATION_GPS_LON];
    [defaults setObject:lat forKey:USER_LOCATION_GPS_LAT];

    [defaults synchronize];
}

+ (CLLocation *)GPSLoaction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLocation = [defaults objectForKey:USER_LOCATION_GPS];

    CLLocationDegrees lat = [[userLocation objectForKey:@"lat"] doubleValue];
    CLLocationDegrees lon = [[userLocation objectForKey:@"long"] doubleValue];
    CLLocationDistance altitude = [[userLocation objectForKey:@"altitude"] doubleValue];
    CLLocationAccuracy hAccuracy = [[userLocation objectForKey:@"hAccuracy"] doubleValue];
    CLLocationAccuracy vAccuracy = [[userLocation objectForKey:@"vAccuracy"] doubleValue];
    CLLocationDirection course = [[userLocation objectForKey:@"course"] doubleValue];
    CLLocationSpeed speed = [[userLocation objectForKey:@"speed"] doubleValue];
    NSDate *timestamp = [userLocation objectForKey:@"timestamp"];

    CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:altitude horizontalAccuracy:hAccuracy verticalAccuracy:vAccuracy course:course speed:speed timestamp:timestamp];

    return location;
}


+ (CLLocationDegrees)userLocationLongitude
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CLLocationDegrees cl = [[defaults objectForKey:USER_LOCATION_GPS_LON] doubleValue];
    return cl;
}

+ (CLLocationDegrees)userLocationLatitude
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CLLocationDegrees cl = [[defaults objectForKey:USER_LOCATION_GPS_LAT] doubleValue];
    return cl;
}

+ (double)distanceToLocationLa:(double)la Lo:(double)lo
{
    CLLocationDegrees cla = [FSLocation userLocationLatitude];
    CLLocationDegrees clo = [FSLocation userLocationLongitude];
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:cla longitude:clo];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:la longitude:lo];
    
    double distance  = [curLocation distanceFromLocation:otherLocation];
    
    return distance;
}

+ (double)distanceToLocation:(CLLocation *)location
{
    CLLocationDegrees cla = [FSLocation userLocationLatitude];
    CLLocationDegrees clo = [FSLocation userLocationLongitude];
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:cla longitude:clo];
    
    double distance  = [curLocation distanceFromLocation:location];
    
    return distance;
}

+ (BOOL)outOfBeijing:(CLLocation *)gps
{
    if (gps.coordinate.latitude > kBEIJING_LATITUDE_MIN &&
        gps.coordinate.latitude < kBEIJING_LATITUDE_MAX &&
        gps.coordinate.longitude > kBEIJING_LONGITUDE_MIN &&
        gps.coordinate.longitude < kBEIJING_LONGITUDE_MAX)
    {
        return NO;
    }
    
    return YES;
}

+ (BOOL)outOfChina:(CLLocation *)gps
{
    if (gps.coordinate.longitude < kCHINA_LONGITUDE_MIN || gps.coordinate.longitude > kCHINA_LONGITUDE_MAX)
    {
        return YES;
    }
    if (gps.coordinate.latitude < kCHINA_LATITUDE_MIN || gps.coordinate.latitude > kCHINA_LATITUDE_MAX)
    {
        return YES;
    }
    
    return NO;
}

@end


