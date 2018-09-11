//
//  WLChainRequest.m
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLChainRequest.h"
#import "WLChainRequestManager.h"

@interface WLChainRequest () <WLRequestDelegate>

/// 所有请求的数组
@property (nonatomic, strong) NSMutableArray *requestArray;
/// 所有请求返回结果的数组
@property (nonatomic, strong) NSMutableArray *requestCallbackArray;
/// 下一个请求的index
@property (nonatomic, assign) NSUInteger nextRequestIndex;
/// 空的请求
@property (nonatomic, strong) WLChainCallback emptyCallback;

@end

@implementation WLChainRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(WLChainRequest *chainRequest, WLRequest *request) {
            // do nothing
        };
    }
    return self;
}

/// 开始请求
- (void)start {
    if (_nextRequestIndex > 0) {
        NSLog(@"Error! Chain request has already started.");
        return;
    }
    
    if ([_requestArray count] > 0) {
        //        [self toggleAccessoriesWillStartCallBack];
        [self startNextRequest];
        [[WLChainRequestManager sharedInstance] addChainRequest:self];
    } else {
        NSLog(@"Error! Chain request array is empty.");
    }
}

/// 停止请求
- (void)stop {
    //    [self toggleAccessoriesWillStopCallBack];
    [self clearRequest];
    [[WLChainRequestManager sharedInstance] removeChainRequest:self];
    //    [self toggleAccessoriesDidStopCallBack];
}

/// 添加请求
- (void)addRequest:(WLRequest *)request callback:(WLChainCallback)callback {
    [_requestArray addObject:request];
    if (callback != nil) {
        [_requestCallbackArray addObject:callback];
    } else {
        [_requestCallbackArray addObject:_emptyCallback];
    }
}

- (NSArray *)requestArray {
    return _requestArray;
}

/// 开始下一个请求
- (BOOL)startNextRequest {
    if (_nextRequestIndex < [_requestArray count]) {
        WLRequest *request = _requestArray[_nextRequestIndex];
        _nextRequestIndex++;
        request.delegate = self;
        [request start];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Network Request Delegate
/// 请求完成
- (void)requestFinished:(WLRequest *)request {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    WLChainCallback callback = _requestCallbackArray[currentRequestIndex];
    callback(self, request);
    if (![self startNextRequest]) {
        if ([_delegate respondsToSelector:@selector(chainRequestFinished:)]) {
            [_delegate chainRequestFinished:self];
            ///移除当前完成的请求
            [[WLChainRequestManager sharedInstance] removeChainRequest:self];
        }
    }
}

/// 请求失败
- (void)requestFailed:(WLRequest *)request {
    if ([_delegate respondsToSelector:@selector(chainRequestFailed:failedBaseRequest:)]) {
        [_delegate chainRequestFailed:self failedBaseRequest:request];
        ///移除当前失败的请求
        [[WLChainRequestManager sharedInstance] removeChainRequest:self];
    }
}

/// 清除请求
- (void)clearRequest {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    if (currentRequestIndex < [_requestArray count]) {
        WLRequest *request = _requestArray[currentRequestIndex];
        [request stop];
    }
    [_requestArray removeAllObjects];
    [_requestCallbackArray removeAllObjects];
}

@end
