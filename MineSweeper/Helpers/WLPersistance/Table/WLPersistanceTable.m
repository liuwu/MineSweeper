//
//  WLPersistanceTable.m
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable.h"

#import "WLPersistanceQueryCommand.h"

#import "WLPersistanceHelper.h"

#import "NSArray+WLPersistanceRecordTransform.h"
#import "WLPersistanceQueryCommand+WLSchemaManipulations.h"
#import "WLPersistanceQueryCommand+WLDataManipulations.h"

@interface WLPersistanceTable ()

@property (nonatomic, weak) id<WLPersistanceTableProtocol> child;
@property (nonatomic, strong, readwrite) WLPersistanceQueryCommand *queryCommand;

@end

@implementation WLPersistanceTable

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(WLPersistanceTableProtocol)]) {
        self.child = (WLPersistanceTable <WLPersistanceTableProtocol> *)self;
        // 获取数据库连接
        WLPersistanceHelper *helper = [[WLPersistanceHelper alloc] initWithDataBaseName:[self.child databaseName]];
        // 初始化数据库持久操作类
        WLPersistanceQueryCommand *queryCommand = [[WLPersistanceQueryCommand alloc] initWithHelper:helper];
        self.queryCommand = queryCommand;
        // 创建数据库表，连接数据库表
        BOOL isCreate = [queryCommand.helper createTableCreatedWithTable:self QueryCommand:queryCommand];
        if (!isCreate) {
            WLErrorLog(@"数据库表：%@ ,创建失败",self.child.tableName);
        }
    } else {
        NSAssert(NO, @"子类必须要实现WLPersistanceTable这个WLPersistanceTableProtocol");
        NSException *exception = [NSException exceptionWithName:@"WLPersistanceTable init error" reason:@"the child class must conforms to protocol: <CTPersistanceTableProtocol>" userInfo:nil];
        @throw exception;
    }
    return self;
}

#pragma mark - method to override
- (BOOL)isCorrectToInsertRecord:(NSObject <WLPersistanceRecordProtocol> *)record {
    return YES;
}

- (BOOL)isCorrectToUpdateRecord:(NSObject <WLPersistanceRecordProtocol> *)record {
    return YES;
}

// 执行Sql语句
- (BOOL)executeSQL:(NSString *)sqlString {
    WLPersistanceHelper *helper = [[WLPersistanceHelper alloc] initWithDataBaseName:[self.child databaseName]];
    return [helper executeSQL:sqlString arguments:nil];
}

@end
