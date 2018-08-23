//
//  NSDate+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 13-12-18.
//  Copyright (c) 2013年 DennisDeng. All rights reserved.
//

/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

//#define D_MINUTE 60
//#define D_HOUR 3600
//#define D_DAY 86400
//#define D_WEEK 604800
//#define D_YEAR 31556926

FOUNDATION_EXPORT const long long SECONDS_IN_YEAR;
FOUNDATION_EXPORT const long long SECONDS_IN_COMMONYEAR;
FOUNDATION_EXPORT const long long SECONDS_IN_LEAPYEAR;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_MONTH_28;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_MONTH_29;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_MONTH_30;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_MONTH_31;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_WEEK;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_DAY;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_HOUR;
FOUNDATION_EXPORT const NSInteger SECONDS_IN_MINUTE;
FOUNDATION_EXPORT const NSInteger MILLISECONDS_IN_DAY;


#define MAX_PREGMENT_DAYS   280

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BMCategory)

+ (NSString *)bm_stringFromDate:(NSDate *)aDate;
+ (NSString *)bm_stringFromDate:(NSDate *)aDate formatter:(NSString *)formatter;
+ (NSString *)bm_stringFromTs:(NSTimeInterval)timestamp;
+ (NSString *)bm_stringFromTs:(NSTimeInterval)timestamp formatter:(NSString *)formatter;
+ (NSString *)bm_stringFromNow;
//+ (NSString *)mqStringFromTs:(NSTimeInterval)timestamp;
+ (NSString *)hmStringDateFromDate:(NSDate *)aDate;
+ (NSString *)hmStringDateFromTs:(NSTimeInterval)timestamp;

+ (NSString *)bm_countDownStringDateFromTs:(NSUInteger)count;

+ (NSTimeInterval)bm_timeIntervalFromString:(NSString *)dateString;
+ (NSTimeInterval)bm_timeIntervalFromString:(NSString *)dateString withFormat:(NSString *)format;
+ (NSDate *)bm_dateFromString:(NSString *)dateString;
+ (NSDate *)bm_dateFromString:(NSString *)dateString withFormat:(NSString *)format;

+ (NSDate *)bm_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)bm_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

+ (NSCalendar *)bm_currentCalendar;

+ (NSDate *)bm_getCurrentDateWithSystemTimeZone;
+ (NSDate *)bm_getCurrentDateWithTimeZone:(NSTimeZone *)timezone;

+ (NSString *)bm_babyAgeWithDueDate:(NSDate *)dueDate;

/**
 * Returns the current date with the time set to midnight.
 */
+ (NSDate *)bm_dateToday;


// Relative dates from the current date
+ (NSDate *)bm_dateTomorrow;
+ (NSDate *)bm_dateYesterday;
+ (NSDate *)bm_dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)bm_dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)bm_dateWithHoursFromNow:(NSInteger)dHours;
+ (NSDate *)bm_dateWithHoursBeforeNow:(NSInteger)dHours;
+ (NSDate *)bm_dateWithMinutesFromNow:(NSInteger)dMinutes;
+ (NSDate *)bm_dateWithMinutesBeforeNow:(NSInteger)dMinutes;

// Comparing dates
+ (BOOL)bm_isSameDayfirst:(NSTimeInterval)firstDate second:(NSTimeInterval)secondDate;
+ (BOOL)bm_isSameDay:(NSDate *)date asDate:(NSDate *)compareDate;
- (BOOL)bm_isEqualToDateIgnoringTime:(NSDate *)aDate;
- (BOOL)bm_isSameDayAsDate:(NSDate *)aDate;
// 判断两个时间是同一分钟
- (BOOL)bm_isSameDayTimeAsDate:(NSDate *)aDate;
- (BOOL)bm_isSameDayTimeAsDate:(NSDate *)aDate compareSecond:(BOOL)compareSecond;


- (BOOL)bm_isToday;
- (BOOL)bm_isTomorrow;
- (BOOL)bm_isYesterday;

- (BOOL)bm_isSameWeekAsDate:(NSDate *)aDate;
- (BOOL)bm_isThisWeek;
- (BOOL)bm_isNextWeek;
- (BOOL)bm_isLastWeek;

- (BOOL)bm_isSameMonthAsDate:(NSDate *)aDate;
- (BOOL)bm_isThisMonth;
- (BOOL)bm_isNextMonth;
- (BOOL)bm_isLastMonth;

- (BOOL)bm_isSameYearAsDate:(NSDate *)aDate;
- (BOOL)bm_isThisYear;
- (BOOL)bm_isNextYear;
- (BOOL)bm_isLastYear;

- (BOOL)bm_isEarlierThanDate:(NSDate *)aDate;
- (BOOL)bm_isLaterThanDate:(NSDate *)aDate;
- (BOOL)bm_isEarlierThanOrEqualTo:(NSDate *)aDate;
- (BOOL)bm_isLaterThanOrEqualTo:(NSDate *)aDate;

