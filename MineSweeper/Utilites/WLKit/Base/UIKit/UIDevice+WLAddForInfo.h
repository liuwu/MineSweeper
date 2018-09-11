//
//  UIDevice+WLAddForInfo.h
//  Welian
//
//  Created by 好迪 on 16/5/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (WLAddForInfo)

#pragma mark - Device Information
///=============================================================================
/// @name 设备信息
///=============================================================================

///描述信息，打印设备型号，系统版本，设备ID
+ (NSString *)wl_description;

/**
 *  @author liuwu     , 16-05-12
 *
 *  获取系统版本号（如：8.1）
 *  @return 版本号
 *  @since V2.7.9
 */
+ (double)wl_systemVersion;

/**
 *  @author liuwu     , 16-07-18
 *
 *  切换屏幕选中到竖屏状态
 */
+ (void)wl_checkDeviceOrientationPortrait;

/// 是否 iPad/iPad mini.
@property (nonatomic, readonly) BOOL wl_isPad;

/// 是否模拟器
@property (nonatomic, readonly) BOOL wl_isSimulator;

/// 设备是否越狱
@property (nonatomic, readonly) BOOL wl_isJailbroken;

/// 是不是可以打电话
@property (nonatomic, readonly) BOOL wl_canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

/// 设备型号模型  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonatomic, readonly) NSString *wl_machineModel;

/// 设备型号名称. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonatomic, readonly) NSString *wl_machineModelName;

///不带(GSM, CDMA, GLOBAL)的设备硬件型号，如：iphone5
@property (nonatomic, readonly) NSString *wl_machineModelSimpleName;

/// 系统启动时间
@property (nonatomic, readonly) NSDate *wl_systemUptime;

/**
 *	返回统一版本的设备编号，无论系统的操作系统版本
 *  先检测在KeyChain中是否存在udid值
 *  如果存在，则直接读出来用
 *  如果不存在，则产生
 *  产生方式：如果硬件Udid可读，则用Udid 否则用 identifierForVendor 再不行，自己产生一个UUID
 *
 *	@return	udid字符串
 */
@property (nonatomic, readonly) NSString *wl_idForDevice;


#pragma mark - Network Information
///=============================================================================
/// @name 网络信息
///=============================================================================


/**
 网络流量类型:
 WWAN: 无线广域网.如：3G/4G
 WIFI: Wi-Fi.
 AWDL: 苹果无线直接连接 (点对点连接). 如：AirDrop, AirPlay, GameKit.
 */
typedef NS_OPTIONS(NSUInteger, WLNetworkTrafficType) {
    WLNetworkTrafficTypeWWANSent     = 1 << 0,
    WLNetworkTrafficTypeWWANReceived = 1 << 1,
    WLNetworkTrafficTypeWIFISent     = 1 << 2,
    WLNetworkTrafficTypeWIFIReceived = 1 << 3,
    WLNetworkTrafficTypeAWDLSent     = 1 << 4,
    WLNetworkTrafficTypeAWDLReceived = 1 << 5,
    
    WLNetworkTrafficTypeWWAN = WLNetworkTrafficTypeWWANSent | WLNetworkTrafficTypeWWANReceived,
    WLNetworkTrafficTypeWIFI = WLNetworkTrafficTypeWIFISent | WLNetworkTrafficTypeWIFIReceived,
    WLNetworkTrafficTypeAWDL = WLNetworkTrafficTypeAWDLSent | WLNetworkTrafficTypeAWDLReceived,
    
    WLNetworkTrafficTypeALL = WLNetworkTrafficTypeWWAN | WLNetworkTrafficTypeWIFI | WLNetworkTrafficTypeAWDL,
};

/**
 获取设备网络流量字节数。
 
 @讨论  这是一个该设备最后启动时间的计数器.
 用法:
 uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes:WLNetworkTrafficTypeALL];
 NSTimeInterval time = CACurrentMediaTime();
 
 uint64_t bytesPerSecond = (bytes - _lastBytes) / (time - _lastTime);
 
 _lastBytes = bytes;
 _lastTime = time;
 
 @param type 流量类型
 @return 字节计数.
 */
