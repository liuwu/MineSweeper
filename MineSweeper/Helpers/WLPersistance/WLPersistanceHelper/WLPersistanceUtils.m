//
//  WLPersistanceUtils.m
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceUtils.h"

@interface LKDateFormatter : NSDateFormatter

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation LKDateFormatter
- (id)init {
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
        self.generatesCalendarDates = YES;
        self.dateStyle = NSDateFormatterNoStyle;
        self.timeStyle = NSDateFormatterNoStyle;
        self.AMSymbol = nil;
        self.PMSymbol = nil;
        NSLocale* locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        if (locale) {
            [self setLocale:locale];
        }
    }
    return self;
}
//防止在IOS5下 多线程 格式化时间时 崩溃
- (NSDate*)dateFromString:(NSString*)string {
    [_lock lock];
    NSDate* date = [super dateFromString:string];
    [_lock unlock];
    return date;
}

- (NSString*)stringFromDate:(NSDate*)date {
    [_lock lock];
    NSString* string = [super stringFromDate:date];
    [_lock unlock];
    return string;
}

@end

@interface LKNumberFormatter : NSNumberFormatter

@end

@implementation LKNumberFormatter

-(NSString *)stringFromNumber:(NSNumber *)number {
    NSString* string = [number stringValue];
    return string;
}

-(NSNumber *)numberFromString:(NSString *)string {
    NSNumber* number = [super numberFromString:string];
    return number;
}

@end

@implementation WLPersistanceUtils

///返回根目录路径 "document"
+ (NSString*)getDocumentPath {
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
#else
    NSString* homePath = [[NSBundle mainBundle] resourcePath];
    return homePath;
#endif
}

///返回 "document/dir/" 文件夹路径
+ (NSString*)getDirectoryForDocuments:(NSString*)dir {
    NSString* dirPath = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    BOOL isDir = NO;
    BOOL isCreated = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
    if (isCreated == NO || isDir == NO) {
        NSError* error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (success == NO)
            NSLog(@"create dir error: %@", error.debugDescription);
    }
    return dirPath;
}

///返回 "document/filename" 路径
+ (NSString*)getPathForDocuments:(NSString*)filename {
    return [[self getDocumentPath] stringByAppendingPathComponent:filename];
}

///返回 "document/dir/filename" 路径
+ (NSString*)getPathForDocuments:(NSString*)filename inDir:(NSString*)dir {
    return [[self getDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}

///文件是否存在
+ (BOOL)isFileExists:(NSString*)filepath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

///删除文件
+ (BOOL)deleteWithFilepath:(NSString*)filepath {
    return [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
}

///返回该文件目录下 所有文件名
+ (NSArray*)getFilenamesWithDir:(NSString*)dir {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* fileList = [fileManager contentsOfDirectoryAtPath:dir error:nil];
    return fileList;
}

///检测字符串是否为空
+ (BOOL)checkStringIsEmpty:(NSString*)string {
    if (string == nil) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    return [[self getTrimStringWithString:string] isEqualToString:@""];
}

+ (NSString*)getTrimStringWithString:(NSString*)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSDateFormatter *)getDBDateFormat {
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[LKDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return format;
}

///把Date 转换成String
+ (NSString *)stringWithDate:(NSDate*)date {
    NSDateFormatter* formatter = [self getDBDateFormat];
    NSString* datestr = [formatter stringFromDate:date];
    if (datestr.length > 19) {
        datestr = [datestr substringToIndex:19];
    }
    return datestr;
}

///把String 转换成Date
+ (NSDate *)dateWithString:(NSString*)str {
    NSDateFormatter* formatter = [self getDBDateFormat];
    NSDate* date = [formatter dateFromString:str];
    return date;
}

///单例formatter
+ (NSNumberFormatter*)numberFormatter {
    static NSNumberFormatter* numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[LKNumberFormatter alloc] init];
    });
    return numberFormatter;
}

@end