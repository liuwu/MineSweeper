//
//  IFriendRequestModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFriendRequestModel : NSObject

// 个人ID
@property (nonatomic, copy) NSString *uid;
// 好友ID
@property (nonatomic, copy) NSString *fuid;
// 好像昵称
@property (nonatomic, copy) NSString *fnickname;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 消息
@property (nonatomic, copy) NSString *message;
// 状态
@property (nonatomic, copy) NSString *status;
// 状态标题
@property (nonatomic, copy) NSString *status_title;
// 添加时间
@property (nonatomic, copy) NSString *add_time;


@end
