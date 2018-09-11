//
//  WLPersistanceHelper.m
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceHelper.h"
#import <sqlite3.h>

#import "WLPersistanceQueryCommand.h"
#import "WLPersistanceTable.h"

#define kDefaultSqliteDataBaseName @"Welian_DataBase_Normal"
#define kEncryptKey @"welian02188406"

@interface WLDataBaseInfos : NSObject

@property (nonatomic, strong) NSMutableArray *dataHelperArray;
@property (nonatomic, strong) NSMutableArray *createdTableNames;

+ (instancetype)sharedInstance;

@end

@implementation WLDataBaseInfos

+ (instancetype)sharedInstance {
    static WLDataBaseInfos *_dataInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataInfo = [[[self class] alloc] init];
    });
    return _dataInfo;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataHelperArray = [NSMutableArray array];
        self.createdTableNames = [NSMutableArray array];
    }
    return self;
}

@end

@interface WLPersistanceHelper ()

//@property (nonatomic, weak) FMDatabase *usingdb;
@property (nonatomic, strong) FMDatabase *usingdb;
//@property (nonatomic, strong) FMDatabase *usingdb;
@property (nonatomic, strong) FMDatabaseQueue *bindingQueue;
@property (nonatomic, copy) NSString* dbPath;

@end

// 是否打印错误日志
static BOOL WLDBLogErrorEnable = NO;

@implementation WLPersistanceHelper
@synthesize encryptionKey = _encryptionKey;

+ (instancetype)sharedInstance {
    static WLPersistanceHelper *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WLPersistanceHelper alloc] init];
    });
    return _instance;
}

// 清除本地缓存
- (void)deleteLocalProtoryCacheDatas {
    NSMutableArray *dataArray = [WLDataBaseInfos sharedInstance].dataHelperArray;
    for (WLPersistanceHelper *helper in dataArray) {
        // 关闭数据库连接
        [helper.bindingQueue close];
        helper.bindingQueue = nil;
        helper.dbPath = nil;
        helper.threadLock = nil;
    }
    // 清空数据
    [[WLDataBaseInfos sharedInstance].dataHelperArray removeAllObjects];
    [[WLDataBaseInfos sharedInstance].createdTableNames removeAllObjects];
}

#pragma mark - dealloc
- (void)dealloc {
    // 关闭数据库连接
    [self.bindingQueue close];
    self.usingdb = nil;
    self.bindingQueue = nil;
    self.dbPath = nil;
}

#pragma mark – Lifecycle
/*
 数据库路径："documents/db/" + filename + ".db"
 关联：FMDatabase.h  + (instancetype)databaseWithPath:(NSString*)inPath;
 */
- (instancetype)initWithDataBaseName:(NSString *)dbname {
    return [self initWithDataBasePath:[WLPersistanceHelper getDBPathWithDBName:dbname]];
}

/**
 database文件的路径
 关联:  FMDatabase.h  + (instancetype)databaseWithPath:(NSString*)inPath;
 */
- (instancetype)initWithDataBasePath:(NSString *)filePath {
    if ([WLPersistanceUtils checkStringIsEmpty:filePath]) {
        ///release self
        self = nil;
        return nil;
    }
    
    WLPersistanceHelper *helper = [WLPersistanceHelper dbHelperWithPath:filePath save:nil];
    if (helper) {
        self = helper;
    }else{
        self = [super init];
        if (self) {
            self.threadLock = [[NSRecursiveLock alloc] init];
            // 设置数据库
            [self setDataBasePath:filePath];
            [WLPersistanceHelper dbHelperWithPath:nil save:self];
        }
    }
    
    return self;
}

#pragma mark - init FMDB
// 获取数据库完成路径
+ (NSString*)getDBPathWithDBName:(NSString*)dbName {
    NSString* fileName = nil;
    if (!dbName) {
        return nil;
    }
    if ([dbName hasSuffix:@".db"] == NO) {
        fileName = [NSString stringWithFormat:@"%@.db", dbName];
    }else{
        fileName = dbName;
    }
    
    NSString* filePath = [WLPersistanceUtils getPathForDocuments:fileName inDir:@"welian/db"];
    return filePath;
}

