//
//  WLBatchRequest.h
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLRequest.h"

@class WLBatchRequest;

typedef NS_ENUM(NSInteger , WLRequestQueueType) {
    // 串行
    WLRequestQueueTypeSerial,
    // 并行
    WLRequestQueueTypeParallel
};

@protocol WLBatchRequestInfoDelegate <NSObject>
@optional
/// 一组请求结束
- (void)batchRequestFinished:(WLBatchRequest *)batchRequest;
/// 一组数据请求错误
- (void)batchRequestFailed:(WLBatchRequest *)batchRequest;

@end

/**
 *  @author liuwu     , 16-07-02
 *
 *  用于处理一组网络请求，统一返回调用结果,其中一个请求失败，则全部失败
 */
@interface WLBatchRequest : NSObject

/// 请求返回的结果的数组
@property (strong, nonatomic, readonly) NSArray<WLRequest *> *requestArray;
/// 请求的队列方式
@property (assign, nonatomic, readonly) WLRequestQueueType queueType;
/// 一组请求的代理
@property (weak, nonatomic) id<WLBatchRequestInfoDelegate> delegate;
/// 请求成功的Block
@property (nonatomic, copy) void (^successCompletionBlock)(WLBatchRequest *);
/// 请求错误的Block
@property (nonatomic, copy) void (^failureCompletionBlock)(WLBatchRequest *);

/**
 *  @author Haodi, 16-06-15 14:06:47
 *  串行 请求方式
 */
- (instancetype)initWithRequestArray:(NSArray<WLRequest *> *)requestArray;

/**
 *  @author Haodi, 16-06-15 15:06:06
 *  可以用于 配置的请求 方式
 */
- (instancetype)initWithRequestArray:(NSArray<WLRequest *> *)requestArray
                           queueType:(WLRequestQueueType)queueType;

///开始请求
- (void)start;
///结束请求
- (void)stop;

/// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(WLBatchRequest *batchRequest))success
                                    failure:(void (^)(WLBatchRequest *batchRequest))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(WLBatchRequest *batchRequest))success
                              failure:(void (^)(WLBatchRequest *batchRequest))failure;

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

@end
