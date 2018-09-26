 //
//  WLRequest.m
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLRequest.h"
#import "WLRequestManager.h"

#import "AFgzipRequestSerializer.h"

@interface WLRequest ()

///子类信息
@property (nonatomic, weak) id<WLRequestAPIDelegate> childApi;
/// 管理类
@property (nonatomic, strong) WLNetwokingConfig *config;
/// 是否已经统一处理错误信息，默认为：NO，如果统一处理错误，外面就不要处理了
@property (nonatomic, assign) BOOL isIgnoreResponseError;

@property (nonatomic, strong, readwrite) AFHTTPRequestSerializer *requestSerializer;

/// 返回结果的Serializer类型，默认：AFHTTPResponseSerializer
@property (nonatomic, strong, readwrite) AFHTTPResponseSerializer *responseSerializer;

@end

@implementation WLRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_requestCriteria) {
            if ([self conformsToProtocol:@protocol(WLRequestAPIDelegate)]) {
                _childApi = (id<WLRequestAPIDelegate>)self;
            }else {
                NSAssert(NO, @"子类必须要实现APIRequest这个protocol");
            }
        }else{
            if (_requestCriteria.apiMethodName.length == 0) {
                NSAssert(NO, @"WLRequest对象中的WLRequestCriteria对象的apiMethodName不能为空");
            }
        }
        
        self.config = [WLNetwokingConfig sharedInstance];
    }
    return self;
}

/// 对象初始化
- (instancetype)initWithRequestCriteria:(WLRequestCriteria *)requestCriteria {
    NSMutableDictionary *paramsMutableDic = [NSMutableDictionary dictionaryWithDictionary:requestCriteria.requestParams];
//    [paramsMutableDic setObject:kDeviceUdid forKey:@"device_id"];
//    [paramsMutableDic setObject:kDeviceUdid forKey:@"deviceId"];
    requestCriteria.requestParams = paramsMutableDic;
    self.requestCriteria = requestCriteria;
    return [self init];
}

- (instancetype)initWithApiMethodName:(NSString *)apiName requestParams:(NSDictionary *)requestParams {
    WLRequestCriteria *criteria = [[WLRequestCriteria alloc] init];
    criteria.apiMethodName = apiName;
//    criteria.requestParams = requestParams;
    criteria.requestParams = requestParams;
    return [self initWithRequestCriteria:criteria];
}


#pragma mark - public Method
///添加self到请求队列中
- (void)start {
    [[WLRequestManager sharedInstance] addRequest:self];
}

///从请求队列中移除self
- (void)stop {
    //    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[WLRequestManager sharedInstance] cancelRequest:self completion:^{
        //        [self toggleAccessoriesDidStopCallBack];
    }];
}

/// block回调开始请求
- (void)startWithCompletionBlockWithSuccess:(WLRequestCompletionBlock)success
                                    failure:(WLRequestCompletionBlock)failure {
    [self startWithCompletionBlockWithSuccess:success failure:failure progress:nil];
}

- (void)startWithCompletionBlockWithSuccess:(WLRequestCompletionBlock)success
                                    failure:(WLRequestCompletionBlock)failure
                                   progress:(WLDownloadProgress)progress {
    
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    self.progress = progress;
    [self start];
}

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    self.progress = nil;
}

/// 请求失败的回调
- (void)requestFailedFilter {
    BOOL isProcess = NO;
    if (![self ignoreUnifiedErrorProcess]) {
        /// 接口访问成功，系统错误
        if (self.config.processRule && [self.config.processRule respondsToSelector:@selector(processResponseWithError:errorType:)]) {
            /// 把错误统一处理
            isProcess = [self.config.processRule processResponseWithError:_error errorType:self.errorType];
        }
    }
    self.isIgnoreResponseError = isProcess;
}

/// 返回的结果信息验证
//- (BOOL)responseInfoValidator {
//    BOOL success = YES;
//    if (self.config.processRule && [self.config.processRule respondsToSelector:@selector(processResponseValidator:)]) {
//        /// _responseJSONObject：是未格式化的原数据。  如果self.responseJSONObject:解析后的数据
//        success = [self.config.processRule processResponseValidator:_responseJSONObject];
//    }
//    return success;
//}

