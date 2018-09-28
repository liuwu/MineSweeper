//
//  WLChatBaseViewController.h
//  Welian
//
//  Created by dong on 15/10/12.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface WLChatBaseViewController : RCConversationViewController

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;

/**
 *  @author dong, 15-11-24 16:11:53
 *  判断自己是否是投资人
 */
//- (BOOL)judgeInvestorAuth;

- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent;

@end
