//
//  ChatInfoViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SLCommonGroupListViewController.h"

#import "IFriendModel.h"

@interface ChatInfoViewController : SLCommonGroupListViewController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) IFriendModel *friendModel;

@end
