//
//  WLPersistanceHelper.h
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>

#import "WLPersistanceUtils.h"

@class WLPersistanceTable,WLPersistanceQueryCommand;


//#define WLDBCode_Async_Begin             \
//__weak WLPersistanceHelper *wself = self; \
//[self asyncBlock :^{__strong WLPersistanceHelper *sself = wself;           \
//if (sself) {
//
//#define WLDBCode_Async_End \
//}                      \
//}];

#define WLDBCheck_tableNameIsInvalid(tableName)                           \
if ([WLPersistanceUtils checkStringIsEmpty:tableName]) {                       \
WLErrorLog(@" \n Fail!Fail!Fail!Fail! \n with TableName is nil"); \
return NO;                                                        \
}

/*
 基于FMDB的数据库管理类
 */
@interface WLPersistanceHelper : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSRecursiveLock *threadLock;

/**
 *  当前数据库加密的key.
 */
@property (copy, readonly, nonatomic) NSString* encryptionKey;

/*
 数据库路径："documents/db/" + filename + ".db"
 关联：FMDatabase.h  + (instancetype)databaseWithPath:(NSString*)inPath;
 */
- (instancetype)initWithDataBaseName:(NSString *)dbname;
// 设置数据库名称
- (void)setDataBaseName:(NSString *)dbName;

/**
 database文件的路径
 关联:  FMDatabase.h  + (instancetype)databaseWithPath:(NSString*)inPath;
 */
- (instancetype)initWithDataBasePath:(NSString *)filePath;
// 设置数据库
- (void)setDataBasePath:(NSString*)filePath;

/**
 设置数据库加密的key
 关联: FMDatabase.h  - (BOOL)setKey:(NSString*)key;
 */
- (BOOL)setKey:(NSString*)key;

/*
 重置数据库加密的key
 */
- (BOOL)rekey:(NSString*)key;

/**
 最后一次插入的行数
 */
- (NSNumber *)lastInsertRowId;

/**
 同步执行数据库操作 可递归调用
 */
- (void)executeDB:(void (^)(FMDatabase* db))block;

/**
 在事务内部,同步执行数据库操作
 block 返回 YES commit 事务    返回 NO  rollback 事务
 */
- (void)executeForTransaction:(BOOL (^)(WLPersistanceHelper* helper))block;

/*
 执行Sql语句，返回是否执行成功
 */
- (BOOL)executeSQL:(NSString*)sql arguments:(NSArray*)args;

/*
 执行Sql语句，返回查询结果第一个Column名称
 */
- (NSString*)executeScalarWithSQL:(NSString*)sql arguments:(NSArray*)args;

/// 执行查询操作
- (NSMutableArray *)extractQueryWithSqlString:(NSString *)sqlString table:(WLPersistanceTable *)table;

/**
 *  @brief don't do any operations of the sql
 */
- (NSMutableArray*)searchWithRAWSQL:(NSString*)sql toClass:(WLPersistanceTable *)modelClass;

//更新表现
- (BOOL)updateToDB:(WLPersistanceTable *)model QueryCommand:(WLPersistanceQueryCommand *)queryCommand;



///获取数据库表是否创建
- (BOOL)createTableCreatedWithTable:(WLPersistanceTable *)table QueryCommand:(WLPersistanceQueryCommand *)queryCommand;
- (BOOL)getTableCreatedWithTable:(WLPersistanceTable *)table;
- (BOOL)getTableCreatedWithTableName:(NSString*)tableName;

///drop all table
- (void)dropAllTable;

///drop table with entity class
- (BOOL)dropTableWithTable:(WLPersistanceTable *)table;
- (BOOL)dropTableWithTableName:(NSString*)tableName;


// 清除本地缓存
- (void)deleteLocalProtoryCacheDatas;

@end
