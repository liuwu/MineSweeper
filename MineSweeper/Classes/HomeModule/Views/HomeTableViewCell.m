//
//  HomeTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/13.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell()

@end

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.hidBottomLine = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor wl_HexE5E5E5];
    self.selectedBackgroundView = backView;
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:UIColorMake(254.f, 72.f, 30.f)]];
//    contentView.backgroundColor = UIColorMake(254.f, 72.f, 30.f);
    [self.contentView addSubview:contentView];
//    [contentView wl_setCornerRadius:10.f];
    contentView.layer.cornerRadius = 10.f;
    contentView.userInteractionEnabled = YES;
    [contentView wl_setLayerShadow:[UIColor grayColor] offset:CGSizeMake(2.f, 2.f) radius:5.f];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(16, kWL_NormalMarginWidth_10, 16, kWL_NormalMarginWidth_10));
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"home_boom_img"];
//    iconImageView.contentMode = UIViewContentModeScaleToFill;
    //    _iconImageView.hidden = YES;
    [contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
//    [iconImageView wl_setDebug:YES];
    
    [_iconImageView sizeToFit];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentView);
        make.width.mas_equalTo(self.iconImageView.width - kWL_NormalMarginWidth_12);
        make.bottom.mas_equalTo(contentView);
        make.right.mas_equalTo(contentView);    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = UIColorMake(242.f, 242., 242.);
    nameLabel.font = UIFontMake(24.f);
    nameLabel.text = @"扫雷游戏";
    [contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    [_nameLabel sizeToFit];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWL_NormalMarginWidth_15);
        make.left.mas_equalTo(kWL_NormalMarginWidth_20);
    }];
    
    UIButton *noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [noteBtn setTitle:@"查看游戏规则>>" forState:UIControlStateNormal];
    noteBtn.titleLabel.font = UIFontMake(14.f);
    // 扩大点击区域
    [noteBtn wl_setEnlargeEdgeWithTop:20 right:0.f bottom:0.f left:0.f];
    [noteBtn addTarget:self action:@selector(noteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:noteBtn];
    self.noteBtn = noteBtn;
    
    [_noteBtn sizeToFit];
    [_noteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.bottom + kWL_NormalMarginWidth_10);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [beginBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
    beginBtn.titleLabel.font = UIFontMake(14.f);
    [beginBtn setTitleColor:UIColorMake(254,72,30) forState:UIControlStateNormal];
    beginBtn.backgroundColor = UIColorMake(254,234,69);
    [beginBtn addTarget:self action:@selector(beginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:beginBtn];
//    [beginBtn wl_setCornerRadius:5.f];
    beginBtn.layer.cornerRadius = 5.f;
    beginBtn.userInteractionEnabled = NO;
    [beginBtn wl_setLayerShadow:[UIColor lightGrayColor] offset:CGSizeMake(2.f, 2.f) radius:1.f];
    self.beginBtn = beginBtn;
    
    [_beginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110.f, 30.f));
        make.bottom.mas_equalTo(-kWL_NormalMarginWidth_20);
        make.left.mas_equalTo(kWL_NormalMarginWidth_20);
    }];
    
}

//- (void)setUserMode:(WLUserModel *)userMode {
//    _userMode = userMode;
//    [_iconImagg sd_setImageWithURL:[NSURL URLWithString:[userMode.avatar wl_imageUrlDownloadImageSceneAvatar]] placeholderImage:[UIImage imageNamed:@"user_small"]];
//    [_nameLabel setText:userMode.name];
//    [_infoLabel setText:[userMode dispalyCompanyAndPosition]];
//    if (userMode.investorauth.integerValue==1) {
//        [_VCImageView setHidden:NO];
//    }else{
//        [_VCImageView setHidden:YES];
//    }
//}

//- (void)setSearchText:(NSString *)searchText{
//    _searchText = searchText;
//    _nameLabel.attributedText = [NSString wl_getAttributedInfoString:_userMode.name searchStr:_searchText color:[UIColor wl_hex0F6EF4] font:_nameLabel.font];
//    _infoLabel.attributedText = [NSString wl_getAttributedInfoString:_infoLabel.text searchStr:_searchText color:[UIColor wl_hex0F6EF4] font:_infoLabel.font];
//}

- (void)noteBtnClicked:(UIButton *)sender {
    DLog(@"noteBtnClicked-----");
}

- (void)beginBtnClicked:(UIButton *)sender {
    DLog(@"beginBtnClicked-----");
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [_iconImagg wl_setCornerRadius:(self.contentView.height- 20)/2];
}

@end
