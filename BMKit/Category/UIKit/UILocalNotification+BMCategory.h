//
//  UILocalNotification+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 15/8/26.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILocalNotification (BMCategory)

// 1: 周日 2~7: 周一~周六
+ (NSDate *)bm_makeNotifDateWithWeekDay:(NSUInteger)weekDay hour:(NSUInteger)hour;

+ (void)bm_localNotificationWithFireDate:(NSDate *)fireDate repeatInterval:(NSCalendarUnit)repeatInterval
                               alertBody:(NSString *)alertBody alertAction:(NSString *)alertAction
                               soundName:(NSString *)soundName
                               noticeKey:(NSString *)noticeKey userInfo:(NSDictionary *)userInfo;

@end
