//
//  WLPersistanceUtils.h
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 工具类
 */
@interface WLPersistanceUtils : NSObject

///返回根目录路径 "document"
+ (NSString*)getDocumentPath;
///返回 "document/dir/" 文件夹路径
+ (NSString*)getDirectoryForDocuments:(NSString*)dir;
///返回 "document/filename" 路径
+ (NSString*)getPathForDocuments:(NSString*)filename;
///返回 "document/dir/filename" 路径
+ (NSString*)getPathForDocuments:(NSString*)filename inDir:(NSString*)dir;
///文件是否存在
+ (BOOL)isFileExists:(NSString*)filepath;
///删除文件
+ (BOOL)deleteWithFilepath:(NSString*)filepath;
///返回该文件目录下 所有文件名
+ (NSArray*)getFilenamesWithDir:(NSString*)dir;

///检测字符串是否为空
+ (BOOL)checkStringIsEmpty:(NSString*)string;
+ (NSString*)getTrimStringWithString:(NSString*)string;

///把Date 转换成String
+ (NSString*)stringWithDate:(NSDate*)date;
///把String 转换成Date
+ (NSDate*)dateWithString:(NSString*)str;
///单例formatter
+ (NSNumberFormatter*)numberFormatter;

@end

#ifdef DEBUG
#ifdef NSLog
#define WLErrorLog(fmt, ...) NSLog(@"#WLDBHelper ERROR:\n" fmt, ##__VA_ARGS__);
#else
#define WLErrorLog(fmt, ...) NSLog(@"\n#WLDBHelper ERROR: %s  [Line %d] \n" fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif
#else
#define WLErrorLog(...)
#endif

