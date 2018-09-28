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


// 红包ID
@property (nonatomic, strong) NSString *pack_id;
// 红包title
@property (nonatomic, strong) NSString *title;
// 红包总金额
@property (nonatomic, copy) NSString *total_money;
// 红包个数
@property (nonatomic, copy) NSString *num;
// 雷数
@property (nonatomic, copy) NSString *thunder;
// 是否领过
@property (nonatomic, copy) NSString *isGet;
/**  是否看过   */
@property (nonatomic, strong) NSNumber *isLook;

/**  评论人头像   */
@property (nonatomic, strong) NSString *avatar;

/**  评论人姓名   */
@property (nonatomic, strong) NSString *name;

/**  评论人uid   */
@property (nonatomic, strong) NSNumber *uid;

@end
