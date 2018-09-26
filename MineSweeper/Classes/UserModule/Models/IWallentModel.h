//
//  IWallentModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWallentHistoryModel.h"

@interface IWallentModel : NSObject

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *frozen;
@property (nonatomic, copy) NSString *deal_password;
@property (nonatomic, copy) NSNumber *is_set_deal_password;
@property (nonatomic, strong) NSArray *list;

@end
