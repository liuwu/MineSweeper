//
//  AppConfigTool.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/21.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "AppConfigTool.h"

#import "AppDelegate.h"

@implementation AppConfigTool

+ (instancetype)shareInstance {
    static AppConfigTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 登录成功
- (void)initLoginUser:(NSDictionary *)userInfo {
    // 设置登录用户信息
    DLog(@"initLoginUser - %@" , describe(userInfo));
    configTool.loginUser = [ILoginUserModel modelWithDictionary:userInfo];
    [NSUserDefaults setObject:configTool.loginUser.uid forKey:kWLLoginUserIdKey];
    [NSUserDefaults setString:configTool.loginUser.mobile forKey:kWLLastLoginUserPhoneKey];
    [NSUserDefaults setObject:userInfo forKey:kWLLoginUserInfoKey];
    // 用户登录成功，通知个人中心页面刷新页面数据
    [kNSNotification postNotificationName:@"kUserLoginSuccess" object:nil];
    [[AppDelegate sharedAppDelegate] checkLoginStatus];
}

// 初始化已经登录的用户信息
- (void)initLoginUserInfo {
    if ([NSUserDefaults objectForKey:kWLLoginUserIdKey] && configTool.loginUser == nil) {
        NSDictionary *userInfo = [NSUserDefaults objectForKey:kWLLoginUserInfoKey];
        configTool.loginUser = [ILoginUserModel modelWithDictionary:userInfo];
        DLog(@"initLoginUserInfo - %@" , describe(userInfo));
        // 检测是否过期，重新获取
        [[AppDelegate sharedAppDelegate] checkTokenExpires];
        // 检测刷新token
//        [[AppDelegate sharedAppDelegate] checkRefreshToken];
    }
}

// 刷新登录用户的Token
- (void)refreshLoginUserToken:(NSDictionary *)tokenInfo {
    ITokenModel *tokenModel = [ITokenModel modelWithDictionary:tokenInfo];
    configTool.loginUser.token = tokenModel;
    NSDictionary *loginUserInfo = [configTool.loginUser modelToJSONObject];
    [NSUserDefaults setObject:loginUserInfo forKey:kWLLoginUserInfoKey];
}

// 获取登录用户性别
- (UIImage *)getLoginUserSex {
    if (configTool.userInfoModel.gender.intValue == 1) {
        return [UIImage imageNamed:@"icon_female_nor"];
    }
    if (configTool.userInfoModel.gender.intValue == 2) {
        return [UIImage imageNamed:@"icon_male_nor"];
    }
    return nil;
}

- (NSString *)getLoginUserSexStr {
    if (configTool.userInfoModel.gender.intValue == 1) {
        return @"男";
    }
    if (configTool.userInfoModel.gender.intValue == 2) {
        return @"女";
    }
    return @"未填写";
}

// 获取当前登录token
- (NSString *)getToken {
    if (configTool.loginUser) {
        return [NSString stringWithFormat:@"%@ %@", configTool.loginUser.token.token_type, configTool.loginUser.token.access_token];
    }
    return nil;
}

@end
