//
//  FriendListViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

//#import "BaseViewController.h"
#import "SLCommonGroupListViewController.h"

typedef NS_ENUM(NSInteger, FriendListType)
{
    FriendListTypeNormal,       //普通好友列表
    FriendListTypeForTransfer,   //转账
    FriendListTypeForGroupChat   //群聊
};

@interface FriendListViewController : SLCommonGroupListViewController

@property (nonatomic, assign) FriendListType frindListType;

- (instancetype)initWithFriendListType:(FriendListType)frindListType;

@end
