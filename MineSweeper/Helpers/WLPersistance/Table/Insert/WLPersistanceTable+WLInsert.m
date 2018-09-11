//
//  WLPersistanceTable+WLInsert.m
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "WLPersistanceTable+WLInsert.h"

#import "WLPersistanceRecord.h"
#import "WLPersistanceAsyncExecutor.h"
#import "WLPersistanceQueryCommand+WLDataManipulations.h"

@implementation WLPersistanceTable (WLInsert)

#pragma mark - Insert
// 把数据对象转换为sql语句
- (NSString *)convertRecordListToSqlStringWithList:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList {
    if (recordList == nil) {
        return @"";
    }
    NSMutableArray *insertList = [[NSMutableArray alloc] init];
    __block NSUInteger errorRecordIndex = 0;
    __block BOOL isSuccessed = YES;
    [recordList enumerateObjectsUsingBlock:^(NSObject <WLPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.child isCorrectToInsertRecord:record]) {
            [insertList addObject:[record dictionaryRepresentationWithTable:self.child]];
        } else {
            isSuccessed = NO;
            errorRecordIndex = idx;
            *stop = YES;
        }
    }];
    if (isSuccessed) {
        WLPersistanceQueryCommand *queryCommand = self.queryCommand;
        [queryCommand insertTable:[self.child tableName] withDataList:insertList];
        NSString *sqlString = queryCommand.sqlString;
        return sqlString;
    }
    return @"";
}

/**
 插入数据
 */
- (BOOL)insertRecordListWithSql:(NSString *)sqlString {
    __block BOOL isSuccessed = YES;
    if (sqlString.length == 0) {
        return isSuccessed;
    }
    WLPersistanceQueryCommand *queryCommand = self.queryCommand;
    [queryCommand.helper executeForTransaction:^BOOL(WLPersistanceHelper *helper) {
        isSuccessed = [helper executeSQL:sqlString arguments:nil];
        return isSuccessed;
    }];
    return isSuccessed;
}

/**
 插入一组数据记录
 */
- (BOOL)insertRecordList:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList {
    __block BOOL isSuccessed = YES;
    
    if (recordList == nil) {
        return isSuccessed;
    }
    
    NSMutableArray *insertList = [[NSMutableArray alloc] init];
    __block NSUInteger errorRecordIndex = 0;
    [recordList enumerateObjectsUsingBlock:^(NSObject <WLPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.child isCorrectToInsertRecord:record]) {
            [insertList addObject:[record dictionaryRepresentationWithTable:self.child]];
        } else {
            isSuccessed = NO;
            errorRecordIndex = idx;
            *stop = YES;
        }
    }];
    
    if (isSuccessed) {
        WLPersistanceQueryCommand *queryCommand = self.queryCommand;
        [queryCommand insertTable:[self.child tableName] withDataList:insertList];
        
        NSString *sqlString = queryCommand.sqlString;
        
        __block BOOL success = NO;
        [queryCommand.helper executeForTransaction:^BOOL(WLPersistanceHelper *helper) {
            success = [queryCommand.helper executeSQL:sqlString arguments:nil];
            return success;
        }];
        if (success) {
            isSuccessed = YES;
        }else{
            isSuccessed = NO;
        }
    }
    return isSuccessed;
}

/**
 插入一条数据记录
 */
- (BOOL)insertRecord:(NSObject <WLPersistanceRecordProtocol> *)record {
    __block BOOL isSuccessed = YES;
    
    if (record) {
        if ([self.child isCorrectToInsertRecord:record]) {
            WLPersistanceQueryCommand *queryCommand = self.queryCommand;
            [queryCommand insertTable:[self.child tableName] withDataList:@[[record dictionaryRepresentationWithTable:self.child]]];
            NSString *sqlString = queryCommand.sqlString;
            
            __block BOOL success = NO;
            [queryCommand.helper executeForTransaction:^BOOL(WLPersistanceHelper *helper) {
                success = [helper executeSQL:sqlString arguments:nil];
                return success;
            }];
            if (success) {
                isSuccessed = YES;
            }else{
                isSuccessed = NO;
            }
        }else{
            isSuccessed = NO;
        }
    }
    return isSuccessed;
}

// 异步插入多条数据
- (void)insertRecordListAsync:(NSArray <NSObject <WLPersistanceRecordProtocol> *> *)recordList callback:(void (^)(BOOL success))block {
    [[WLPersistanceAsyncExecutor sharedInstance] performAsyncAction:^{
        BOOL result = [self insertRecordList:recordList];
        if (block) {
            block(result);
        }
    } shouldWaitUntilDone:NO];
}

/**
 异步插入一条数据记录
 */
- (void)insertRecordAsync:(NSObject <WLPersistanceRecordProtocol> *)record callback:(void (^)(BOOL success))block {
    [[WLPersistanceAsyncExecutor sharedInstance] performAsyncAction:^{
        BOOL result = [self insertRecord:record];
        if (block) {
            block(result);
        }
    } shouldWaitUntilDone:NO];
}

@end
