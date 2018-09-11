//
//  WLRequest+WLAdd.h
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLRequest.h"

/**
 *  @author liuwu     , 16-07-02
 *
 *  WLRequest的扩展类，添加缓存cache
 */
@interface WLRequest (WLAdd)

/// 是否需要缓存
@property (nonatomic, assign, readonly) BOOL isNeedCache;
/// 判断是否有缓存
@property (nonatomic, assign, readonly) BOOL hasCached;
/// 返回当前缓存的对象
@property (nonatomic, strong, readonly) id cacheObject;
/// 缓存的时间是否有效
@property (nonatomic, assign, readonly) BOOL isCacheTimeValidator;
/// 缓存有效时间，如果过期，需要重新请求更新缓存
@property (nonatomic, assign, readonly) NSInteger cacheTime;
/// 接口访问的url地址
@property (nonatomic, copy, readonly) NSString *urlString;


/// 请求的url地址的hash值
- (NSUInteger)urlStringHash;
/// 参数请求的hash地址
- (NSUInteger)paramsStringHash;

/// 手动将请求的数据写入该请求的缓存
- (void)saveDataInfoToCache:(id)jsonResponse;

@end
