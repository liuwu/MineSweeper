//
//  WLPersistanceTable+WLFind.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable+WLFind.h"

#import "WLPersistanceRecord.h"
#import "WLPersistanceCriteria.h"

#import "NSString+WLSQL.h"
#import "NSArray+WLPersistanceRecordTransform.h"
#import "WLPersistanceQueryCommand+WLReadMethods.h"
#import "WLPersistanceQueryCommand+WLDataManipulations.h"

@implementation WLPersistanceTable (WLFind)

/**
 *  查询最后一条记录
 */
- (NSObject <WLPersistanceRecordProtocol> *)findLatestRecord {
    WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
    criteria.isDistinct = NO;
    criteria.orderBy = [self.child primaryKeyName];
    criteria.isDESC = YES;
    criteria.limit = 1;
    return [self findFirstRowWithCriteria:criteria];
}

/*
 查询当前表的所有记录
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllRecords {
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    NSString *tableName = self.child.tableName;
    NSString *sqlString = @"SELECT * FROM :tableName";
    NSDictionary *params = NSDictionaryOfVariableBindings(tableName);
    NSString *finalString = [sqlString stringWithSQLParams:params];
//    [queryCommand.sqlString appendString:finalString];
    NSArray *fetchedResult = [queryCommand.helper extractQueryWithSqlString:finalString table:self];
    return [fetchedResult transformSQLItemsToClass:[self.child recordClass]];
}

/**
 *  查询所有满足where条件的记录. @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams : for how to use where condition.
 *
 *  @param condition       where条件
 *  @param conditionParams 绑定where条件的参数
 *  @param isDistinct      if YES, 将使用 'SELECT DISTINCT' 从句.  DISTINCT 关键字与 SELECT 语句一起使用，来消除所有重复的记录，并只获取唯一一次记录。
 *
 *  @return 记录数组.
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct {
    WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
    criteria.isDistinct = isDistinct;
    criteria.whereCondition = condition;
    criteria.whereConditionParams = conditionParams;
    return [self findAllWithCriteria:criteria];
}

/// 查询所有满足where条件的记录，按照指定的属性排序
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct orderby:(NSString *)orderBy isDESC:(BOOL)isDESC {
    WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
    criteria.isDistinct = isDistinct;
    criteria.whereCondition = condition;
    criteria.whereConditionParams = conditionParams;
    criteria.orderBy = orderBy;
    criteria.isDESC = isDESC;
    return [self findAllWithCriteria:criteria];
}

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
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params {
    if (sqlString == nil) {
        return @[];
    }
    NSString *finalString = [sqlString stringWithSQLParams:params];
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    [queryCommand.sqlString appendString:finalString];
    NSArray *fetchedResult = [queryCommand.helper extractQueryWithSqlString:queryCommand.sqlString table:self];
    return [fetchedResult transformSQLItemsToClass:[self.child recordClass]];
}

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
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithCriteria:(WLPersistanceCriteria *)criteria {
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    queryCommand = [criteria applyToSelectQueryCommand:queryCommand tableName:[self.child tableName]];
    NSArray *fetchedResult = [queryCommand.helper extractQueryWithSqlString:queryCommand.sqlString table:self];
    return [fetchedResult transformSQLItemsToClass:[self.child recordClass]];
}

/**
 *  获取指定条件查询的数组中的第一条记录。
 @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams : for how to use where condition. First row means the first record of fetched record list, not the first record in table.
 *
 *  @param condition       condition used in WHERE clause
 *  @param conditionParams params to bind into whereCondition
 *  @param isDistinct      if YES, will use 'SELECT DISTINCT' clause
 *  @param error           error if fails
 *
 *  @return 第一条记录
 */
