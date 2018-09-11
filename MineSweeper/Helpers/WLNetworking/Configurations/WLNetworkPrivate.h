//
//  WLNetworkPrivate.h
//  Welian_MVP
//
//  Created by weLian on 16/6/30.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络库的一些操作方法
 */
@interface WLNetworkPrivate : NSObject

///为url添加参数
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;

/// 对指定字符串md5加密
+ (NSString *)md5StringFromString:(NSString *)string;

///检查本地是否存在需要保存的文件夹和文件
+ (NSString *)checkFolder:(NSString *)folder fileName:(NSString *)fileName;

#pragma mark - 资源路径
+ (NSString *)navResourcePath;
+ (NSString *)userResourcePath;
//+ (NSString *)documentPath;
//+ (NSString *)tempFolderPath;
+ (NSString *)filePathForCachesPath:(NSString *)path;
+ (NSString *)filePathForRelativePath:(NSString *)path;
+ (long long) fileSizeAtPath:(NSString*) filePath;


#pragma mark - 本地文件处理
+ (BOOL)getFileAttributes:(NSString *)fileName TargetSize:(NSInteger)curSize;// 获取文件的各类属性比较是否相同
+ (BOOL)fileExistByPath:(NSString *)storePath;//检查本地文件是否存在
+ (BOOL)fileDelete:(NSString *)sName;//删除文件
//移动文件
+ (BOOL)filesMove:(NSString *)sName TargetName:(NSString *)tName;
+ (BOOL)filesCopy:(NSString *)sName TargetName:(NSString *)tName;//复制文件


@end
