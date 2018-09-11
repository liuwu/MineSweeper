//
//  NSFileManager+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/18.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSFileManager+WLAdd.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(NSFileManager_WLAdd)

@implementation NSFileManager (WLAdd)

+ (NSURL *)urlForDirectory:(NSSearchPathDirectory)directory {
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory {
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)wl_tempFolderPath {
    return NSTemporaryDirectory();
}

/**
 获取ApplicationSupport文件目录的url地址
 */
+ (NSString *)wl_applicationSupportDirectory {
    return [self pathForDirectory:NSApplicationSupportDirectory];
}

/**
 获取Documents文件目录的url地址
 */
+ (NSURL *)wl_documentsURL {
    return [self urlForDirectory:NSDocumentDirectory];
}

/**
 获取Documents文件目录的地址字符串
 */
+ (NSString *)wl_documentsPath {
    return [self pathForDirectory:NSDocumentDirectory];
}

/**
 获取Library文件目录的url地址
 */
+ (NSURL *)wl_libraryURL {
    return [self urlForDirectory:NSLibraryDirectory];
}

/**
 获取Library文件目录的地址字符串
 */
+ (NSString *)wl_libraryPath {
    return [self pathForDirectory:NSLibraryDirectory];
}

/**
 获取Caches文件目录的url地址
 */
+ (NSURL *)wl_cachesURL {
    return [self urlForDirectory:NSCachesDirectory];
}

/**
 获取Caches文件目录的地址字符串
 */
+ (NSString *)wl_cachesPath {
    return [self pathForDirectory:NSCachesDirectory];
}

/**
 添加一个特色的文件系统标志，避免iCloud备份文件
 */
+ (BOOL)wl_addSkipBackupAttributeToFile:(NSString *)path {
    NSError *error = nil;
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:YES];
    [url setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

/**
 获取可用磁盘空间
 */
+ (double)wl_availableDiskSpace {
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.wl_documentsPath error:nil];
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

@end
