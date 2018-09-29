//
//  IRecommendModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRecommendInfoModel.h"

@interface IRecommendModel : NSObject


// 返佣总额
@property (nonatomic, copy) NSString *total_money;
// 今日返佣总额
@property (nonatomic, copy) NSString *today_total_money;
// 数量
@property (nonatomic, copy) NSString *count;
// 页数
@property (nonatomic, copy) NSString *page;
// 总页数
@property (nonatomic, copy) NSNumber *pages;
// 详细
@property (nonatomic, copy) NSArray *list;

@end
