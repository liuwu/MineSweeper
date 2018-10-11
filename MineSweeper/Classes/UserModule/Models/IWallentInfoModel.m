//
//  IWallentInfoModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/28.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IWallentInfoModel.h"

@implementation IWallentInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"bank_card" : [ICardModel class]};
}


@end
