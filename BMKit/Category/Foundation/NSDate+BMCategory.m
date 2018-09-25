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

#import "NSDate+BMCategory.h"

const long long SECONDS_IN_YEAR = 31557600;
const long long SECONDS_IN_COMMONYEAR = 31536000;
const long long SECONDS_IN_LEAPYEAR = 31622400;
const NSInteger SECONDS_IN_MONTH_28 = 2419200;
const NSInteger SECONDS_IN_MONTH_29 = 2505600;
const NSInteger SECONDS_IN_MONTH_30 = 2592000;
const NSInteger SECONDS_IN_MONTH_31 = 2678400;
const NSInteger SECONDS_IN_WEEK = 604800;
const NSInteger SECONDS_IN_DAY = 86400;
const NSInteger SECONDS_IN_HOUR = 3600;
const NSInteger SECONDS_IN_MINUTE = 60;
const NSInteger MILLISECONDS_IN_DAY = 86400000;

static const unsigned int allCalendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear;

@implementation NSDate (BMCategory)

+ (void)load
{
    [NSDate bm_currentCalendar];
}

+ (NSString *)bm_stringFromDate:(NSDate *)aDate
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [dateFormater stringFromDate:aDate];
}

+ (NSString *)bm_stringFromDate:(NSDate *)aDate formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:formatter];
    return [dateFormater stringFromDate:aDate];
}

+ (NSString *)bm_stringFromTs:(NSTimeInterval)timestamp
{
    return [NSDate bm_stringFromTs:timestamp formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)bm_stringFromTs:(NSTimeInterval)timestamp formatter:(NSString *)formatter
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:formatter];
    return [dateFormater stringFromDate:date];
}

+ (NSString *)bm_stringFromNow
{
    return [NSDate bm_stringFromDate:[NSDate date]];
}

//+ (NSString *)mqStringFromTs:(NSTimeInterval)timestamp
//{
//    NSTimeInterval ts = timestamp/1000;
//    
//    return [NSDate stringFromTs:ts];
//}

+ (NSString *)hmStringDateFromDate:(NSDate *)aDate
{
    NSTimeInterval timestamp = [aDate timeIntervalSince1970];

    return [self hmStringDateFromTs:timestamp];
}

// 在帖子里出现的时间，按以下规则进行展示：
//
// ①1分钟内的，显示为刚刚
// ②1分钟至1个小时内的，转换成N分钟前；
// ③超过1小时，在今天内的，显示今天 XX:XX;
// ④超过1小时，且不是今天内的，今年以内的，显示④XX-XX，即几月几日；
// ⑤其他的，显示年月日，XXXX-XX-XX；
+ (NSString *)fsStringDateFromTs:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger past = now - timestamp;
    if (past <= 60)
    {
        return @"刚刚";
    }
    else if(past < SECONDS_IN_HOUR)
    {
        NSInteger min = past/SECONDS_IN_HOUR;
        return [NSString stringWithFormat:@"%ld分钟前", (long)min];
    }
    else if ([date bm_isToday])
    {
        [dateFormat setDateFormat:@"今天 HH:mm"];
        return [dateFormat stringFromDate:date];
    }
    else if ([date bm_isThisYear])
    {
        [dateFormat setDateFormat:@"MM-dd"];
        return [dateFormat stringFromDate:date];
    }
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)hmStringDateFromTs:(NSTimeInterval)timestamp
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger past = now - timestamp;
    if (past <= 0)
    {
        return @"刚刚";
    }
    else if (past < SECONDS_IN_MINUTE)
    {
        return [NSString stringWithFormat:@"%ld秒前", (long)past];
    }
    else if(past < SECONDS_IN_HOUR)
    {
        NSInteger min = past/SECONDS_IN_HOUR;
        return [NSString stringWithFormat:@"%ld分钟前", (long)min];
    }
    else if (past < SECONDS_IN_DAY)
    {
        NSInteger hour = past/SECONDS_IN_HOUR;
        return [NSString stringWithFormat:@"%ld小时前", (long)hour];
    }
    else if (past < SECONDS_IN_DAY*5)
    {
        NSInteger day = past/SECONDS_IN_DAY;
        return [NSString stringWithFormat:@"%ld天前", (long)day];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)bm_countDownStringDateFromTs:(NSUInteger)count
{
    if (count <= 0)
    {
        return @"";
    }
    else if (count < SECONDS_IN_MINUTE)
    {
        return [NSString stringWithFormat:@"%ld秒", (long)count];
    }
    else if(count < SECONDS_IN_HOUR)
    {
        NSUInteger min = count/SECONDS_IN_MINUTE;
        NSUInteger second = count%SECONDS_IN_MINUTE;
        return [NSString stringWithFormat:@"%ld分%ld秒", (long)min, (long)second];
    }
    else if (count < SECONDS_IN_DAY)
    {
        NSUInteger hour = count/SECONDS_IN_HOUR;
        NSUInteger min = (count%SECONDS_IN_HOUR)/SECONDS_IN_MINUTE;
        NSUInteger second = count%SECONDS_IN_MINUTE;
        return [NSString stringWithFormat:@"%ld小时%ld分%ld秒", (long)hour, (long)min, (long)second];
    }
    else
    {
        NSInteger day = count/SECONDS_IN_DAY;
        NSUInteger hour = (count%SECONDS_IN_DAY)/SECONDS_IN_HOUR;
        NSUInteger min = (count%SECONDS_IN_HOUR)/SECONDS_IN_MINUTE;
        NSUInteger second = count%SECONDS_IN_MINUTE;
        return [NSString stringWithFormat:@"%ld天%ld小时%ld分%ld秒", (long)day, (long)hour, (long)min, (long)second];
    }
}

