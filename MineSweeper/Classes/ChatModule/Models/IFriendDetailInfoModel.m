//
//  IFriendDetailInfoModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "IFriendDetailInfoModel.h"

@implementation IFriendDetailInfoModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.uid = dic[@"id"];
    self.desc = dic[@"description"];
    return YES;
}

// 获取登录用户性别
- (UIImage *)getLoginUserSex {
    if (self.gender.intValue == 1) {
        return [UIImage imageNamed:@"icon_female_nor"];
    }
    if (self.gender.intValue == 2) {
        return [UIImage imageNamed:@"icon_male_nor"];
    }
    return nil;
}

@end
