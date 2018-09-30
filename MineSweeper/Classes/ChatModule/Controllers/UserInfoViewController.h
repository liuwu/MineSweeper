//
//  UserInfoViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SLCommonGroupListViewController.h"
#import "IFriendModel.h"

@interface UserInfoViewController : SLCommonGroupListViewController

// 好友信息
//@property (nonatomic, strong) IFriendModel *friendModel;
@property (nonatomic, copy) NSString *userId;

@end
