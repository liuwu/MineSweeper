//
//  ChatHistoryTableViewCell.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/29.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ChatHistoryTableViewCell : BaseTableViewCell

@property (nonatomic, strong) RCMessage *message;

//返回cell的高度
+ (CGFloat)configureWithMessage:(RCMessage *)message;

@end
