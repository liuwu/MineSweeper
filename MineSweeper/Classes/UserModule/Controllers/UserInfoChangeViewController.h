//
//  UserInfoChangeViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "QDCommonViewController.h"

#import "IFriendDetailInfoModel.h"

typedef NS_ENUM(NSInteger, UserInfoChangeType)
{
    UserInfoChangeTypeNickName,
    UserInfoChangeTypeRealName,
    UserInfoChangeTypeSetFriendRemark,
};

@interface UserInfoChangeViewController : QDCommonViewController

@property (nonatomic, assign) UserInfoChangeType changeType;

@property (nonatomic, copy) NSString *uid;

- (instancetype)initWithUserInfoChangeType:(UserInfoChangeType)changeType;

@end
