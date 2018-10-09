//
//  ChatRedPacketCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/25.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatRedPacketCell.h"
#import "RcRedPacketMessageExtraModel.h"

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
        
        UIView *topView = [[UIView alloc] init];
//        topView.backgroundColor = [UIColor whiteColor];
        topView.alpha = .5f;
//        topView.hidden = YES;
//        topView.userInteractionEnabled = YES;
        [self.messageContentView addSubview:topView];
        self.topView = topView;
        
//        UIView *topCoreView = [[UIView alloc] init];
//        topCoreView.backgroundColor = [UIColor whiteColor];
//        topCoreView.alpha = .5f;
//        topCoreView.hidden = YES;
//        [self.messageContentView addSubview:topCoreView];
//        self.topCoreView = topCoreView;
        WEAKSELF
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf didRedPacketTap];
        }];
        [backView addGestureRecognizer:tap];
        [topView addGestureRecognizer:tap];
//        [backView bk_whenTapped:^{
//            [weakSelf didRedPacketTap];
//        }];
//
//        [topView bk_whenTapped:^{
//            [weakSelf didRedPacketTap];
//        }];
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
    _nameLabel.text = redPacketModel.title;// @"15-9";
    RCMessage *message = [[RCIMClient sharedRCIMClient] getMessage:model.messageId];
    // 设置扩展字段 红包状态 0：默认  1：已领取 2：红包已抢完 3：红包过期
    RcRedPacketMessageExtraModel *extraModel = nil;
    if (message.extra.length > 0) {
        extraModel = [RcRedPacketMessageExtraModel modelWithJSON:message.extra];
    }
    NSString *statusStr = @"游戏红包";
    if (extraModel) {
        switch (extraModel.status.integerValue) {
            case 1:{
                    statusStr = @"红包已领取";
            }
                break;
            case 2:
            {
                statusStr = @"红包已抢完";
            }
                break;
            case 3:
            {
                statusStr = @"红包过期";
            }
                break;
            default:
                break;
        }
    }
    
    _statusLabel.text = statusStr;
    _redIconImageView.image = [UIImage imageNamed:@"chats_redP_icon_empty"];
    
    if (extraModel && extraModel.status.integerValue > 0) {
        _topView.hidden = NO;
    } else {
        _topView.hidden = YES;
    }
    if (model.messageDirection == MessageDirection_SEND) {
        [_topView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeScaleAspectFill];
        
        [_backView wl_setWLRadius:WLRadiusMake(18, 0, 18, 18) withBorderColor:UIColorMake(254,72,30) borderWidth:1 backgroundColor:UIColorMake(254,72,30) backgroundImage:[UIImage imageWithColor:UIColorMake(254,72,30)] contentMode:UIViewContentModeScaleAspectFill];
    } else {
        [_topView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:[UIColor whiteColor] borderWidth:1 backgroundColor:[UIColor whiteColor] backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] contentMode:UIViewContentModeScaleAspectFill];
        
        [_backView wl_setWLRadius:WLRadiusMake(0, 18, 18, 18) withBorderColor:UIColorMake(254,72,30) borderWidth:1 backgroundColor:UIColorMake(254,72,30) backgroundImage:[UIImage imageWithColor:UIColorMake(254,72,30)] contentMode:UIViewContentModeScaleAspectFill];
    }
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.messageContentView);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.messageContentView);
//                make.edges.mas_equalTo(self.backView);
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
}

//+ (CGSize)cellHigetWithModel:(RCMessageModel *)model {
//    static CGFloat cardX = 10.f;
//    RCRedPacketMessage *packetModel = (RCRedPacketMessage *)model.content;
//    CGFloat cardHigh = 65.f;
//    if (model) {
//        
//    }
//    return CGSizeMake(DEVICE_WIDTH, cardHigh+20);
//}

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
    CGFloat height = 65 + 20;//红包高度 + 上下间距
    if (model.isDisplayMessageTime) {
        // 显示时间
        height += 45.f;// 时间45
    }
    if (model.isDisplayNickname) {
        // 显示用户名
        height += 12.f + 4;
    }
    return CGSizeMake(DEVICE_WIDTH, height);
}

@end
