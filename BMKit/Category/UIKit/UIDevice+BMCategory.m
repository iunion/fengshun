//
//  UIDevice+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 12-1-11.
//  Copyright (c) 2012年 DennisDeng. All rights reserved.
//

#import "UIDevice+BMCategory.h"
#import "NSString+BMCategory.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>

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


@implementation UIDevice (BMCategory)

+ (NSString *)bm_devicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *)bm_devicePlatformString
{
    NSString *platform = [self bm_devicePlatform];
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (Rev. A)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,3"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";

    // iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    // iPad mini
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2 (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2 (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad mini 2 (China)";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad mini 4 (Cellular)";
    // iPad Pro 9.7
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7 (WiFi)";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7 (Cellular)";
    // iPad Pro 12.9
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9 (WiFi)";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9 (Cellular)";
    // iPad (5th generation)
    if ([platform isEqualToString:@"iPad6,11"])     return @"iPad (5th generation)";
    if ([platform isEqualToString:@"iPad6,12"])     return @"iPad (5th generation)";
    // iPad Pro (12.9-inch, 2nd generation)
    if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro (12.9-inch, 2nd generation)";
    if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro (12.9-inch, 2nd generation)";
    // iPad Pro (10.5-inch)
    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";

    // Apple TV
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV (2nd generation)";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV (3rd generation)";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV (3rd generation)";
    if ([platform isEqualToString:@"AppleTV5,3"])   return @"Apple TV (4th generation)";
    if ([platform isEqualToString:@"AppleTV6,2"])   return @"Apple TV 4K";
    // Apple Watch
    if ([platform isEqualToString:@"Watch1,1"])     return @"Apple Watch (1st generation) 38mm";
    if ([platform isEqualToString:@"Watch1,2"])     return @"Apple Watch (1st generation) 42mm";
    if ([platform isEqualToString:@"Watch2,6"])     return @"Apple Watch Series 1 38mm";
    if ([platform isEqualToString:@"Watch2,7"])     return @"Apple Watch Series 1 42mm";
    if ([platform isEqualToString:@"Watch2,3"])     return @"Apple Watch Series 2 38mm";
    if ([platform isEqualToString:@"Watch2,4"])     return @"Apple Watch Series 2 42mm";
    if ([platform isEqualToString:@"Watch3,1"])     return @"Apple Watch Series 3 38mm";
    if ([platform isEqualToString:@"Watch3,2"])     return @"Apple Watch Series 3 42mm";
    if ([platform isEqualToString:@"Watch3,3"])     return @"Apple Watch Series 3 38mm";
    if ([platform isEqualToString:@"Watch3,4"])     return @"Apple Watch Series 3 42mm";
    // Simulator
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

+ (BOOL)bm_isiPad
{
    if ([[[self bm_devicePlatform] substringToIndex:4] isEqualToString:@"iPad"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)bm_isiPhone
{
    if ([[[self bm_devicePlatform] substringToIndex:6] isEqualToString:@"iPhone"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)bm_isiPod
{
    if ([[[self bm_devicePlatform] substringToIndex:4] isEqualToString:@"iPod"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)bm_isAppleTV
{
    if ([[[self bm_devicePlatform] substringToIndex:7] isEqualToString:@"AppleTV"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)bm_isAppleWatch
{
    if ([[[self bm_devicePlatform] substringToIndex:5] isEqualToString:@"Watch"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)bm_isSimulator
{
    if ([[self bm_devicePlatform] isEqualToString:@"i386"] || [[self bm_devicePlatform] isEqualToString:@"x86_64"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)bm_isRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0 || [UIScreen mainScreen].scale == 3.0))
        return YES;
    else
        return NO;
}

+ (BOOL)bm_isRetinaHD
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 3.0))
        return YES;
    else
        return NO;
}

+ (CGFloat)bm_iOSVersion
{
    static float version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.floatValue;
    });
    return version;
}

+ (NSUInteger)getSysInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSUInteger)bm_cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger)bm_busFrequency
{
    return [self getSysInfo:HW_TB_FREQ];
}

+ (NSUInteger)bm_ramSize
{
    return [self getSysInfo:HW_MEMSIZE];
}

+ (NSUInteger)bm_cpuNumber
{
    return [self getSysInfo:HW_NCPU];
}

+ (NSUInteger)bm_cpuAvailableCount
{
    return [self getSysInfo:HW_AVAILCPU];
}

+ (NSUInteger)bm_totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)bm_userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

+ (NSUInteger)bm_freeMemory
{
    return ([self getSysInfo:HW_PHYSMEM] - [self getSysInfo:HW_USERMEM]);
}

+ (NSUInteger)bm_maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

+ (NSNumber *)bm_totalDiskSpace
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [attributes objectForKey:NSFileSystemSize];
}

+ (NSString *)bm_totalDiskSpaceString
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float totalSpace = [[attributes objectForKey:NSFileSystemSize] floatValue];
    return [NSString bm_storeStringWithBitSize:totalSpace];
}

+ (NSNumber *)bm_usedDiskSpace
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float totalSpace = [[attributes objectForKey:NSFileSystemSize] floatValue];
    float freeSpace = [[attributes objectForKey:NSFileSystemFreeSize] floatValue];
    float usedSpace = totalSpace - freeSpace;
    
    return [NSNumber numberWithFloat:usedSpace];
}

+ (NSString *)bm_usedDiskSpaceString
{
    // 通过NSFileManager所有信息
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float totalSpace = [[attributes objectForKey:NSFileSystemSize] floatValue];
    float freeSpace = [[attributes objectForKey:NSFileSystemFreeSize] floatValue];
    float usedSpace = totalSpace - freeSpace;
    return [NSString bm_storeStringWithBitSize:usedSpace];
}

+ (NSNumber *)bm_freeDiskSpace
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [attributes objectForKey:NSFileSystemFreeSize];
}

