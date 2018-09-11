//
//  WLPersistanceTable+WLUpdate.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable.h"

@interface WLPersistanceTable (WLUpdate)

/**
 更新一条记录
 */
- (BOOL)updateRecord:(NSObject <WLPersistanceRecordProtocol> *)record;

/**
 更新一组记录
 */
- (void)updateRecordList:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList;

/*
 更新数据
 */
- (BOOL)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams;

- (BOOL)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue;

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue;

/// 更新不在当前数组中的数据
- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey notInList:(NSArray *)keyList;

- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey inList:(NSArray *)keyList;

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList;

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList;

@end
