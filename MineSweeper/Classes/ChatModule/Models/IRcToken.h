//
//  IRcToken.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/22.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRcToken : NSObject

// token
@property (nonatomic, copy) NSString *token;
// 过期时间
@property (nonatomic, copy) NSString *expires_time;

@end
