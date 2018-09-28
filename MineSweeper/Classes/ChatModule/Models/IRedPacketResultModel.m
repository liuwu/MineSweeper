//
//  IRedPacketResultModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IRedPacketResultModel.h"

@implementation IRedPacketResultModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list" : [IRedPacektMemberModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.packet_id = dic[@"id"];
    return YES;
}

@end
