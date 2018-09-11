//
//  NSDate+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSDate+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSDate_WLAdd)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (WLAdd)

#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================

///年数
- (NSInteger)wl_year {
    return [[CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self] year];
}

///月数
- (NSInteger)wl_month {
    return [[CURRENT_CALENDAR components:NSCalendarUnitMonth fromDate:self] month];
}

///天数
- (NSInteger)wl_day {
    return [[CURRENT_CALENDAR components:NSCalendarUnitDay fromDate:self] day];
}

///小时
- (NSInteger)wl_hour {
    return [[CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:self] hour];
}

///分钟数
- (NSInteger)wl_minute {
    return [[CURRENT_CALENDAR components:NSCalendarUnitMinute fromDate:self] minute];
}

///秒钟数
- (NSInteger)wl_second {
    return [[CURRENT_CALENDAR components:NSCalendarUnitSecond fromDate:self] second];
}

///毫秒数
- (NSInteger)wl_nanosecond {
    return [[CURRENT_CALENDAR components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

///周几(1~7, 第一天是基于用户设置)
- (NSInteger)wl_weekday {
    return [[CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self] weekday];
}

///周几的序号
- (NSInteger)wl_weekdayOrdinal {
    return [[CURRENT_CALENDAR components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

///一个月中第几周
- (NSInteger)wl_weekOfMonth {
    return [[CURRENT_CALENDAR components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

///一年中的第几周
- (NSInteger)wl_weekOfYear {
    return [[CURRENT_CALENDAR components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

///yearForWeekOfYear
- (NSInteger)wl_yearForWeekOfYear {
    return [[CURRENT_CALENDAR components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

///当前季度
- (NSInteger)wl_quarter {
    return [[CURRENT_CALENDAR components:NSCalendarUnitQuarter fromDate:self] quarter];
}

///是否润月
- (BOOL)wl_isLeapMonth {
    return [[CURRENT_CALENDAR components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

///是否润年
- (BOOL)wl_isLeapYear {
    return [self isLeapYear];
}

///是否今天
- (BOOL)wl_isToday {
    return [self isToday];
}

///是否昨天
- (BOOL)wl_isYesterday {
    return [self isYesterday];
}

/**
 *  获取星期几(名称)
 *
 *  @return Return weekday as a localized string
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSString *)wl_dayFromWeekday {
    return [NSDate wl_dayFromWeekday:self];
}

+ (NSString *)wl_dayFromWeekday:(NSDate *)date {
    switch([date wl_weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

/**
 *  @author liuwu     , 16-05-14
 *
 *  获取给定时间和当前时间的计算后显示内容
 *  @return 解析显示结果
 *  @since V2.7.9
 */
- (NSString *)wl_timeAgoSimple {
    NSDate *now = [NSDate date];
    double delta = [now timeIntervalSinceDate:self];
    CGFloat deltaMinutes = delta / 60.0f;
    
    // 3.获得当前时间和发送时间 的 间隔  (now - send)
    NSString *timeStr = @"";
    if (delta < 60) {// 一分钟内
        timeStr = @"刚刚";
    } else if (deltaMinutes < 60) { // 一个小时内
        timeStr = [NSString stringWithFormat:@"%.f分钟前", deltaMinutes];
    } else if (deltaMinutes < 60 * 24) { // 一天内
        timeStr = [NSString stringWithFormat:@"%.f小时前", deltaMinutes/60.f];
    } else { // 几天前
        timeStr = [self wl_stringWithFormat:@"MM-dd"];
    }
    return timeStr;
}


/**
 返回一个增加给定年数后的日期
 
 @param years  增加的年数.
 @return 增加所需年数后的日期
 */
- (nullable NSDate *)wl_dateByAddingYears:(NSInteger)years {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [CURRENT_CALENDAR dateByAddingComponents:components toDate:self options:0];
}

/**
 返回一个增加指定月数的日期
 
 @param months  增加的月数.
 @return 增加所需月数后的日期.
 */
- (nullable NSDate *)wl_dateByAddingMonths:(NSInteger)months {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [CURRENT_CALENDAR dateByAddingComponents:components toDate:self options:0];
}

/**
 返回一个增加给定周数的日期
 
 @param weeks  增加的周数.
 @return 增加所需周数后的日期.
 */
- (nullable NSDate *)wl_dateByAddingWeeks:(NSInteger)weeks {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [CURRENT_CALENDAR dateByAddingComponents:components toDate:self options:0];
}

/**
 返回一个增加指定天数的日期。
 
 @param days  增加的天数.
 @return 增加所需天数后的日期
 */
- (nullable NSDate *)wl_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

/**
 返回一个增加指定小时数的日期。
 
 @param hours  增加的小时数.
 @return 增加所需小时数后的日期.
 */
- (nullable NSDate *)wl_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

/**
 返回一个增加指定分钟数后的日期
 
 @param minutes  增加的分钟数.
 @return 增加指定分钟后的日期.
 */
- (nullable NSDate *)wl_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

/**
 返回一个增加指定秒数后的日期。
 
 @param seconds  增加的秒数.
 @return 增加指定描述后的日期.
 */
- (nullable NSDate *)wl_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}


#pragma mark - Date Format
///=============================================================================
/// @name 日期格式化
///=============================================================================

/**
 返回表示该日期的格式化字符串
 查看格式描述： http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 
 @param format   所需日期格式的字符串。例如： @"yyyy-MM-dd HH:mm:ss"
 
 @return 格式化后的日期字符串
 */
- (nullable NSString *)wl_stringWithFormat:(NSString *)format {
    return [self stringWithFormat:format];
}

/**
 返回表示该日期的格式化字符串
 查看格式描述： http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 
 @param format   所需日期格式的字符串。例如： @"yyyy-MM-dd HH:mm:ss"
 @param timeZone  时区.
 @param locale    本地化格式.
 
 @return NSString 格式化后的日期字符串
 */
- (nullable NSString *)wl_stringWithFormat:(NSString *)format
                                  timeZone:(nullable NSTimeZone *)timeZone
                                    locale:(nullable NSLocale *)locale {
    return [self stringWithFormat:format timeZone:timeZone locale:locale];
}

/**
 返回一个ISO8601格式后的日期字符串。例如："2010-07-09T16:13:30+12:00"
 
 @return NSString ISO8601格式化后的日期字符串
 */
- (nullable NSString *)wl_stringWithISOFormat {
    return [self stringWithISOFormat];
}

/**
 返回给定字符串使用给定格式解析后的日期
 
 @param dateString 待解析的字符串.
 @param format     格式字符串的日期格式.
 
 @return A date 使用给定格式解析给定字符串后的日期。如果无法解析字符串，返回nil.
 */
+ (nullable NSDate *)wl_dateWithString:(NSString *)dateString format:(NSString *)format {
    return [self dateWithString:dateString format:format];
}

/**
 返回给定字符串使用给定格式解析后的日期
 
 @param dateString 待解析的字符串.
 @param format     格式字符串的日期格式.
 @param timeZone   时区, 可以为nil.
 @param locale     本地化, 可以nil.
 
 @return A date 使用给定格式解析给定字符串后的日期。如果无法解析字符串，返回nil.
 */
+ (nullable NSDate *)wl_dateWithString:(NSString *)dateString
                                format:(NSString *)format
                              timeZone:(nullable NSTimeZone *)timeZone
                                locale:(nullable NSLocale *)locale {
    return [self dateWithString:dateString format:format timeZone:timeZone locale:locale];
}

/**
 返回一个从给定的字符串使用ISO8601格式解析出来的日期
 
 @param dateString ISO8601格式的日期字符串用. 例如： "2010-07-09T16:13:30+12:00"
 
 @return A date 使用格式解析字符串后的日期.如果无法解析字符串，返回nil.
 */
+ (nullable NSDate *)wl_dateWithISOFormatString:(NSString *)dateString {
    return [self dateWithISOFormatString:dateString];
}

@end
