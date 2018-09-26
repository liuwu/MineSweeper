//
//  IUserInfoModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/22.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IUserInfoModel.h"

@implementation IUserInfoModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.userId = dic[@"id"];
    return YES;
}

@end
