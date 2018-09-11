//
//  WLPersistanceQueryCommand+WLDataManipulations.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceQueryCommand.h"

/*
 数据操作扩展类
 */
@interface WLPersistanceQueryCommand (WLDataManipulations)

/**
 *  通过表名、数据列表对数据库表进行插入操作.
 *
 *  @param tableName 表名
 *  @param dataList  插入的数据数组
 *
 *  @return return WLPersistanceQueryCommand
 *
 *  @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法
 *
 */
- (WLPersistanceQueryCommand *)insertTable:(NSString *)tableName withDataList:(NSArray *)dataList;

/**
 *  通过传入的表名、条件、条件参数对数据库表进行更新操作.
 *
 *  @param tableName       表名
 *  @param data            需要更新的数据字典
 *  @param condition       条件
 *  @param conditionParams 条件参数
 *
 *  @return return WLPersistanceQueryCommand
 *
 *  @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法
 *
 */
- (WLPersistanceQueryCommand *)updateTable:(NSString *)tableName
                                  withData:(NSDictionary *)data
                                 condition:(NSString *)condition
                           conditionParams:(NSDictionary *)conditionParams;

/**
 *  通过传入的表名、条件、条件参数对数据库表进行删除操作
 *
 *  @param tableName       表名
 *  @param condition       条件
 *  @param conditionParams 条件参数
 *
 *  @return return WLPersistanceQueryCommand
 *
 *   @警告 你不应该直接使用这个方法，在WLPersistanceTable中使用替代方法
 *
 */
- (WLPersistanceQueryCommand *)deleteTable:(NSString *)tableName
                             withCondition:(NSString *)condition
                           conditionParams:(NSDictionary *)conditionParams;

@end
