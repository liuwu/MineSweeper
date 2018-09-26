//
//  IMyRedPacketResultModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IMyRedPacketResultModel.h"

@implementation IMyRedPacketResultModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list" : [IMyRedPacketModel class]};
}

@end
