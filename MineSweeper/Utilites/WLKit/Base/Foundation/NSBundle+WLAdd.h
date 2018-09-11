//
//  NSBundle+WLAdd.h
//  Welian
//
//  Created by weLian on 16/5/16.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/**
 NSBundle的常用方法
 */
@interface NSBundle (WLAdd)

//[ IOS开发NSBundle对象使用详解]http://blog.csdn.net/guozh/article/details/8823674

/**
 返回一个根据分辨率得出的路径搜索最佳顺序的 NSNumber 对象的数组
 
 例如： iPhone3GS:@[@1,@2,@3] iPhone5:@[@2,@3,@1]  iPhone6 Plus:@[@3,@2,@1]
 */
+ (NSArray<NSNumber *> *)wl_preferredScales;

/**
 根据指定的包目录和文件名，文件类型及手机分辨率得出文件的具体路径。
 它首先搜索文件对应的屏幕尺寸，然后从高到底的比例搜索。
 
 @param name       在指定的bundlePath目录中的资源文件的名称.
 @param ext        如果扩展是一个空的字符串或nil,假定扩展名不存在，该文件是遇到的第一个正好匹配名称的文件。
 @param bundlePath bundle目录的路径. 这必须是一个有效的路径. 例如,一个苹果指定的bundle目录，你可以指定路径/Applications/MyApp.app.
 @return 资源文件的完整路径或如果文件无法找到返回nil.如果bundlepath参数不存在或不可读目录此方法返回nil.
 */
+ (nullable NSString *)wl_pathForScaledResource:(NSString *)name
                                         ofType:(nullable NSString *)ext
                                    inDirectory:(NSString *)bundlePath;

/**
 根据程序的资源的目录和文件的文件名，文件类型及手机分辨率得出文件的具体路径。
 它先搜索对应屏幕尺寸（如@2x）的文件，然后从高到底的比例搜索.
 
 @param name       资源文件的名称。如果名称是空字符串或nil，返回第一个匹配类型的文件.
 @param ext        如果扩展是一个空的字符串或nil,假定扩展名不存在，该文件是遇到的第一个正好匹配名称的文件。
 @return 资源文件完整路径名，如果无法找到返回nil.
 */
- (nullable NSString *)wl_pathForScaledResource:(NSString *)name ofType:(nullable NSString *)ext;

/**
 根据程序的资源的目录里的指定子目录，和文件的文件名，文件类型及手机分辨率得出文件的具体路径。
 它首先搜索文件对应的屏幕尺寸，然后从高到底的比例搜索。
 
 @param name       资源文件名.
 @param ext        如果扩展是一个空字符串或nil，返回在自路径及其子目录下的所有文件。如果提供扩展不搜索子目录。
 @param subpath    bundle子目录的名称. 可以为nil.
 @return 资源文件完整路径名，如果无法找到返回nil.
 */
- (nullable NSString *)wl_pathForScaledResource:(NSString *)name
                                         ofType:(nullable NSString *)ext
                                    inDirectory:(nullable NSString *)subpath;


@end

NS_ASSUME_NONNULL_END


#ifndef kBundle
#define kBundle [NSBundle mainBundle]
#endif

#ifndef kBundleInfoDict
#define kBundleInfoDict [kBundle infoDictionary]
#endif

#define kBundleInfoDictValue(key) [kBundleInfoDict objectForKey:key]
//app 版本号
#define kAppVersion kBundleInfoDictValue(@"CFBundleShortVersionString")

// KPlatformType
#define kPlatformType            kBundleInfoDictValue (@"KPlatformType")

