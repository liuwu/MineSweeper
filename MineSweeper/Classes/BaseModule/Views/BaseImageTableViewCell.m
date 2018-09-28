//
//  BaseImageTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/27.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseImageTableViewCell.h"

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
    self.detailTextLabel.left = self.imageView.right + 10.f;
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
