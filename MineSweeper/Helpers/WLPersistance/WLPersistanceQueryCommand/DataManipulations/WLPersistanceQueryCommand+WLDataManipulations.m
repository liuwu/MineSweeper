//
//  WLPersistanceQueryCommand+WLDataManipulations.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceQueryCommand+WLDataManipulations.h"
#import "WLPersistanceQueryCommand+WLReadMethods.h"
#import "NSString+WLSQL.h"

@implementation WLPersistanceQueryCommand (WLDataManipulations)

/**
 *  通过表名、数据列表对数据库表进行插入操作.
 *  @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法
 *
 */
- (WLPersistanceQueryCommand *)insertTable:(NSString *)tableName withDataList:(NSArray *)dataList {
    [self resetQueryCommand];
    
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (WLPersistance_isEmptyString(safeTableName) || dataList == nil) {
        return self;
    }
    
    NSMutableArray *valueItemList = [[NSMutableArray alloc] init];
    __block NSString *columString = nil;
    [dataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull description, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *columList = [[NSMutableArray alloc] init];
        NSMutableArray *valueList = [[NSMutableArray alloc] init];
        
        [description enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull colum, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            [columList addObject:[NSString stringWithFormat:@"`%@`", [colum safeSQLMetaString]]];
            if ([value isKindOfClass:[NSString class]]) {
                [valueList addObject:[NSString stringWithFormat:@"'%@'", [value safeSQLEncode]]];
            } else if ([value isKindOfClass:[NSNull class]]) {
                [valueList addObject:@"NULL"];
            } else {
                [valueList addObject:[NSString stringWithFormat:@"'%@'", value]];
            }
        }];
        
        if (columString == nil) {
            columString = [columList componentsJoinedByString:@","];
        }
        NSString *valueString = [valueList componentsJoinedByString:@","];
        
        [valueItemList addObject:[NSString stringWithFormat:@"(%@)", valueString]];
    }];
    
    // 某条记录不存在则插入，存在则更新 : 采用REPLACE 替换 插入:INSERT
    [self.sqlString appendFormat:@"REPLACE INTO `%@` (%@) VALUES %@;", safeTableName, columString, [valueItemList componentsJoinedByString:@","]];
    
    return self;
}

/**
 *  通过传入的表名、条件、条件参数对数据库表进行更新操作.
 *  @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法
 *
 */
- (WLPersistanceQueryCommand *)updateTable:(NSString *)tableName
                                  withData:(NSDictionary *)data
                                 condition:(NSString *)condition
                           conditionParams:(NSDictionary *)conditionParams {
    [self resetQueryCommand];
    
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (WLPersistance_isEmptyString(safeTableName) || data == nil){
        return self;
    }
    
    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    
    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull colum, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSString class]]) {
            [valueList addObject:[NSString stringWithFormat:@"`%@`='%@'", [colum safeSQLMetaString], [value safeSQLEncode]]];
        } else if ([value isKindOfClass:[NSNull class]]) {
            [valueList addObject:[NSString stringWithFormat:@"`%@`=NULL", [colum safeSQLMetaString]]];
        } else {
            [valueList addObject:[NSString stringWithFormat:@"`%@`=%@", [colum safeSQLMetaString], value]];
        }
    }];
    
    NSString *valueString = [valueList componentsJoinedByString:@","];
    
    
    [self.sqlString appendFormat:@"UPDATE `%@` SET %@ ", safeTableName, valueString];
    
    NSString *trimmedCondition = [condition safeSQLMetaString];
    return [self where:trimmedCondition params:conditionParams];
}

/**
 *  通过传入的表名、条件、条件参数对数据库表进行删除操作
 *   @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法
 *
 */
- (WLPersistanceQueryCommand *)deleteTable:(NSString *)tableName
                             withCondition:(NSString *)condition
                           conditionParams:(NSDictionary *)conditionParams {
    [self resetQueryCommand];
    
    NSString *safeTableName = [tableName safeSQLMetaString];
    
    if (WLPersistance_isEmptyString(safeTableName)) {
        return self;
    }
    
    [self.sqlString appendFormat:@"DELETE FROM `%@` ", safeTableName];
    
    NSString *trimmedCondition = [condition safeSQLMetaString];
    return [self where:trimmedCondition params:conditionParams];
}

@end
