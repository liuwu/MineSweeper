//
//  IRedPacketModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/27.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRedPacketModel : NSObject


//  红包id
@property (nonatomic, copy) NSString *redpack_id;
// 包红标题
@property (nonatomic, copy) NSString *money;

@end
