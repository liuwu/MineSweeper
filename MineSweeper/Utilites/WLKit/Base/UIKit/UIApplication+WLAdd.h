//
//  UIApplication+WLAdd.h
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/*
 UIApplication的扩展类
 */
@interface UIApplication (WLAdd)

/// "Documents"文件夹在这个app中的沙盒位置.
@property (nonatomic, readonly) NSURL *wl_documentsURL;
@property (nonatomic, readonly) NSString *wl_documentsPath;

/// "Caches"文件夹在这个app的沙盒位置.
@property (nonatomic, readonly) NSURL *wl_cachesURL;
@property (nonatomic, readonly) NSString *wl_cachesPath;

/// "Library"文件夹在这个app的沙盒位置.
@property (nonatomic, readonly) NSURL *wl_libraryURL;
@property (nonatomic, readonly) NSString *wl_libraryPath;

/// 应用呈现的Bundle Name (show in SpringBoard).
@property (nullable, nonatomic, readonly) NSString *wl_appBundleName;

/// 应用程序的Bundle ID.  如. "com.ibireme.MyApp"
@property (nullable, nonatomic, readonly) NSString *wl_appBundleID;

/// 应用程序的版本号.  如. "1.2.0"
@property (nullable, nonatomic, readonly) NSString *wl_appVersion;

/// 应用程序的Build number. 如. "123"
@property (nullable, nonatomic, readonly) NSString *wl_appBuildVersion;

/// 这个app是否盗版 (不是从appstore安装).
@property (nonatomic, readonly) BOOL wl_isPirated;

/// 这个app是否是调试状态(debugger attached).
@property (nonatomic, readonly) BOOL wl_isBeingDebugged;

/// 当前线程的实际内存使用字节数. (-1 when error occurs)
@property (nonatomic, readonly) int64_t wl_memoryUsage;

/// 当前线程的CPU使用率, 1.0 指 100%. (-1 when error occurs)
@property (nonatomic, readonly) float wl_cpuUsage;


/**
 增加主动网络请求的数量。
 如果这个数在递增前是零，这将启动状态栏网络活动指示器的动画。
 这个方法是线程安全的。
 这个方法在应用程序扩展中没有作用。
 */
- (void)wl_incrementNetworkActivityCount;

/**
 减少主动网络请求的数量。
 如果这个数在递减后是零，这将停止状态栏网络活动指示器的动画。
 这个方法是线程安全的。
 这个方法在应用程序扩展中没有作用。
 */
- (void)wl_decrementNetworkActivityCount;


/// 返回YES是指在应用程序扩展.
+ (BOOL)wl_isAppExtension;

/// 和sharedApplication相同, 但返回nil在应用程序扩展.
+ (nullable UIApplication *)wl_sharedExtensionApplication;

@end

NS_ASSUME_NONNULL_END

