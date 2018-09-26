//
//  IWallentHistoryModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWallentHistoryModel : NSObject


@property (nonatomic, copy) NSString *hid;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *from_member_id;
@property (nonatomic, copy) NSString *to_member_id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *pay_title;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *add_time;

@end
