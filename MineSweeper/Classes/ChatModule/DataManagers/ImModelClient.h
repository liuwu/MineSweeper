//
//  ImModelClient.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseModelClient.h"

@interface ImModelClient : BaseModelClient

// IM - 获取 token
+ (WLRequest *)getImTokenWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// IM - 添加好友 - 搜索
+ (WLRequest *)searchAddFriendWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// IM - 用户信息
+ (WLRequest *)getImMemberInfoWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// IM - 添加好友
+ (WLRequest *)sendImFriendRequestWithParams:(NSDictionary *)params
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
+ (WLRequest *)saveImFriendRemarkWithParams:(NSDictionary *)params
                                    Success:(SuccessBlock)success
                                     Failed:(FailedBlock)failed;

// IM - 好友信息 - 删除
+ (WLRequest *)deleteImFriendWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;



// IM - 聊天信息
+ (WLRequest *)getImChatInfoWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// IM - 聊天信息 - 免打扰
+ (WLRequest *)setImChatNotDisturbWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed;

// IM - 聊天信息 - 取消免打扰
+ (WLRequest *)setImChatCancelNotDisturbWithParams:(NSDictionary *)params
                                           Success:(SuccessBlock)success
                                            Failed:(FailedBlock)failed;

// IM - 聊天信息 - 聊天置顶
+ (WLRequest *)setImChatIsTopWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// IM - 聊天信息 - 取消聊天置顶
+ (WLRequest *)setImChatCancelIsTopWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed;

// IM - 红包 - 发红包
+ (WLRequest *)imSendRedpackWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// IM - 红包 - 抢红包
+ (WLRequest *)imGrabRedpackWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// IM - 红包 - 红包记录
+ (WLRequest *)getImRedpackHistoryWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed;

// IM - 红包 - 我的红包记录
+ (WLRequest *)getMyImRedpackHistoryWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed;

@end
