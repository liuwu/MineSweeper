//
//  IRecommendModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IRecommendModel.h"

@implementation IRecommendModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list" : [IRecommendInfoModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.total_money = dic[@"total_money"] ? : @"0.00";
    self.today_total_money = [dic[@"today_total_money"] isKindOfClass:[NSNull class]] | !dic[@"today_total_money"] ? @"0.00" : dic[@"today_total_money"];
    return YES;
}


@end
