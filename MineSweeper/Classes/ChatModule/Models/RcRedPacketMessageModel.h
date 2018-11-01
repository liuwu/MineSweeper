//
//  RcRedPacketMessageModel.h
//  MineSweeper
//
//  Created by liuwu on 2018/11/1.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "RCRedPacketGetMessage.h"
#import "RCRedPacketMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RcRedPacketMessageModel : RCMessage

/*!
 消息的内容
 */
@property(nonatomic, strong) RCRedPacketMessage *content;

@end

NS_ASSUME_NONNULL_END
