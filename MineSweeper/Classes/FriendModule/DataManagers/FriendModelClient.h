//
//  FriendModelClient.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseModelClient.h"

@interface FriendModelClient : BaseModelClient

// IM - 获取 token
+ (WLRequest *)getImTokenWithParams:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

// IM - 添加好友 - 搜索
+ (WLRequest *)getImMemberSearchWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

// IM - 用户信息
+ (WLRequest *)getImMemberInfoWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// IM - 添加好友请求
+ (WLRequest *)getImFriendRequestWithParams:(NSDictionary *)params
                                    Success:(SuccessBlock)success
                                     Failed:(FailedBlock)failed;

// IM - 好友申请列表
+ (WLRequest *)getImFriendRequestListWithParams:(NSDictionary *)params
                                        Success:(SuccessBlock)success
                                         Failed:(FailedBlock)failed;

// IM - 好友申请 - 接受
+ (WLRequest *)acceptImFriendRequestWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed;

// IM - 好友申请 - 拒绝
+ (WLRequest *)rejectImFriendRequestWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed;

// IM - 通讯录
+ (WLRequest *)getImFriendListWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// IM - 好友信息 - 设置备注
+ (WLRequest *)setImFriendRemarkWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

// IM - 好友信息 - 删除
+ (WLRequest *)deleteImFriendWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

@end
