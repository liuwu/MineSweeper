//
//  IGroupDetailInfo.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/26.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IGroupDetailInfo.h"

@implementation IGroupDetailInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"member_list" : [IFriendModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.groupId = dic[@"id"];
    return YES;
}

@end
