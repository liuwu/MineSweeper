//
//  WLPersistanceTable.h
//  Welian
//
//  Created by weLian on 16/9/8.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

/*
 WLPersistanceTable :
 ------------------ 插入操作Demo  ---------------------
 // 声明对象，给对象赋值
 WLUserInfoModel *userinfomodel = [[WLUserInfoModel alloc] init];
 [userinfomodel objectRepresentationWithDictionary:infoDict];
 userinfomodel.isLogin = YES;
 
 WLUserInfoTable *userInfoTable = [[WLUserInfoTable alloc] init];
 // table操作数据，插入单挑数据
 [userInfoTable insertRecord:userinfomodel];
 
 /// 异步插入一组数据
 [userInfoTable insertRecordList:datas callback:^(BOOL suceess) {
     if (suceess) {
         [UIAlertView showWithMessage:@"异步插入成功"];
     }
 }];

 
 ------------------ 查询操作Demo  ---------------------
 1、参数条件查询：
     WLUserInfoTable *userInfoTable = [[WLUserInfoTable alloc] init];
     NSString *whereCondition = @"uid = :uid";
     //下面的操作等同于：@{@"uid":uid}，给上面的:uid设置值
     NSDictionary *conditionParams = NSDictionaryOfVariableBindings(uid);
     // 从用户信息表中，通过Table查询需要的Record信息，  查询第一条，uid为指定uid的用户的信息
     WLUserInfoModel *userInfoModel =  (WLUserInfoModel *)[userInfoTable findFirstRowWithWhereCondition:whereCondition conditionParams:conditionParams isDistinct:YES];
 
 2、条件对象查询
     WLUserInfoTable *userInfoTable = [[WLUserInfoTable alloc] init];
     NSString *whereCondition = @"uid = :uid";
     //下面的操作等同于：@{@"uid":uid}，给上面的:uid设置值
     NSDictionary *conditionParams = NSDictionaryOfVariableBindings(uid);
     
     // 根据条件对象查询
     WLPersistanceCriteria *criteria = [[WLPersistanceCriteria alloc] init];
     criteria.whereCondition = whereCondition;
     criteria.whereConditionParams = conditionParams;
     WLUserInfoModel *userInfoModel = (WLUserInfoModel *)[userInfoTable findFirstRowWithCriteria:criteria];
 
 
 
 
 */

#import <Foundation/Foundation.h>
#import "WLPersistanceTableProtocol.h"

@class WLPersistanceQueryCommand;

static NSString* const WLSQL_Type_Text = @"TEXT";
static NSString* const WLSQL_Type_Int = @"INTEGER";
static NSString* const WLSQL_Type_Double = @"DOUBLE";
static NSString* const WLSQL_Type_Blob = @"BLOB";

static NSString* const WLSQL_Attribute_NotNull = @"NOT NULL";
static NSString* const WLSQL_Attribute_PrimaryKey = @"PRIMARY KEY";
static NSString* const WLSQL_Attribute_Default = @"DEFAULT";
static NSString* const WLSQL_Attribute_Unique = @"UNIQUE";
static NSString* const WLSQL_Attribute_Check = @"CHECK";
static NSString* const WLSQL_Attribute_ForeignKey = @"FOREIGN KEY";

/*
 WLPersistanceTable是用来操作记录的.
 你应该为每一个Table对象的基础上创建一个表Table，需要继承WLPersistanceTable并且必须遵循<WLPersistanceTableProtocol>协议
 */
@interface WLPersistanceTable : NSObject


@property (nonatomic, weak, readonly) WLPersistanceTable <WLPersistanceTableProtocol> *child;

@property (nonatomic, assign, readonly) BOOL isFromMigration;
@property (nonatomic, strong, readonly) WLPersistanceQueryCommand *queryCommand;

@property (nonatomic, strong, readonly) NSArray *columnInfos;


// 执行SQL语句
- (BOOL)executeSQL:(NSString *)sqlString;



@end
