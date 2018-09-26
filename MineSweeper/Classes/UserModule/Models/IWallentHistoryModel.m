//
//  IWallentHistoryModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IWallentHistoryModel.h"

@implementation IWallentHistoryModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.hid = dic[@"id"];
    return YES;
}

@end
