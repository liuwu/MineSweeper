//
//  WLNetworkingCacheTool.h
//  Welian_Network_Demo
//
//  Created by weLian on 16/7/4.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author liuwu     , 16-06-30
 *
 *  缓存的相关操作
 */
@interface WLNetworkingCacheTool : NSObject

/// 实例化
+ (instancetype)sharedInstance;

/// 判断是否缓存了指定key的数据
- (BOOL)containsObjectForKey:(NSString *)key;

/// 缓存数据
- (void)saveObject:(id)object forKey:(NSString *)key;

/// 通过key读取缓存
- (id)objectForKey:(NSString *)key;

/// 删--删除缓存
- (void)removeObjectForKey:(NSString *)key;

/// 清空所有缓存
- (void)removeAllCaches;

@end
