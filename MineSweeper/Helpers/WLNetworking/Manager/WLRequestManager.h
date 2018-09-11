//
//  WLRequestManager.h
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WLRequest;

typedef void (^WLNetworkManagerCompletionBlock)(void);

/**
 *  @author liuwu     , 16-07-02
 *
 *  单个Request请求管理类
 */
@interface WLRequestManager : NSObject

/// 声明对象实例
+ (instancetype)sharedInstance;

/// 添加指定的请求
- (void)addRequest:(WLRequest *)request;

/// 取消指定Request请求的调用
- (void)cancelRequest:(WLRequest *)request
           completion:(WLNetworkManagerCompletionBlock)completion;

/// 取消所有的请求
- (void)cancelAllRequests;

@end
