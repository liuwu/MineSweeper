//
//  BaseImageTableViewCell.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/27.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "IFriendModel.h"
#import "IGameGroupModel.h"
#import "IFriendRequestModel.h"
#import "IRedPacektMemberModel.h"
#import "IMyRedPacketModel.h"


@interface BaseImageTableViewCell : BaseTableViewCell


@property (nonatomic, strong) IFriendModel *friendModel;

@property (nonatomic, strong) IGameGroupModel *groupModel;

@property (nonatomic, strong) IFriendRequestModel *friendRequestModel;

@property (nonatomic, strong) IRedPacektMemberModel *redPacketMemberModel;

@property (nonatomic, strong) IMyRedPacketModel *myRedPacketModel;

@property (nonatomic, strong) RCSearchConversationResult *conversationResult;


@property (nonatomic, assign) BOOL showBadge;

@end
