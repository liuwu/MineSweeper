//
//  WLRequestCriteria.h
//  Welian
//
//  Created by weLian on 16/9/12.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络请求的方式
typedef NS_ENUM (NSUInteger, WLRequestMethodType){
    /// get请求
    WLRequestMethodTypeGet = 0,
    ///post请求
    WLRequestMethodTypePost,
    ///下载（图片、pdf、文件等）
    WLRequestMethodTypeDown,
    ///上传（图片）
    WLRequestMethodTypeUpdateImage,
    /// PUT请求
    WLRequestMethodTypePUT,
    ///delete
    WLRequestMethodTypeDelete,
    ///Patch
    WLRequestMethodTypePatch,
};

/// Request请求的SerializerType
typedef NS_ENUM(NSInteger , WLRequestSerializerType) {
    WLRequestSerializerTypeHTTP = 0,
    WLRequestSerializerTypeJSON,
    WLRequestSerializerTypeGZIP,
};

/// 请求返回的Response的SerializerType
typedef NS_ENUM(NSInteger , WLResponseSerializerType) {
    WLResponseSerializerTypeHTTP = 0,
    WLResponseSerializerTypeJSON,
};

/// 请求的统一接口。重复请求处理类型
typedef NS_ENUM(NSUInteger, WLRequestCoverType) {
    WLRequestCoverTypeNormal = 0,// 默认，不做处理，允许重复请求
    WLRequestCoverTypeBefore,// 用来在搜索等接口，根据接口名移除前面的请求
    WLRequestCoverTypeAfter,// 移除新的请求，防止统一参数的接口请求重复访问
};

/*
 接口请求条件对象
 */
@interface WLRequestCriteria : NSObject

/// 接口地址，每个接口都有自己的接口地址。 如果地址包含http，则代表完整的地址，如：图片、文件下载url地址
@property (nonatomic, copy) NSString *apiMethodName;

/// 接口请求的参数内容,默认为nil.
@property (nonatomic, copy) NSDictionary *requestParams;

/// 文件下载到本地的文件夹名称，当apiMethodName返回的内容包含http时使用。默认目录：@"/LocalFile/"
@property (nonatomic, copy) NSString *fileFolderName;

/// 上传的图片
@property (nonatomic, strong) UIImage *updateImage;

/// 是否需要缓存，默认： NO
@property (nonatomic, assign) BOOL shouldCache;

/// 当shouldCache为YES的时候有效。 缓存有效时间，如果过期，需要重新请求更新缓存。默认-1:需要更新缓存
@property (nonatomic, assign) NSInteger cacheTimeInSeconds;

/// 请求的连接超时时间，默认为60秒
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/// 是否忽略统一的参数加工,默认为NO
@property (nonatomic, assign) BOOL ignoreUnifiedResponseProcess;

/// 是否忽略统一的错误结果加工,默认为NO
@property (nonatomic, assign) BOOL ignoreUnifiedErrorProcess;

/// 请求方式，包括Get、Post、Head、Put、Delete、Patch，具体查看 WLRequestMethodType,默认是：Post请求
@property (nonatomic, assign) WLRequestMethodType requestMethodType;

/// Request请求的SerializerType，默认以：json格式传参
@property (nonatomic, assign) WLRequestSerializerType requestSerializerType;

/// 请求结果返回的Response的SerializerType,默认以http方式收取数据
@property (nonatomic, assign) WLResponseSerializerType reponseSerializerType;

/// 当请求的返回使用的是JsonSerializer，设置才有效.当数据返回 null 时是否删除这个字段的值，也就是为 nil，默认YES，
@property (nonatomic, assign) BOOL removesKeysWithNullValues;
/// 请求的覆盖类型，默认允许接口重复请求
@property (nonatomic, assign) WLRequestCoverType requestCoverType;
/**
 是否忽略返回数据AES256解密
 
 @return YES则不解密处理
 */
@property (nonatomic, assign) BOOL ignoreDecryptAES256Value;

@property (nonatomic, assign) BOOL ignoreHttpHeader;

@property (nonatomic, strong) NSDictionary *httpHeader;

@end
