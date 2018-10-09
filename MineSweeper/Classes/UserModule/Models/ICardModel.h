//
//  ICardModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICardModel : NSObject

// ID
@property (nonatomic, copy) NSString *cardId;
// 账号名
@property (nonatomic, copy) NSString *username;
// 卡号
@property (nonatomic, copy) NSString *account;
// 银行地址
@property (nonatomic, copy) NSString *bank_adress;
// 银行类型：储蓄卡
@property (nonatomic, copy) NSString *type;



//username:(NSString *)刘武
//account:(NSString *)6225885864447263
//id:(NSString *)53
//bank_adress:(NSString *)招商银行
//type:(NSString *)储蓄卡

@end
