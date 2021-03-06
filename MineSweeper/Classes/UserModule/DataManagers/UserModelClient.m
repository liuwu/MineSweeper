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
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
                                  image:(UIImage *)image
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self updateFileWithParams:nil apiMethodName:@"App/User/Info/avatar" image:image Success:^(id resultInfo) {
        DLog(@"个人中心 - 头像修改 ---- %@",describe(resultInfo));
        SAFE_BLOCK_CALL(success,resultInfo);
    } Failed:^(NSError *error) {
//        [WLHUDView showOnlyTextHUD:error.localizedDescription];
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
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
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
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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

// 提现 - 提现信息
+ (WLRequest *)withdrawInfoWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Wallet/withdraw_info"
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
                                  Success:^(id resultInfo) {
                                      DLog(@"提现 - 提现信息 ---- %@",describe(resultInfo));
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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

// 钱包 - 转账
+ (WLRequest *)transferWallentWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Wallet/transfer"
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
                                  Success:^(id resultInfo) {
                                      DLog(@"钱包 - 转账 ---- %@",describe(resultInfo));
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
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
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
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
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
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
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
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
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
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

// 我的 - 设置 - 账户与安全
+ (WLRequest *)getUserSafeIndexWithParams:(NSDictionary *)params
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Safe/index"
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"我的 - 设置 - 账户与安全 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 我的 - 设置 - 免密下注
+ (WLRequest *)setSecretFreeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Safe/secret_free"
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"我的 - 设置 - 免密下注 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 修改手机验证码
+ (WLRequest *)getChangeMobileVcodeWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Info/change_mobile_sms"
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
                                  Success:^(id resultInfo) {
                                      DLog(@"修改手机验证码 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 修改手机号
+ (WLRequest *)changeMobileWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Info/change_mobile"
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"修改手机号 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 推广海报
+ (WLRequest *)getPosterWithParams:(NSDictionary *)params
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Info/pop_posters"
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"推广海报 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 抽奖
+ (WLRequest *)getLuckDrawWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/LuckDraw/index"
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"抽奖 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 我的银行卡列表
+ (WLRequest *)getBankCardListWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/User/Wallet/get_bank_card"
            ignoreUnifiedResponseProcess:NO
                              checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"我的银行卡列表 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 新增银行卡
+ (WLRequest *)addBankCardListWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Wallet/add_bank_card"
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"新增银行卡 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// 银行卡解绑
+ (WLRequest *)delBankCardListWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Wallet/bank_card_del"
             ignoreUnifiedResponseProcess:NO
                               checkToken:YES
                                 Success:^(id resultInfo) {
                                     DLog(@"银行卡解绑 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

@end
