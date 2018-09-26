//
//  IMyRedPacketModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMyRedPacketModel : NSObject

//  红包id
@property (nonatomic, copy) NSString *packet_id;
// 红包金额
@property (nonatomic, copy) NSString *money;

// 发红包人的id
@property (nonatomic, copy) NSString *from_member_id;
// 发红包人的昵称
@property (nonatomic, copy) NSString *from_nickname;

// 1踩雷 0 没有踩雷
@property (nonatomic, copy) NSString *is_thunder;
// 1手气最佳  0不是
@property (nonatomic, copy) NSString *is_optimum;
// 时间
@property (nonatomic, copy) NSString *update_time;

@end
