//
//  WLBatchRequest.m
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLBatchRequest.h"
#import "WLBatchRequestManager.h"

@interface WLBatchRequest ()<WLRequestDelegate>

@property (nonatomic) NSInteger finishedCount;

@end

@implementation WLBatchRequest

- (instancetype)initWithRequestArray:(NSArray<WLRequest *> *)requestArray{
    return [self initWithRequestArray:requestArray queueType:WLRequestQueueTypeSerial];
}

- (instancetype)initWithRequestArray:(NSArray<WLRequest *> *)requestArray queueType:(WLRequestQueueType)queueType{
    self = [super init];
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        _queueType = queueType;
        
        for (WLRequest * req in _requestArray) {
            if (![req isKindOfClass:[WLRequest class]]) {
                NSLog(@"Error, request item must be WLRequest instance.");
                return nil;
            }
        }
    }
    return self;
}

///启动请求
- (void)start {
    if (_finishedCount > 0) {
        NSLog(@"Error! Batch request has already started.");
        return;
    }
    
    ///把当前这组请求放入管理类中。
    [[WLBatchRequestManager sharedInstance] addBatchRequest:self];
    
    //    [self toggleAccessoriesWillStartCallBack];
    switch (_queueType) {
        case WLRequestQueueTypeSerial: {
            //队列请求
            WLRequest * req  = _requestArray.firstObject;
            req.delegate = self;
            [req start];
            break;
        }
        case WLRequestQueueTypeParallel: {
            ///同步请求
            for (WLRequest * req in _requestArray) {
                req.delegate = self;
                [req start];
            }
            break;
        }
    }
}

///停止当前请求
- (void)stop {
    _delegate = nil;
    ///移除当前请求组中所有请求
    [self clearRequest];
    ///从管理类中移除当前请求
    [[WLBatchRequestManager sharedInstance] removeBatchRequest:self];
}

#pragma mark - Block 请求回调开始
- (void)startWithCompletionBlockWithSuccess:(void (^)(WLBatchRequest *batchRequest))success
                                    failure:(void (^)(WLBatchRequest *batchRequest))failure{
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(WLBatchRequest *batchRequest))success
                              failure:(void (^)(WLBatchRequest *batchRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

#pragma mark - WLRequestInfoDelegate
///请求完成
- (void)requestFinished:(WLRequest *)request {
    _finishedCount++;
    
    // 串行队列请求方式
    if (_queueType == WLRequestQueueTypeSerial && _finishedCount < _requestArray.count) {
        WLRequest * req  = _requestArray[_finishedCount];
        req.delegate = self;
        [req start];
    }
    
    // 请求完成统一返回
    if (_finishedCount == _requestArray.count) {
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            [_delegate batchRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self clearCompletionBlock];
        ///请求完成，移除当前请求队列
        [[WLBatchRequestManager sharedInstance] removeBatchRequest:self];
    }
}

///请求失败
- (void)requestFailed:(WLRequest *)request {
    // 循环停止所有请求
    for (WLRequest *req in _requestArray) {
        [req stop];
    }
    // Callback
    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [_delegate batchRequestFailed:self];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self);
    }
    // 清除Block回调
    [self clearCompletionBlock];
    ///请求完成，移除当前请求队列
    [[WLBatchRequestManager sharedInstance] removeBatchRequest:self];
}

///清除请求
- (void)clearRequest {
    for (WLRequest * req in _requestArray) {
        [req stop];
    }
    [self clearCompletionBlock];
}

///取消所有请求
- (void)cancelAllRequest{
    NSLog(@"WLBatchRequest cancel All request");
    [self stop];
}

@end
