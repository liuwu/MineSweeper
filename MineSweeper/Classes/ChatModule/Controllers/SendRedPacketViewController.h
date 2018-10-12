//
//  SendRedPacketViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "QDCommonViewController.h"

typedef void (^SendRedPacketSuccessBlock)(RCMessage *sendMsg);

@interface SendRedPacketViewController : QDCommonViewController

@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) SendRedPacketSuccessBlock sendRedPacketBlock;

@end
