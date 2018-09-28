//
//  ImGroupModelClient.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ImGroupModelClient.h"

@implementation ImGroupModelClient

// IM- 群组 - 创建
+ (WLRequest *)setImGroupAddWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_add"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM- 群组 - 创建 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 加入
+ (WLRequest *)setImGroupJoinWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_join"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 加入 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 退出
+ (WLRequest *)setImGroupQuitWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_quit"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 退出 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 群名称
+ (WLRequest *)setImGroupTitleWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_title"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 群名称 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 删除群成员
+ (WLRequest *)deleteImGroupMemberWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_member_del"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 删除群成员 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 成员
+ (WLRequest *)getImGroupMemberListWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/group_member_list"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 成员 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 信息
+ (WLRequest *)getImGroupInfoWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/group_info"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 群组 - 信息 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 群组 - 列表
+ (WLRequest *)getImGroupListWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/group_list"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 群组 - 列表 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 群组 - 公告
+ (WLRequest *)setImGroupNoticeWithParams:(NSDictionary *)params
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_notice"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 群组 - 公告 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 群组 - 免打扰 - 取消
+ (WLRequest *)cancelImGroupNotDisturbWithParams:(NSDictionary *)params
                                         Success:(SuccessBlock)success
                                          Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_not_disturb_cancel"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 免打扰 - 取消 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 置顶
+ (WLRequest *)setImGroupIsTopWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_is_top"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 置顶---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 置顶 - 取消
+ (WLRequest *)setImGroupCancelIsTopWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_is_top_cancel"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 置顶 - 取消 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 免打扰
+ (WLRequest *)setImGroupNotDisturbWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_not_disturb"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 免打扰 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 群组 - 设置名片
+ (WLRequest *)setImGroupRemarkWithParams:(NSDictionary *)params
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed {
    WLRequest *api = [self postWithParams:params apiMethodName:@"App/IM/IM/group_remark"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 群组 - 设置名片 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 红包 - 群组
+ (WLRequest *)setImGameGroupListWithParams:(NSDictionary *)params
                                    Success:(SuccessBlock)success
                                     Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/game_group_list"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 红包 - 群组 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 获取轮播图
+ (WLRequest *)getImBannerWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/get_banner"
                                  Success:^(id resultInfo) {
                                      DLog(@"IM - 获取轮播图 ---- %@",describe(resultInfo));
                                      SAFE_BLOCK_CALL(success,resultInfo);
                                  } Failed:^(NSError *error) {
                                      // 统一错误处理
                                      //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                      SAFE_BLOCK_CALL(failed, error);
                                  }];
    return api;
}

// IM - 获取系统公告
+ (WLRequest *)getImSystemNoticeWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/get_notice"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 获取系统公告 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

// IM - 获取系统公告详情
+ (WLRequest *)getImSystemNoticeDetailWithParams:(NSDictionary *)params
                                         Success:(SuccessBlock)success
                                          Failed:(FailedBlock)failed {
    WLRequest *api = [self getWithParams:params apiMethodName:@"App/IM/IM/get_notice_detail"
                                 Success:^(id resultInfo) {
                                     DLog(@"IM - 获取系统公告详情 ---- %@",describe(resultInfo));
                                     SAFE_BLOCK_CALL(success,resultInfo);
                                 } Failed:^(NSError *error) {
                                     // 统一错误处理
                                     //                     [WLNetWorkingProcessFilter checkErrorWithRequest:request customMsg:nil];
                                     SAFE_BLOCK_CALL(failed, error);
                                 }];
    return api;
}

@end
