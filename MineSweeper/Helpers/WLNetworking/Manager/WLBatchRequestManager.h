//
//  WLBatchRequestManager.h
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WLBatchRequest;

/**
 *  用来管理WLBatchRequest的请求信息
 */
@interface WLBatchRequestManager : NSObject

+ (instancetype)sharedInstance;

/// 添加一组队列请求
- (void)addBatchRequest:(WLBatchRequest *)request;
/// 移除一组队列请求
- (void)removeBatchRequest:(WLBatchRequest *)request;

@end
