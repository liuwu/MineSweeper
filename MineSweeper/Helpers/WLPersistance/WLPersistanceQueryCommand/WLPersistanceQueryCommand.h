//
//  WLPersistanceQueryCommand.h
//  Welian
//
//  Created by weLian on 16/9/9.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLPersistanceHelper.h"

/**
 *  WLPersistanceQueryCommand是一个持久层的SQL语句构建者
 *
 *  @警告 你不应该创建自己的WLPersistanceQueryCommand实例
 *
 */
@interface WLPersistanceQueryCommand : NSObject

/**
 当前生成的SQL字符串
 */
@property (nonatomic, strong, readonly) NSMutableString *sqlString;

/**
 *  related CTPersistanceDataBase
 */
//@property (nonatomic, copy, readonly) WLPersistanceHelper *helper;
@property (nonatomic, strong) WLPersistanceHelper *helper;


- (instancetype)initWithHelper:(WLPersistanceHelper *)helper;

// 清空Sql字符串
- (WLPersistanceQueryCommand *)resetQueryCommand;

@end
