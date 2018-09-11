//
//  WLRequestManager.m
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLRequestManager.h"
#import "WLRequest.h"
#import "WLRequest+WLAdd.h"
#import "WLLogger.h"

/// 自定义操作类
#import "WLNetworkPrivate.h"
#import "WLNetworkingConfiguration.h"

//网络请求
#import "WLNetworkManager.h"

#import <AFNetworking/AFNetworking.h>

@interface WLRequestManager ()

///网络访问管理者
@property (nonatomic, strong) WLNetworkManager *netWorkManager;
///请求的记录
@property (nonatomic, strong) NSMutableDictionary *requestsRecord;

@end

@implementation WLRequestManager

#pragma mark - Lifecycle
///声明对象实例
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WLRequestManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - Public
///添加指定的请求
- (void)addRequest:(WLRequest *)request {
    WLRequestCoverType coverType = [request requestCoverTypeInfo];
    switch (coverType) {
        case WLRequestCoverTypeAfter: {
            NSDictionary *copyRecord = [self.requestsRecord copy];
            for (NSString *key in copyRecord) {
                WLRequest *loclrequest = copyRecord[key];
                if ([loclrequest urlStringHash] == [request urlStringHash] &&
                    [loclrequest paramsStringHash] == [request paramsStringHash]) {
                    // 同一接口与请求参数的接口，覆盖后面的接口
                    if (loclrequest.requestDataTask.state == NSURLSessionTaskStateRunning ||
                        loclrequest.requestDataTask.state == NSURLSessionTaskStateSuspended) {
                        // 取消现在的请求，不进行现在的请求，直接返回
                        return;
                    }
                }
            }
            break;
        }
        case WLRequestCoverTypeBefore: {
            // 同一接口，不同参数的请求，覆盖前面的接口
            NSDictionary *copyRecord = [self.requestsRecord copy];
            for (NSString *key in copyRecord) {
                WLRequest *loclrequest = copyRecord[key];
                if ([loclrequest urlStringHash] == [request urlStringHash]) {
                    //存在同一个接口的请求，判断是否请求结束，未结束移除正在请求的接口
                    if (loclrequest.requestDataTask.state == NSURLSessionTaskStateRunning ||
                        loclrequest.requestDataTask.state == NSURLSessionTaskStateSuspended) {
                        // 取消前面的请求
                        [self cancelRequest:loclrequest completion:nil];
                    }
                }
            }
            break;
        }
        case WLRequestCoverTypeNormal: {
            // 默认允许重复接口请求，不做处理
            break;
        }
    }
    // 判断是否有缓存
    if (request.isNeedCache) {
        if (request.hasCached && request.isCacheTimeValidator) {
            ///已经存在缓存
            ///成功后，设置数据，返回请求
            request.responseJSONObject = request.cacheObject;
            //打印请求结果信息
            [WLLogger logDebugInfoWithCachedResponse:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                /// 进入请求成功回调
                [self requestSuccessWithRequest:request];
            });
            ///清除block回调
            [request clearCompletionBlock];
            return;
        }
    }
    [self wl_addRequst:request];
}

///取消指定Request请求的调用
- (void)cancelRequest:(WLRequest *)request
           completion:(WLNetworkManagerCompletionBlock)completion {
    [self wl_cancelRequest:request];
    if (completion != nil) {
        completion();
    }
}

///取消所有的请求
- (void)cancelAllRequests {
    NSDictionary *copyRecord = [self.requestsRecord copy];
    for (NSString *key in copyRecord) {
        WLRequest *request = copyRecord[key];
        [request stop];
    }
}

#pragma mark - Private
///取消请求
- (void)wl_cancelRequest:(WLRequest *)request {
    //任务暂停
    [request.requestDataTask suspend];
    //任务取消
    [request.requestDataTask cancel];
    [self removeOperation:request.requestDataTask];
    [request clearCompletionBlock];
}