// 设置数据库名称
- (void)setDataBaseName:(NSString *)dbName {
    [self setDataBasePath:[WLPersistanceHelper getDBPathWithDBName:dbName]];
}

// 设置数据库
- (void)setDataBasePath:(NSString*)filePath {
    if (self.bindingQueue && [self.dbPath isEqualToString:filePath]) {
        return;
    }
    NSFileManager* fileManager = [NSFileManager defaultManager];
    // 创建数据库目录
    NSRange lastComponent = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    
    if (lastComponent.length > 0) {
        NSString* dirPath = [filePath substringToIndex:lastComponent.location];
        BOOL isDir = NO;
        BOOL isCreated = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
        
        if ((isCreated == NO) || (isDir == NO)) {
            NSError* error = nil;
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
            NSDictionary* attributes = @{ NSFileProtectionKey : NSFileProtectionNone };
#else
            NSDictionary* attributes = nil;
#endif
            BOOL success = [fileManager createDirectoryAtPath:dirPath
                                  withIntermediateDirectories:YES
                                                   attributes:attributes
                                                        error:&error];
            if (success == NO) {
                WLErrorLog(@"create dir error: %@", error.debugDescription);
            }
        }
        else {
            /**
             *  @brief  Disk I/O error when device is locked
             *          https://github.com/ccgus/fmdb/issues/262
             */
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
            [fileManager setAttributes:@{ NSFileProtectionKey : NSFileProtectionNone }
                          ofItemAtPath:dirPath
                                 error:nil];
#endif
        }
    }
    
    [self.threadLock lock];
    
    self.dbPath = filePath;
    [self.bindingQueue close];
    [[WLDataBaseInfos sharedInstance].createdTableNames removeAllObjects];
    
#ifndef SQLITE_OPEN_FILEPROTECTION_NONE
#define SQLITE_OPEN_FILEPROTECTION_NONE 0x00400000
#endif
    self.bindingQueue = [[FMDatabaseQueue alloc] initWithPath:filePath
                                                        flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_NONE];
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager setAttributes:@{ NSFileProtectionKey : NSFileProtectionNone } ofItemAtPath:filePath error:nil];
    }
#endif
    
    ///充值数据库密钥reset encryptionKey
    _encryptionKey = nil;
    
    [self.bindingQueue inDatabase:^(FMDatabase* db) {
        db.logsErrors = WLDBLogErrorEnable;
    }];
    [self.threadLock unlock];
}

#pragma mark - set key
- (NSString*)encryptionKey {
    [self.threadLock lock];
    NSString* key = _encryptionKey;
    [self.threadLock unlock];
    return key;
}

/**
 设置数据库加密的key
 关联: FMDatabase.h  - (BOOL)setKey:(NSString*)key;
 */
- (BOOL)setKey:(NSString*)key {
    [self.threadLock lock];
    _encryptionKey = [key copy];
    __block BOOL success = NO;
    if (self.bindingQueue && _encryptionKey.length > 0) {
        [self executeDB:^(FMDatabase* db) {
            success = [db setKey:_encryptionKey];
        }];
    }
    [self.threadLock unlock];
    return success;
}

/*
 重置数据库加密的key
 */
- (BOOL)rekey:(NSString*)key {
    [self.threadLock lock];
    _encryptionKey = [key copy];
    __block BOOL success = NO;
    if (self.bindingQueue && _encryptionKey.length > 0) {
        [self executeDB:^(FMDatabase* db) {
            success = [db rekey:_encryptionKey];
        }];
    }
    [self.threadLock unlock];
    return success;
}

#pragma mark - core
// 最后一次插入的数据的rowid
- (NSNumber *)lastInsertRowId {
    __block NSNumber *lastInsertRowId;
    [self executeDB:^(FMDatabase* db) {
        lastInsertRowId = @([db lastInsertRowId]);
    }];
    return lastInsertRowId;
}

/**
 同步执行数据库操作 可递归调用
 */
