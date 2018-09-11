//
//  WLPersistanceQueryCommand+WLSchemaManipulations.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceQueryCommand.h"

/*
 数据库表操作
 */
@interface WLPersistanceQueryCommand (WLSchemaManipulations)

/**
 *  创建数据库表的column信息
 *
 *  @param tableName  table名字
 *  @param columnInfo table的column信息
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo;

/**
 *  删除数据库表
 *
 *  @param tableName 数据库表的名字
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)dropTable:(NSString *)tableName;

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
                               tableName:(NSString *)tableName;

/**
 *  给Table添加索引 （索引（Index）是一种特殊的查找表，数据库搜索引擎用来加快数据检索。）
    create Index for table with indexed column list and condition with condition params.
 *
 *  @param indexName         index name
 *  @param tableName         table name
 *  @param indexedColumnList indexed column list
 *  @param condition         condition
 *  @param conditionParams   params for condition
 *  @param isUnique          if YES, create UNIQUE index
 *
 *  @return return WLPersistanceQueryCommand
 */
//- (WLPersistanceQueryCommand *)createIndex:(NSString *)indexName tableName:(NSString *)tableName indexedColumnList:(NSArray *)indexedColumnList condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isUnique:(BOOL)isUnique;

/**
 *  通过索引名称删除索引
 *
 *  @param indexName index name
 *
 *  @return return WLPersistanceQueryCommand
 */
//- (WLPersistanceQueryCommand *)dropIndex:(NSString *)indexName;

@end
