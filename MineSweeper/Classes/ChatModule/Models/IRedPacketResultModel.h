//
//  IRedPacketResultModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRedPacektMemberModel.h"

@interface IRedPacketResultModel : NSObject

// 包红标题
@property (nonatomic, copy) NSString *title;
// 红包总金额
@property (nonatomic, copy) NSString *total_money;
// 红包个数
@property (nonatomic, copy) NSString *num;
//  抢红人的昵称
@property (nonatomic, copy) NSString *nickname;
// 用id
@property (nonatomic, copy) NSNumber *member_id;
// 抢的红包金额
@property (nonatomic, copy) NSString *grab_money;
// 抢红包人列表
@property (nonatomic, strong) NSArray *list;

@end
