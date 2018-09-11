//
//  WLShareFriendsTool.h
//  Welian
//
//  Created by dong on 2016/11/25.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareFriendsController.h"

@class CardStatuModel;
@interface WLShareFriendsTool : NSObject
single_interface(WLShareFriendsTool)


- (void)shareFriendsWithModel:(CardStatuModel *)cardStatuModel;



- (void)shareFriendsWithImage:(UIImage *)image;

@end
