//
//  UserModelClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "UserModelClient.h"

@implementation UserModelClient

// 个人中心-获取用户信息
+ (WLRequest *)getUserInfoWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Info/info"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心-获取用户信息 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心- 个人资料修改
+ (WLRequest *)changeUserInfoWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Info/info"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心- 个人资料修改 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心 - 头像修改
+ (WLRequest *)changeUserLogoWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Info/avatar"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心 - 头像修改 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心 - 头像获取
+ (WLRequest *)getUserLogoWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Info/avatar"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心 - 头像获取 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 我的钱包
+ (WLRequest *)getWallentWithParams:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Wallet/index"
                                 Success:^(id resultInfo) {
                                     DLog(@"我的钱包 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 钱包 - 充值
+ (WLRequest *)rechargeWallentWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Wallet/recharge"
                                 Success:^(id resultInfo) {
                                     DLog(@"钱包 - 充值 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 钱包 - 提现 - 支付宝授权登录
+ (WLRequest *)aliPayLoginWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Wallet/login_alipay"
                                 Success:^(id resultInfo) {
                                     DLog(@"钱包 - 提现 - 支付宝授权登录 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 钱包 - 提现
+ (WLRequest *)withdrawWallentWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Wallet/withdraw"
                                 Success:^(id resultInfo) {
                                     DLog(@" 钱包 - 提现 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心-支付密码 - 设置
+ (WLRequest *)setPayPwdWithParams:(NSDictionary *)params
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Safe/set_deal_password"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心-支付密码 - 设置 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心-支付密码 - 修改
+ (WLRequest *)changePayPwdWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Safe/change_deal_password"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心-支付密码 - 修改 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心-支付密码 - 忘记 - 短信验证码
+ (WLRequest *)forgetPayPwdVcodeWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Safe/forget_deal_password_sms"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心-支付密码 - 忘记 - 短信验证码 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心-支付密码 - 忘记 - 校验验证码
+ (WLRequest *)forgetPayCheckVcodeWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Safe/verify_deal_password_sms"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心-支付密码 - 忘记 - 校验验证码 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心-支付密码 - 忘记 - 重置
+ (WLRequest *)resetPayPwdWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Safe/reset_deal_password"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心-支付密码 - 忘记 - 重置 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心 - 用户二维码
+ (WLRequest *)getUserQrcodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Info/user_qrcode"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心 - 用户二维码 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心 - 设置邀请人
+ (WLRequest *)setInviteCodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Info/set_invite_code"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心 - 设置邀请人 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心 - 返佣记录
+ (WLRequest *)getRecommoneListWithParams:(NSDictionary *)params
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Info/get_commission_record"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心 - 返佣记录 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 个人中心 - 获取下一级
+ (WLRequest *)getRecommoneNextListWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Info/get_commission_list"
                                 Success:^(id resultInfo) {
                                     DLog(@"个人中心 - 获取下一级 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 获取省市区数据
+ (WLRequest *)getSystemCityListWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Info/get_area_chars"
                                 Success:^(id resultInfo) {
                                     DLog(@"获取省市区数据 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

@end
