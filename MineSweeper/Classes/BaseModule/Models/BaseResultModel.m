//
//  BaseResultModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/18.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseResultModel.h"

@implementation BaseResultModel

#pragma mark - YYModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }

- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }


@end
