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

@end
