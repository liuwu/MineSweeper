//
//  NSArray+WLPersistanceRecordTransform.h
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLPersistanceRecord.h"

@interface NSArray (WLPersistanceRecordTransform)

/**
 *  Transform items in Array to the Object by classType, the classType must confirms to <CTPersistanceRecordProtocol>, if the classType is not confirmed to <CTPersistanceRecordProtocol>, this method will return an empty array, not nil.
 *
 *  @param classType the class of result Object
 *
 *  @return return the list of transformed objects
 */
- (NSArray *)transformSQLItemsToClass:(Class<WLPersistanceRecordProtocol>)classType;

@end
