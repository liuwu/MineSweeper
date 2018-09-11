//
//  WLSystemManager.m
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLSystemManager.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "NSFileManager+WLAdd.h"
#import "NSUserDefaults+WLAdd.h"
#import "UIDevice+WLAddForInfo.h"
#import "NSString+WLAdd.h"

///--------------3D touch相关-----------------
///扫一扫
NSString *const kWL_3DTouchScan             = @"Scan";
///融资
NSString *const kWL_3DTouchFinancing        = @"Financing";
///活动
NSString *const kWL_3DTochActivity          = @"Activity";
///项目
NSString *const kWL_3DTochProject           = @"Project";


@implementation WLSystemManager

#pragma mark - 系统操作
///判断版本是否是第一次
+ (BOOL)isVersionfirst {
    //存储和比较当前版本号
    NSString *key = @"CFBundleVersion";
    //取出沙盒中存储的上次使用软件的版本号
    NSString *lastVersion = [NSUserDefaults stringForKey:key];
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if (![currentVersion isEqualToString:lastVersion]) {
        // 存储新版本
        [NSUserDefaults setString:currentVersion forKey:key];
        return YES;
    }else {
        return NO;
    }
}

/**
 *  手动添加3D touch功能
 */
+ (void)init3DTouchActionShow:(BOOL)isShow{
    if (kIOS9Later) {
        /** type 该item 唯一标识符
         localizedTitle ：标题
         localizedSubtitle：副标题
         icon：icon图标 可以使用系统类型 也可以使用自定义的图片
         userInfo：用户信息字典 自定义参数，完成具体功能需求
         */
        UIApplication *application = [UIApplication sharedApplication];
        if (isShow) {
            UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D_touch_saoyisao"];
            UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:kWL_3DTouchScan localizedTitle:@"扫一扫" localizedSubtitle:nil icon:icon1 userInfo:nil];
            
            UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D_touch_rongzizonge"];
            UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:kWL_3DTouchFinancing localizedTitle:@"我要融资" localizedSubtitle:nil icon:icon2 userInfo:nil];
            UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D_touch_search"];
            UIApplicationShortcutItem *item4 = [[UIApplicationShortcutItem alloc]initWithType:kWL_3DTochProject localizedTitle:@"创业项目" localizedSubtitle:nil icon:icon4 userInfo:nil];
            application.shortcutItems = @[item1,item2,item4];
        }else{
            application.shortcutItems = @[];
        }
    }else {
        DLog(@"用来3D Touch版本太低");
    }
}


#pragma mark - 自定义操作
+ (NSString *)wl_filePathForCachesPath:(NSString *)path {
    NSString *result = [[NSFileManager wl_cachesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",path]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:result]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return result;
}

+ (UIImage *)wl_imageWithCachePath:(NSString *)path {
    return [self wl_imageWithPath:path isCache:NO inCach:YES];
}

+ (UIImage *)wl_imageWithPath:(NSString *)path {
    return [self wl_imageWithPath:path isCache:NO];
}

+ (UIImage *)wl_imageWithPath:(NSString *)path isCache:(BOOL)cache {
    return [self wl_imageWithPath:path isCache:cache inCach:NO];
}

+ (UIImage *)wl_imageWithPath:(NSString *)path isCache:(BOOL)cache inCach:(BOOL)incache {
    UIImage *image;
    if (cache) {
        image = [WLSystemManager wl_cacheForKey:path];
        if (image) {
            image.cached = YES;
            return image;
        }
    }
    if (incache) {
        NSString *folder = [[NSFileManager wl_cachesPath] stringByAppendingPathComponent:path];
        image = [UIImage imageWithContentsOfFile:folder];;
    }else{
        image = [UIImage imageWithContentsOfFile:[self wl_filePathForRelativePath:path]];
    }
    image.cached = NO;
    if (cache && image) {
        [WLSystemManager wl_setCache:image forKey:path];
    }
    return image;
}

//保存图片到本地路径，返回路径
+ (NSString *)wl_saveImage:(UIImage *)image ToFolder:(NSString *)toFolder WithName:(NSString *)imageName {
    //保存到本地
    @autoreleasepool {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
        NSString *folder = [[WLSystemManager wl_userResourcePath] stringByAppendingPathComponent:toFolder];
        if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
            DLog(@"创建home cover 目录!");
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        //保持图片到本地
        NSString *fullPathToFile = [folder stringByAppendingPathComponent:imageName];
        //如果本地存在同名文件删除s
        if ([WLSystemManager wl_fileExistByPath:fullPathToFile]) {
            [WLSystemManager wl_fileDelete:fullPathToFile];
        }
        // 写入本地
        BOOL isSave = [imageData writeToFile:fullPathToFile atomically:YES];
        if (!isSave) {
            DLog(@"动态图片写入沙盒失败");
        }
        return [NSString stringWithFormat:@"%@/%@",toFolder,imageName];
    }
}

#pragma mark - 资源路径
+ (NSString *)wl_navResourcePath {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"];
}

+ (NSString *)wl_userResourcePath {
    NSString *result = [[NSFileManager wl_documentsPath] stringByAppendingPathComponent:@"Resource"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:result]) {
            [fileManager createDirectoryAtPath:result withIntermediateDirectories:YES attributes:nil error:nil];
            [NSFileManager wl_addSkipBackupAttributeToFile:result];
        } else {
            DLog(@"user resource folder exists");
        }
    });
    
    return result;
}

