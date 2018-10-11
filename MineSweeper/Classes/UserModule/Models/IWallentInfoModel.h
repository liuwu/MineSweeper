//
//  IWallentInfoModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/28.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICardModel.h"

@interface IWallentInfoModel : NSObject

// 余额
@property (nonatomic, copy) NSString *balance;
// 可提现金额
@property (nonatomic, copy) NSNumber *enbale_balance;
// 信息
@property (nonatomic, copy) NSString *info;
// 提现状态 1：提现维护弹出维护公告信息  0没有维护
@property (nonatomic, copy) NSNumber *status;
// 提现维护内容
@property (nonatomic, copy) NSString *winthdraw_explain;

@property (nonatomic, strong) ICardModel *bank_card;


//balance:(NSString *)9909.10
//enbale_balance:(double)9909.1
//info:(NSString *)提现说明

@end