- (void)executeDB:(void (^)(FMDatabase* db))block {
    if (!block) {
        NSAssert(NO, @"block is nil!");
        return;
    }
    [self.threadLock lock];
    
    if (self.usingdb != nil) {
        block(self.usingdb);
    }else{
        if (self.bindingQueue == nil) {
            self.bindingQueue = [[FMDatabaseQueue alloc] initWithPath:_dbPath];
            [[WLDataBaseInfos sharedInstance].createdTableNames removeAllObjects];
            [self.bindingQueue inDatabase:^(FMDatabase* db) {
                db.logsErrors = WLDBLogErrorEnable;
                if (_encryptionKey.length > 0) {
                    [db setKey:_encryptionKey];
                }
            }];
        }
        [self.bindingQueue inDatabase:^(FMDatabase* db) {
            self.usingdb = db;
            block(db);
            self.usingdb = nil;
        }];
    }
    
    [self.threadLock unlock];
}

/**
 在事务内部,同步执行数据库操作
 block 返回 YES commit 事务    返回 NO  rollback 事务
 */
- (void)executeForTransaction:(BOOL (^)(WLPersistanceHelper* helper))block {
    WLPersistanceHelper *helper = self;
    
    [self executeDB:^(FMDatabase* db) {
        BOOL inTransacttion = db.inTransaction;
        
        if (!inTransacttion) {
            [db beginTransaction];
        }
        
        BOOL isCommit = NO;
        
        if (block) {
            isCommit = block(helper);
        }
        
        if (!inTransacttion) {
            if (isCommit) {
                [db commit];
            }else{
                [db rollback];
            }
        }
    }];
}

/*
 执行Sql语句，返回是否执行成功
 */
- (BOOL)executeSQL:(NSString*)sql arguments:(NSArray*)args {
    __block BOOL execute = NO;
    
    [self executeDB:^(FMDatabase* db) {
        if (args.count > 0) {
            execute = [db executeUpdate:sql withArgumentsInArray:args];
        }else{
            execute = [db executeUpdate:sql];
        }
        
        if (db.hadError) {
            WLErrorLog(@" sql:%@ \n args:%@ \n sqlite error :%@ \n", sql, args, db.lastErrorMessage);
        }
    }];
    return execute;
}

/*
 执行Sql语句，返回查询结果第一个Column名称
 */
- (NSString*)executeScalarWithSQL:(NSString*)sql arguments:(NSArray*)args {
    __block NSString* scalar = nil;
    
    [self executeDB:^(FMDatabase* db) {
        FMResultSet* set = nil;
        
        if (args.count > 0) {
            set = [db executeQuery:sql withArgumentsInArray:args];
        }else{
            set = [db executeQuery:sql];
        }
        
        if (db.hadError) {
            WLErrorLog(@" sql:%@ \n args:%@ \n sqlite error :%@ \n", sql, args, db.lastErrorMessage);
        }
        
        if (([set columnCount] > 0) && [set next]) {
            scalar = [set stringForColumnIndex:0];
        }
        
        [set close];
    }];
    return scalar;
}

#pragma mark - Private
+ (WLPersistanceHelper *)dbHelperWithPath:(NSString*)dbFilePath save:(WLPersistanceHelper*)helper {
    NSMutableArray* dbArray = [[WLDataBaseInfos sharedInstance] dataHelperArray];
    WLPersistanceHelper *instance = nil;
    if (helper) {
        // 加密
        [helper setKey:kEncryptKey];
        BOOL isHave = [dbArray bk_any:^BOOL(id obj) {
            return [[obj dbPath] isEqualToString:helper.dbPath];
        }];
        if (!isHave) {
            [[[WLDataBaseInfos sharedInstance] dataHelperArray] addObject:helper];
        }
        instance = helper;
    }else{
        if (dbFilePath) {
            for (WLPersistanceHelper *localHelper in dbArray) {
                if ([localHelper.dbPath isEqualToString:dbFilePath]) {
                    instance = localHelper;
                }else{
                    // 移除多余的缓存数据库连接
                    [[[WLDataBaseInfos sharedInstance] dataHelperArray] removeObject:localHelper];
                }
            }
        }
    }
    return instance;
}

/**
 *  @brief don't do any operations of the sql
 */
