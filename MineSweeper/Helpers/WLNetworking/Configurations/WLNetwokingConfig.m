//
//  WLNetwokingConfig.m
//  Welian_MVP
//
//  Created by weLian on 16/6/30.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLNetwokingConfig.h"
#import "WLRequestManager.h"

///网络连接无法连接
NSString *const kWLNetworkNoContentNotification = @"WLNetworkNoContentNotifi";
/// 网络连接已恢复
NSString *const kWLNetworkReContentNotification = @"WLNetworkReContentNotification";

@interface WLNetwokingConfig ()

/// 网络链接当前是否连接，默认连接状态
@property (nonatomic, assign) BOOL isNetWorkConnect;

@end

@implementation WLNetwokingConfig

#pragma mark - life cycle
///实例化
+ (instancetype)sharedInstance {
    static WLNetwokingConfig *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WLNetwokingConfig alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // https  参数配置
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        // 是否信任服务器无效或过期的SSL证书。默认为“否”。
        _securityPolicy.allowInvalidCertificates = NO;
        //是否验证证书CN域中的域名。默认为“是”,假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        _securityPolicy.validatesDomainName = YES;
        
        //开始网络监控
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [self checkReachableStatus];
    }
    return self;
}

#pragma mark - Check ReachableStatus
///监控网络状态
- (void)checkReachableStatus {
    _isNetWorkConnect = YES;//默认链接状态
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"Reachability: 未知网络");
                if (!_isNetWorkConnect) {
                    _isNetWorkConnect = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kWLNetworkReContentNotification object:nil];
                }
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"Reachability: 无网络");
                if (_isNetWorkConnect) {
                    _isNetWorkConnect = NO;
                    //全局通知，没有网络
                    NSDictionary *params = @{@"msg" : kNetworkNoContent};
                    [[NSNotificationCenter defaultCenter] postNotificationName:kWLNetworkNoContentNotification object:nil userInfo:params];
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"Reachability: 手机自带网络");
                if (!_isNetWorkConnect) {
                    _isNetWorkConnect = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kWLNetworkReContentNotification object:nil];
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"Reachability: WIFI");
                if (!_isNetWorkConnect) {
                    _isNetWorkConnect = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kWLNetworkReContentNotification object:nil];
                }
                break;
            }
        }
    }];
}

/// 取消所有的请求
- (void)cancelAllRequests {
    [[WLRequestManager sharedInstance] cancelAllRequests];
}

#pragma mark - getter & setter
///网络是否可以访问
- (BOOL)isReachable {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (BOOL)openHttpsSSL {
    return YES;
}

//是否wifi网络环境
- (BOOL)isReachableViaWiFi {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

/// app版本
- (NSString *)appVersion {
    return kAppVersion;
}

/// 给服务器访问地址后面追加的全局参数，如果子类为空，可以设置初始值
- (NSDictionary *)urlArguments {
    NSDictionary *params = nil;
    if (self.processRule && [self.processRule respondsToSelector:@selector(urlArgumentsInfos)]) {
        params = [self.processRule urlArgumentsInfos];
    }
    return params;
}

@end
