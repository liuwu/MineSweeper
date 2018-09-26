//
//  RCRedPacketMessage.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/25.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCRedPacketMessageTypeIdentifier @"RC:RedPacketMsg"

@interface RCRedPacketMessage : RCMessageContent<RCMessageContentView>


/**  该条消息的id   */
@property (nonatomic, strong) NSNumber *commentid;

/**  是否看过   */
@property (nonatomic, strong) NSNumber *isLook;

/**  评论人头像   */
@property (nonatomic, strong) NSString *avatar;

/**  评论人姓名   */
@property (nonatomic, strong) NSString *name;

/**  评论人uid   */
@property (nonatomic, strong) NSNumber *uid;

@end