- (NSMutableArray*)searchWithRAWSQL:(NSString*)sql toClass:(WLPersistanceTable *)modelClass {
    if (sql.length == 0) {
        return nil;
    }
    __block NSMutableArray* results = nil;
    [self executeDB:^(FMDatabase* db) {
        FMResultSet* set = [db executeQuery:sql];
        results = [self executeResult:set Class:modelClass tableName:nil];
        [set close];
    }];
    return results;
}

- (BOOL)updateToDB:(WLPersistanceTable *)model QueryCommand:(WLPersistanceQueryCommand *)queryCommand {
    if (queryCommand.sqlString == nil) {
        return NO;
    }
    BOOL execute = [self executeSQL:queryCommand.sqlString arguments:nil];
    return execute;
}

#pragma mark - Private
/// 执行查询操作
- (NSMutableArray *)extractQueryWithSqlString:(NSString *)sqlString table:(WLPersistanceTable *)table{
    if (sqlString.length == 0) {
        return nil;
    }
    
    __block NSMutableArray* results = nil;
    [self executeDB:^(FMDatabase* db) {
            FMResultSet* set = [db executeQuery:sqlString];
            results = [self executeResult:set Class:table tableName:[table.child tableName]];
        [set close];
    }];
    return results;
}

- (void)sqlString:(NSMutableString*)sql groupBy:(NSString*)groupBy orderBy:(NSString*)orderby offset:(NSInteger)offset count:(NSInteger)count {
    if ([WLPersistanceUtils checkStringIsEmpty:groupBy] == NO) {
        [sql appendFormat:@" group by %@", groupBy];
    }
    
    if ([WLPersistanceUtils checkStringIsEmpty:orderby] == NO) {
        [sql appendFormat:@" order by %@", orderby];
    }
    
    if (count > 0) {
        [sql appendFormat:@" limit %ld offset %ld", (long)count, (long)offset];
    }
    else if (offset > 0) {
        [sql appendFormat:@" limit %d offset %ld", INT_MAX, (long)offset];
    }
}

- (NSMutableArray*)executeOneColumnResult:(FMResultSet *)set {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    while ([set next]) {
        NSString* string = [set stringForColumnIndex:0];
        
        if (string) {
            [array addObject:string];
        }
        else {
            NSData* data = [set dataForColumnIndex:0];
            
            if (data) {
                [array addObject:data];
            }
        }
    }
    
    return array;
}

- (NSMutableArray*)executeResult:(FMResultSet*)set Class:(WLPersistanceTable *)modelClass tableName:(NSString*)tableName {
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        // 直接返回数据库数据的字典对象
        [array addObject:set.resultDictionary];
    }
    
    return array;
}



- (BOOL)createTableCreatedWithTable:(WLPersistanceTable *)table QueryCommand:(WLPersistanceQueryCommand *)queryCommand {
    return [self _createTableWithModelClass:table tableName:table.child.tableName QueryCommand:queryCommand];
}

///获取数据库表是否创建
- (BOOL)getTableCreatedWithTable:(WLPersistanceTable *)table {
    return [self getTableCreatedWithTableName:table.child.tableName];
}

- (BOOL)getTableCreatedWithTableName:(NSString*)tableName {
    __block BOOL isTableCreated = NO;
    
    [self executeDB:^(FMDatabase* db) {
        FMResultSet* set = [db executeQuery:@"select count(name) from sqlite_master where type='table' and name=?", tableName];
        if ([set next]) {
            if ([set intForColumnIndex:0] > 0) {
                isTableCreated = YES;
            }
        }
        
        [set close];
    }];
    return isTableCreated;
}

///drop all table
- (void)dropAllTable {
    [self executeDB:^(FMDatabase* db) {
        FMResultSet* set = [db executeQuery:@"select name from sqlite_master where type='table'"];
        NSMutableArray* dropTables = [NSMutableArray arrayWithCapacity:0];
        
        while ([set next]) {
            NSString* tableName = [set stringForColumnIndex:0];
            if (tableName) {
                [dropTables addObject:tableName];
            }
        }
        
        [set close];
        
        for (NSString* tableName in dropTables) {
            if ([tableName hasPrefix:@"sqlite_"] == NO) {
                NSString* dropTable = [NSString stringWithFormat:@"drop table %@", tableName];
                [db executeUpdate:dropTable];
            }
        }
        [[WLDataBaseInfos sharedInstance].createdTableNames removeAllObjects];
    }];
}

