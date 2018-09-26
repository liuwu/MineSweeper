//
//  INoticeModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/22.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "INoticeModel.h"

@implementation INoticeModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.titleId = dic[@"id"];
    return YES;
}

@end
