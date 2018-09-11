//
//  WLPersistanceCriteria.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceCriteria.h"
#import "WLPersistanceQueryCommand+WLReadMethods.h"
#import "WLPersistanceQueryCommand+WLDataManipulations.h"

@implementation WLPersistanceCriteria

- (instancetype)init {
    self = [super init];
    if (self) {
        self.limit = WLPersistanceNoLimit;
        self.offset = WLPersistanceNoOffset;
    }
    return self;
}

/**
 *  构建一个SELECT的SQL
 *
 *  @param queryCommand WLPersistanceQueryCommand instance
 *  @param tableName    name of table or tables which connected with comma(,)
 *
 *  @return return WLPersisstanceQueryCommand
 */
- (WLPersistanceQueryCommand *)applyToSelectQueryCommand:(WLPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName {
    [queryCommand select:self.select isDistinct:self.isDistinct];
    [queryCommand from:tableName];
    [queryCommand where:self.whereCondition params:self.whereConditionParams];
    [queryCommand orderBy:self.orderBy isDESC:self.isDESC];
    [queryCommand limit:self.limit offset:self.offset];
    return queryCommand;
}

/**
 *  构建一个DELETE的SQL
 *
 *  @param queryCommand WLPersistanceQueryCommand instance
 *  @param tableName    name of table
 *
 *  @return return WLPersistanceQueryCommand
 */
- (WLPersistanceQueryCommand *)applyToDeleteQueryCommand:(WLPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName {
    [queryCommand deleteTable:tableName withCondition:self.whereCondition conditionParams:self.whereConditionParams];
    return queryCommand;
}

@end
