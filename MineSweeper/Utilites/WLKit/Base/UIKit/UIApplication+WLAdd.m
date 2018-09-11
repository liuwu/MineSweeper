//
//  UIApplication+WLAdd.m
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "UIApplication+WLAdd.h"
#import "UIDevice+WLAddForInfo.h"

#import <sys/sysctl.h>
#import <mach/mach.h>
#import <objc/runtime.h>

#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UIApplication_WLAdd)

@implementation UIApplication (WLAdd)

- (NSURL *)wl_documentsURL {
    return [self documentsURL];
}

- (NSString *)wl_documentsPath {
    return [self documentsPath];
}

- (NSURL *)wl_cachesURL {
    return [self cachesURL];
}

- (NSString *)wl_cachesPath {
    return [self cachesPath];
}

- (NSURL *)wl_libraryURL {
    return [self libraryURL];
}

- (NSString *)wl_libraryPath {
    return [self libraryPath];
}

- (BOOL)wl_isPirated {
    return [self isPirated];
}

- (NSString *)wl_appBundleName {
    return [self appBundleName];
}

- (NSString *)wl_appBundleID {
    return [self appBundleID];
}

- (NSString *)wl_appVersion {
    return [self appVersion];
}

- (NSString *)wl_appBuildVersion {
    return [self appBuildVersion];
}

- (BOOL)wl_isBeingDebugged {
    return [self isBeingDebugged];
}

- (int64_t)wl_memoryUsage {
    return [self memoryUsage];
}

- (float)wl_cpuUsage {
    return [self cpuUsage];
}

/**
 增加主动网络请求的数量。
 如果这个数在递增前是零，这将启动状态栏网络活动指示器的动画。
 这个方法是线程安全的。
 这个方法在应用程序扩展中没有作用。
 */
- (void)wl_incrementNetworkActivityCount {
    [self incrementNetworkActivityCount];
}

/**
 减少主动网络请求的数量。
 如果这个数在递减后是零，这将停止状态栏网络活动指示器的动画。
 这个方法是线程安全的。
 这个方法在应用程序扩展中没有作用。
 */
- (void)wl_decrementNetworkActivityCount {
    [self decrementNetworkActivityCount];
}


/// 返回YES是指在应用程序扩展.
+ (BOOL)wl_isAppExtension {
    return [self isAppExtension];
}

/// 和sharedApplication相同, 但返回nil在应用程序扩展.
+ (nullable UIApplication *)wl_sharedExtensionApplication {
    return [self sharedExtensionApplication];
}

@end
