//
//  NSDate+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 *  @author liuwu     , 16-05-10
 *
 *  NSDate的常见任务和扩展
 *  @since V2.7.9
 */
@interface NSDate (WLAdd)

#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================

@property (nonatomic, readonly) NSInteger wl_year; ///< 年份
@property (nonatomic, readonly) NSInteger wl_month; ///< 月份 (1~12)
@property (nonatomic, readonly) NSInteger wl_day; ///< 日期 (1~31)
@property (nonatomic, readonly) NSInteger wl_hour; ///< 小时 (0~23)
@property (nonatomic, readonly) NSInteger wl_minute; ///< 分钟 (0~59)
@property (nonatomic, readonly) NSInteger wl_second; ///< 秒 (0~59)
@property (nonatomic, readonly) NSInteger wl_nanosecond; ///< 纳秒
@property (nonatomic, readonly) NSInteger wl_weekday; ///< 周几 (1~7, 第一天是基于用户设置)
@property (nonatomic, readonly) NSInteger wl_weekdayOrdinal; ///< 周序号
@property (nonatomic, readonly) NSInteger wl_weekOfMonth; ///< 一个月中的第几周 (1~5)
@property (nonatomic, readonly) NSInteger wl_weekOfYear; ///< 一年中的第几周 (1~53)
@property (nonatomic, readonly) NSInteger wl_yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger wl_quarter; ///< 季度
@property (nonatomic, readonly) BOOL wl_isLeapMonth; ///< 是否润月
@property (nonatomic, readonly) BOOL wl_isLeapYear; ///< 是否润年
@property (nonatomic, readonly) BOOL wl_isToday; ///< 日期是否在今天 (基于当前的语言环境)
@property (nonatomic, readonly) BOOL wl_isYesterday; ///< 日期是否在昨天 (基于当前的语言环境)

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
- (NSString *)wl_dayFromWeekday;
+ (NSString *)wl_dayFromWeekday:(NSDate *)date;


/**
 *  @author liuwu     , 16-05-14
 *
 *  获取给定时间和当前时间的计算后显示内容
 *  @return 解析显示结果
 *  @since V2.7.9
 */
- (NSString *)wl_timeAgoSimple;


#pragma mark - Date modify
///=============================================================================
/// @name 日期修改
///=============================================================================

/**
 返回一个增加给定年数后的日期
 
 @param years  增加的年数.
 @return 增加所需年数后的日期
 */
- (nullable NSDate *)wl_dateByAddingYears:(NSInteger)years;

/**
 返回一个增加指定月数的日期
 
 @param months  增加的月数.
 @return 增加所需月数后的日期.
 */
- (nullable NSDate *)wl_dateByAddingMonths:(NSInteger)months;

/**
 返回一个增加给定周数的日期
 
 @param weeks  增加的周数.
 @return 增加所需周数后的日期.
 */
- (nullable NSDate *)wl_dateByAddingWeeks:(NSInteger)weeks;

/**
 返回一个增加指定天数的日期。
 
 @param days  增加的天数.
 @return 增加所需天数后的日期
 */
- (nullable NSDate *)wl_dateByAddingDays:(NSInteger)days;

/**
 返回一个增加指定小时数的日期。
 
 @param hours  增加的小时数.
 @return 增加所需小时数后的日期.
 */
- (nullable NSDate *)wl_dateByAddingHours:(NSInteger)hours;

/**
 返回一个增加指定分钟数后的日期
 
 @param minutes  增加的分钟数.
 @return 增加指定分钟后的日期.
 */
- (nullable NSDate *)wl_dateByAddingMinutes:(NSInteger)minutes;

/**
 返回一个增加指定秒数后的日期。
 
 @param seconds  增加的秒数.
 @return 增加指定描述后的日期.
 */
- (nullable NSDate *)wl_dateByAddingSeconds:(NSInteger)seconds;


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
- (nullable NSString *)wl_stringWithFormat:(NSString *)format;

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
                                    locale:(nullable NSLocale *)locale;

/**
 返回表示此日期的 ISO8601 格式的字符串。例如："2010-07-09T16:13:30+12:00"
 
 @return NSString ISO8601格式化后的日期字符串
 */
- (nullable NSString *)wl_stringWithISOFormat;

/**
 返回给定字符串使用给定格式解析后的日期
 
 @param dateString 待解析的字符串.
 @param format     格式字符串的日期格式.
 
 @return A date 使用给定格式解析给定字符串后的日期。如果无法解析字符串，返回nil.
 */
+ (nullable NSDate *)wl_dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 将在 timeZone 时区，locale 语言环境 下的 format 格式的字符串转成 NSDate
 
 @param dateString 待解析的字符串.
 @param format     格式字符串的日期格式.
 @param timeZone   时区, 可以为nil.
 @param locale     本地化, 可以nil.
 
 @return A date 使用给定格式解析给定字符串后的日期。如果无法解析字符串，返回nil.
 */
+ (nullable NSDate *)wl_dateWithString:(NSString *)dateString
                                format:(NSString *)format
                              timeZone:(nullable NSTimeZone *)timeZone
                                locale:(nullable NSLocale *)locale;

/**
 将 ISO8601 格式的字符串转成 NSDate。
 
 @param dateString ISO8601格式的日期字符串用. 例如： "2010-07-09T16:13:30+12:00"
 @return A date 使用格式解析字符串后的日期.如果无法解析字符串，返回nil.
 */
+ (nullable NSDate *)wl_dateWithISOFormatString:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
