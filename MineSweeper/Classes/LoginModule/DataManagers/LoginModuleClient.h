//
//  LoginModuleClient.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/18.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseModelClient.h"

@interface LoginModuleClient : BaseModelClient


// 获取图形验证码
+ (WLRequest *)getImageVcodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// 注册-获取短信验证码
+ (WLRequest *)getRegistVcodeWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// 注册
+ (WLRequest *)registWithParams:(NSDictionary *)params
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;

// 登录 - 短信验证码
+ (WLRequest *)getLoginVcodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// 登录 - 短信登录
+ (WLRequest *)loginByVcodeWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed;

// 登录 - 密码登录
+ (WLRequest *)loginByPwdWithParams:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

// 找回密码-发送验证码
+ (WLRequest *)getForgetPwdVcodeWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

// 找回密码-保存
+ (WLRequest *)saveForgetPwdWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

@end
