//
//  WLLogger.h
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/13.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLRequest.h"

/**
 *  打印请求的内容信息，包括请求、请求返回的内容、读取缓存的内容
 */
@interface WLLogger : NSObject

+ (instancetype)sharedInstance;

/**
 *  打印请求信息
 */
+ (void)logDebugInfoWithRequest:(WLRequest *)request;

/**
 *  打印请求返回的内容
 *  @param request Api请求
 */
+ (void)logDebugInfoWithResponse:(WLRequest *)request;

/**
 *  读取缓存的内容
 *  @param request Api请求
 */
+ (void)logDebugInfoWithCachedResponse:(WLRequest *)request;

@end