/// 返回的请求数据的加工数据
- (void)requestResponseJsonObjectFilter {
    id responseJSONObject = nil;
    // 统一加工response
    if (self.config.processRule && [self.config.processRule respondsToSelector:@selector(processResponseWithRequest:ignoreDecryptAES256:)]) {
        if (![self ignoreUnifiedResponseProcess]) {
            responseJSONObject = [self.config.processRule processResponseWithRequest:_responseJSONObject ignoreDecryptAES256:self.ignoreDecryptAES256Value];
            if ([self.childApi respondsToSelector:@selector(responseProcess:)]){
                responseJSONObject = [self.childApi responseProcess:responseJSONObject];
            }
            // 如果是错误类型，支持赋值给error
            if ([responseJSONObject isKindOfClass:[NSError class]]) {
                self.error = responseJSONObject;
            }
            self.responseJSONObject = responseJSONObject;
        }
    }
    
    if ([self.childApi respondsToSelector:@selector(responseProcess:)]){
        responseJSONObject = [self.childApi responseProcess:_responseJSONObject];
        // 如果是错误类型，支持赋值给error
        if ([responseJSONObject isKindOfClass:[NSError class]]) {
            self.error = responseJSONObject;
        }
        self.responseJSONObject = responseJSONObject;
    }
}

//是否忽略统一的参数加工,默认为NO
- (BOOL)ignoreUnifiedResponseProcess {
    if ([self.childApi respondsToSelector:@selector(ignoreUnifiedResponseProcess)]){
        return [self.childApi ignoreUnifiedResponseProcess];
    }else{
        if (_requestCriteria) {
            return _requestCriteria.ignoreUnifiedResponseProcess;
        }
        //是否忽略统一的参数加工,默认为NO
        return NO;
    }
}

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - getter & setter
- (NSInteger)responseStatusCode {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)self.requestDataTask.response;
    return httpResponse.statusCode;
}

- (NSDictionary *)responseHeaders {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)self.requestDataTask.response;
    return httpResponse.allHeaderFields;
}

