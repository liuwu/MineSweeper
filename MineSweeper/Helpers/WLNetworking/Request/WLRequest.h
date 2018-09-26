//
//  WLRequest.h
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLNetworkingConfiguration.h"
#import "WLRequestCriteria.h"

/// 接口返回状态类型
typedef NS_ENUM(NSUInteger, WLNetWorkingResultStateType) {
    /// --------- 普通的接口信息错误 ----------
    WLNetWorkingResultStateTypeSuccess = 1,           /// 接口调用成功
    WLNetWorkingResultStateTypeError = 0,           /// 接口调用失败
    WLNetWorkingResultStateTypeNormal = 1001,            /// 系统普通的错误，不做任何处理的
    WLNetWorkingResultStateTypeNoLogin = 1010,           /// 用户未登录，session过期
    WLNetWorkingResultStateTypeHub = 1101,               /// 需要hub提醒的，最常用的错误提醒
    WLNetWorkingResultStateTypeAlert = 1102,             /// 普通alert提醒的
    
    /// ------- 服务器内部错误 ------------
    WLNetWorkingResultStateTypeService = 2000,           /// 服务器错误，只打印
    
    /// ------- 程序系统级别的错误 ----------
    WLNetWorkingResultStateTypeSystem = 3000,            /// 系统级错误
    WLNetWorkingResultStateTypeSystemLogout = 3101,      /// 退出登录
    WLNetWorkingResultStateTypeSystemAlertAndJump = 3102,      /// 需要alert提醒，并且点击后需要跳转指定页面的
    WLNetWorkingResultStateTypeSystemAlertCancelOrJump = 3103, /// 需要alert提醒，有取消、确定按钮，点击“确定”后需要跳转指定APP内页面的
};

