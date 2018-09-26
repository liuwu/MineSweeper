//
//  BaseResultModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/18.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResultModel : NSObject

// 内容
@property (nonatomic, copy) NSDictionary *info;
// 消息内容
@property (nonatomic, copy) NSString *msg;
///状态码
@property (nonatomic, assign) int status;

@end
