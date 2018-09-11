//
//  WLPersistanceTable+WLDelete.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable+WLDelete.h"

#import "WLPersistanceCriteria.h"
#import "NSString+WLSQL.h"

@implementation WLPersistanceTable (WLDelete)

/// 删除数据表的所有数据
- (void)deleteTableAllRecord {
    NSString *finalSql = [NSString stringWithFormat:@"DELETE FROM %@",[self.child tableName]];
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    BOOL execte = [queryCommand.helper executeSQL:finalSql arguments:nil];
    if (!execte) {
        WLErrorLog(@"deleteWithSql  failed! sql:%@",queryCommand.sqlString);
    }
}

/**
 *  delete a record.
 *
 *  @param record the record you want to delete
 *  @param error  the error if delete fails
 */
- (void)deleteRecord:(NSObject <WLPersistanceRecordProtocol> *)record {
    [self deleteWithPrimaryKey:[record valueForKey:[self.child primaryKeyName]]];
}

/**
 *  delete a list of record
 *
 *  @param recordList the record list you want to delete
 *  @param error      the error if delete fails
 */
- (void)deleteRecordList:(NSArray <NSObject<WLPersistanceRecordProtocol> *> *)recordList {
    NSMutableArray *primatKeyList = [[NSMutableArray alloc] init];
    [recordList enumerateObjectsUsingBlock:^(NSObject <WLPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *primaryKeyValue = [record valueForKey:[self.child primaryKeyName]];
        if (primaryKeyValue) {
            [primatKeyList addObject:primaryKeyValue];
        }
    }];
    [self deleteWithPrimaryKeyList:primatKeyList];
}

/**
 *  delete with condition. The "where condition" is a string which will be used in SQL WHERE clause. Can bind params if you have words start with colon.
 *
 *  Example for whereCondition and conditionParams:
 *
 *      NSString *whereCondition = @"hello = :something"; // the key in string must start wich colon
 *
 *      NSDictionary *conditionParams = @{
 *
 *          @"something":@"world"
 *
 *      };// the where string will be "hello = world"
 *
 *  @param whereCondition  the string for WHERE clause
 *  @param conditionParams the params to bind in to where condition
 *  @param error           the error if delete fails
 */
- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams {
    WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
    criteria.whereCondition = whereCondition;
    criteria.whereConditionParams = conditionParams;
    [self deleteWithCriteria:criteria];
}

/**
 *  delete with criteria
 *
 *  @param criteria the criteria for delete
 *  @param error    the error if delete fails
 *
 *  @see CTPersistanceCriteria
 */
- (void)deleteWithCriteria:(WLPersistanceCriteria *)criteria {
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    queryCommand = [criteria applyToDeleteQueryCommand:queryCommand tableName:[self.child tableName]];
    BOOL execte = [queryCommand.helper executeSQL:queryCommand.sqlString arguments:nil];
    if (!execte) {
        WLErrorLog(@"deleteWithCriteria  failed! sql:%@",queryCommand.sqlString);
    }
}

/**
 *  delete with SQL string
 *
 *  @param sqlString the sqlString can be used as same as whereCondition to bind params, @see deleteWithWhereCondition:conditionParams:error:
 *  @param params    the params to bind into sqlString
 *  @param error     the error if delete fails
 */
- (void)deleteWithSql:(NSString *)sqlString params:(NSDictionary *)params {
    NSString *finalSql = [sqlString stringWithSQLParams:params];
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    [queryCommand.sqlString appendString:finalSql];
    BOOL execte = [queryCommand.helper executeSQL:queryCommand.sqlString arguments:nil];
    if (!execte) {
        WLErrorLog(@"deleteWithSql  failed! sql:%@",queryCommand.sqlString);
    }
}

/**
 *  delete with parimary key
 *
 *  @param primaryKeyValue the primary key of record to be deleted
 *  @param error           the error if delete fails
 */
- (void)deleteWithPrimaryKey:(NSString *)primaryKeyValue {
    if (primaryKeyValue) {
        WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
        criteria.whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
        criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
        [self deleteWithCriteria:criteria];
    }
}

/**
 *  delete a list record by primary key list.
 *
 *  @param primaryKeyValueList the primary key list
 *  @param error               the error if delete fails
 */
- (void)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList {
    if ([primaryKeyValueList count] > 0) {
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
        criteria.whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
        criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
        [self deleteWithCriteria:criteria];
    }
}

@end