- (NSObject <WLPersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct {
    WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
    criteria.isDistinct = isDistinct;
    criteria.whereCondition = condition;
    criteria.whereConditionParams = conditionParams;
    criteria.limit = 1;
    return [self findFirstRowWithCriteria:criteria];
}

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
- (NSObject <WLPersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params {
    NSString *finalString = [sqlString stringWithSQLParams:params];
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    finalString = [finalString stringByReplacingOccurrencesOfString:@";" withString:@""];
    [queryCommand.sqlString appendFormat:@"%@ ", finalString];
    [queryCommand limit:1];
    NSMutableArray *resultArray = [queryCommand.helper extractQueryWithSqlString:queryCommand.sqlString table:self];
    if (resultArray.count > 0) {
        NSDictionary *info = [resultArray firstObject];
        return [[@[info] transformSQLItemsToClass:[self.child recordClass]] firstObject];
    }else{
        return nil;
    }
    //    return [[[queryCommand fetchWithError:error] transformSQLItemsToClass:[self.child recordClass]] firstObject];
}

/**
 *  find first row with criteria.
 *
 *  @param criteria criteria to find records
 *  @param error    error if fails
 *
 *  @return return the first row
 *  @see CTPersistanceCriteria
 */
- (NSObject <WLPersistanceRecordProtocol> *)findFirstRowWithCriteria:(WLPersistanceCriteria *)criteria {
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    criteria.limit = 1;
    queryCommand = [criteria applyToSelectQueryCommand:queryCommand tableName:[self.child tableName]];
    NSMutableArray *resultArray = [queryCommand.helper extractQueryWithSqlString:queryCommand.sqlString table:self];
    if (resultArray.count > 0) {
        NSDictionary *info = [resultArray firstObject];
        return [[@[info] transformSQLItemsToClass:[self.child recordClass]] firstObject];
    }else{
        return nil;
    }
}

/**
 *  return total record count in this table
 *
 *  @return return total record count in this table
 */
- (NSNumber *)countTotalRecord {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM %@", self.child.tableName];
    NSDictionary *countResult = [self countWithSQL:sqlString params:nil];
    return countResult[@"count"];
}

/**
 *  record count of record list with matches where condition. @see deleteWithWhereCondition:conditionParams:error: for how to use where condition.
 *
 *  @param whereCondition  condition used in WHERE clause
 *  @param conditionParams params ro bind into whereCondition
 *  @param error           error if fails
 *
 *  @return return record count of record list with matches where condition.
 */
- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams {
    NSString *sqlString = @"SELECT COUNT(*) AS count FROM :tableName WHERE :whereString;";
    NSString *whereString = [whereCondition stringWithSQLParams:conditionParams];
    NSString *tableName = self.child.tableName;
    NSDictionary *params = NSDictionaryOfVariableBindings(whereString, tableName);
    NSDictionary *countResult = [self countWithSQL:sqlString params:params];
    return countResult[@"count"];
}

/**
 *  return count of record list by SQL. sqlString can be bind with params like where condition. @see deleteWithWhereCondition:conditionParams:error: for how to use where condition.
 *
 *  @param sqlString the sqlString to count
 *  @param params    the params to bind into sqlString
 *  @param error     error if fails
 *
 *  @return return a dictionary which contains count column.
 */
- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params {
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [queryCommand.sqlString appendString:finalString];
    return [[queryCommand.helper extractQueryWithSqlString:queryCommand.sqlString table:self] firstObject];
}

/**
 *  find a record with primary key.
 *
 *  @param primaryKeyValue the primary key of the record you want to find
 *  @param error           error if fails
 *
 *  @return return a record
 */
- (NSObject <WLPersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue {
    if (primaryKeyValue == nil) {
        return nil;
    }
    
    WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
    criteria.whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
    criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
    return [self findFirstRowWithCriteria:criteria];
}

/**
 *  find all records by primary key list
 *
 *  @param primaryKeyValueList list of primary keys to find
 *  @param error               error if fails
 *
 *  @return return a list of record
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList {
    NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
    WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
    criteria.whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
    criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
    return [self findAllWithCriteria:criteria];
}

/**
 *  find all keyname's value equal to value
 *
 *  @param keyname key name
 *  @param value   value of key name
 *  @param error   error if fails
 *
 *  @return return a list of record
 */
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname value:(id)value {
    if (keyname && value) {
        WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
        criteria.whereCondition = [NSString stringWithFormat:@"%@ = :value", keyname];
        criteria.whereConditionParams = NSDictionaryOfVariableBindings(value);
        return [self findAllWithCriteria:criteria];
    }
    return @[];
}

/// 查询不在当前数组中的数据
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyName notInList:(NSArray *)keyList {
    if (keyName && keyList.count > 0) {
        return [self findAllWithWhereCondition:nil whereConditionParams:nil keyName:keyName notInList:keyList];
    }
    return nil;
}


/// 查询给定条件并且不在当前数组中的数据
- (NSArray <NSObject <WLPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)whereCondition
                                                             whereConditionParams:(NSDictionary *)whereConditionParams
                                                                          keyName:(NSString *)keyName
                                                                        notInList:(NSArray *)keyList {
//    NSString *keyListString = [keyList componentsJoinedByString:@","];
//    NSDictionary *whereNoInListParams = NSDictionaryOfVariableBindings(keyListString);
    NSString *whereString;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (whereCondition && whereConditionParams) {
        whereString = keyList.count > 0 ? [NSString stringWithFormat:@"%@ AND %@ NOT IN :keyListString",whereCondition, keyName] : whereCondition;
        [dict setDictionary:whereConditionParams];
    }else{
        whereString = keyList.count > 0 ? [NSString stringWithFormat:@"%@ NOT IN :keyListString", keyName] : @"";
    }
    if ([keyList count] > 0) {
        [dict setObject:keyList forKey:@"keyListString"];
    }
    if (whereString.length > 0) {
         return [self findAllWithWhereCondition:whereString conditionParams:dict isDistinct:NO];
    }
    return nil;
}

@end
