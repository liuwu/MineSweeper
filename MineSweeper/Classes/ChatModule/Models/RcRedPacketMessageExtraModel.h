//
//  RcRedPacketMessageExtraModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/10/1.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RcRedPacketMessageExtraModel : NSObject

// 设置扩展字段 红包状态 0或者nil：默认  1：已领取 2：红包已抢完 3：红包过期
@property (nonatomic, strong) NSNumber *status;

@end