///是否有网络连接
- (BOOL)isReachable {
    BOOL isReachability = [WLNetwokingConfig sharedInstance].isReachable;
    if (!isReachability) {
        return NO;
        //        self.errorType = CTAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

///请求的方法名
- (NSString *)apiMethodName {
    if ([self.childApi respondsToSelector:@selector(apiMethodName)]) {
        return [self.childApi apiMethodName];
    }else{
        if (self.requestCriteria) {
           return self.requestCriteria.apiMethodName;
        }
        return @"";
    }
}

/// 文件下载到的文件夹名称
- (NSString *)downfileFolderName {
    if ([self.childApi respondsToSelector:@selector(fileFolderName)]) {
        return [self.childApi fileFolderName];
    }else{
        if (_requestCriteria) {
            return _requestCriteria.fileFolderName;
        }
        //默认的文件下载目录
        return @"/LocalFile/";
    }
}

// 上传的图片
- (UIImage *)updateImage {
    if (_requestCriteria) {
        return _requestCriteria.updateImage;
    }
    return nil;
}

/// 请求的参数内容
- (NSDictionary *)requestParamInfos {
    if ([self.childApi respondsToSelector:@selector(requestParams)]) {
        return [self.childApi requestParams];
    }else{
        if (_requestCriteria) {
            return _requestCriteria.requestParams;
        }
        //默认为nil
        return nil;
    }
}

- (AFHTTPRequestSerializer *)requestSerializer {
    if (!_requestSerializer) {
        if ([self.childApi respondsToSelector:@selector(requestSerializerType)]) {
            if ([self.childApi requestSerializerType] == WLRequestSerializerTypeHTTP) {
                _requestSerializer = [AFHTTPRequestSerializer serializer];
            }else{
                _requestSerializer = [AFJSONRequestSerializer serializer];
            }
        }else {
            if (_requestCriteria.requestSerializerType == WLRequestSerializerTypeHTTP) {
                _requestSerializer = [AFHTTPRequestSerializer serializer];
            }else if(_requestCriteria.requestSerializerType == WLRequestSerializerTypeJSON){
                _requestSerializer = [AFJSONRequestSerializer serializer];
            }else{
                _requestSerializer = [AFgzipRequestSerializer serializerWithSerializer:[AFJSONRequestSerializer serializer]];
            }
        }
        if (!self.requestCriteria.ignoreHttpHeader) {
            if (self.config.processRule && [self.config.processRule respondsToSelector:@selector(httpHeaderInfos)]) {
                NSDictionary *httpHeaderDic = self.config.processRule.httpHeaderInfos;
                for (NSString *key in httpHeaderDic.allKeys) {
                    [_requestSerializer setValue:httpHeaderDic[key] forHTTPHeaderField:key];
                }
            }
        }
    }
    return _requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        if ([self.childApi respondsToSelector:@selector(reponseSerializerType)]) {
            if ([self.childApi reponseSerializerType] == WLResponseSerializerTypeHTTP) {
                _responseSerializer = [AFHTTPResponseSerializer serializer];
            }else {
                AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
                ///当数据返回 null 时是否删除这个字段的值，也就是为 nil，默认YES，
                jsonSerializer.removesKeysWithNullValues = YES;
                if ([self.childApi respondsToSelector:@selector(removesKeysWithNullValues)]) {
                    jsonSerializer.removesKeysWithNullValues = [self.childApi removesKeysWithNullValues];
                }
                _responseSerializer = jsonSerializer;
            }
        }else {
            if (_requestCriteria.reponseSerializerType == WLResponseSerializerTypeJSON) {
                AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
                ///当数据返回 null 时是否删除这个字段的值，也就是为 nil，默认YES，
                jsonSerializer.removesKeysWithNullValues = _requestCriteria.removesKeysWithNullValues;
                _responseSerializer = jsonSerializer;
            }
            _responseSerializer = [AFHTTPResponseSerializer serializer];
        }
    }
    return _responseSerializer;
}

///接口请求的超时时间，默认：60秒
- (NSTimeInterval)timeOutInterval {
    if ([self.childApi respondsToSelector:@selector(requestTimeoutInterval)]) {
        return [self.childApi requestTimeoutInterval];
    }else{
        if (_requestCriteria) {
            return _requestCriteria.requestTimeoutInterval;
        }
        return kWLNetworkingTimeoutSeconds;
    }
}

/// 是否忽略统一的参数加工,默认为NO
- (BOOL)ignoreUnifiedResponse {
    if ([self.childApi respondsToSelector:@selector(ignoreUnifiedResponseProcess)]) {
        return [self.childApi ignoreUnifiedResponseProcess];
    }else {
        if (_requestCriteria) {
            return _requestCriteria.ignoreUnifiedResponseProcess;
        }
        //默认统一加工，NO
        return NO;
    }
}

/// 是否忽略统一的返回错误处理，默认为NO
- (BOOL)ignoreUnifiedErrorProcess {
    if ([self.childApi respondsToSelector:@selector(ignoreUnifiedErrorProcess)]) {
        return [self.childApi ignoreUnifiedErrorProcess];
    }else {
        if (_requestCriteria) {
            return _requestCriteria.ignoreUnifiedErrorProcess;
        }
        //默认统一加工，NO
        return NO;
    }
}

- (BOOL)ignoreDecryptAES256Value {
    if ([self.childApi respondsToSelector:@selector(ignoreDecryptAES256Value)]) {
        return [self.childApi ignoreDecryptAES256Value];
    }else {
        if (_requestCriteria) {
            return _requestCriteria.ignoreDecryptAES256Value;
        }
        return NO;
    }
}

// 接口的请求方式，默认为WLRequestMethodTypePost
- (WLRequestMethodType)requestMethodType {
    if ([self.childApi respondsToSelector:@selector(requestMethodType)]) {
        return [self.childApi requestMethodType];
    }else {
        if (_requestCriteria) {
            return _requestCriteria.requestMethodType;
        }
        //默认
        return WLRequestMethodTypePost;
    }
}

// 请求的覆盖方式
- (WLRequestCoverType)requestCoverTypeInfo {
    if ([self.childApi respondsToSelector:@selector(requestCoverType)]) {
        return [self.childApi requestCoverType];
    }else {
        if (_requestCriteria) {
            return _requestCriteria.requestCoverType;
        }
        //默认服务器
        return WLRequestCoverTypeNormal;
    }
}


@end