+ (NSString *)bm_freeDiskSpaceString
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float freeSpace = [[attributes objectForKey:NSFileSystemFreeSize] floatValue];
    return [NSString bm_storeStringWithBitSize:freeSpace];
}

+ (NSString *)bm_deviceName
{
    return [UIDevice currentDevice].name;
}

+ (NSString *)bm_OSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (BOOL)bm_isMultitaskingSupported
{
    return [[UIDevice currentDevice] isMultitaskingSupported];
}

+ (BOOL)bm_hasJailBroken
{
#if !(TARGET_IPHONE_SIMULATOR)
    // Check 1 : existence of files that are common for jailbroken devices
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ||
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])
    {
        return YES;
    }
    
    FILE *f = NULL ;
    if ((f = fopen("/bin/bash", "r")) ||
        (f = fopen("/Applications/Cydia.app", "r")) ||
        (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) ||
        (f = fopen("/usr/sbin/sshd", "r")) ||
        (f = fopen("/etc/apt", "r")))
    {
        fclose(f);
        return YES;
    }
    fclose(f);
    // Check 2 : Reading and writing in system directories (sandbox violation)
    NSError *error;
    NSString *stringToBeWritten = @"Jailbreak Test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES
                          encoding:NSUTF8StringEncoding error:&error];
    if (error == nil)
    {
        //Device is jailbroken
        return YES;
    }
    else
    {
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    }
#endif
    return NO;
}

@end


#pragma mark - <#mark#>

@implementation UIDevice (Authority)

+ (NSString *)locationAuthority
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

+ (NSString *)netAuthority
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

+ (NSString *)pushAuthority
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

+ (NSString *)cameraAuthority
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

+ (NSString *)photoAuthority
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

+ (NSString *)audioAuthority
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

+ (NSString *)addressAuthority
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

+ (NSString *)calendarAuthority
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

+ (NSString *)remindAuthority
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

+ (NSString *)bluetoothAuthority
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