+ (NSTimeInterval)bm_timeIntervalFromString:(NSString *)dateString
{
    return [NSDate bm_timeIntervalFromString:dateString withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSTimeInterval)bm_timeIntervalFromString:(NSString *)dateString withFormat:(NSString *)format
{
    NSDate *date = [self bm_dateFromString:dateString withFormat:format];
    return [date timeIntervalSince1970];
}

+ (NSDate *)bm_dateFromString:(NSString *)dateString
{
    return [NSDate bm_dateFromString:dateString withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)bm_dateFromString:(NSString *)dateString withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:format];
    NSDate *destDate = [dateFormatter dateFromString:dateString];

    //BMLog(@"%@", destDate);

    return destDate;
}

+ (NSString *)bm_babyAgeWithDueDate:(NSDate *)dueDate
{
    if (!dueDate || [dueDate timeIntervalSince1970] == 0)
    {
        return @"";
    }

    NSDate *currentDay = [[NSDate date] bm_dateAtStartOfDay];

    NSInteger pregancyDays = [dueDate bm_daysAfterDate:currentDay] ;
    if (pregancyDays > MAX_PREGMENT_DAYS+1)
    {
        return @"备孕中";
    }
    else if (pregancyDays > 0 && pregancyDays <= MAX_PREGMENT_DAYS)
    {
        pregancyDays = MAX_PREGMENT_DAYS - pregancyDays;
        
        NSMutableString *pregnancyText = [NSMutableString stringWithCapacity:0];

        [pregnancyText appendString:@"孕"];

        NSInteger weekNum = (pregancyDays)/7;
        NSInteger dayNum = (pregancyDays)%7;
        if (weekNum > 0)
        {
            [pregnancyText appendFormat:@"%ld周", (long)weekNum];
            if (dayNum > 0)
            {
                [pregnancyText appendFormat:@"%ld天", (long)dayNum];
            }
        }
        else
        {
            if (dayNum > 0)
            {
                [pregnancyText appendFormat:@"%ld天", (long)dayNum];
            }
            else
            {
                return @"怀孕了";
            }
        }

        return pregnancyText;
    }
    else
    {
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//        
//        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:dueDate];
//        NSDateComponents* comp2 = [calendar components:unitFlags fromDate:currentDay];
//        NSInteger years = comp2.year - comp1.year;
//        NSInteger months = comp2.month - comp1.month;
//        NSInteger days = comp2.day - comp1.day;

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateCom = [calendar components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[dueDate bm_dateAtStartOfDay] toDate:[[NSDate date] bm_dateAtStartOfDay] options:0];
        
        NSInteger years = [dateCom year];
        NSInteger months = [dateCom month];
        NSInteger days = [dateCom day];

        NSString *babyAge = @"";

        if (years > 0)
        {
            if (months > 0)
            {
                if (days > 0)
                {
                    babyAge = [NSString stringWithFormat:@"%ld岁%ld个月%ld天", (long)years, (long)months, (long)days];
                }
                else if (days == 0)
                {
                    babyAge = [NSString stringWithFormat:@"%ld岁%ld个月", (long)years, (long)months];
                }
            }
            else
            {
                if (days > 0)
                {
                    babyAge = [NSString stringWithFormat:@"%ld岁%ld天", (long)years, (long)days];
                }
                else if (days == 0)
                {
                    babyAge = [NSString stringWithFormat:@"%ld岁", (long)years];
                }
            }
        }
        else if (years == 0)
        {
            if (months > 0)
            {
                if (days > 0)
                {
                    babyAge = [NSString stringWithFormat:@"%ld个月%ld天", (long)months, (long)days];
                }
                else if (days == 0)
                {
                    babyAge = [NSString stringWithFormat:@"%ld个月", (long)months];
                }
            }
            else if (months == 0)
            {
//                if (days == 0)
//                {
//                    babyAge = @"宝宝出生";
//                }
//                else
//                {
//                    babyAge = [NSString stringWithFormat:@"%ld天", (long)days];
//                }
                babyAge = [NSString stringWithFormat:@"出生%ld天",(long)days+1];
            }
        }

        return babyAge;
    }
}

