//
//  WLPersistanceQueryCommand+WLSchemaManipulations.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceQueryCommand+WLSchemaManipulations.h"
#import "NSString+WLSQL.h"

@implementation WLPersistanceQueryCommand (WLSchemaManipulations)

/**
 *  创建数据库表的column信息
 *
 *  @param tableName  table名字
 *  @param columnInfo table的column信息
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo {
    [self resetQueryCommand];
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (WLPersistance_isEmptyString(safeTableName)) {
        return self;
    }
    
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        NSString *safeColumnName = columnName;
        NSString *safeDescription = columnDescription;
        
        if (WLPersistance_isEmptyString(safeDescription)) {
            [columnList addObject:[NSString stringWithFormat:@"`%@`", safeColumnName]];
        } else {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@", safeColumnName, safeDescription]];
        }
    }];
    
    NSString *columns = [columnList componentsJoinedByString:@","];
    [self.sqlString appendFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", safeTableName, columns];
    
    return self;
}

/**
 *  删除数据库表
 *
 *  @param tableName 数据库表的名字
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)dropTable:(NSString *)tableName {
    [self resetQueryCommand];
    if (WLPersistance_isEmptyString(tableName)) {
        return self;
    }
    NSString *safeTableName = [tableName safeSQLMetaString];
    [self.sqlString appendFormat:@"DROP TABLE IF EXISTS `%@`;", safeTableName];
    return self;
}

/**
 *  给Table通过列名和coloum信息添加column
 *
 *  @param columnName 列名
 *  @param columnInfo 列信息
 *  @param tableName  table名称
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)addColumn:(NSString *)columnName
                              columnInfo:(NSString *)columnInfo
                               tableName:(NSString *)tableName {
    [self resetQueryCommand];
    NSString *safeColumnName = [columnName safeSQLMetaString];
    NSString *safeColumnInfo = [columnInfo safeSQLMetaString];
    NSString *safeTableName = [tableName safeSQLMetaString];
    
    if (WLPersistance_isEmptyString(safeTableName) || WLPersistance_isEmptyString(safeColumnInfo) || WLPersistance_isEmptyString(safeColumnName)) {
        return self;
    }
    
    [self.sqlString appendFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", safeTableName, safeColumnName, safeColumnInfo];
    
    return self;
}

@end
