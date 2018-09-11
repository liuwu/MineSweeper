//
//  WLPersistanceTableProtocol.h
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WLPersistanceRecordProtocol;

@protocol WLPersistanceTableProtocol <NSObject>

@required
/**
 数据库名称
 */
- (NSString *)databaseName;

/**
 数据库的表名
 */
- (NSString *)tableName;

/**
 设置当前数据库表的column信息。
 */
- (NSDictionary *)columnInfo;

/**
 record的Class类型
 */
- (Class)recordClass;

/**
 *  the name of the primary key.
 *
 *  @return return the name of the primary key.
 */
- (NSString *)primaryKeyName;

@optional
/**
 修改当前database的name
 */
//- (void)modifyDatabaseName:(NSString *)newDatabaseName;

/**
 在insert前检查Record
 */
- (BOOL)isCorrectToInsertRecord:(NSObject <WLPersistanceRecordProtocol> *)record;
 
 /**
 在update前检查Record
 */
- (BOOL)isCorrectToUpdateRecord:(NSObject <WLPersistanceRecordProtocol> *)record;

@end
