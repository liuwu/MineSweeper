//
//  LoginModuleClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/18.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "LoginModuleClient.h"
#import "BaseResultModel.h"

@implementation LoginModuleClient

// 我的 - 刷新 token
+ (WLRequest *)refreshTokenWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/OAuth/refresh"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"我的 - 刷新 token ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success, resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 我的 - token
+ (WLRequest *)getUserTokenWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/OAuth/token"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"我的 - token ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success, resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 获取图形验证码
+ (WLRequest *)getImageVcodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Register/get_code_verification"
                 Success:^(id resultInfo) {
//                     NSDictionary *resultInfo = request.responseJSONObject;
                     DLog(@"注册-获取图形验证码 ---- %@",describe(resultInfo));
                     SAFE_BLOCK_CALL(success, resultInfo);
                 } Failed:^(NSError *error) {
                     // 统一错误处理
//                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                     SAFE_BLOCK_CALL(failed, error);
                 }];
    return api;
}

// 注册-获取短信验证码
+ (WLRequest *)getRegistVcodeWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Register/register_password_sms"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"注册-获取短信验证码 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 注册
+ (WLRequest *)registWithParams:(NSDictionary *)params
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Register/register"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"注册 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 登录 - 短信验证码
+ (WLRequest *)getLoginVcodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Login/get_login_sms"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"登录 - 短信验证码 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 登录 - 短信登录
+ (WLRequest *)loginByVcodeWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Login/login_sms"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"登录 - 短信登录 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 登录 - 密码登录
+ (WLRequest *)loginByPwdWithParams:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Login/login"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"登录 - 密码登录 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 找回密码-发送验证码
+ (WLRequest *)getForgetPwdVcodeWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Login/forget_password_sms"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"找回密码-发送验证码 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// 找回密码-保存
+ (WLRequest *)saveForgetPwdWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/User/Login/forget_password"
                                  Success:^(id resultInfo) {
                                      //                     NSDictionary *resultInfo = request.responseJSONObject;
                                      DLog(@"找回密码-保存 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}





@end
