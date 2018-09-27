//
//  IUserInfoModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/22.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUserInfoModel : NSObject

// 用户编号
@property (nonatomic, copy) NSNumber *uid;
// 用户ID
@property (nonatomic, copy) NSString *userId;
// 手机
@property (nonatomic, copy) NSString *mobile;
// 姓名
@property (nonatomic, copy) NSString *nickname;
// 真实姓名
@property (nonatomic, copy) NSString *realname;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 性别 //0未填 1 男 2 女
@property (nonatomic, copy) NSString *gender;
// 邀请码
@property (nonatomic, copy) NSString *invite_code;
// 地址
@property (nonatomic, copy) NSString *address;
// 是否推广  1 直接我的推广页面   0填写邀请码
@property (nonatomic, copy) NSNumber *is_enroller;
// 余额
@property (nonatomic, copy) NSString *balance;
// 1已设置支付密码  0 没有
@property (nonatomic, copy) NSNumber *is_default_password;

@end