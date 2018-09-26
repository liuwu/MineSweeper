//
//  AppDelegate.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/10.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

single_interface(AppDelegate)
@property (strong, nonatomic) UIWindow *window;

// 退出登录
//- (void)logoutWithErrormsg:(NSString *)errormsg;
//
/////登录成功
//- (void)loginSucceed;

// 检测登录状态
- (void)checkLoginStatus;
// 检查登录Token已过期
- (void)checkTokenExpires;
// 检查登录的Token过期
- (void)checkRefreshToken;


@end

