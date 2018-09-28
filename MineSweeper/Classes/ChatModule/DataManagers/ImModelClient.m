//
//  ImModelClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ImModelClient.h"

@implementation ImModelClient

// IM - 获取 token
+ (WLRequest *)getImTokenWithParams:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/get_token"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 获取 token ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 添加好友 - 搜索
+ (WLRequest *)searchAddFriendWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/member_search"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 添加好友 - 搜索 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 用户信息
+ (WLRequest *)getImMemberInfoWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/member_info"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 用户信息 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 添加好友
+ (WLRequest *)sendImFriendRequestWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/friend_request"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 添加好友 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 好友申请列表
+ (WLRequest *)getImFriendRequestListWithParams:(NSDictionary *)params
                                        Success:(SuccessBlock)success
                                         Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/friend_request_list"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 好友申请列表 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 好友申请 - 接受
+ (WLRequest *)acceptImFriendRequestWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/friend_request_accept"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 好友申请 - 接受 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 好友申请 - 拒绝
+ (WLRequest *)rejectImFriendRequestWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/friend_request_refuse"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 好友申请 - 拒绝 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 通讯录
+ (WLRequest *)getImFriendListWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/friend_list"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 通讯录 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 好友信息 - 设置备注
+ (WLRequest *)saveImFriendRemarkWithParams:(NSDictionary *)params
                                    Success:(SuccessBlock)success
                                     Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/friend_remark"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 好友信息 - 设置备注 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 好友信息 - 删除
+ (WLRequest *)deleteImFriendWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/friend_del"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 好友信息 - 删除 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}


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

// IM - 聊天信息 - 聊天置顶
+ (WLRequest *)setImChatIsTopWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/is_top"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 聊天信息 - 聊天置顶 ---- %@",describe(resultInfo));
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
