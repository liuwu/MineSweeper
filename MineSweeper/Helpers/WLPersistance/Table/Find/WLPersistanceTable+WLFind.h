//
//  WLPersistanceTable+WLFind.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable.h"

@class WLPersistanceRecord,WLPersistanceCriteria;

/*
 数据库表查询数据的扩展类
 */
@interface WLPersistanceTable (WLFind)

/**
 *  查询最后一条记录
 */
- (NSObject <WLPersistanceRecordProtocol> *)findLatestRecord;

/*
 查询当前表的所有记录
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllRecords;

/**
 查询条件定义方式如下：
 // 条件
 NSString *whereCondition = @"hello = :something";
 // 条件对应数据
 NSDictionary *conditionParams = @{@"something":@"world"};
 
 *  查询所有满足where条件的记录.
 *
 *  @param condition       where条件
 *  @param conditionParams 绑定where条件的参数
 *  @param isDistinct      if YES, 将使用 'SELECT DISTINCT' 从句.  DISTINCT 关键字与 SELECT 语句一起使用，来消除所有重复的记录，并只获取唯一一次记录。
 *
 *  @return 记录数组.
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct;

/// 查询所有满足where条件的记录，按照指定的属性排序
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct orderby:(NSString *)orderBy isDESC:(BOOL)isDESC;

/**
 *  获取通过Sql字符串查询的所有记录. sqlString can be bind with params like where condition.
 @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams for how to use where condition.
 *
 *  @param sqlString the sqlString for finding all records
 *  @param params    the params to be bind into sqlString
 *  @param error     error if fails
 *
 *  @return 记录数组
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params;

/**
 *  获取通过criteria查询的所有记录.
 *
 *  @param criteria criteria to find records
 *  @param error    error if fails
 *
 *  @return 记录数组
 *
 *  @see CTPersistanceCriteria
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithCriteria:(WLPersistanceCriteria *)criteria;

/**
 查询条件定义方式如下：
 // 条件
 NSString *whereCondition = @"hello = :something";
 // 条件对应数据
 NSDictionary *conditionParams = @{@"something":@"world"};
 
 *  获取指定条件查询的数组中的第一条记录。
 *
 *  @param condition       condition used in WHERE clause
 *  @param conditionParams params to bind into whereCondition
 *  @param isDistinct      if YES, will use 'SELECT DISTINCT' clause
 *  @param error           error if fails
 *
 *  @return 第一条记录
 */
- (NSObject <WLPersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct;

/**
 *  获取通过sql字符串查询的第一条记录.
 sqlString can be bind with params like where condition.
 @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams : for how to use where condition.
 *
 *  First row means the first record of fetched record list, not the first record in table.
 *
 *  @param sqlString the sqlString to find
 *  @param params    the params to bind into sqlString
 *  @param error     error if fails
 *
 *  @return 第一条记录.
 */
- (NSObject <WLPersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params;

/**
 *  find first row with criteria.
 *
 *  @param criteria criteria to find records
 *  @param error    error if fails
 *
 *  @return return the first row
 *  @see CTPersistanceCriteria
 */
- (NSObject <WLPersistanceRecordProtocol> *)findFirstRowWithCriteria:(WLPersistanceCriteria *)criteria;

/**
 *  return total record count in this table
 *
 *  @return return total record count in this table
 */
- (NSNumber *)countTotalRecord;

/**
 // 条件
 NSString *whereCondition = @"hello = :something";
 // 条件对应数据
 NSDictionary *conditionParams = @{@"something":@"world"};
 
 *  record count of record list with matches where condition.
 *
 *  @param whereCondition  condition used in WHERE clause
 *  @param conditionParams params ro bind into whereCondition
 *  @param error           error if fails
 *
 *  @return return record count of record list with matches where condition.
 */
- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams;

/**
 *  return count of record list by SQL. sqlString can be bind with params like where condition. @see deleteWithWhereCondition:conditionParams:error: for how to use where condition.
 *
 *  @param sqlString the sqlString to count
 *  @param params    the params to bind into sqlString
 *  @param error     error if fails
 *
 *  @return return a dictionary which contains count column.
 */
- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params;

/**
 *  find a record with primary key.
 *
 *  @param primaryKeyValue the primary key of the record you want to find
 *  @param error           error if fails
 *
 *  @return return a record
 */
- (NSObject <WLPersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue;

/**
 *  find all records by primary key list
 *
 *  @param primaryKeyValueList list of primary keys to find
 *  @param error               error if fails
 *
 *  @return return a list of record
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList;

/**
 *  find all keyname's value equal to value
 *
 *  @param keyname key name
 *  @param value   value of key name
 *  @param error   error if fails
 *
 *  @return return a list of record
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname value:(id)value;

/// 查询不在当前数组中的数据
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)KeyName notInList:(NSArray *)keyList;
/// 查询给定条件并且不在当前数组中的数据
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)whereCondition
                                                             whereConditionParams:(NSDictionary *)whereConditionParams
                                                                          keyName:(NSString *)keyName
                                                                        notInList:(NSArray *)keyList;

@end