///drop table with entity class
- (BOOL)dropTableWithTable:(WLPersistanceTable *)table {
    return [self dropTableWithTableName:table.child.tableName];
}

- (BOOL)dropTableWithTableName:(NSString *)tableName {
    if ([WLPersistanceUtils checkStringIsEmpty:tableName]) {
        return NO;
    }
    
    NSString* dropTable = [NSString stringWithFormat:@"drop table %@", tableName];
    
    BOOL isDrop = [self executeSQL:dropTable arguments:nil];
    
    [self.threadLock lock];
    [[WLDataBaseInfos sharedInstance].createdTableNames removeObject:tableName];
    [self.threadLock unlock];
    
    return isDrop;
}

- (BOOL)_createTableWithModelClass:(WLPersistanceTable *)modelClass tableName:(NSString*)tableName QueryCommand:(WLPersistanceQueryCommand *)queryCommand {
    if (!tableName.length) {
        NSAssert(NO, @"none table name");
        return NO;
    }
    BOOL isCreate = [self getTableCreatedWithTableName:tableName];
    if (isCreate) {
        // 已创建表 就跳过
        [self.threadLock lock];
        if ([[WLDataBaseInfos sharedInstance].createdTableNames containsObject:tableName] == NO) {
            [[WLDataBaseInfos sharedInstance].createdTableNames addObject:tableName];
            // 把数据库表的coloums和属性对比，如果属性新增的，需要进行ALTER TABLE 操作
            [self fixSqlColumnsWithTable:modelClass];
        }
        [self.threadLock unlock];
        return YES;
    }
    
    NSString* createTableSQL;
    if (queryCommand.sqlString.length > 0) {
        createTableSQL = queryCommand.sqlString;
    }else{
        NSMutableArray *columnList = [[NSMutableArray alloc] init];
        
        [modelClass.child.columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
            NSString *safeColumnName = columnName;
            NSString *safeDescription = columnDescription;
            if (safeDescription.length == 0 || safeDescription == nil) {
                [columnList addObject:[NSString stringWithFormat:@"%@", safeColumnName]];
            }else{
                [columnList addObject:[NSString stringWithFormat:@"%@ %@", safeColumnName, safeDescription]];
            }
        }];
        
        NSString *columns = [columnList componentsJoinedByString:@","];
        createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);",tableName,columns];//[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)", tableName, table_pars, pksb];
    }
    
    BOOL isCreated = [self executeSQL:createTableSQL arguments:nil];
    
    [self.threadLock lock];
    if (isCreated) {
        [[WLDataBaseInfos sharedInstance].createdTableNames addObject:tableName];
    }
    [self.threadLock unlock];
    
    return isCreated;
}

// 把数据库表的coloums和属性对比，如果属性新增的，需要进行ALTER TABLE 操作
- (void)fixSqlColumnsWithTable:(WLPersistanceTable *)table {
    [self executeDB:^(FMDatabase* db) {
        
        NSString *tableName = table.child.tableName;
        // 查询数据库中当前表的列
        NSString* select = [NSString stringWithFormat:@"select * from %@ limit 0", tableName];
        FMResultSet* set = [db executeQuery:select];
        NSArray* columnArray = set.columnNameToIndexMap.allKeys;
        [set close];
        
        NSMutableArray *alterAddColumns = [NSMutableArray array];
        
        NSDictionary *tableColumDict = [table.child columnInfo];
        for (NSString *columnStr in tableColumDict) {
            if ([columnArray containsObject:columnStr.lowercaseString] == NO) {
                //数据库中不存在，需要ALTER ADD
                NSString *alertSQL = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", tableName, columnStr,tableColumDict[columnStr]];
                BOOL success = [db executeUpdate:alertSQL];
                if (success) {
                    // 进行了新增的列
                    [alterAddColumns addObject:columnStr];
                    
                    WLErrorLog(@"数据库表： %@ ALTER 新的Column:%@",tableName,columnStr.lowercaseString);
                }
            }
        }
    }];
}

@end
