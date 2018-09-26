//
//  BannerImgModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/22.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BannerImgModel.h"

@implementation BannerImgModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.save_path = [NSString stringWithFormat:@"%@%@",@"https://test.cnsunrun.com/saoleiapp/", dic[@"save_path"]];
    return YES;
}

@end
