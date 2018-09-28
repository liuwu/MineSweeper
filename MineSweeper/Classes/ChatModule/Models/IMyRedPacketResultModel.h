//
//  IMyRedPacketResultModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMyRedPacketModel.h"

@interface IMyRedPacketResultModel : NSObject

//  抢红人的昵称
@property (nonatomic, copy) NSString *nickname;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 用id
@property (nonatomic, copy) NSString *member_id;
// 红包总数
@property (nonatomic, copy) NSString *total_num;
// 红包总金额
@property (nonatomic, copy) NSString *total_money;
// 页数
@property (nonatomic, copy) NSString *pages;
// 数量
@property (nonatomic, copy) NSString *count;
// 列表
@property (nonatomic, strong) NSArray *list;

@end
