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
// 头像
@property (nonatomic, copy) NSString *avatar;

// 1踩雷 0 没有踩雷
@property (nonatomic, copy) NSString *is_thunder;
// 1手气最佳  0不是
@property (nonatomic, copy) NSString *is_optimum;
// 时间
@property (nonatomic, copy) NSString *update_time;


//update_time:(NSString *)2018-09-30 15:39:27
//is_optimum:(NSString *)0
//avatar:(NSString *)https://test.cnsunrun.com/saoleiapp/Uploads/Avatar/000/00/07/69_avatar_big.jpg?time=1538293810
//id:(NSString *)522
//from_nickname:(NSString *)不介意。
//from_member_id:(NSString *)769
//money:(NSString *)16.68
//is_thunder:(NSString *)1

@end
