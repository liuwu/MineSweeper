//
//  UIDevice+WLAddForInfo.m
//  Welian
//
//  Created by 好迪 on 16/5/10.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIDevice+WLAddForInfo.h"
#import "NSString+WLAdd.h"

//#import "SSKeychain.h"

#include <sys/sysctl.h>
#include <sys/socket.h>
#include <mach/mach.h>

#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UIDevice_WLAdd)


@implementation UIDevice (WLAddForInfo)

///描述信息，打印设备型号，系统版本，设备ID
+ (NSString *)wl_description{
    NSString *desc = [NSString stringWithFormat:@"\n设备型号:%@;\n系统版本:%@;\n;\n",kDeviceModelInfo,kDeviceIOSVersion];
    return desc;
}

/// 获取iOS系统的版本号
+ (double)wl_systemVersion {
    return [self systemVersion];
}

/**
 *  @author liuwu     , 16-07-18
 *
 *  切换屏幕选中到竖屏状态
 */
+ (void)wl_checkDeviceOrientationPortrait {
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

- (BOOL)wl_isPad {
    return [self isPad];
}

- (BOOL)wl_isSimulator {
    return [self isSimulator];
}

- (BOOL)wl_isJailbroken {
    return [self isJailbroken];
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)wl_canMakePhoneCalls {
    return [self canMakePhoneCalls];
}
#endif

#pragma mark -
//设备型号字符串
- (NSString*)wl_machineModel {
    return [self machineModel];
}

/// 设备硬件型号
- (NSString*)wl_machineModelName {
    return [self machineModelName];
}

/**
 *  @author liuwu     , 16-05-12
 *
 *  不带(GSM, CDMA, GLOBAL)的设备硬件型号，如：iphone5
 *  @return 设置型号字符串
 *  @since V2.7.9
 */
- (NSString *)wl_machineModelSimpleName {
    NSString *hardware = [self wl_machineModel];
    if ([hardware isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([hardware isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([hardware isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([hardware isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([hardware isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([hardware isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([hardware isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([hardware isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([hardware isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([hardware isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([hardware isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([hardware isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([hardware isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([hardware isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    if ([hardware isEqualToString:@"iPod1,1"])      return @"iPod Touch 1";
    if ([hardware isEqualToString:@"iPod2,1"])      return @"iPod Touch 2";
    if ([hardware isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
    if ([hardware isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
    if ([hardware isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
    if ([hardware isEqualToString:@"iPod7,1"])      return @"iPod Touch 6";
    
    if ([hardware isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([hardware isEqualToString:@"iPad1,2"])      return @"iPad";
    if ([hardware isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina";
    if ([hardware isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina";

    if ([hardware isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([hardware isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([hardware isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([hardware isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([hardware isEqualToString:@"iPad5,1"])      return @"iPad mini 4";
    if ([hardware isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    if ([hardware isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([hardware isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([hardware isEqualToString:@"iPad6,3"])      return @"iPad Pro (9.7 inch)";
    if ([hardware isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7 inch)";
    if ([hardware isEqualToString:@"iPad6,7"])      return @"iPad Pro (12.9 inch)";
    if ([hardware isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9 inch)";
    
    if ([hardware isEqualToString:@"i386"])         return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", hardware);
    
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";

    return nil;
}

- (NSDate *)wl_systemUptime {
    return [self systemUptime];
}

/**
 *	返回统一版本的设备编号，无论系统的操作系统版本
 *  先检测在KeyChain中是否存在udid值
 *  如果存在，则直接读出来用
 *  如果不存在，则产生
 *  产生方式：如果硬件Udid可读，则用Udid 否则用 identifierForVendor 再不行，自己产生一个UUID
 *
 *	@return	udid字符串
 */
- (NSString *)wl_idForDevice{
    NSString *deviceIndetity = [YYKeychain getPasswordForService:@"com.chuansongmen.welianos"  account:@"udid"];
//    NSString *deviceIndetity = [SSKeychain passwordForService:@"com.chuansongmen.welianos" account:@"udid"];
    if (deviceIndetity.length == 0) {
        deviceIndetity = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        NSError *err = nil;
        if (![YYKeychain setPassword:deviceIndetity forService:@"com.chuansongmen.welianos" account:@"udid" error:&err]) {
            DLog(@"dev id %@",err);
        }
        //d45df9d3ed0d9a2108148ae807373c3e    de9d4b4a2c2b4cf25a0bc1da984801ec
//        if (![SSKeychain setPassword:deviceIndetity forService:@"com.chuansongmen.welianos" account:@"udid" error:&err]) {
//            DLog(@"dev id %@",err);
//        }
    }
    return deviceIndetity;
}


#pragma mark - Network Information
///=============================================================================
/// @name 网络信息
///=============================================================================


typedef struct {
    uint64_t en_in;
    uint64_t en_out;
    uint64_t pdp_ip_in;
    uint64_t pdp_ip_out;
    uint64_t awdl_in;
    uint64_t awdl_out;
} net_interface_counter;


static uint64_t net_counter_add(uint64_t counter, uint64_t bytes) {
    if (bytes < (counter % 0xFFFFFFFF)) {
        counter += 0xFFFFFFFF - (counter % 0xFFFFFFFF);
        counter += bytes;
    } else {
        counter = bytes;
    }
    return counter;
}

static uint64_t net_counter_get_by_type(net_interface_counter *counter, WLNetworkTrafficType type) {
    uint64_t bytes = 0;
    if (type & WLNetworkTrafficTypeWWANSent) bytes += counter->pdp_ip_out;
    if (type & WLNetworkTrafficTypeWWANReceived) bytes += counter->pdp_ip_in;
    if (type & WLNetworkTrafficTypeWIFISent) bytes += counter->en_out;
    if (type & WLNetworkTrafficTypeWIFIReceived) bytes += counter->en_in;
    if (type & WLNetworkTrafficTypeAWDLSent) bytes += counter->awdl_out;
    if (type & WLNetworkTrafficTypeAWDLReceived) bytes += counter->awdl_in;
    return bytes;
}

static net_interface_counter get_net_interface_counter() {
    static dispatch_semaphore_t lock;
    static NSMutableDictionary *sharedInCounters;
    static NSMutableDictionary *sharedOutCounters;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInCounters = [NSMutableDictionary new];
        sharedOutCounters = [NSMutableDictionary new];
        lock = dispatch_semaphore_create(1);
    });
    
    net_interface_counter counter = {0};
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        while (cursor) {
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                const struct if_data *data = cursor->ifa_data;
                NSString *name = cursor->ifa_name ? [NSString stringWithUTF8String:cursor->ifa_name] : nil;
                if (name) {
                    uint64_t counter_in = ((NSNumber *)sharedInCounters[name]).unsignedLongLongValue;
                    counter_in = net_counter_add(counter_in, data->ifi_ibytes);
                    sharedInCounters[name] = @(counter_in);
                    
                    uint64_t counter_out = ((NSNumber *)sharedOutCounters[name]).unsignedLongLongValue;
                    counter_out = net_counter_add(counter_out, data->ifi_obytes);
                    sharedOutCounters[name] = @(counter_out);
                    
                    if ([name hasPrefix:@"en"]) {
                        counter.en_in += counter_in;
                        counter.en_out += counter_out;
                    } else if ([name hasPrefix:@"awdl"]) {
                        counter.awdl_in += counter_in;
                        counter.awdl_out += counter_out;
                    } else if ([name hasPrefix:@"pdp_ip"]) {
                        counter.pdp_ip_in += counter_in;
                        counter.pdp_ip_out += counter_out;
                    }
                }
            }
            cursor = cursor->ifa_next;
        }
        dispatch_semaphore_signal(lock);
        freeifaddrs(addrs);
    }
    
    return counter;
}

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
- (uint64_t)wl_getNetworkTrafficBytes:(WLNetworkTrafficType)types {
    net_interface_counter counter = get_net_interface_counter();
    return net_counter_get_by_type(&counter, types);
}


#pragma mark - Disk Space
///=============================================================================
/// @name 磁盘空间
///=============================================================================

/// 磁盘空间大小，字节表示. (出错时为：-1)
- (int64_t)wl_diskSpace {
    return [self diskSpace];
}

/// 空闲的磁盘空间大小，字节表示. (出错时为：-1)
- (int64_t)wl_diskSpaceFree {
    return [self diskSpaceFree];
}

/// 已使用的磁盘空间大小，字节表示. (出错时为：-1)
- (int64_t)wl_diskSpaceUsed {
    return [self diskSpaceUsed];
}


#pragma mark - Memory Information
///=============================================================================
/// @name 内存信息
///=============================================================================

/// 总的物理内存大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryTotal {
    return [self memoryTotal];
}

/// 使用中的（主动+非活动+有线）内存大小，字节表示.(出错时为：-1)
- (int64_t)wl_memoryUsed {
    return [self memoryUsed];
}

/// 空闲内存的大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryFree {
    return [self memoryFree];
}

/// 活动中的内存大小，字节表示.(出错时为：-1)
- (int64_t)wl_memoryActive {
    return [self memoryActive];
}

/// 非活动内存大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryInactive {
    return [self memoryInactive];
}

/// 有线内存大小，字节表示. (出错时为：-1)
- (int64_t)wl_memoryWired {
    return [self memoryWired];
}

/// Purgable字节大小，字节表. (出错时为：-1)
- (int64_t)wl_memoryPurgable {
    return [self memoryPurgable];
}


#pragma mark - CPU Information
///=============================================================================
/// @name CPU信息
///=============================================================================

/// 可用的CPU处理器数.
- (NSUInteger)wl_cpuCount {
    return [self cpuCount];
}

/// 当前的CPU处理器的使用率，1.0指100% (出错时为：-1)
- (float)wl_cpuUsage {
    return [self cpuUsage];
}

/// 当前使用的CPU处理所有使用率（NSNumber的数组），1.0指100%.出错时：nil
- (NSArray *)wl_cpuUsagePerProcessor {
    return [self cpuUsagePerProcessor];
}


@end
