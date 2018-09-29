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
//@property (nonatomic, strong) UIView *topCoreView;
@property (nonatomic, strong) UIImageView *redIconImageView;
//@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *statusLabel;
//@property (nonatomic, strong) QMUILabel *timeLabel;

@end

@implementation ChatRedPacketCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self.baseContentView wl_setDebug:YES];
//        [self.baseContentView setFrame:CGRectMake(0, 10, frame.size.width, frame.size.height)];
        
        UIView *backView = [[UIView alloc] init];
        [self.messageContentView addSubview:backView];
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
        
//        QMUILabel *timeLabel = [[QMUILabel alloc] init];
//        timeLabel.font = UIFontBoldMake(11);
//        timeLabel.textColor = WLColoerRGB(153.f);
//        timeLabel.backgroundColor = UIColorMake(240,241,243);
//        [timeLabel wl_setCornerRadius:9.f];
//        [self.contentView addSubview:timeLabel];
//        self.timeLabel = timeLabel;
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        topView.alpha = .5f;
        topView.hidden = YES;
        topView.userInteractionEnabled = YES;
        [self.messageContentView addSubview:topView];
        self.topView = topView;
        
//        UIView *topCoreView = [[UIView alloc] init];
//        topCoreView.backgroundColor = [UIColor whiteColor];
//        topCoreView.alpha = .5f;
//        topCoreView.hidden = YES;
//        [self.messageContentView addSubview:topCoreView];
//        self.topCoreView = topCoreView;
        
        
//        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagGest:)];
//        tapG.numberOfTapsRequired = 1;
//        [backView addGestureRecognizer:tapG];
//        [backView setUserInteractionEnabled:NO];
        WEAKSELF
        [backView bk_whenTapped:^{
            [weakSelf didRedPacketTap];
        }];
    }
    return self;
}

// 红包点击
- (void)didRedPacketTap {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model
{
    [super setDataModel:model];
    RCRedPacketMessage *redPacketModel = (RCRedPacketMessage *)model.content;
//    self.cardList = [NSArray modelArrayWithClass:[CardStatuModel class] json:cardListM.cardlist];
    _nameLabel.text = redPacketModel.title;// @"15-9";
    _statusLabel.text = redPacketModel.drawed.boolValue ? @"红包已领取" : @"游戏红包";
//    _timeLabel.text = @"2018/08/06  12:05:03";
//    _timeLabel.hidden = !self.isDisplayMessageTime;
//    self.messageTimeLabel.text = @"208/08/06  12:05:03";;
//    _redIconImageView.image = [UIImage imageNamed:@"chats_redP_icon_full"];
    _redIconImageView.image = [UIImage imageNamed:@"chats_redP_icon_empty"];
//    _backView.backgroundColor = redPacketModel.isGet.boolValue ? [UIColor grayColor] : UIColorMake(254,72,30);
//    [self.portraitImageView ]
//    _logoImageView.hidden =YES;
//    UIImageView *logoImageView = (UIImageView *)self.portraitImageView;
//    [logoImageView wl_setDebug:YES];
    
    
//    [self.baseContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57, 65.f));
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10.f);
//    }];
//    [_backView wl_setDebug:YES];
//    [self.messageContentView wl_setDebug:YES];
//    [self.baseContentView wl_setDebug:YES];
    
    if (model.messageDirection == MessageDirection_SEND) {
        // 设置红包背景图
        if (redPacketModel.drawed.boolValue) {
            _topView.hidden = NO;
//            _topCoreView.hidden = NO;
//            [_topView wl_setCornerRadius:18];
//            [_topView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withImage:[UIImage qmui_imageWithView:_topView]];
             [_topView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeScaleAspectFill];
        } else {
            _topView.hidden = YES;
             [_backView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:UIColorMake(254,72,30) borderWidth:1 backgroundColor:UIColorMake(254,72,30) backgroundImage:[UIImage imageWithColor:UIColorMake(254,72,30)] contentMode:UIViewContentModeScaleAspectFill];
        }
       
        
//         [_topView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeScaleAspectFill];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.messageContentView);
//            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57 - 119.f, 65.f));
            //            make.top.mas_equalTo();
//            make.right.mas_equalTo(self.baseContentView.mas_left).mas_offset(-10.f);
        }];
        
//        [_topCoreView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
//            make.right.mas_equalTo(self.backView);
//            make.top.mas_equalTo(self.backView);
//        }];
        
//        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57 - 119.f, 65.f));
////            make.top.mas_equalTo();
//            make.right.mas_equalTo(self.baseContentView.mas_left).mas_offset(-10.f);
//        }];
    } else {
//        self.messageDirection = MessageDirection_RECEIVE;
//        [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57 - 119.f, 65.f));
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10.f);
//        }];
//
        // 设置红包背景图
        if (redPacketModel.drawed.boolValue) {
            _topView.hidden = NO;
//            _topCoreView.hidden = NO;
            [_topView wl_setCornerRadius:18];
//            [_topView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withImage:[[UIImage qmui_imageWithView:_topView]];
//            [_topView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:[UIColor greenColor] borderWidth:1.f];
//            [_backView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:UIColorMake(255,164,143) borderWidth:1 backgroundColor:UIColorMake(255,164,143) backgroundImage:[UIImage imageWithColor:UIColorMake(255,164,143)] contentMode:UIViewContentModeScaleAspectFill];
            [_topView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeScaleAspectFill];
        } else {
            _topView.hidden = YES;
            [_backView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:UIColorMake(254,72,30) borderWidth:1 backgroundColor:UIColorMake(254,72,30) backgroundImage:[UIImage imageWithColor:UIColorMake(254,72,30)] contentMode:UIViewContentModeScaleAspectFill];
        }
        
        // 设置红包背景图
//        [_backView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:UIColorMake(254,72,30) borderWidth:1 backgroundColor:UIColorMake(254,72,30) backgroundImage:[UIImage imageWithColor:UIColorMake(254,72,30)] contentMode:UIViewContentModeScaleAspectFill];
        
//        [_topView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeBottomRight];
//        [_topView wl_setCornerRadius:18.f];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.messageContentView);
            //            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 57 - 119.f, 65.f));
            //            make.top.mas_equalTo();
            //            make.right.mas_equalTo(self.baseContentView.mas_left).mas_offset(-10.f);
        }];
        
//        [_topCoreView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
//            make.left.mas_equalTo(self.backView);
//            make.top.mas_equalTo(self.backView);
//        }];
    }
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.messageContentView);
        //        make.edges.mas_equalTo(self.backView);
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
