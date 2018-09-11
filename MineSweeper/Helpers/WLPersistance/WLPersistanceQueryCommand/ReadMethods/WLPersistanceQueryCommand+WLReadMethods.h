//
//  WLPersistanceQueryCommand+WLReadMethods.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceQueryCommand.h"

static NSInteger const WLPersistanceNoLimit = -1;
static NSInteger const WLPersistanceNoOffset = -1;

/*
 数据查看方法的扩展
 
 @警告 你不应该直接使用下面这些方法，在WLPersistanceTable中使用替代方法.
 */
@interface WLPersistanceQueryCommand (WLReadMethods)

/**
 *  创建SELECT部分的SQL.
 *
 *  @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法.
 *
 *  @param columList  SQL中SELECT后面的column列表字符串
 *  @param isDistinct 如果是YES：使用 SELECT DISTINCT 生成SQL语句
 *  @return return WLPersistanceQueryCommand
 *
 *  注：DISTINCT 关键字与 SELECT 语句一起使用，来消除所有重复的记录，并只获取唯一一次记录
 */
- (WLPersistanceQueryCommand *)select:(NSString *)columList isDistinct:(BOOL)isDistinct;

/**
 *  创建FROM部分的SQl.
 *
 *  @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法.
 *
 *  @param fromList FROM part in SQL中From后面的部分
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)from:(NSString *)fromList;

/**
 *  创建WHERE部分的SQL.
 *
 *  @param condition where条件
 *  @param params    where条件的参数
 *  @return return WLPersistanceQueryCommand
 *
 *  @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法.
 */
- (WLPersistanceQueryCommand *)where:(NSString *)condition params:(NSDictionary *)params;

/**
 *  创建ORDER 部分的SQL
 *
 *  @param orderBy ORDER BY part of SQL
 *  @param isDESC  if YES, use DESC, if NO, use ASC
 *
 *  @return return CTPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)orderBy:(NSString *)orderBy isDESC:(BOOL)isDESC;

/**
 *  创建 LIMIT 部分的SQL
 *
 *  @param limit limit count
 *
 *  @return return CTPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)limit:(NSInteger)limit;

/**
 *  创建 OFFSET 部分的SQL
 *
 *  @param offset offset
 *  @return return CTPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)offset:(NSInteger)offset;

/**
 *  创建LIMIT和OFFSET 部分的SQL的简洁方法
 *
 *  @param limit  limit count
 *  @param offset offset
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)limit:(NSInteger)limit offset:(NSInteger)offset;

/**
 *  所有记录的计数SQL
 *
 *  @return count number
 */
- (WLPersistanceQueryCommand *)countAll;

@end
