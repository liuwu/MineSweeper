//
//  INoticeInfoModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/30.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "INoticeInfoModel.h"

@implementation INoticeInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list" : [INoticeModel class]};
}

@end
