//
//  IGroupDetailInfo.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/26.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IFriendModel.h"

@interface IGroupDetailInfo : NSObject

// 群组ID对应返回的id
@property (nonatomic, copy) NSString *groupId;
// 群组标题
@property (nonatomic, copy) NSString *title;
// 创建者UID
@property (nonatomic, copy) NSString *_uid;
// 群组类型 0 普通群组 1游戏群组
@property (nonatomic, copy) NSNumber *type;
// 是否加入群组 0：否，1：是
@property (nonatomic, copy) NSNumber *is_exist;
// 备注
@property (nonatomic, copy) NSString *remark;
// 是否禁言 0否 1是
@property (nonatomic, copy) NSString *is_disable;
// 是否置顶，0不置顶
@property (nonatomic, copy) NSString *is_top;
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSString *notice_time;
// 禁止打扰 0：否 1是
@property (nonatomic, copy) NSString *not_disturb;
@property (nonatomic, copy) NSString *activity_id;
// 成员列表
@property (nonatomic, strong) NSArray *member_list;

@end
