//
//  ILoginUserModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/21.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ILoginUserModel.h"

@implementation ILoginUserModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"token" : [ITokenModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (dic[@"id"]) {
        self.uid = dic[@"id"];
    }
    return YES;
}

//- (void)customOperation:(NSDictionary *)dict
//{
//    self.project = [IProjectDetailInfo objectWithDict:dict[@"project"]];
//    self.user = [WLUserModel modelWithDictionary:dict[@"user"]];
//    self.created = [[dict[@"created"] wl_dateFormartNormalString] formattedDateWithFormat:@"yyyy/MM/dd"];
//}

@end
