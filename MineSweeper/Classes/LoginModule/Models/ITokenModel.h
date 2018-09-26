//
//  ITokenModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/21.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITokenModel : NSObject

// 刷新token
@property (nonatomic, copy) NSString *refresh_token;
// token
@property (nonatomic, copy) NSString *access_token;
// 类型
@property (nonatomic, copy) NSString *token_type;
// 过期时间
@property (nonatomic, copy) NSString *expires_time;

@end
