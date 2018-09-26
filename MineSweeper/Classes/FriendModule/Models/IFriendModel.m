//
//  IFriendModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IFriendModel.h"

@implementation IFriendModel

#pragma mark - YYModel
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.uid = dic[@"id"];
    return YES;
}

@end
