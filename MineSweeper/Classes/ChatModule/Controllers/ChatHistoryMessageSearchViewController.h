//
//  ChatHistoryMessageSearchViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/29.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SLCommonTableViewController.h"

typedef NS_ENUM(NSInteger, ChatHistoryType)
{
    ChatHistoryTypePrivate, //单聊
    ChatHistoryTypeGroup, //群聊
};

@interface ChatHistoryMessageSearchViewController : SLCommonTableViewController

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) ChatHistoryType chatHistoryType;

@property (nonatomic, copy) NSString *targetId;

- (instancetype)initWithStyle:(UITableViewStyle)style ChatHistoryType:(ChatHistoryType)chatHistoryType;

@end
