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

@protocol ChatRedPacketCellDelegate <NSObject,RCMessageCellDelegate>

- (void)chatRedPacketCell:(ChatRedPacketCell *)redPacketCell didTapCard:(RCRedPacketMessage *)model;

- (void)chatRedPacketCell:(ChatRedPacketCell *)redPacketCell didLogoImageTap:(RCRedPacketMessage *)model;

@end


@interface ChatRedPacketCell : RCMessageCell //RCMessageBaseCell

@property (nonatomic, weak) id <ChatRedPacketCellDelegate> cellDelegate;

+ (CGSize)cellHigetWithModel:(RCMessageModel *)model;

@end
