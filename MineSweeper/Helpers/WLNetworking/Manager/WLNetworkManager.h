//
//  WLNetworkManager.h
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/5.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络请求的方式
typedef NS_ENUM (NSUInteger, WLHttpRequestType){
    /// get请求
    WLHttpRequestTypeTypeGet = 0,
    ///post请求
    WLHttpRequestTypePost,
    ///PUT请求
    WLHttpRequestTypePUT,
    ///Delete
    WLHttpRequestTypeDelete,
    ///Patch
    WLHttpRequestTypePatch
};

/*! 定义请求成功的block */
typedef void( ^ WLResponseSuccess)(NSURLSessionTask *task, id response);
/*! 定义请求失败的block */
typedef void( ^ WLResponseFailed)(NSURLSessionTask *task, NSError *error);

/**
 *  Http网络请求的基础封装
 */
@interface WLNetworkManager : NSObject

/// 请求的Serializer类型，默认：AFJSONRequestSerializer
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
/// 返回结果的Serializer类型，默认：AFHTTPResponseSerializer
@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;
/// 接口请求的超时时间，默认：60秒
@property (nonatomic, assign) NSTimeInterval timeOutInterval;

/*!
 *  网络请求方法,block回调
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
- (NSURLSessionTask *)wl_requestWithType:(WLHttpRequestType)type
                               UrlString:(NSString *)urlString
                              Parameters:(NSDictionary *)parameters
                            SuccessBlock:(WLResponseSuccess)successBlock
                            FailureBlock:(WLResponseFailed)failureBlock;



/*!
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */
- (NSURLSessionTask *)wl_downLoadFileWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                          SavaPath:(NSString *)savePath
                                      SuccessBlock:(WLResponseSuccess)successBlock
                                      FailureBlock:(WLResponseFailed)failureBlock
                                  DownLoadProgress:(WLDownloadProgress)progress;



@end
