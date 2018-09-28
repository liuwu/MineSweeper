//
//  IFriendModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFriendModel : NSObject<NSCopying>

// 首字母
@property (nonatomic, copy) NSString *firstPinyin;
// 用户ID
@property (nonatomic, copy) NSString *uid;
// 用户ID
@property (nonatomic, copy) NSString *id_num;
// 手机
@property (nonatomic, copy) NSString *mobile;
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 好友备注
@property (nonatomic, copy) NSString *remark;
// 是否置顶：0：否，1：是
@property (nonatomic, copy) NSString *is_top;
// 是否免打扰：0：否，1：是
@property (nonatomic, copy) NSString *not_disturb;
// 聊天背景
@property (nonatomic, copy) NSString *chat_image;

@end
