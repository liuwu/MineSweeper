//
//  FriendModelClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "FriendModelClient.h"

@implementation FriendModelClient

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
+ (WLRequest *)getImMemberSearchWithParams:(NSDictionary *)params
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
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/friend_request_accept"
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
+ (WLRequest *)setImFriendRemarkWithParams:(NSDictionary *)params
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

@end