+ (NSDate *)bm_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    return [NSDate bm_dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)bm_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDate *nsDate = nil;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.year   = year;
    components.month  = month;
    components.day    = day;
    components.hour   = hour;
    components.minute = minute;
    components.second = second;
    
    nsDate = [[NSDate bm_currentCalendar] dateFromComponents:components];
    
    return nsDate;
}

//+ (NSDate*)dateWithToday
//{
//    return [[NSDate date] dateAtMidnight];
//}
//
//- (NSDate*)dateAtMidnight
//{
//	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//	NSDateComponents *comps = [gregorian components:
//                               (NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
//                                           fromDate:[NSDate date]];
//	NSDate *midnight = [gregorian dateFromComponents:comps];
//	[gregorian release];
//	return midnight;
//}

// Courtesy of Lukasz Margielewski
// Updated via Holger Haenisch
+ (NSCalendar *)bm_currentCalendar
{
//    static NSCalendar *sharedCalendar = nil;
//    if (!sharedCalendar)
//        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
//    return sharedCalendar;
    
    static NSCalendar *sharedCalendar = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    
    return sharedCalendar;
}

+ (NSDate *)bm_getCurrentDateWithSystemTimeZone
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];

    NSDate *localeDate = [date dateByAddingTimeInterval:interval];  

    BMLog(@"%@", localeDate);
    
    return localeDate;
}

+ (NSDate *)bm_getCurrentDateWithTimeZone:(NSTimeZone *)timezone
{
    NSDate *date = [NSDate date];
    NSInteger interval = [timezone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];  
    
    BMLog(@"%@", localeDate);
    
    return localeDate;
}

#pragma mark - Relative Dates

+ (NSDate *)bm_dateWithDaysFromNow:(NSInteger)days
{
    // Thanks, Jim Morrison
    return [[NSDate date] bm_dateByAddingDays:days];
}

+ (NSDate *)bm_dateWithDaysBeforeNow:(NSInteger)days
{
    // Thanks, Jim Morrison
    return [[NSDate date] bm_dateBySubtractingDays:days];
}

+ (NSDate *)bm_dateToday
{
    return [NSDate bm_dateWithDaysFromNow:0];
}