+ (NSString *)wl_filePathForRelativePath:(NSString *)path {
    NSString *result = [[self wl_userResourcePath] stringByAppendingPathComponent:path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:result]) {
        return result;
    }
    
    result = [[self wl_navResourcePath] stringByAppendingPathComponent:path];
    return result;
}

#pragma mark - 缓存
static NSCache *sharedCache = nil;
+ (id)wl_cacheForKey:(NSString *)key {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedCache) {
            DLog(@"cacheForKey alloc cache!");
            sharedCache = [[NSCache alloc] init];
            //sharedCache.countLimit = 60;
        }
    });
    return [sharedCache objectForKey:key];
}

+ (void)wl_setCache:(id)cache forKey:(NSString *)key {
    if (!cache) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedCache) {
            DLog(@"setCache alloc cache!");
            sharedCache = [[NSCache alloc] init];
            //sharedCache.countLimit = 60;
        }
    });
    
    [sharedCache setObject:cache forKey:key];
}

+ (void)wl_cleanCache {
    DLog(@"clean cache!");
    [sharedCache removeAllObjects];
}

#pragma mark - 本地文件处理
+ (long long)wl_fileSizeAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 获取文件的各类属性比较是否相同
+ (BOOL)wl_getFileAttributes:(NSString *)fileName TargetSize:(NSInteger)curSize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileName error:nil];
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        DLog(@"File Size:%@ , New File Size:%ld",fileSize,(long)curSize);
        if ([fileSize intValue] == curSize) {
            return YES;
        }else {
            return NO;
        }
    }else {
        DLog(@"Local Image File Not Exist!");
        return NO;
    }
}

//检查本地文件是否存在
+ (BOOL)wl_fileExistByPath:(NSString *)storePath {
    BOOL rtn = NO;
    rtn = [[NSFileManager defaultManager] fileExistsAtPath:storePath];
    return rtn;
}

//删除文件
+ (BOOL)wl_fileDelete:(NSString *)sName {
    BOOL isDelete = NO;
    if ([self wl_fileExistByPath:sName]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error=nil;
        isDelete = [fileManager removeItemAtPath:sName error:&error];
    }
    return isDelete;
}

//移动文件
+ (BOOL)wl_filesMove:(NSString *)sName TargetName:(NSString *)tName {
    NSFileManager *fileManaget = [NSFileManager defaultManager];
    NSError *error=nil;
    return [fileManaget moveItemAtPath:sName toPath:tName error:&error];
}

//复制文件
+ (BOOL)wl_filesCopy:(NSString *)sName TargetName:(NSString *)tName {
    NSFileManager *fileManaget = [NSFileManager defaultManager];
    NSError *error=nil;
    return [fileManaget copyItemAtPath:sName toPath:tName error:&error];
}

@end

@implementation UIImage (WLCache)

static char imageCachedKey;

- (BOOL)isCached
{
    return [objc_getAssociatedObject(self, &imageCachedKey) boolValue];
}

- (void)setCached:(BOOL)cached
{
    [super willChangeValueForKey:@"cached"];
    objc_setAssociatedObject(self, &imageCachedKey, @(cached), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [super didChangeValueForKey:@"cached"];
}

@end
