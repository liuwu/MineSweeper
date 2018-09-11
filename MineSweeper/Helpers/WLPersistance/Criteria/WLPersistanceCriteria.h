//
//  WLPersistanceCriteria.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLPersistanceQueryCommand.h"

/*
 方便用户创建查询数据的范围的标准对象
 */
@interface WLPersistanceCriteria : NSObject

/**
 *  查询的列表或者通过(,)进行连接的列数组 
    the column or column list which connected with comma(,) to be select.
 */
@property (nonatomic, copy) NSString *select;

/**
 *  WHERE的条件
 */
@property (nonatomic, copy) NSString *whereCondition;

/**
 *  params for whereCondition
 */
@property (nonatomic, copy) NSDictionary *whereConditionParams;

/**
 *  the key to order
 */
@property (nonatomic, copy) NSString *orderBy;

/**
 *  if YES, will generate DESC in ORDER BY clause. if NO, will generate ASC in ORDER BY clause
 */
@property (nonatomic, assign) BOOL isDESC;

/**
 *  the limit count
 */
@property (nonatomic, assign) NSInteger limit;

/**
 *  the offset to fetch
 */
@property (nonatomic, assign) NSInteger offset;

/**
 *  if YES, will generate SELECT DISTINCT, if NO, will generate SELECT
 */
@property (nonatomic, assign) BOOL isDistinct;

/**
 *  generate SQL for SELECT
 *
 *  @param queryCommand WLPersistanceQueryCommand instance
 *  @param tableName    name of table or tables which connected with comma(,)
 *
 *  @return return WLPersisstanceQueryCommand
 */
- (WLPersistanceQueryCommand *)applyToSelectQueryCommand:(WLPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;

/**
 *  generate SQL for DELETE
 *
 *  @param queryCommand WLPersistanceQueryCommand instance
 *  @param tableName    name of table
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)applyToDeleteQueryCommand:(WLPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;

@end