+ (NSDate *)bm_dateTomorrow
{
    return [NSDate bm_dateWithDaysFromNow:1];
}

+ (NSDate *)bm_dateYesterday
{
    return [NSDate bm_dateWithDaysBeforeNow:1];
}

+ (NSDate *)bm_dateWithHoursFromNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + SECONDS_IN_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)bm_dateWithHoursBeforeNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - SECONDS_IN_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)bm_dateWithMinutesFromNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + SECONDS_IN_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)bm_dateWithMinutesBeforeNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - SECONDS_IN_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark Comparing Dates

/*
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [calendar setTimeZone:GTMzone];
    NSDateComponents *components1 = [calendar components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [calendar components:DATE_COMPONENTS fromDate:aDate];
    //BMLog(@"%d, %d -- %d, %d -- %d, %d", [components1 year], [components2 year], [components1 month], [components2 month], [components1 day], [components2 day]);
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]) &&
            ([components1 day] == [components2 day]));
}
*/

+ (BOOL)bm_isSameDayfirst:(NSTimeInterval)firstDate second:(NSTimeInterval)secondDate
{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:firstDate];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:secondDate];
    return [date1 bm_isSameDayAsDate:date2];
}

+ (BOOL)bm_isSameDay:(NSDate *)date asDate:(NSDate *)compareDate
{
    return [date bm_isSameDayAsDate:compareDate];
}

- (BOOL)bm_isEqualToDateIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
        (components1.month == components2.month) && 
        (components1.day == components2.day));
}

- (BOOL)bm_isSameDayAsDate:(NSDate *)aDate
{
    return [self bm_isEqualToDateIgnoringTime:aDate];
}

// 判断两个时间是同一分钟
- (BOOL)bm_isSameDayTimeAsDate:(NSDate *)aDate
{
    return [self bm_isSameDayTimeAsDate:aDate compareSecond:NO];
}

- (BOOL)bm_isSameDayTimeAsDate:(NSDate *)aDate compareSecond:(BOOL)compareSecond
{
    NSDateComponents *components1 = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:aDate];
    if ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day) &&
            (components1.minute == components2.minute))
    {
        if (compareSecond)
        {
            return (components1.second == components2.second);
        }
        
        return YES;
    }

    return NO;
}

- (BOOL)bm_isToday
{
    return [self bm_isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)bm_isTomorrow
{
    return [self bm_isEqualToDateIgnoringTime:[NSDate bm_dateTomorrow]];
}

- (BOOL)bm_isYesterday
{
    return [self bm_isEqualToDateIgnoringTime:[NSDate bm_dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)bm_isSameWeekAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (abs((int)[self timeIntervalSinceDate:aDate]) < SECONDS_IN_WEEK);
}

- (BOOL)bm_isThisWeek
{
    return [self bm_isSameWeekAsDate:[NSDate date]];
}

- (BOOL)bm_isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + SECONDS_IN_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self bm_isSameWeekAsDate:newDate];
}

- (BOOL)bm_isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - SECONDS_IN_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self bm_isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL)bm_isSameMonthAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)bm_isThisMonth
{
    return [self bm_isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL)bm_isLastMonth
{
    return [self bm_isSameMonthAsDate:[[NSDate date] bm_dateBySubtractingMonths:1]];
}

- (BOOL)bm_isNextMonth
{
    return [self bm_isSameMonthAsDate:[[NSDate date] bm_dateByAddingMonths:1]];
}

- (BOOL)bm_isSameYearAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL)bm_isThisYear
{
    // Thanks, baspellis
    return [self bm_isSameYearAsDate:[NSDate date]];
}

- (BOOL)bm_isNextYear
{
    NSDateComponents *components1 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
	return (components1.year == (components2.year + 1));
}

- (BOOL)bm_isLastYear
{
    NSDateComponents *components1 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
	return (components1.year == (components2.year - 1));
}

- (BOOL)bm_isEarlierThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)bm_isLaterThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)bm_isEarlierThanOrEqualTo:(NSDate *) aDate
{
    return ([self compare:aDate] != NSOrderedDescending);
}

