//
//  INoticeModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/22.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INoticeModel : NSObject

@property (nonatomic, copy) NSString *titleId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *is_read;

@end
