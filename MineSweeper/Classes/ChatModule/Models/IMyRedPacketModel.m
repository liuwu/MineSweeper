//
//  IMyRedPacketModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IMyRedPacketModel.h"

@implementation IMyRedPacketModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.packet_id = dic[@"id"];
    return YES;
}

@end
