//
//  ICardModel.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ICardModel.h"

@implementation ICardModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.cardId = dic[@"id"];
    return YES;
}


@end
