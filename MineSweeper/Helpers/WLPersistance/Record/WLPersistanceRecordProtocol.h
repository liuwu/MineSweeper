//
//  WLPersistanceRecordProtocol.h
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLPersistanceTable.h"

@protocol WLPersistanceRecordProtocol <NSObject>

@required
/**
 *  transform record into dictionary based with column infomation and table name
 *
 *  @param table   the instance of CTPersistanceTable
 *
 *  @return return the dicitonary of record data.
 */
- (NSDictionary *)dictionaryRepresentationWithTable:(WLPersistanceTable <WLPersistanceTableProtocol> *)table;

/**
 *  config your record with dictionary.
 *
 *  @param dictionary the data fetched with CTPersistanceTable
 */
- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary;

/**
 *  CTPersistanceTable will set data by this method, this method can also be called when merge another record.
 *
 *  @param value the value in fetched data
 *  @param key   the key in fetched data
 *
 *  @return return YES if success.
 */
- (BOOL)setPersistanceValue:(id)value forKey:(NSString *)key;

/**
 *  merge record
 *
 *  @param record         the record to merge
 *  @param shouldOverride if YES, the data in record param will override the data in self.
 *
 *  @return return the merged record
 */
- (NSObject <WLPersistanceRecordProtocol> *)mergeRecord:(NSObject <WLPersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride;

@optional

/**
 *  if you want to make this record able to merge, you should return all keys available when merging.
 *
 *  @return return the available key list.
 */
- (NSArray *)availableKeyList;


@end