- (BOOL)bm_isLaterThanOrEqualTo:(NSDate *) aDate
{
    return ([self compare:aDate] != NSOrderedAscending);
}

// Thanks, markrickert
- (BOOL)bm_isInFuture
{
    return ([self bm_isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL)bm_isInPast
{
    return ([self bm_isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles

- (BOOL)bm_isTypicallySunday
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if (components.weekday == 1)
        return YES;
    return NO;
}

- (BOOL)bm_isTypicallyWeekend
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)bm_isTypicallyWorkday
{
    return ![self bm_isTypicallyWeekend];
}

+ (BOOL)bm_isLeapYear:(NSInteger)year
{
    if (year%400 == 0)
    {
        return YES;
    }
    else if (year%100 == 0)
    {
        return NO;
    }
    else if (year%4 == 0)
    {
        return YES;
    }
    
    return NO;
}


- (BOOL)bm_isLeapMonth
{
    return [[[NSDate bm_currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

/**
 *  Returns whether the receiver falls in a leap year.
 *
 *  @return NSInteger
 */
- (BOOL)bm_isInLeapYear
{
    NSInteger year = self.bm_year;
    
    return [NSDate bm_isLeapYear:year];
}


#pragma mark Adjusting  Date to String
- (NSString *)bm_stringByFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:formatter];

    return [dateFormatter stringFromDate:self];
}

- (NSString *)bm_stringByDefaultFormatter
{
    return [self bm_stringByFormatter:@"yyyy年MM月dd日"];
}


#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *)bm_dateByAddingYears:(NSInteger)dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)bm_dateBySubtractingYears:(NSInteger)dYears
{
    return [self bm_dateByAddingYears:-dYears];
}

- (NSDate *)bm_dateByAddingMonths:(NSInteger)dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
    
- (NSDate *)bm_dateBySubtractingMonths:(NSInteger)dMonths
{
    return [self bm_dateByAddingMonths:-dMonths];
}

- (NSDate *)bm_dateByAddingWeeks:(NSInteger) dweeks
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setWeekOfYear:dweeks];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)bm_dateBySubtractingWeeks:(NSInteger) dweeks
{
    return [self bm_dateByAddingWeeks:-dweeks];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *)bm_dateByAddingDays:(NSInteger)dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)bm_dateBySubtractingDays:(NSInteger)dDays
{
	return [self bm_dateByAddingDays: (dDays * -1)];
}

- (NSDate *)bm_dateByAddingHours:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + SECONDS_IN_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)bm_dateBySubtractingHours:(NSInteger)dHours
{
    return [self bm_dateByAddingHours: (dHours * -1)];
}

- (NSDate *)bm_dateByAddingMinutes:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + SECONDS_IN_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)bm_dateBySubtractingMinutes:(NSInteger)dMinutes
{
    return [self bm_dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *)bm_dateByAddingSeconds:(NSInteger) dSeconds
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + dSeconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)bm_dateBySubtractingSeconds:(NSInteger)dSeconds
{
    return [self bm_dateByAddingSeconds: (dSeconds * -1)];
}


#pragma mark - Extremes

- (NSDate *)bm_dateAtStartOfDay
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate bm_currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *)bm_dateAtEndOfDay
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate bm_currentCalendar] dateFromComponents:components];
}

- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate
{
    NSDateComponents *dTime = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Retrieving Intervals

- (NSInteger)bm_minutesAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / SECONDS_IN_MINUTE);
}

- (NSInteger)bm_minutesBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / SECONDS_IN_MINUTE);
}

- (NSInteger)bm_hoursAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / SECONDS_IN_HOUR);
}

- (NSInteger)bm_hoursBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / SECONDS_IN_HOUR);
}

- (NSInteger)bm_daysAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / SECONDS_IN_DAY);
}

- (NSInteger)bm_daysBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / SECONDS_IN_DAY);
}

