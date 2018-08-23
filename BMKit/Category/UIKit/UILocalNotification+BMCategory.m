//
//  UILocalNotification+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 15/8/26.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import "UILocalNotification+BMCategory.h"
#import "NSObject+BMCategory.h"
#import "NSDate+BMCategory.h"
#import "NSDictionary+BMCategory.h"

@implementation UILocalNotification (BMCategory)

// 1: 周日 2~7: 周一~周六
+ (NSDate *)bm_makeNotifDateWithWeekDay:(NSUInteger)weekDay hour:(NSUInteger)hour
{
    NSDate *dayNow = [NSDate date];
    NSInteger weekDayNow = [dayNow bm_weekday];
    NSDate *notifWeekDate;
    
    if (weekDayNow == weekDay)
    {
        if (dayNow.bm_hour < hour)
        {
            notifWeekDate = [[dayNow bm_dateAtStartOfDay] bm_dateByAddingHours:hour];
        }
        else
        {
            notifWeekDate = [[[NSDate bm_dateWithDaysFromNow:7] bm_dateAtStartOfDay] bm_dateByAddingHours:hour];
        }
    }
    else
    {
        NSDate *notifDate = [NSDate bm_dateWithDaysFromNow:(weekDay+7-weekDayNow)%7];
        notifWeekDate = [[notifDate bm_dateAtStartOfDay] bm_dateByAddingHours:hour];
    }
    
    return notifWeekDate;
}

+ (void)bm_localNotificationWithFireDate:(NSDate *)fireDate repeatInterval:(NSCalendarUnit)repeatInterval
                               alertBody:(NSString *)alertBody alertAction:(NSString *)alertAction
                               soundName:(NSString *)soundName
                               noticeKey:(NSString *)noticeKey userInfo:(NSDictionary *)userInfo
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = fireDate;
    localNotif.timeZone = [NSTimeZone localTimeZone];
    localNotif.repeatInterval = repeatInterval;
    localNotif.alertBody = alertBody;
    if ([alertAction bm_isNotEmpty])
    {
        localNotif.alertAction = alertAction;
    }
    else
    {
        localNotif.alertAction = @"查看";
    }
    
    if ([soundName bm_isNotEmpty])
    {
        localNotif.soundName = soundName;
    }
    else
    {
        localNotif.soundName = UILocalNotificationDefaultSoundName;
    }
    
    localNotif.applicationIconBadgeNumber = 1;
    
    NSMutableDictionary *infor = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [infor bm_setString:noticeKey forKey:@"noticeKey"];
    
    if ([infor bm_isNotEmptyDictionary])
    {
        localNotif.userInfo = infor;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
