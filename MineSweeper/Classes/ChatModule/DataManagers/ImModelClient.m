//
//  ImModelClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ImModelClient.h"

@implementation ImModelClient

// IM - 聊天信息
+ (WLRequest *)getImChatInfoWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/chat_info"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 聊天信息 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 聊天信息 - 免打扰
+ (WLRequest *)setImChatNotDisturbWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/not_disturb"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 聊天信息 - 免打扰 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 聊天信息 - 取消免打扰
+ (WLRequest *)setImChatCancelNotDisturbWithParams:(NSDictionary *)params
                                           Success:(SuccessBlock)success
                                            Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/not_disturb_cancel"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 聊天信息 - 取消免打扰 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 聊天信息 - 取消聊天置顶
+ (WLRequest *)setImChatCancelIsTopWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/is_top_cancel"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 聊天信息 - 取消聊天置顶 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 红包 - 发红包
+ (WLRequest *)imSendRedpackWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/send_redpack"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 红包 - 发红包 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 红包 - 抢红包
+ (WLRequest *)imGrabRedpackWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/grab_redpack"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 红包 - 抢红包 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 红包 - 红包记录
+ (WLRequest *)getImRedpackHistoryWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/get_redpack"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 红包 - 红包记录 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 红包 - 我的红包记录
+ (WLRequest *)getMyImRedpackHistoryWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/get_my_redpack_record"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 红包 - 我的红包记录 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

@end
