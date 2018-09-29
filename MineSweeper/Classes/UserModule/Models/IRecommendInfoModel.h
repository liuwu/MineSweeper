//
//  IRecommendInfoModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRecommendInfoModel : NSObject

// 昵称
@property (nonatomic, copy) NSString *from_nickname;
// 返佣金额
@property (nonatomic, copy) NSString *total_money;
// 等级
@property (nonatomic, copy) NSString *level;
// 时间
@property (nonatomic, copy) NSString *add_time;


// 用户ID
@property (nonatomic, copy) NSString *member_id;
// 上层ID
@property (nonatomic, copy) NSString *member_pid;
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 层级
@property (nonatomic, copy) NSString *distance;



//add_time:(NSString *)2018-09-28 17:35:03
//avatar:(NSString *)https://test.cnsunrun.com//saoleiapp/Uploads/Avatar/000/00/00/00_avatar_middle.jpg
//member_id:(NSString *)713
//nickname:(NSString *)11111
//member_pid:(NSString *)725
//distance:(NSString *)1

@end
