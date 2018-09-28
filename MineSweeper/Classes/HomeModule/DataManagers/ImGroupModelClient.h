//
//  ImGroupModelClient.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseModelClient.h"

@interface ImGroupModelClient : BaseModelClient


// IM- 群组 - 创建
+ (WLRequest *)setImGroupAddWithParams:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

// IM - 群组 - 加入
+ (WLRequest *)setImGroupJoinWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// IM - 群组 - 退出
+ (WLRequest *)setImGroupQuitWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// IM - 群组 - 群名称
+ (WLRequest *)setImGroupTitleWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// IM - 群组 - 删除群成员
+ (WLRequest *)deleteImGroupMemberWithParams:(NSDictionary *)params
                                     Success:(SuccessBlock)success
                                      Failed:(FailedBlock)failed;

// IM - 群组 - 成员
+ (WLRequest *)getImGroupMemberListWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed;

// IM - 群组 - 信息
+ (WLRequest *)getImGroupInfoWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// IM - 群组 - 列表
+ (WLRequest *)getImGroupListWithParams:(NSDictionary *)params
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

// IM - 群组 - 公告
+ (WLRequest *)setImGroupNoticeWithParams:(NSDictionary *)params
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed;

// IM - 群组 - 免打扰 - 取消
+ (WLRequest *)cancelImGroupNotDisturbWithParams:(NSDictionary *)params
                                         Success:(SuccessBlock)success
                                          Failed:(FailedBlock)failed;

// IM - 群组 - 置顶
+ (WLRequest *)setImGroupIsTopWithParams:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

// IM - 群组 - 置顶 - 取消
+ (WLRequest *)setImGroupCancelIsTopWithParams:(NSDictionary *)params
                                       Success:(SuccessBlock)success
                                        Failed:(FailedBlock)failed;

// IM - 群组 - 免打扰
+ (WLRequest *)setImGroupNotDisturbWithParams:(NSDictionary *)params
                                      Success:(SuccessBlock)success
                                       Failed:(FailedBlock)failed;

// IM - 群组 - 设置名片
+ (WLRequest *)setImGroupRemarkWithParams:(NSDictionary *)params
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed;

// IM - 红包 - 群组
+ (WLRequest *)setImGameGroupListWithParams:(NSDictionary *)params
                                    Success:(SuccessBlock)success
                                     Failed:(FailedBlock)failed;

// IM - 获取轮播图
+ (WLRequest *)getImBannerWithParams:(NSDictionary *)params
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

// IM - 获取系统公告
+ (WLRequest *)getImSystemNoticeWithParams:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

// IM - 获取系统公告详情
+ (WLRequest *)getImSystemNoticeDetailWithParams:(NSDictionary *)params
                                         Success:(SuccessBlock)success
                                          Failed:(FailedBlock)failed;

@end
