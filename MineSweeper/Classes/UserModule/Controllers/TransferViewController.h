//
//  TransferViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "QDCommonViewController.h"
#import "IFriendModel.h"

@interface TransferViewController : QDCommonViewController

// 转账的用户
@property (nonatomic, strong) IFriendModel *friendModel;

@end