- (uint64_t)wl_getNetworkTrafficBytes:(WLNetworkTrafficType)types;


#pragma mark - Disk Space
///=============================================================================
/// @name 磁盘空间
///=============================================================================

/// 磁盘空间大小，字节表示. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_diskSpace;

/// 空闲的磁盘空间大小，字节表示. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_diskSpaceFree;

/// 已使用的磁盘空间大小，字节表示. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_diskSpaceUsed;


#pragma mark - Memory Information
///=============================================================================
/// @name 内存信息
///=============================================================================

/// 总的物理内存大小，字节表示. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_memoryTotal;

/// 使用中的（主动+非活动+有线）内存大小，字节表示.(出错时为：-1)
@property (nonatomic, readonly) int64_t wl_memoryUsed;

/// 空闲内存的大小，字节表示. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_memoryFree;

/// 活动中的内存大小，字节表示.(出错时为：-1)
@property (nonatomic, readonly) int64_t wl_memoryActive;

/// 非活动内存大小，字节表示. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_memoryInactive;

/// 有线内存大小，字节表示. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_memoryWired;

/// Purgable字节大小，字节表. (出错时为：-1)
@property (nonatomic, readonly) int64_t wl_memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU信息
///=============================================================================

/// 可用的CPU处理器数.
@property (nonatomic, readonly) NSUInteger wl_cpuCount;

/// 当前的CPU处理器的使用率，1.0指100% (出错时为：-1)
@property (nonatomic, readonly) float wl_cpuUsage;

/// 当前使用的CPU处理所有使用率（NSNumber的数组），1.0指100%.出错时：nil
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *wl_cpuUsagePerProcessor;


@end

NS_ASSUME_NONNULL_END


#ifndef kSystemVersion
#define kSystemVersion [UIDevice wl_systemVersion]
#endif

#ifndef kIOS6Later
#define kIOS6Later (kSystemVersion >= 6)
#endif

#ifndef kISIOS7  ///因为目前系统只支持7以上的，所以小于8就是7的系统
#define kISIOS7 (kSystemVersion < 8)
#endif

#ifndef kIOS7Later
#define kIOS7Later (kSystemVersion >= 7)
#endif

#ifndef kIOS8Later
#define kIOS8Later (kSystemVersion >= 8)
#endif

#ifndef kIOS9Later
#define kIOS9Later (kSystemVersion >= 9)
#endif

#ifndef kIOS10Later
#define kIOS10Later (kSystemVersion >= 10)
#endif

#ifndef kIOS11Later
#define kIOS11Later (kSystemVersion >= 11)
#endif

#ifndef kDeviceUdid
#define kDeviceUdid  [[UIDevice currentDevice] wl_idForDevice]
#endif

#ifndef kDeviceIOSVersion
#define kDeviceIOSVersion [[UIDevice currentDevice] systemVersion]
#endif

#ifndef kDeviceModelInfo ///设备硬件型号
#define kDeviceModelInfo  [[UIDevice currentDevice] wl_machineModelName]
#endif

#ifndef kDeviceModelSimpleInfo  ///设备硬件简洁型号
#define kDeviceModelSimpleInfo  [[UIDevice currentDevice] machineModelSimpleName]
#endif

//iphone5适配
//#define IPhone4 [DEVICE_MODEL_SIMPLE_INFO isEqualToString:@"iPhone4"]
//#define Iphone5 [DEVICE_MODEL_SIMPLE_INFO isEqualToString:@"iPhone5"]
//检测iphone6(bool)
//#define Iphone6 [[NSString getCurrentDeviceModel] isEqualToString:@"iPhone6"]
//检测iphone6p(bool)
//#define Iphone6plus [[NSString getCurrentDeviceModel] isEqualToString:@"iPhone6Plus"]

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define iphone4And4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5And5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6And6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plusAnd6splus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
