//
//  ILoginUserModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/21.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITokenModel.h"

@interface ILoginUserModel : NSObject

// 用户ID
@property (nonatomic, copy) NSString *uid;
// 姓名
@property (nonatomic, copy) NSString *username;
// 手机
@property (nonatomic, copy) NSString *mobile;
// 密码
@property (nonatomic, copy) NSString *password;
// 是否默认密码
@property (nonatomic, copy) NSString *is_default_password;
// token
@property (nonatomic, strong) ITokenModel *token;

@end
