//
//  ICityModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/25.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ICityModel.h"

@implementation ICityModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.cid = dic[@"id"];
    return YES;
}

@end
