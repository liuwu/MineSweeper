//
//  ChatRedPacketCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/25.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatRedPacketCell.h"

@interface ChatRedPacketCell()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *redIconImageView;
//@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *statusLabel;
@property (nonatomic, strong) QMUILabel *timeLabel;

@end

@implementation ChatRedPacketCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self.baseContentView wl_setDebug:YES];
        [self.baseContentView setFrame:CGRectMake(0, 10, frame.size.width, frame.size.height)];
        
        UIView *backView = [[UIView alloc] init];
        [self.contentView addSubview:backView];
        self.backView = backView;
        
        UIImageView *redIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chats_redP_icon_full"]];
        [backView addSubview:redIconImageView];
        self.redIconImageView = redIconImageView;
        
//        UIImageView *logoImageView = [[UIImageView alloc] init];
//        logoImageView.image = [UIImage imageWithColor:[UIColor redColor]];
//        [logoImageView wl_setCornerRadius:36/2.f];
//        [self.contentView addSubview:logoImageView];
//        self.logoImageView = logoImageView;
        
        QMUILabel *nameLabel = [[QMUILabel alloc] init];
        nameLabel.font = UIFontBoldMake(15);
        nameLabel.textColor = [UIColor whiteColor];
        [backView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        QMUILabel *statusLabel = [[QMUILabel alloc] init];
        statusLabel.font = UIFontBoldMake(12);
        statusLabel.textColor = UIColorMake(255,181,164);
        [backView addSubview:statusLabel];
        self.statusLabel = statusLabel;
        
        QMUILabel *timeLabel = [[QMUILabel alloc] init];
        timeLabel.font = UIFontBoldMake(11);
        timeLabel.textColor = WLColoerRGB(153.f);
        timeLabel.backgroundColor = UIColorMake(240,241,243);
        [timeLabel wl_setCornerRadius:9.f];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        topView.alpha = .5f;
        [backView addSubview:topView];
        self.topView = topView;
        
//        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagGest:)];
//        tapG.numberOfTapsRequired = 1;
//        [backView addGestureRecognizer:tapG];
//        WEAKSELF
//        [backView bk_whenTapped:^{
//            [weakSelf didRedPacketTap];
//        }];
        
//        [logoImageView bk_whenTapped:^{
//            [weakSelf didLogoImageTap];
//        }];
        
//        UILongPressGestureRecognizer *msglongPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
//        msglongPressGr.minimumPressDuration = .5;
//        [self.titleLabel addGestureRecognizer:msglongPressGr];
//        UILongPressGestureRecognizer *cardlongPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
//        cardlongPressGr.minimumPressDuration = .5;
//        [self.cardView.tapBut addGestureRecognizer:cardlongPressGr];
    }
    return self;
}

// 头像点击
- (void)didLogoImageTap {
    if ([_cellDelegate respondsToSelector:@selector(chatRedPacketCell:didLogoImageTap:)]) {
        [_cellDelegate chatRedPacketCell:self didLogoImageTap:(RCRedPacketMessage *)self.model];
    }
}

// 红包点击
- (void)didRedPacketTap {
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) return;
    if ([_cellDelegate respondsToSelector:@selector(chatRedPacketCell:didTapCard:)]) {
        [_cellDelegate chatRedPacketCell:self didTapCard:(RCRedPacketMessage *)self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model
{
    self.model = model;
    RCRedPacketMessage *redPacketModel = (RCRedPacketMessage *)model.content;
//    self.cardList = [NSArray modelArrayWithClass:[CardStatuModel class] json:cardListM.cardlist];
    _nameLabel.text = @"15-9";
    _statusLabel.text = @"红包已发送";
    _timeLabel.text = @"2018/08/06  12:05:03";
    _timeLabel.hidden = !self.isDisplayMessageTime;
//    self.messageTimeLabel.text = @"208/08/06  12:05:03";;
//    _redIconImageView.image = [UIImage imageNamed:@"chats_redP_icon_full"];
    _redIconImageView.image = [UIImage imageNamed:@"chats_redP_icon_empty"];
    
//    [self.portraitImageView ]
//    _logoImageView.hidden =YES;
    UIImageView *logoImageView = (UIImageView *)self.portraitImageView;
    [logoImageView wl_setDebug:YES];
    
    
    [self.baseContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57, 65.f));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10.f);
    }];
    
    if (redPacketModel.uid.integerValue == configTool.loginUser.uid.intValue) {
        _topView.hidden = YES;
        // 设置红包背景图
        [_backView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:UIColorMake(254,72,30) borderWidth:1 backgroundColor:UIColorMake(254,72,30) backgroundImage:[UIImage imageWithColor:UIColorMake(254,72,30)] contentMode:UIViewContentModeScaleAspectFill];
        
//         [_topView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeScaleAspectFill];
        
//        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
//            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10.f);
//            make.top.mas_equalTo(self.baseContentView);
//        }];
        
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10.f);
            make.top.mas_equalTo(self.baseContentView);
        }];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57 - 119.f, 65.f));
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10.f);
            make.right.mas_equalTo(logoImageView.mas_left).mas_offset(-10.f);
        }];
    } else {
        _topView.hidden = NO;
        // 设置红包背景图
        [_backView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:UIColorMake(254,72,30) borderWidth:1 backgroundColor:UIColorMake(254,72,30) backgroundImage:[UIImage imageWithColor:UIColorMake(254,72,30)] contentMode:UIViewContentModeScaleAspectFill];
        
        [_topView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeBottomRight];
        
//        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
//            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10.f);
//            make.top.mas_equalTo(self.baseContentView);
//        }];
        
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10.f);
            make.top.mas_equalTo(self.baseContentView);
        }];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57 - 119.f, 65.f));
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10.f);
            make.left.mas_equalTo(logoImageView.mas_right).mas_offset(10.f);
        }];
    }
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView);
    }];
    
    [_redIconImageView sizeToFit];
    [_redIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).mas_offset(20.f);
        make.centerY.mas_equalTo(self.backView);
    }];
    
    [_nameLabel sizeToFit];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.redIconImageView.mas_right).mas_offset(5.f);
        make.top.mas_equalTo(self.redIconImageView.mas_top).mas_offset(10.f);
    }];
    
    [_statusLabel sizeToFit];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(3.f);
    }];
    
//    [_timeLabel sizeToFit];
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.contentView);
//        make.top.mas_equalTo(self.baseContentView.mas_top).mas_offset(-22.f);
//    }];
}

+ (CGSize)cellHigetWithModel:(RCMessageModel *)model {
    static CGFloat cardX = 10.f;
    RCRedPacketMessage *packetModel = (RCRedPacketMessage *)model.content;
    CGFloat cardHigh = 65.f;
    if (model) {
        
    }
    return CGSizeMake(DEVICE_WIDTH, cardHigh+20);
}

/*!
 自定义消息 Cell 的 Size
 
 @param model               要显示的消息model
 @param collectionViewWidth cell所在的collectionView的宽度
 @param extraHeight         cell内容区域之外的高度
 
 @return 自定义消息Cell的Size
 
 @discussion 当应用自定义消息时，必须实现该方法来返回cell的Size。
 其中，extraHeight是Cell根据界面上下文，需要额外显示的高度（比如时间、用户名的高度等）。
 一般而言，Cell的高度应该是内容显示的高度再加上extraHeight的高度。
 */
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(DEVICE_WIDTH, model.isDisplayMessageTime ? 130.f : 85.f);
}

@end
