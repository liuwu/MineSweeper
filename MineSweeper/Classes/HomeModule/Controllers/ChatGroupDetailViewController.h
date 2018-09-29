//
//  ChatGroupDetailViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SLCommonGroupListViewController.h"
#import "IGroupDetailInfo.h"

@interface ChatGroupDetailViewController : SLCommonGroupListViewController


@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, strong) IGroupDetailInfo *groupDetailInfo;

@end
