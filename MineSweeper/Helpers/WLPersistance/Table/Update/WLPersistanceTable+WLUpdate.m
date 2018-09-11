//
//  WLPersistanceTable+WLUpdate.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable+WLUpdate.h"

#import "WLPersistanceRecord.h"
#import "WLPersistanceQueryCommand+WLDataManipulations.h"

@implementation WLPersistanceTable (WLUpdate)

/**
 更新一条记录
 */
- (BOOL)updateRecord:(NSObject <WLPersistanceRecordProtocol> *)record {
    return [self updateKeyValueList:[record dictionaryRepresentationWithTable:self.child] primaryKeyValue:[record valueForKey:[self.child primaryKeyName]]];
}

/**
 更新一组记录
 */
- (void)updateRecordList:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList {
    [recordList enumerateObjectsUsingBlock:^(NSObject <WLPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        [self updateRecord:record];
    }];
}

// 更新数据
- (BOOL)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams {
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    // 把数据解析成sql字符串
    [queryCommand updateTable:[self.child tableName] withData:keyValueList condition:whereCondition conditionParams:whereConditionParams];
    
    return [queryCommand.helper updateToDB:self QueryCommand:queryCommand];
}

- (BOOL)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue {
    NSString *whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
    return [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams];
}


- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue {
    if (key && value && primaryKeyValue) {
        NSString *whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams];
    }
}

/// 更新不在当前数组中的数据
- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey notInList:(NSArray *)keyList {
    if (key && value && wherekey && keyList.count > 0) {
        NSArray *keyListString = keyList;//[keyList componentsJoinedByString:@","];
        NSString *whereCondition = [NSString stringWithFormat:@"%@ NOT IN :keyListString", wherekey];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(keyListString);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey inList:(NSArray *)keyList {
    if (key && value && wherekey && keyList.count > 0) {
//        NSString *keyListString = [keyList componentsJoinedByString:@","];
        NSArray *keyListString = keyList;
        NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:keyListString)", wherekey];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(keyListString);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList {
    if (key && value) {
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList {
    NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
    NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
    [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams];
}

@end
