//
//  UIDevice+Private.m
//  fengshun
//
//  Created by jiang deng on 2019/1/7.
//Copyright © 2019 FS. All rights reserved.
//

#if USE_TEST_HELP

#import "UIDevice+Private.h"

#import <CoreLocation/CLLocationManager.h>
#import <CoreTelephony/CTCellularData.h>
#import <AVFoundation/AVFoundation.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
#import <AssetsLibrary/AssetsLibrary.h>
#else
#import <Photos/Photos.h>
#endif
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@implementation UIDevice (Private)

// 私有API，上线会被拒
+ (NSString *)bm_deviceColor
{
    return [self _getDeviceColorWithKey:@"DeviceColor"];
}

// 私有API，上线会被拒
+ (NSString *)bm_deviceEnclosureColor
{
    return [self _getDeviceColorWithKey:@"DeviceEnclosureColor"];
}

#pragma mark Private Method
// 私有API，上线会被拒
+ (NSString *)_getDeviceColorWithKey:(NSString *)key
{
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector])
    {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    
    if ([device respondsToSelector:selector])
    {
        // 消除警告“performSelector may cause a leak because its selector is unknown”
        IMP imp = [device methodForSelector:selector];
        NSString * (*func)(id, SEL, NSString *) = (void *)imp;
        
        return func(device, selector, key);
    }
    
    return @"unKnown";
}

@end

#pragma mark - Authority

@implementation UIDevice (Authority)

+ (NSString *)bm_locationAuthority
{
    NSString *authority = @"";
    if ([CLLocationManager locationServicesEnabled])
    {
        CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
        switch (state)
        {
            case kCLAuthorizationStatusNotDetermined:
                authority = @"NotDetermined";
                break;
                
            case kCLAuthorizationStatusRestricted:
                authority = @"Restricted";
                break;
                
            case kCLAuthorizationStatusDenied:
                authority = @"Denied";
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways:
                authority = @"Always";
                break;
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                authority = @"WhenInUse";
                break;
                
            default:
                break;
        }
    }
    else
    {
        authority = @"NoEnabled";
    }
    
    return authority;
}

// 是否有联网功能
+ (NSString *)bm_netAuthority
{
    NSString *authority = @"Unknown";
    
    if (@available(iOS 9.0, *))
    {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        CTCellularDataRestrictedState state = cellularData.restrictedState;
        switch (state)
        {
            case kCTCellularDataRestricted:
                authority = @"Restricted";
                break;
            case kCTCellularDataNotRestricted:
                authority = @"NotRestricted";
                break;
            case kCTCellularDataRestrictedStateUnknown:
                authority = @"Unknown";
                break;
            default:
                break;
        }
    }
    
    return authority;
}

+ (NSString *)bm_pushAuthority
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (IOS_VERSION >= 8.0)
    { // iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone)
        {
            return @"NO";
        }
    }
    else
    { // iOS7以下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone)
        {
            return @"NO";
        }
    }
#pragma clang diagnostic pop
    
    return @"YES";
}

+ (NSString *)bm_cameraAuthority
{
    NSString *authority = @"";
    // 读取媒体类型
    NSString *mediaType = AVMediaTypeVideo;
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus)
    {
        case AVAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case AVAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case AVAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)bm_photoAuthority
{
    NSString *authority = @"";
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0 //iOS 8.0以下使用AssetsLibrary.framework
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status)
    {
        case ALAuthorizationStatusNotDetermined:    //用户还没有选择
        {
            authority = @"NotDetermined";
        }
            break;
        case ALAuthorizationStatusRestricted:       //家长控制
        {
            authority = @"Restricted";
        }
            break;
        case ALAuthorizationStatusDenied:           //用户拒绝
        {
            authority = @"Denied";
        }
            break;
        case ALAuthorizationStatusAuthorized:       //已授权
        {
            authority = @"Authorized";
        }
            break;
            
        default:
            break;
    }
#else   //iOS 8.0以上使用Photos.framework
    PHAuthorizationStatus current = [PHPhotoLibrary authorizationStatus];
    switch (current)
    {
        case PHAuthorizationStatusNotDetermined:    //用户还没有选择(第一次)
        {
            authority = @"NotDetermined";
        }
            break;
        case PHAuthorizationStatusRestricted:       //家长控制
        {
            authority = @"Restricted";
        }
            break;
        case PHAuthorizationStatusDenied:           //用户拒绝
        {
            authority = @"Denied";
        }
            break;
        case PHAuthorizationStatusAuthorized:       //已授权
        {
            authority = @"Authorized";
        }
            break;
            
        default:
            break;
    }
#endif
    return authority;
}

+ (NSString *)bm_audioAuthority
{
    NSString *authority = @"";
    // 读取媒体类型
    NSString *mediaType = AVMediaTypeAudio;
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus)
    {
        case AVAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case AVAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case AVAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)bm_addressAuthority
{
    NSString *authority = @"";
    
    if (@available(iOS 9.0, *))
    {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (authStatus)
        {
            case CNAuthorizationStatusAuthorized:
                authority = @"Authorized";
                break;
            case CNAuthorizationStatusDenied:
            {
                authority = @"Denied";
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                authority = @"NotDetermined";
            }
                break;
            case CNAuthorizationStatusRestricted:
                authority = @"Restricted";
                break;
        }
    }
    else
    {
        ABAuthorizationStatus authorStatus = ABAddressBookGetAuthorizationStatus();
        switch (authorStatus) {
            case kABAuthorizationStatusAuthorized:
                authority = @"Authorized";
                break;
            case kABAuthorizationStatusDenied:
            {
                authority = @"Denied";
            }
                break;
            case kABAuthorizationStatusNotDetermined:
            {
                authority = @"NotDetermined";
            }
                break;
            case kABAuthorizationStatusRestricted:
                authority = @"Restricted";
                break;
            default:
                break;
        }
    }
    
    return authority;
}

+ (NSString *)bm_calendarAuthority
{
    NSString *authority = @"";
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status)
    {
        case EKAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case EKAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case EKAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case EKAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)bm_remindAuthority
{
    NSString *authority = @"";
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (status)
    {
        case EKAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case EKAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case EKAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case EKAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)bm_bluetoothAuthority
{
//    CBPeripheralManagerAuthorizationStatusNotDetermined = 0,// 未进行授权选择
//    CBPeripheralManagerAuthorizationStatusRestricted,　　　　// 未授权，且用户无法更新，如家长控制情况下
//    CBPeripheralManagerAuthorizationStatusDenied,　　　　　　 // 用户拒绝App使用
//    CBPeripheralManagerAuthorizationStatusAuthorized,　　　　// 已授权，可使用
    
    NSString *authority = @"";
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    switch (status)
    {
        case CBPeripheralManagerAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case CBPeripheralManagerAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case CBPeripheralManagerAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case CBPeripheralManagerAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

@end

#endif

