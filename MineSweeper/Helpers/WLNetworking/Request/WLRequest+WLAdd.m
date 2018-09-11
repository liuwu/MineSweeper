//
//  WLRequest+WLAdd.m
//  Welian_MVP
//
//  Created by weLian on 16/7/2.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLRequest+WLAdd.h"
#import "WLNetworkingCacheTool.h"
#import "WLNetworkPrivate.h"

@implementation WLRequest (WLAdd)

/// 是否需要缓存默认为NO
- (BOOL)isNeedCache {
    if ([self.childApi respondsToSelector:@selector(shouldCache)]) {
        return [self.childApi shouldCache];
    }else{
        if (self.requestCriteria) {
            return self.requestCriteria.shouldCache;
        }
        return NO;
    }
}

/// 判断是否有缓存
- (BOOL)hasCached {
    return [[WLNetworkingCacheTool sharedInstance] containsObjectForKey:[self cacheFileKey]];
}

/// 返回当前缓存的对象
- (id)cacheObject {
    return [[WLNetworkingCacheTool sharedInstance] objectForKey:[self cacheFileKey]];
}

/// 缓存的时间是否有效
- (BOOL)isCacheTimeValidator {
    if (self.cacheTimeAgo > self.cacheTime) {
        return NO;
    }
    return YES;
}

/// 缓存有效时间，如果过期，需要重新请求更新缓存
- (NSInteger)cacheTime {
    if ([self.childApi respondsToSelector:@selector(cacheTimeInSeconds)]) {
        return [self.childApi cacheTimeInSeconds];
    }else{
        return -1;
    }
}

/// 请求的url地址的hash值
- (NSUInteger)urlStringHash {
    return [[self urlString] hash];
}

/// 参数请求的hash地址
- (NSUInteger)paramsStringHash {
    return [[self.requestParamInfos modelToJSONString] hash];
}

/// 接口访问的url地址
- (NSString *)urlString {
    return [self buildRequestUrl];
}

/// 手动将请求的数据写入该请求的缓存
- (void)saveDataInfoToCache:(id)jsonResponse {
    if (self.isNeedCache) {
        //需要缓存
        [[WLNetworkingCacheTool sharedInstance] saveObject:jsonResponse forKey:[self cacheFileKey]];
        
        //缓存当前的时间
        [self saveCacheTimeForData];
    }
}

#pragma mark - Private
/// 构建请求的链接地址
- (NSString *)buildRequestUrl {
    ///请求的方法名
    NSString *methodName = self.apiMethodName;
    if (methodName.length == 0) {
        return @"";
    }
    
    ///如果单个接口的请求地址包含http，则识别为全部的请求地址,如图片、pdf下载文件路径
    //NSString *detailUrl = methodName;//[self.childApi apiMethodName];
    if ([methodName hasPrefix:@"http"]) {
        return methodName;
    }
    
    //获取服务器信息
    NSString *baseUrl = [WLServiceInfo sharedServiceInfo].serviceBaseUrl;
    NSString *url = [baseUrl stringByAppendingPathComponent:methodName];
    ///全局请求参数
    NSDictionary *urlArgDic = [WLNetwokingConfig sharedInstance].urlArguments;
    if ([urlArgDic.allValues count] > 0) {
        url = [WLNetworkPrivate urlStringWithOriginUrlString:url appendParameters:urlArgDic];
    }
    return url;
}

/// 返回当前缓存的时间对象
- (NSDate *)localCacheTime {
    return [[WLNetworkingCacheTool sharedInstance] objectForKey:[self cacheTimeKey]];
}

/// 缓存过去的时间
- (NSInteger)cacheTimeAgo {
    NSDate *time = [self localCacheTime];
    int seconds = -[time timeIntervalSinceNow];
    return seconds;
}

/// 缓存当前缓存的时间
- (void)saveCacheTimeForData {
    if (self.isNeedCache) {
        //需要缓存
        [[WLNetworkingCacheTool sharedInstance] saveObject:[NSDate date] forKey:[self cacheTimeKey]];
    }
}

/// 缓存的键
- (NSString *)cacheFileKey {
    ///请求的url地址
    NSString *requestUrl = [self buildRequestUrl];
    /// 请求的参数内容
    NSString *requestParams = [self.requestParamInfos jsonPrettyStringEncoded];
    /// 请求的版本
    NSString *appVersion = [WLNetwokingConfig sharedInstance].appVersion;
    NSString *requestInfo = [NSString stringWithFormat:@"Url:%@ Params:%@ AppVersion%@", requestUrl, requestParams, appVersion];
    /// 请求的缓存key
    NSString *cacheKey = [WLNetworkPrivate md5StringFromString:requestInfo];
    return cacheKey;
}

/// 当前缓存数据的时间key
- (NSString *)cacheTimeKey {
    return [NSString stringWithFormat:@"%@_Time",[self cacheFileKey]];
}

@end
