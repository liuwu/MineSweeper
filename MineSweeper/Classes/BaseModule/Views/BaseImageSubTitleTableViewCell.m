//
//  BaseImageSubTitleTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/28.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseImageSubTitleTableViewCell.h"

@implementation BaseImageSubTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setRecommendModel:(IRecommendInfoModel *)recommendModel {
    _recommendModel = recommendModel;
    
    self.textLabel.text = _recommendModel.nickname;
    self.detailTextLabel.text = _recommendModel.num ? _recommendModel.num.stringValue : @"0";//_recommendModel.add_time;// @"2018-8-12";
    WEAKSELF
    [self.imageView setImageWithURL:[NSURL URLWithString:_recommendModel.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
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
    self.detailTextLabel.right = self.contentView.right - 10.f;
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
