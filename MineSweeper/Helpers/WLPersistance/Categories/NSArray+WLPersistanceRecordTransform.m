//
//  NSArray+WLPersistanceRecordTransform.m
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "NSArray+WLPersistanceRecordTransform.h"

@implementation NSArray (WLPersistanceRecordTransform)

- (NSArray *)transformSQLItemsToClass:(Class)classType {
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    if ([self count] > 0) {
        [self enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull recordInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            id <WLPersistanceRecordProtocol> record = [[classType alloc] init];
            if ([record respondsToSelector:@selector(objectRepresentationWithDictionary:)]) {
                [record objectRepresentationWithDictionary:recordInfo];
                [recordList addObject:record];
            }
        }];
    }
    return recordList;
}

@end
