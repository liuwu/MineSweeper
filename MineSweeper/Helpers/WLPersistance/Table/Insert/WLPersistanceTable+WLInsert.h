//
//  WLPersistanceTable+WLInsert.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable.h"

@interface WLPersistanceTable (WLInsert)


// 把数据对象转换为sql语句，sqlie插入数据的数量最大一次500条
- (NSString *)convertRecordListToSqlStringWithList:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList;

/**
 插入数据
 */
- (BOOL)insertRecordListWithSql:(NSString *)sqlString;

/**
 插入一组数据记录，sqlie插入数据的数量最大一次500条
 */
- (BOOL)insertRecordList:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList;

/**
 插入一条数据记录
 */
- (BOOL)insertRecord:(NSObject <WLPersistanceRecordProtocol> *)record;


/**
 异步插入多条数据
 */
- (void)insertRecordListAsync:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList callback:(void (^)(BOOL success))block;

/**
 异步插入一条数据记录
 */
- (void)insertRecordAsync:(NSObject <WLPersistanceRecordProtocol> *)record callback:(void (^)(BOOL success))block;

@end
