//
//  BaseImageTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/27.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseImageTableViewCell.h"

#import "IFriendModel.h"
#import "WLRongCloudDataSource.h"

@implementation BaseImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setGroupModel:(IGameGroupModel *)groupModel {
    _groupModel = groupModel;
    self.textLabel.text = _groupModel.title;// @"小尹子";
    WEAKSELF
    [self.imageView setImageWithURL:[NSURL URLWithString:_groupModel.image]
                        placeholder:[UIImage imageNamed:@"game_group_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
                                 //                                 image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
                                 weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                             } else {
                                 weakSelf.imageView.image = [UIImage imageNamed:@"game_group_icon"];
                             }
                         }];
}

- (void)setFriendRequestModel:(IFriendRequestModel *)friendRequestModel {
    _friendRequestModel = friendRequestModel;
    self.textLabel.text = _friendRequestModel.fnickname;// @"小尹子";
    self.detailTextLabel.text = _friendRequestModel.message;
    WEAKSELF
    [self.imageView setImageWithURL:[NSURL URLWithString:_friendRequestModel.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
                                 //                                 image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
                                 weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                             }else {
                                 weakSelf.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
                             }
                         }];
}

- (void)setFriendModel:(IFriendModel *)friendModel {
    _friendModel = friendModel;
    self.textLabel.text = _friendModel.nickname;// @"小尹子";
    WEAKSELF
    [self.imageView setImageWithURL:[NSURL URLWithString:_friendModel.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
                                 //                                 image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
                                 weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                             }else {
                                 weakSelf.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
                             }
                         }];
}

- (void)setRedPacketMemberModel:(IRedPacektMemberModel *)redPacketMemberModel {
    _redPacketMemberModel = redPacketMemberModel;
    
    self.textLabel.text = _redPacketMemberModel.nickname;// @"小尹子";
    self.detailTextLabel.text = _redPacketMemberModel.update_time;
    WEAKSELF
    [self.imageView setImageWithURL:[NSURL URLWithString:_redPacketMemberModel.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
                                 //                                 image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
                                 weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                             }else {
                                 weakSelf.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
                             }
                         }];
}

- (void)setMyRedPacketModel:(IMyRedPacketModel *)myRedPacketModel {
    _myRedPacketModel = myRedPacketModel;
    
    self.textLabel.text = _myRedPacketModel.from_nickname;// @"小尹子";
    self.detailTextLabel.text = _myRedPacketModel.update_time;
    WEAKSELF
    [self.imageView setImageWithURL:[NSURL URLWithString:_myRedPacketModel.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
                                 //                                 image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
                                 weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                             }else {
                                 weakSelf.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
                             }
                         }];
}

- (void)setConversationResult:(RCSearchConversationResult *)conversationResult {
    _conversationResult = conversationResult;
    
    RCConversation *conData = _conversationResult.conversation;
    RCMessageContent *lastestMessage = conData.lastestMessage;
    if (conData.conversationType == ConversationType_PRIVATE) {
        if ([lastestMessage isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *txtMsg = (RCTextMessage *)lastestMessage;
            self.detailTextLabel.text = txtMsg.content;//
        }
        
        self.textLabel.text = @" ";//message.senderUserInfo.name;
        //        long time = conData.messageDirection == MessageDirection_RECEIVE  ? conData.receivedTime : conData.sentTime;
        WEAKSELF
        [[WLRongCloudDataSource shareInstance] getLocalUserInfoWithUserId:conData.targetId completion:^(IFriendModel *friendModel) {
            weakSelf.textLabel.text = friendModel.nickname;//message.senderUserInfo.name;
            [weakSelf.imageView setImageWithURL:[NSURL URLWithString:friendModel.avatar]
                                    placeholder:[UIImage imageNamed:@"game_friend_icon"]
                                        options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                                     completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                         if (image) {
                                             weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                                         }else {
                                             weakSelf.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
                                         }
                                     }];
        }];
    }
    
    if (conData.conversationType == ConversationType_GROUP) {
        if ([lastestMessage isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *txtMsg = (RCTextMessage *)lastestMessage;
            self.detailTextLabel.text = txtMsg.content;//
        }
        
        self.textLabel.text = @" ";//message.senderUserInfo.name;
        //        long time = conData.messageDirection == MessageDirection_RECEIVE  ? conData.receivedTime : conData.sentTime;
        WEAKSELF
        [weakSelf.imageView.image = [UIImage imageNamed:@"game_group_icon"] qmui_imageWithClippedCornerRadius:36.f/2];
        [[WLRongCloudDataSource shareInstance] getLocalGroupInfoWithGroupId:conData.targetId completion:^(IGameGroupModel *groupModel) {
            weakSelf.textLabel.text = groupModel.title;//message.senderUserInfo.name;
        }];
    }
    //    self.textLabel.text = conData.conversationTitle;

}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView wl_setCornerRadius:36.f/2];
//    [self.imageView wl_setBorderWidth:0.5f color:WLColoerRGB(153.f)];
    self.imageView.size = CGSizeMake(36.f, 36.f);
    self.imageView.centerY = self.contentView.height / 2.f;
    self.imageView.left = 10.f;
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
//        make.centerY.mas_equalTo(self.contentView);
//        make.left.mas_equalTo(10.f);
//    }];
    self.textLabel.left = self.imageView.right + 10.f;
    if (_showBadge) {
        self.detailTextLabel.size = CGSizeMake(20.f, 20.f);
        self.detailTextLabel.right = self.contentView.width - 10.f;
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.left = self.imageView.right + 10.f;
    }
//    if (self.style == UITableViewCellStyleValue1) {
//        self.detailTextLabel.right = self.contentView.width - 15.f;
//    } else {
//        self.detailTextLabel.left = self.imageView.right + 10.f;
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
