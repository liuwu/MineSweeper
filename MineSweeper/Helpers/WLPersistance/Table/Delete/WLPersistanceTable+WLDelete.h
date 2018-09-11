//
//  WLPersistanceTable+WLDelete.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable.h"

@class WLPersistanceCriteria;

@interface WLPersistanceTable (WLDelete)

/// 删除数据表的所有数据
- (void)deleteTableAllRecord;

/**
 *  delete a record.
 *
 *  @param record the record you want to delete
 *  @param error  the error if delete fails
 */
- (void)deleteRecord:(NSObject <WLPersistanceRecordProtocol> *)record;

/**
 *  delete a list of record
 *
 *  @param recordList the record list you want to delete
 *  @param error      the error if delete fails
 */
- (void)deleteRecordList:(NSArray <NSObject<WLPersistanceRecordProtocol> *> *)recordList;

/**
 用法：
 // 条件
 NSString *whereCondition = @"hello = :something";
 // 条件对应数据
 NSDictionary *conditionParams = @{@"something":@"world"};
 
 *  delete with condition. The "where condition" is a string which will be used in SQL WHERE clause. Can bind params if you have words start with colon.
 
 *  @param whereCondition  the string for WHERE clause
 *  @param conditionParams the params to bind in to where condition
 *  @param error           the error if delete fails
 */
- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams;

/**
 *  delete with criteria
 *
 *  @param criteria the criteria for delete
 *  @param error    the error if delete fails
 *
 *  @see CTPersistanceCriteria
 */
- (void)deleteWithCriteria:(WLPersistanceCriteria *)criteria;

/**
 *  delete with SQL string
 *
 *  @param sqlString the sqlString can be used as same as whereCondition to bind params, @see deleteWithWhereCondition:conditionParams:error:
 *  @param params    the params to bind into sqlString
 *  @param error     the error if delete fails
 */
- (void)deleteWithSql:(NSString *)sqlString params:(NSDictionary *)params;

/**
 *  delete with parimary key
 *
 *  @param primaryKeyValue the primary key of record to be deleted
 *  @param error           the error if delete fails
 */
- (void)deleteWithPrimaryKey:(NSString *)primaryKeyValue;

/**
 *  delete a list record by primary key list.
 *
 *  @param primaryKeyValueList the primary key list
 *  @param error               the error if delete fails
 */
- (void)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList;

@end