///添加请求
- (void)wl_addRequst:(WLRequest *)request {
    //打印请求信息
    [WLLogger logDebugInfoWithRequest:request];
    
    //    ///请求的URl地址
    NSString *url = request.urlString;
    //如果请求地址为空 取消不进行
    if (url.length == 0) {
        return;
    }
    
    //请求的参数
    NSDictionary *params = request.requestParamInfos;
    
    ///请求的类型
    self.netWorkManager.requestSerializer = request.requestSerializer;
    ///返回结果的类型
    self.netWorkManager.responseSerializer = request.responseSerializer;
    ///请求的超时时间
    self.netWorkManager.timeOutInterval = request.timeOutInterval;
    
    // 实际的网络请求
    if ([request isReachable]) {
        ///请求的方法
        WLRequestMethodType methodType = request.requestMethodType;
        
        typeof(self) __weak weakSelf = self;
        switch (methodType) {
            case WLRequestMethodTypeGet: {
                request.requestDataTask = [self.netWorkManager wl_requestWithType:WLHttpRequestTypeTypeGet UrlString:url Parameters:params SuccessBlock:^(NSURLSessionTask *task, id response) {
                    [weakSelf handleRequestResult:task responseObject:response];
                } FailureBlock:^(NSURLSessionTask *task, NSError *error) {
                    [weakSelf handleRequestResult:task responseObject:error];
                }];
                break;
            }
            case WLRequestMethodTypePost: {
                request.requestDataTask = [self.netWorkManager wl_requestWithType:WLHttpRequestTypePost UrlString:url Parameters:params SuccessBlock:^(NSURLSessionTask *task, id response) {
                    [weakSelf handleRequestResult:task responseObject:response];
                } FailureBlock:^(NSURLSessionTask *task, NSError *error) {
                    [weakSelf handleRequestResult:task responseObject:error];
                }];
                break;
            }
            case WLRequestMethodTypeDown: {
                request.requestDataTask = [self.netWorkManager wl_downLoadFileWithUrlString:url parameters:nil SavaPath:request.downfileFolderName SuccessBlock:^(NSURLSessionTask *task, id response) {
                    [weakSelf handleRequestResult:request.requestDataTask responseObject:response];
                } FailureBlock:^(NSURLSessionTask *task, NSError *error) {
                    [weakSelf handleRequestResult:request.requestDataTask responseObject:error];
                } DownLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                    if (request.progress) {
                        request.progress(bytesProgress, totalBytesProgress);
                    }
                }];
                break;
            }
            case WLRequestMethodTypePUT:{
                request.requestDataTask = [self.netWorkManager wl_requestWithType:WLHttpRequestTypePUT UrlString:url Parameters:params SuccessBlock:^(NSURLSessionTask *task, id response) {
                    [weakSelf handleRequestResult:task responseObject:response];
                } FailureBlock:^(NSURLSessionTask *task, NSError *error) {
                    [weakSelf handleRequestResult:task responseObject:error];
                }];
                break;
            }
            case WLRequestMethodTypeDelete: {
                request.requestDataTask = [self.netWorkManager wl_requestWithType:WLHttpRequestTypeDelete UrlString:url Parameters:params SuccessBlock:^(NSURLSessionTask *task, id response) {
                    [weakSelf handleRequestResult:task responseObject:response];
                } FailureBlock:^(NSURLSessionTask *task, NSError *error) {
                    [weakSelf handleRequestResult:task responseObject:error];
                }];
                break;
            }
            case WLRequestMethodTypePatch: {
                request.requestDataTask = [self.netWorkManager wl_requestWithType:WLHttpRequestTypePatch UrlString:url Parameters:params SuccessBlock:^(NSURLSessionTask *task, id response) {
                    [weakSelf handleRequestResult:task responseObject:response];
                } FailureBlock:^(NSURLSessionTask *task, NSError *error) {
                    [weakSelf handleRequestResult:task responseObject:error];
                }];
                break;
            }
        }
        DLog(@"Add request: %@  id:%lu", NSStringFromClass([request class]), (unsigned long)request.requestDataTask.taskIdentifier);
        //把请求加入队列
        [self addOperation:request];
    }else{
        /// 网络无法访问
        ///请求失败的统一处理
        request.errorType = WLErrorTypeNoNetWork;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestFaieldWithRequest:request];
        });
    }
}

///接口调用完成，进行处理
- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)res{
    NSString *key = [self requestHashKey:task];
    WLRequest *request = self.requestsRecord[key];
    request.responseJSONObject = res;
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///请求错误
        if ([res isKindOfClass:[NSError class]]) {
            if ([res code] == NSURLErrorTimedOut) {
                //请求超时
                request.errorType = WLErrorTypeTimeOut;
            }else{
                request.errorType = WLErrorTypeFailed;
            }
            request.error = res;
        }else{
            /// 加工返回的数据
            [request requestResponseJsonObjectFilter];
            if ([request.responseJSONObject isKindOfClass:[NSError class]]) {
                //给错误赋值
                request.errorType = WLErrorTypeNoContent;
            }else{
                request.errorType = WLErrorTypeSuccess;
                ///需要缓存的话，进行缓存
                if (request.isNeedCache) {
                    [request saveDataInfoToCache:request.responseJSONObject];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request.errorType == WLErrorTypeSuccess) {
                //打印请求结果信息
                [WLLogger logDebugInfoWithResponse:request];
                /// 数据成功，返回成功
                [weakSelf requestSuccessWithRequest:request];
            }else{
                //请求失败的统一处理
                [weakSelf requestFaieldWithRequest:request];
            }
            ///移除任务
            [weakSelf removeOperation:task];
            ///清除block回调
            [request clearCompletionBlock];
        });
    });
}

///数据请求成功，设置数据，返回
- (void)requestSuccessWithRequest:(WLRequest *)request{
    ///成功的block回调
    if (request.successCompletionBlock) {
        request.successCompletionBlock(request);
    }
    
    if (request.delegate != nil) {
        /// 成功的代理
        [request.delegate requestFinished:request];
    }
}

/// 请求失败
- (void)requestFaieldWithRequest:(WLRequest *)request {
    /// 错误信息处理
    [request requestFailedFilter];
    //打印请求结果信息
    [WLLogger logDebugInfoWithResponse:request];
    if (request.failureCompletionBlock) {
        ///请求失败回调
        request.failureCompletionBlock(request);
    }
    
    if (request.delegate != nil) {
        ///代理回调
        [request.delegate requestFailed:request];
    }
}

///请求的任务的Hash key
- (NSString *)requestHashKey:(NSURLSessionTask *)task {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
    return key;
}

///把请求加入队列
- (void)addOperation:(WLRequest *)request {
    if (request.requestDataTask != nil) {
        NSString *key = [self requestHashKey:request.requestDataTask];
        @synchronized(self) {
            self.requestsRecord[key] = request;
        }
    }
}

///移除当前任务
- (void)removeOperation:(NSURLSessionTask *)task {
    NSString *key = [self requestHashKey:task];
    @synchronized(self) {
        [self.requestsRecord removeObjectForKey:key];
    }
    DLog(@"Request queue size = %lu", (unsigned long)[self.requestsRecord count]);
}

#pragma mark - Getter & Setter
/// 网络访问管理者
- (WLNetworkManager *)netWorkManager {
    if (_netWorkManager == nil) {
        _netWorkManager = [[WLNetworkManager alloc] init];
    }
    return _netWorkManager;
}

///请求的记录字典
- (NSMutableDictionary *)requestsRecord {
    if (_requestsRecord == nil) {
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    return _requestsRecord;
}

@end
