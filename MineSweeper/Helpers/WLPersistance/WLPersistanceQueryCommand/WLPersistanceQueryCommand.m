//
//  WLPersistanceQueryCommand.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceQueryCommand.h"

@interface WLPersistanceQueryCommand ()

@property (nonatomic, strong) NSMutableString *sqlString;
//@property (nonatomic, copy) NSString *databaseName;

@end

@implementation WLPersistanceQueryCommand

- (instancetype)initWithDatabaseNameName:(NSString *)tableName {
    self = [super init];
    if (self) {
//        self.databaseName = tableName;
    }
    return self;
}

- (instancetype)initWithHelper:(WLPersistanceHelper *)helper {
    self = [super init];
    if (self) {
        self.helper = helper;
    }
    return self;
}

// 清空Sql字符串
- (WLPersistanceQueryCommand *)resetQueryCommand {
    self.sqlString = nil;
    return self;
    
}

#pragma mark - getters and setters
- (NSMutableString *)sqlString {
    if (_sqlString == nil) {
        _sqlString = [[NSMutableString alloc] init];
    }
    return _sqlString;
}
@end