- (BOOL)bm_isInFuture;
- (BOOL)bm_isInPast;

// Date roles
- (BOOL)bm_isTypicallySunday;
- (BOOL)bm_isTypicallyWorkday;
- (BOOL)bm_isTypicallyWeekend;

- (BOOL)bm_isLeapMonth;
// 闰年
- (BOOL)bm_isInLeapYear;

// Date to String
- (NSString *)bm_stringByFormatter:(NSString *)formatter;
- (NSString *)bm_stringByDefaultFormatter;

// Adjusting dates
- (NSDate *)bm_dateByAddingYears:(NSInteger)dYears;
- (NSDate *)bm_dateBySubtractingYears:(NSInteger)dYears;
- (NSDate *)bm_dateByAddingMonths:(NSInteger)dMonths;
- (NSDate *)bm_dateBySubtractingMonths:(NSInteger)dMonths;
- (NSDate *)bm_dateByAddingWeeks:(NSInteger)dweeks;
- (NSDate *)bm_dateBySubtractingWeeks:(NSInteger)dweeks;
- (NSDate *)bm_dateByAddingDays:(NSInteger)dDays;
- (NSDate *)bm_dateBySubtractingDays:(NSInteger)dDays;
- (NSDate *)bm_dateByAddingHours:(NSInteger)dHours;
- (NSDate *)bm_dateBySubtractingHours:(NSInteger)dHours;
- (NSDate *)bm_dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *)bm_dateBySubtractingMinutes:(NSInteger)dMinutes;
- (NSDate *)bm_dateByAddingSeconds:(NSInteger)dSeconds;
- (NSDate *)bm_dateBySubtractingSeconds:(NSInteger)dSeconds;

// Date extremes
/*
 * Returns a copy of the date with the time set to 00:00:00 on the same day.
 */
- (NSDate *)bm_dateAtStartOfDay;
/*
 * Returns a copy of the date with the time set to 23:59:59 on the same day.
 */
- (NSDate *)bm_dateAtEndOfDay;

// Retrieving intervals
- (NSInteger)bm_minutesAfterDate:(NSDate *)aDate;
- (NSInteger)bm_minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)bm_hoursAfterDate:(NSDate *)aDate;
- (NSInteger)bm_hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)bm_daysAfterDate:(NSDate *)aDate;
- (NSInteger)bm_daysBeforeDate:(NSDate *)aDate;

- (NSTimeInterval)bm_secondsFromDate:(NSDate *)aDate;
- (NSInteger)bm_minutesFromDate:(NSDate *)aDate;
- (NSInteger)bm_hoursFromDate:(NSDate *)aDate;
- (NSInteger)bm_daysFromDate:(NSDate *)aDate;
- (NSInteger)bm_weeksFromDate:(NSDate *)aDate;
- (NSInteger)bm_monthsFromDate:(NSDate *)aDate;
- (NSInteger)bm_yearsFromDate:(NSDate *)aDate;

- (NSInteger)bm_distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
// 接近的小时
- (NSInteger)bm_nearestHour;
// hour(小时)
- (NSInteger)bm_hour;
// minute(分钟)
- (NSInteger)bm_minute;
// second(秒)
- (NSInteger)bm_seconds;
// day(日期)
- (NSInteger)bm_day;
// month(月份)
- (NSInteger)bm_month;
// quarter(季度)
- (NSInteger)bm_quarter;
// year(年份)
- (NSInteger)bm_year;
// era(年份)
- (NSInteger)bm_era;

// dayOfYear(本年第几天)
- (NSInteger)bm_dayOfYear;

// weekday(星期)
// Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Friday:5, Saturday:6
- (NSInteger)bm_weekday;
// weekOfMonth(本月第几周)
- (NSInteger)bm_weekOfMonth;
// weekOfYear(本年第几周)
- (NSInteger)bm_weekOfYear;
- (NSInteger)bm_nthWeekday; // e.g. 2nd Tuesday of the month == 2
- (NSInteger)bm_weekdayOrdinal;  // same as nthWeekday
- (NSInteger)bm_yearForWeekOfYear;

// 本月天数
- (NSInteger)bm_daysInMonth;
// 本年天数
- (NSInteger)bm_daysInYear;


// Date to String
- (NSString *)bm_stringWithDefaultFormat;
- (NSString *)bm_stringWithFormat:(NSString *)format;
- (NSString *)bm_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSString *)bm_mqString;
- (NSString *)bm_shortString;
- (NSString *)bm_shortDateString;
- (NSString *)bm_shortTimeString;
- (NSString *)bm_mediumString;
- (NSString *)bm_mediumDateString;
- (NSString *)bm_mediumTimeString;
- (NSString *)bm_longString;
- (NSString *)bm_longDateString;
- (NSString *)bm_longTimeString;

@end

NS_ASSUME_NONNULL_END
