//
//  IWallentModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IWallentModel.h"

@implementation IWallentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list" : [IWallentHistoryModel class]};
}

@end
