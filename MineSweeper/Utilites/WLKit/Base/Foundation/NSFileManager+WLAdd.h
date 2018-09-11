//
//  NSFileManager+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (WLAdd)

//temp文件字符串地址
+ (NSString *)wl_tempFolderPath;

/**
 获取ApplicationSupport文件目录的url地址
 */
+ (NSString *)wl_applicationSupportDirectory;

/**
 获取Documents文件目录的url地址
 */
+ (NSURL *)wl_documentsURL;

/**
 获取Documents文件目录的地址字符串
 */
+ (NSString *)wl_documentsPath;

/**
 获取Library文件目录的url地址
 */
+ (NSURL *)wl_libraryURL;

/**
 获取Library文件目录的地址字符串
 */
+ (NSString *)wl_libraryPath;

/**
 获取Caches文件目录的url地址
 */
+ (NSURL *)wl_cachesURL;

/**
 获取Caches文件目录的地址字符串
 */
+ (NSString *)wl_cachesPath;

/**
 添加一个特色的文件系统标志，避免iCloud备份文件
 */
+ (BOOL)wl_addSkipBackupAttributeToFile:(NSString *)path;

/**
 获取可用磁盘空间
 */
+ (double)wl_availableDiskSpace;

@end

NS_ASSUME_NONNULL_END


#ifndef kFileManager
#define kFileManager [NSFileManager defaultManager]
#endif
