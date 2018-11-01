//
//  RCRedPacketMessage.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/25.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCRedPacketMessageTypeIdentifier @"app:RedpackMsg"

@interface RCRedPacketMessage : RCMessageContent<RCMessageContentView>

// 红包ID
@property (nonatomic, strong) NSString *pack_id;
// 红包title
@property (nonatomic, strong) NSString *title;
// 红包总金额
@property (nonatomic, strong) NSString *total_money;
// 红包个数
@property (nonatomic, strong) NSString *num;
// 雷数
@property (nonatomic, strong) NSString *thunder;
// 是否领过
@property (nonatomic, strong) NSString *drawed;
// 领取金额
@property (nonatomic, strong) NSString *money;
// 红包领取者id
@property (nonatomic, strong) NSString *drawUid;
// 红包领取者名称
@property (nonatomic, strong) NSString *drawName;
/**  是否看过   */
@property (nonatomic, strong) NSNumber *isLook;
/**  评论人头像   */
@property (nonatomic, strong) NSString *avatar;
/**  发送人   */
@property (nonatomic, strong) NSString *name;

/**  发送人uid   */
@property (nonatomic, strong) NSNumber *uid;

/**  排序  */
@property (nonatomic, strong) NSNumber *sorted;

@end
