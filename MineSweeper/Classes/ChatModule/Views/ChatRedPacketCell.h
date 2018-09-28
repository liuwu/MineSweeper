//
//  ChatRedPacketCell.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/25.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#import "RCRedPacketMessage.h"

@class ChatRedPacketCell,RCRedPacketMessage;


@interface ChatRedPacketCell : RCMessageCell 

+ (CGSize)cellHigetWithModel:(RCMessageModel *)model;

@end
