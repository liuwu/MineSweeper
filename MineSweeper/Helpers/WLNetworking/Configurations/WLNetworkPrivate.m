//
//  WLNetworkPrivate.m
//  Welian_MVP
//
//  Created by weLian on 16/6/30.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLNetworkPrivate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WLNetworkPrivate

///url编码
+ (NSString*)urlEncode:(NSString*)str {
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

///url参数转nstring
+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}

///为url添加参数
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}

/// 对指定字符串md5加密
+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

///检查本地是否存在需要保存的文件夹和文件
+ (NSString *)checkFolder:(NSString *)folder fileName:(NSString *)fileName {
    NSString *toFolder = [[self userResourcePath] stringByAppendingPathComponent:folder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        NSLog(@"创建home cover 目录!");
        [[NSFileManager defaultManager] createDirectoryAtPath:toFolder
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    ////检查本地文件是否存在
    NSString *filePath = [toFolder stringByAppendingPathComponent:fileName];
    if ([self fileExistByPath:filePath]) {
        BOOL isdelete = [self fileDelete:filePath];
        NSLog(@"isdelete : %d",isdelete);
    }
    return filePath;
}


#pragma mark - 资源路径
+ (NSString *)navResourcePath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"];
}

+ (NSString *)userResourcePath
{
    NSString *result = [[self documentPath] stringByAppendingPathComponent:@"Resource"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:result]) {
            [fileManager createDirectoryAtPath:result withIntermediateDirectories:YES attributes:nil error:nil];
            [NSFileManager wl_addSkipBackupAttributeToFile:result];
        } else {
            NSLog(@"user resource folder exists");
        }
    });
    
    return result;
}

+ (NSString *)cachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)tempFolderPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)filePathForCachesPath:(NSString *)path
{
    NSString *result = [[self cachesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",@"StatusImage",path]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:result]) {
        return result;
    }
    return @"";
}

+ (NSString *)filePathForRelativePath:(NSString *)path
{
    NSString *result = [[self userResourcePath] stringByAppendingPathComponent:path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:result]) {
        return result;
    }
    
    result = [[self navResourcePath] stringByAppendingPathComponent:path];
    return result;
}

#pragma mark - 本地文件处理
// 获取文件的各类属性比较是否相同
+ (BOOL)getFileAttributes:(NSString *)fileName TargetSize:(NSInteger)curSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileName error:nil];
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        NSLog(@"File Size:%@ , New File Size:%ld",fileSize,(long)curSize);
        if ([fileSize intValue] == curSize) {
            return YES;
        }else {
            return NO;
        }
    }else {
        NSLog(@"Local Image File Not Exist!");
        return NO;
    }
}

//检查本地文件是否存在
+ (BOOL)fileExistByPath:(NSString *)storePath
{
    BOOL rtn = NO;
    rtn = [[NSFileManager defaultManager] fileExistsAtPath:storePath];
    return rtn;
}

//删除文件
+ (BOOL)fileDelete:(NSString *)sName
{
    BOOL isDelete = NO;
    if ([self fileExistByPath:sName]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error=nil;
        isDelete = [fileManager removeItemAtPath:sName error:&error];
    }
    return isDelete;
}

//复制文件
+ (BOOL)filesCopy:(NSString *)sName TargetName:(NSString *)tName
{
    NSFileManager *fileManaget = [NSFileManager defaultManager];
    NSError *error=nil;
    return [fileManaget copyItemAtPath:sName toPath:tName error:&error];
}

//移动文件
+ (BOOL)filesMove:(NSString *)sName TargetName:(NSString *)tName
{
    NSFileManager *fileManaget = [NSFileManager defaultManager];
    NSError *error=nil;
    return [fileManaget moveItemAtPath:sName toPath:tName error:&error];
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
