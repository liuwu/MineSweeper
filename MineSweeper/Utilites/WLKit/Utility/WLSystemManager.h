//
//  WLSystemManager.h
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

///------------3D touch相关--------------
///扫一扫
extern NSString *const kWL_3DTouchScan;
///融资
extern NSString *const kWL_3DTouchFinancing;
///活动
extern NSString *const kWL_3DTochActivity;
///项目
extern NSString *const kWL_3DTochProject;


/*
 Welian系统工具类，定义常用类方法
 */

typedef void (^WLSaveImageBlock)(NSString *fullImagePath,NSString *smallImagePath,NSError *error);

@interface WLSystemManager : NSObject

#pragma mark - 系统操作
///判断版本是否是第一次
+ (BOOL)isVersionfirst;
///3D Touch动态标签
+ (void)init3DTouchActionShow:(BOOL)isShow;


#pragma mark - 自定义操作
////保存图片到本地路径
//+ (void)wl_saveImageInCacheWithAsset:(ALAsset *)asset ToFolder:(NSString *)toFolder backImagePath:(WLSaveImageBlock)saveImageBlock;
//
//+ (UIImage *)wl_thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size;

+ (NSString *)wl_filePathForCachesPath:(NSString *)path;

+ (UIImage *)wl_imageWithCachePath:(NSString *)path;

//保存图片到本地路径，返回路径
+ (NSString *)wl_saveImage:(UIImage *)image ToFolder:(NSString *)toFolder WithName:(NSString *)imageName;

#pragma mark - 资源路径
+ (NSString *)wl_navResourcePath;
+ (NSString *)wl_userResourcePath;
+ (NSString *)wl_filePathForRelativePath:(NSString *)path;

#pragma mark - 缓存
+ (id)wl_cacheForKey:(NSString *)key;
+ (void)wl_setCache:(id)cache forKey:(NSString *)key;
+ (void)wl_cleanCache;

#pragma mark - 本地文件处理
// 获取文件的大小
+ (long long)wl_fileSizeAtPath:(NSString *)filePath;
// 获取文件的各类属性比较是否相同
+ (BOOL)wl_getFileAttributes:(NSString *)fileName TargetSize:(NSInteger)curSize;
//检查本地文件是否存在
+ (BOOL)wl_fileExistByPath:(NSString *)storePath;
//删除文件
+ (BOOL)wl_fileDelete:(NSString *)sName;
//移动文件
+ (BOOL)wl_filesMove:(NSString *)sName TargetName:(NSString *)tName;
//复制文件
+ (BOOL)wl_filesCopy:(NSString *)sName TargetName:(NSString *)tName;

@end


@interface UIImage (WLCache)

@property (assign, nonatomic, getter = isCached) BOOL cached;

@end
