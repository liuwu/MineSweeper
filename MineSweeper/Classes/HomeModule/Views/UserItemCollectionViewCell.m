//
//  UserItemCollectionViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "UserItemCollectionViewCell.h"

@interface UserItemCollectionViewCell()

@end

@implementation UserItemCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    UIImageView *logoImageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
    [logoImageView wl_setCornerRadius:25.f];
//    [logoImageView wl_setBorderWidth:0.8f color:WLColoerRGB(153.f)];
    [self.contentView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(49, 49));
        make.top.mas_equalTo(20.f);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.font = UIFontMake(12);
    titleLabel.textColor = WLColoerRGB(51.f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.minimumScaleFactor = .6f;
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
//    [titleLabel wl_setDebug:YES];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.contentView.width, 20.f));
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).mas_offset(5.f);
    }];
}

- (void)setFriendModel:(IFriendModel *)friendModel {
    _friendModel = friendModel;
    
    self.titleLabel.text = _friendModel.nickname;// _userArray[indexPath.row];
    WEAKSELF
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_friendModel.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
                                 weakSelf.logoImageView.image = [image qmui_imageWithClippedCornerRadius:49.f/2];
                             }else {
                                 weakSelf.logoImageView.image = [UIImage imageNamed:@"game_friend_icon"];
                             }
                         }];
}

@end
