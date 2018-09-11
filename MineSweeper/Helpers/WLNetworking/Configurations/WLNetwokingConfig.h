//
//  WLNetwokingConfig.h
//  Welian_MVP
//
//  Created by weLian on 16/6/30.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLRequest.h"
#import "WLNetworkingConfiguration.h"

@protocol WLNetwokingProcessDelegate <NSObject>

/**
 *  @author liuwu     , 16-08-02
 *
 *  接口的Header
 *  @return 参数
 */
- (NSDictionary *)httpHeaderInfos;

/**
 *  @author liuwu     , 16-08-02
 *
 *  接口的统一参数
 *  @return 参数
 *  @since V2.8.3
 */
- (NSDictionary *)urlArgumentsInfos;

/**
 *  用于统一加工response，返回处理后response
 *
 *  @param response response
 *  @return 处理后的response
 */
- (id)processResponseWithRequest:(id)request ignoreDecryptAES256:(BOOL)ignoreDecryptAES256;

/**
 *  用于统一加工response，返回是否数据返回正确
 *
 *  @param response response
 *  @return 处理后的response，判断是否接口调用成功
 */
//- (BOOL)processResponseValidator:(id)response;

/**
 *  用于统一的NSError错误处理
 *  @param error 接口错误信息
 *  @param errorType 错误类型
 */
- (BOOL)processResponseWithError:(id)error errorType:(WLErrorType)errorType;

@end


/**
 *  网络全局控制信息
 */
@interface WLNetwokingConfig : NSObject

///实例化
+ (instancetype)sharedInstance;

/// 数据加工的规则
@property (nonatomic, strong) id <WLNetwokingProcessDelegate> processRule;


/// --------------------- 运行环境相关 -------------------
/**
 *  是否开启https SSL 验证
 *  @return YES为开启，NO为关闭
 */
@property (nonatomic, assign, readonly) BOOL openHttpsSSL;

/// 网络是否可以访问
@property (nonatomic, assign, readonly) BOOL isReachable;
/// 是否WiFi网络
@property (nonatomic, assign, readonly) BOOL isReachableViaWiFi;
/// https  参数配置
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;


/// --------------------- app信息 -----------------------
/// app版本
@property (nonatomic, readonly) NSString *appVersion;

///给Url追加的arguments,用于全局参数，比如：AppVersion，默认为nil
@property (nonatomic, readonly) NSDictionary *urlArguments;

/// 取消所有的请求
- (void)cancelAllRequests;

@end