///网络请求的方式
typedef NS_ENUM (NSUInteger, WLErrorType){
    WLErrorTypeSuccess = 0,     //API请求成功且返回数据正确，此时的数据是可以直接拿来用的
    WLErrorTypeNoContent,       //API请求成功但返回的数据不正确。
    WLErrorTypeFailed,          ///网络请求失败，接口级别错误
    WLErrorTypeTimeOut,         ///网络请求失败，接口请求超时
    WLErrorTypeNoNetWork,       //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

@class WLRequest;
typedef void(^WLRequestCompletionBlock)(WLRequest *request);

/*------------- API 请求需要实现的 -------------------------------*/
@protocol WLRequestAPIDelegate <NSObject>

@required

/**
 *  接口地址，每个接口都有自己的接口地址。 如果地址包含http，则代表完整的地址，如：图片、文件下载url地址
 *
 *  @return 接口地址
 */
- (NSString *)apiMethodName;

@optional

/**
 *  @author liuwu     , 16-07-06
 *
 *  接口请求的参数内容,默认为nil.
 *  @return 参数内容
 */
- (NSDictionary *)requestParams;

/**
 *  请求方式，包括Get、Post、Head、Put、Delete、Patch，具体查看 WLRequestMethodType,默认是：Post请求
 *
 *  @return 请求方式
 */
- (WLRequestMethodType)requestMethodType;

/**
 *  @author liuwu     , 16-07-06
 *
 *  Request请求的SerializerType，默认以：json格式传参
 *  @return http 或者 Json请求
 */
- (WLRequestSerializerType)requestSerializerType;

/**
 *  @author liuwu     , 16-07-06
 *
 *  请求结果返回的Response的SerializerType,默认以http方式收取数据
 *  @return http 或者 Json请求
 */
- (WLResponseSerializerType)reponseSerializerType;

/**
 *  @author liuwu     , 16-08-31
 *
 *  请求的覆盖类型，默认运行接口允许请求
 */
- (WLRequestCoverType)requestCoverType;

/**
 *  @author liuwu     , 16-07-06
 *
 *  文件下载到本地的文件夹名称，当apiMethodName返回的内容包含http时使用。默认目录：@"/LocalFile/"
 *  @return 下载的文件夹名称
 */
- (NSString *)fileFolderName;

/**
 *  @author liuwu     , 16-07-06
 *
 *  是否需要缓存，默认： NO
 *  @return YES OR NO
 */
- (BOOL)shouldCache;

/**
 *  @author liuwu     , 16-07-06
 *
 *  当shouldCache为YES的时候有效。 缓存有效时间，如果过期，需要重新请求更新缓存。默认-1:需要更新缓存
 *  @return 缓存的有效时间
 */
- (NSInteger)cacheTimeInSeconds;

/**
 *  @author liuwu     , 16-07-06
 *
 *  请求的连接超时时间，默认为60秒
 *  @return 网络请求超时的秒数
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 *  处理responseJSONObject，当外部访问 self.responseJSONObject 的时候就会返回这个方法处理后的数据
 *
 *  @param responseObject 输入的 responseObject ，在方法内切勿使用 self.responseJSONObject
 *
 *  @return 处理后的responseJSONObject
 */
- (id)responseProcess:(id)responseObject;

/**
 *  是否忽略统一的参数加工,默认为NO
 *
 *  @return 返回 YES，那么 self.responseJSONObject 将返回原始的数据
 */
- (BOOL)ignoreUnifiedResponseProcess;

/**
 *  是否忽略统一的错误加工,默认为NO
 *
 *  @return 返回 YES，那么将不进行统一的错误处理
 */
- (BOOL)ignoreUnifiedErrorProcess;

/**
 *  当数据返回 null 时是否删除这个字段的值，也就是为 nil，默认YES，具体查看http://honglu.me/2015/04/11/json%E4%B8%AD%E5%A4%B4%E7%96%BC%E7%9A%84null/
 *  当请求的返回使用的是JsonSerializer，设置才有效
 *  @return YES/NO
 */
- (BOOL)removesKeysWithNullValues;

/**
 是否忽略返回数据AES256解密

 @return YES则不解密处理
 */
- (BOOL)ignoreDecryptAES256Value;

@end

///-------- Request请求代理 ------------------
@protocol WLRequestDelegate <NSObject>
@optional
/// 请求成功
- (void)requestFinished:(WLRequest *)request;
/// 请求失败
- (void)requestFailed:(WLRequest *)request;
/// 清除请求
- (void)clearRequest;

@end

/**
 *  @author liuwu     , 16-07-02
 *
 *  一个请求的内容定义
 */
@interface WLRequest : NSObject

/// -------------- 请求的结果数据信息 --------------------
/// 请求返回的数据
@property (nonatomic, strong) id responseJSONObject;
/// 请求返回的数据
@property (nonatomic, strong) NSError *error;
/// 是否已经统一处理错误信息，默认为：NO，如果统一处理错误，外面就不要处理了
@property (nonatomic, assign, readonly) BOOL isIgnoreResponseError;
/// 网络请求返回的状态码
@property (nonatomic, readonly) NSInteger responseStatusCode;
/// 请求结果的Headers
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
/// 当前请求对应的任务
@property (nonatomic, strong) NSURLSessionTask *requestDataTask;
/// 错误原因
@property (nonatomic, assign) WLErrorType errorType;

/// ------------- 请求的参数内容信息 ---------------------------
/// 请求的参数对象
@property (nonatomic, strong) WLRequestCriteria *requestCriteria;
/// 请求的Delegate对象
@property (nonatomic, weak) id<WLRequestDelegate> delegate;
/// 子类信息
@property (nonatomic, weak, readonly) id<WLRequestAPIDelegate> childApi;
/// 网络状态是否可用
@property (nonatomic, assign, readonly) BOOL isReachable;
/// 请求成功的回调
@property (nonatomic, copy) WLRequestCompletionBlock successCompletionBlock;
/// 请求失败的回调
@property (nonatomic, copy) WLRequestCompletionBlock failureCompletionBlock;

@property (nonatomic, copy) WLDownloadProgress progress;

/// -------------- 请求相关的配置信息 --------------------------
/// 请求的Serializer类型，默认：AFJSONRequestSerializer
@property (nonatomic, strong, readonly) AFHTTPRequestSerializer *requestSerializer;
/// 返回结果的Serializer类型，默认：AFHTTPResponseSerializer
@property (nonatomic, strong, readonly) AFHTTPResponseSerializer *responseSerializer;
/// 请求的接口名字
@property (nonatomic, copy, readonly) NSString *apiMethodName;
/// 文件下载目录
@property (nonatomic, copy, readonly) NSString *downfileFolderName;
/// 文件下载目录
@property (nonatomic, strong, readonly) UIImage *updateImage;
/// 请求的参数内容
@property (nonatomic, strong, readonly) NSDictionary *requestParamInfos;
/// 接口请求的超时时间，默认：60秒
@property (nonatomic, assign, readonly) NSTimeInterval timeOutInterval;
/// 是否忽略统一的参数加工,默认为NO
@property (nonatomic, assign, readonly) BOOL ignoreUnifiedResponse;
/// 是否忽略统一的参数加工,默认为NO
@property (nonatomic, assign, readonly) BOOL ignoreUnifiedErrorProcess;
/// 网络请求的方式
@property (nonatomic, assign, readonly) WLRequestMethodType requestMethodType;

/**
 是否忽略返回数据AES256解密
 
 @return YES则不解密处理
 */
@property (nonatomic, assign, readonly) BOOL ignoreDecryptAES256Value;

/// 对象初始化
- (instancetype)initWithRequestCriteria:(WLRequestCriteria *)requestCriteria;

- (instancetype)initWithApiMethodName:(NSString *)apiName requestParams:(NSDictionary *)requestParams;

/// 添加self到请求队列中
- (void)start;

/// 从请求队列中移除self
- (void)stop;

/// block回调开始请求
- (void)startWithCompletionBlockWithSuccess:(WLRequestCompletionBlock)success
                                    failure:(WLRequestCompletionBlock)failure;

- (void)startWithCompletionBlockWithSuccess:(WLRequestCompletionBlock)success
                                    failure:(WLRequestCompletionBlock)failure
                                   progress:(WLDownloadProgress)progress;

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

/// 请求失败的回调
- (void)requestFailedFilter;
/// 返回的请求数据的加工数据
- (void)requestResponseJsonObjectFilter;

// 请求的覆盖方式
- (WLRequestCoverType)requestCoverTypeInfo;

@end
