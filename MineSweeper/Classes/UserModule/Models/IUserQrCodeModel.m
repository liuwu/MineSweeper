//
//  IUserQrCodeModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IUserQrCodeModel.h"

@implementation IUserQrCodeModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.userId = dic[@"id"];
    return YES;
}

@end