- (NSTimeInterval)bm_secondsFromDate:(NSDate *)aDate
{
    return [self timeIntervalSinceDate:aDate];
}

- (NSInteger)bm_minutesFromDate:(NSDate *)aDate
{
    return [self bm_minutesAfterDate:aDate];
}

- (NSInteger)bm_hoursFromDate:(NSDate *)aDate
{
    return [self bm_hoursAfterDate:aDate];
}

- (NSInteger)bm_daysFromDate:(NSDate *)aDate
{
    NSDate *earliest = [self earlierDate:aDate];
    NSDate *latest = (earliest == self) ? aDate : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:NSCalendarUnitDay fromDate:earliest toDate:latest options:0];
    return multiplier*components.day;
}

- (NSInteger)bm_weeksFromDate:(NSDate *)aDate
{
//    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
//    return (NSInteger) (ti / SECONDS_IN_WEEK);
    
    NSDate *earliest = [self earlierDate:aDate];
    NSDate *latest = (earliest == self) ? aDate : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.weekOfYear;
}

- (NSInteger)bm_monthsFromDate:(NSDate *)aDate
{
    NSDate *earliest = [self earlierDate:aDate];
    NSDate *latest = (earliest == self) ? aDate : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:earliest toDate:latest options:0];
    return multiplier*(components.month + 12*components.year);
}

- (NSInteger)bm_yearsFromDate:(NSDate *)aDate
{
    NSDate *earliest = [self earlierDate:aDate];
    NSDate *latest = (earliest == self) ? aDate : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:NSCalendarUnitYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.year;
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)bm_distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}


#pragma mark - Decomposing Dates

- (NSInteger)bm_nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + SECONDS_IN_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger)bm_hour
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.hour;
}

- (NSInteger)bm_minute
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.minute;
}

- (NSInteger)bm_seconds
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.second;
}

- (NSInteger)bm_day
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.day;
}

- (NSInteger)bm_month
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.month;
}

- (NSInteger)bm_quarter
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.quarter;
}

- (NSInteger)bm_year
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.year;
}

- (NSInteger)bm_era
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.era;
}

- (NSInteger)bm_dayOfYear
{
    NSCalendar *calendar = [NSDate bm_currentCalendar];
    return [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
}

- (NSInteger)bm_weekday
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.weekday;
}

- (NSInteger)bm_weekOfMonth
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger)bm_weekOfYear
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)bm_nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)bm_weekdayOrdinal
{
    NSDateComponents *components = [[NSDate bm_currentCalendar] components:allCalendarUnitFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)bm_yearForWeekOfYear
{
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear;

    NSDateComponents *components = [[NSDate bm_currentCalendar] components:unitFlags fromDate:self];
    return components.yearForWeekOfYear;
}

- (NSInteger)bm_daysInMonth
{
    NSCalendar *calendar = [NSDate bm_currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:self];
    return days.length;
}

/**
 *  Returns how many days are in the year of the receiver.
 *
 *  @return NSInteger
 */
- (NSInteger)bm_daysInYear
{
    if ([self bm_isInLeapYear])
    {
        return 366;
    }
    
    return 365;
}


#pragma mark - String Properties

- (NSString *)bm_stringWithDefaultFormat
{
    return [self bm_stringWithFormat:@"yyyy年MM月dd日"];
}

- (NSString *)bm_stringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.locale = [NSLocale currentLocale]; // Necessary?
    //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)bm_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = dateStyle;
    dateFormatter.timeStyle = timeStyle;
    //formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [dateFormatter stringFromDate:self];
}

- (NSString *)bm_mqString
{
    return [self bm_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)bm_shortString
{
    return [self bm_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)bm_shortTimeString
{
    return [self bm_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)bm_shortDateString
{
    return [self bm_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)bm_mediumString
{
    return [self bm_stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *)bm_mediumTimeString
{
    return [self bm_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *)bm_mediumDateString
{
    return [self bm_stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)bm_longString
{
    return [self bm_stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *)bm_longTimeString
{
    return [self bm_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *)bm_longDateString
{
    return [self bm_stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}


@end
