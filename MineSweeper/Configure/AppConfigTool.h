//
//  AppConfigTool.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/21.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILoginUserModel.h"
#import "IUserInfoModel.h"
#import "IRcToken.h"
#import "ISafeIndexModel.h"

#define configTool [AppConfigTool shareInstance]

@interface AppConfigTool : NSObject


/// 登录的用户信息
@property (nonatomic, strong) ILoginUserModel *loginUser;
// 用户信息
@property (nonatomic, strong) IUserInfoModel *userInfoModel;
// 融云token
@property (nonatomic, strong) IRcToken *rcToken;
// 是否设置支付密码
@property (nonatomic, strong) ISafeIndexModel *safeIdexModel;

+ (instancetype)shareInstance;

// 登录成功
- (void)initLoginUser:(NSDictionary *)userInfo;

// 初始化已经登录的用户信息
- (void)initLoginUserInfo;

// 刷新登录用户的Token
- (void)refreshLoginUserToken:(NSDictionary *)tokenInfo;

// 获取登录用户性别
- (UIImage *)getLoginUserSex;
- (NSString *)getLoginUserSexStr;

// 获取当前登录token
- (NSString *)getToken;

@end
