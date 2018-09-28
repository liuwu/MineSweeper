//
//  UserModelClient.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseModelClient.h"

@interface UserModelClient : BaseModelClient

// 个人中心-获取用户信息
+ (WLRequest *)getUserInfoWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

// 个人中心- 个人资料修改
+ (WLRequest *)changeUserInfoWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// 个人中心 - 头像修改
+ (WLRequest *)changeUserLogoWithParams:(NSDictionary *)params
                                  image:(UIImage *)image
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// 个人中心 - 头像获取
+ (WLRequest *)getUserLogoWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

// 我的钱包
+ (WLRequest *)getWallentWithParams:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

// 钱包 - 充值
+ (WLRequest *)rechargeWallentWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// 钱包 - 提现 - 支付宝授权登录
+ (WLRequest *)aliPayLoginWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

// 钱包 - 提现
+ (WLRequest *)withdrawWallentWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// 钱包 - 转账
+ (WLRequest *)transferWallentWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// 个人中心-支付密码 - 设置
+ (WLRequest *)setPayPwdWithParams:(NSDictionary *)params
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed;

// 个人中心-支付密码 - 修改
+ (WLRequest *)changePayPwdWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed;

// 个人中心-支付密码 - 忘记 - 短信验证码
+ (WLRequest *)forgetPayPwdVcodeWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

// 个人中心-支付密码 - 忘记 - 校验验证码
+ (WLRequest *)forgetPayCheckVcodeWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed;

// 个人中心-支付密码 - 忘记 - 重置
+ (WLRequest *)resetPayPwdWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

// 个人中心 - 用户二维码
+ (WLRequest *)getUserQrcodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// 个人中心 - 设置邀请人
+ (WLRequest *)setInviteCodeWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// 个人中心 - 返佣记录
+ (WLRequest *)getRecommoneListWithParams:(NSDictionary *)params
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed;

// 个人中心 - 获取下一级
+ (WLRequest *)getRecommoneNextListWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed;

// 获取省市区数据
+ (WLRequest *)getSystemCityListWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

// 我的 - 设置 - 账户与安全
+ (WLRequest *)getUserSafeIndexWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

// 修改手机验证码
+ (WLRequest *)getChangeMobileVcodeWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed;

// 修改手机号
+ (WLRequest *)changeMobileWithParams:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed;

// 推广海报
+ (WLRequest *)getPosterWithParams:(NSDictionary *)params
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed;

// 抽奖
+ (WLRequest *)getLuckDrawWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

@end
