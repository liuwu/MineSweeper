//
//  IFriendDetailInfoModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFriendDetailInfoModel : NSObject

@property (nonatomic, copy) NSString *uid;
// 用户ID
@property (nonatomic, copy) NSNumber *id_num;
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 好友备注
@property (nonatomic, copy) NSString *remark;
// 性别 1：男 2：女
@property (nonatomic, copy) NSString *gender;
// 是否好友：0：否，1：是
@property (nonatomic, copy) NSNumber *is_friend;
// 是否我添加的：0：否，1：是
@property (nonatomic, copy) NSNumber *is_me_add;
// 描述
@property (nonatomic, copy) NSString *desc;
//
@property (nonatomic, copy) NSString *updates_image;
//
@property (nonatomic, copy) NSString *is_mute;

// 获取登录用户性别
- (UIImage *)getLoginUserSex;

@end
