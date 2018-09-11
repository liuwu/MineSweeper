//
//  WLNetworkingCacheTool.m
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/4.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "WLNetworkingCacheTool.h"
//#import "YYCache.h"
#import "WLNetworkingConfiguration.h"

@interface WLNetworkingCacheTool ()

@property (nonatomic, strong) YYCache *cache;

@end

@implementation WLNetworkingCacheTool

#pragma mark - life cycle
/// 实例化
+ (instancetype)sharedInstance {
    static WLNetworkingCacheTool *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WLNetworkingCacheTool alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //设置全局的缓存的失效时间30秒
        self.cache.memoryCache.ageLimit = kWLCacheOutdateTimeSeconds;
        self.cache.diskCache.ageLimit = kWLCacheOutdateTimeSeconds;
    }
    return self;
}

#pragma mark - Public
/// 判断是否缓存了指定key的数据
- (BOOL)containsObjectForKey:(NSString *)key {
    return [self.cache containsObjectForKey:key];
}

/// 缓存数据
- (void)saveObject:(id)object forKey:(NSString *)key {
    ///缓存数据，同时进行内存缓存与文件缓存
    [self.cache setObject:object forKey:key];
    //// 如果只想内存缓存，可以直接调用`memoryCache`对象
    //    [self.cache.memoryCache setObject:object forKey:key];
}

/// 通过key读取缓存
- (id)objectForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

/// 删--删除缓存
- (void)removeObjectForKey:(NSString *)key {
    [self.cache removeObjectForKey:key];
}

/// 删--删除缓存
- (void)removeAllCaches {
    [self.cache removeAllObjects];
}


#pragma mark - getter & setter
- (YYCache *)cache {
    if (_cache == nil) {
        _cache = [YYCache cacheWithName:@"WLNetworkingDb"];
    }
    return _cache;
}

@end
