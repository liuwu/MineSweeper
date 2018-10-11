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

@property (nonatomic, strong) ICardModel *bank_card;


//balance:(NSString *)9909.10
//enbale_balance:(double)9909.1
//info:(NSString *)提现说明

@end
