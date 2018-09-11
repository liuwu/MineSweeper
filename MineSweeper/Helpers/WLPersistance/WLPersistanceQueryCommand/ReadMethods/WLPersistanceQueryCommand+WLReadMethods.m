//
//  WLPersistanceQueryCommand+WLReadMethods.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceQueryCommand+WLReadMethods.h"
#import "NSString+WLSQL.h"

@implementation WLPersistanceQueryCommand (WLReadMethods)

/**
 *  为SQl创建SELECT部分.
 */
- (WLPersistanceQueryCommand *)select:(NSString *)columList isDistinct:(BOOL)isDistinct {
    [self resetQueryCommand];
    
    if (columList == nil) {
        if (isDistinct) {
            // DISTINCT 关键字与 SELECT 语句一起使用，来消除所有重复的记录，并只获取唯一一次记录
            [self.sqlString appendString:@"SELECT DISTINCT * "];
        } else {
            [self.sqlString appendString:@"SELECT * "];
        }
    } else {
        if (isDistinct) {
            [self.sqlString appendFormat:@"SELECT DISTINCT '%@' ", [columList safeSQLEncode]];
        } else {
            [self.sqlString appendFormat:@"SELECT '%@' ", [columList safeSQLEncode]];
        }
    }
    
    return self;
}

- (WLPersistanceQueryCommand *)from:(NSString *)fromList {
    if (fromList == nil) {
        return self;
    }
    [self.sqlString appendFormat:@"FROM '%@' ", [fromList safeSQLEncode]];
    return self;
}

- (WLPersistanceQueryCommand *)where:(NSString *)condition params:(NSDictionary *)params {
    if (condition == nil) {
        return self;
    }
    
    NSString *whereString = [condition stringWithSQLParams:params];
    [self.sqlString appendFormat:@"WHERE %@ ", whereString];
    
    return self;
}

- (WLPersistanceQueryCommand *)orderBy:(NSString *)orderBy isDESC:(BOOL)isDESC {
    if (orderBy == nil) {
        return self;
    }
    [self.sqlString appendFormat:@"ORDER BY %@ ", [orderBy safeSQLMetaString]];
    if (isDESC) {
        [self.sqlString appendString:@"DESC "];
    } else {
        [self.sqlString appendString:@"ASC "];
    }
    return self;
}

- (WLPersistanceQueryCommand *)limit:(NSInteger)limit {
    if (limit == WLPersistanceNoLimit) {
        return self;
    }
    [self.sqlString appendFormat:@"LIMIT %lu ", (unsigned long)limit];
    return self;
}

- (WLPersistanceQueryCommand *)offset:(NSInteger)offset {
    if (offset == WLPersistanceNoOffset) {
        return self;
    }
    [self.sqlString appendFormat:@"OFFSET %lu ", (unsigned long)offset];
    return self;
}

- (WLPersistanceQueryCommand *)limit:(NSInteger)limit offset:(NSInteger)offset {
    return [[self limit:limit] offset:offset];
}

- (WLPersistanceQueryCommand *)countAll {
    [self.sqlString appendFormat:@"SELECT COUNT(*) "];
    return self;
}

@end
