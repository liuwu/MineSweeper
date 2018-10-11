//
//  ChatGetRedPacketCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/28.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatGetRedPacketCell.h"

#import "RCRedPacketGetMessage.h"

@interface ChatGetRedPacketCell()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *redIconImageView;
@property (nonatomic, strong) QMUILabel *titleLabel;
@property (nonatomic, strong) QMUIButton *redBtn;

@end

@implementation ChatGetRedPacketCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = UIColorMake(240,241,243);
        [backView wl_setCornerRadius:9.f];
        [self.baseContentView addSubview:backView];
        self.backView = backView;
        
        UIImageView *redIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chats_redPsmall_icon"]];
        [backView addSubview:redIconImageView];
        self.redIconImageView = redIconImageView;
        
        QMUILabel *titleLabel = [[QMUILabel alloc] init];
        titleLabel.font = UIFontBoldMake(11);
        titleLabel.textColor = [UIColor lightGrayColor];
        [backView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        QMUIButton *redBtn = [[QMUIButton alloc] init];
        [redBtn setTitle:@"红包" forState:UIControlStateNormal];
        [redBtn setTitleColor:UIColorMake(254,72,30) forState:UIControlStateNormal];
        redBtn.titleLabel.font = UIFontBoldMake(11);
        redBtn.backgroundColor = [UIColor clearColor];
        [redBtn addTarget:self action:@selector(redBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:redBtn];
        self.redBtn = redBtn;
    }
    return self;
}

- (void)redBtnClicked:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model
{
    [super setDataModel:model];
    RCRedPacketGetMessage *redPacketModel = (RCRedPacketGetMessage *)model.content;
    //    self.cardList = [NSArray modelArrayWithClass:[CardStatuModel class] json:cardListM.cardlist];
    NSString *infoStr = @"";
    if (redPacketModel.tip_content.length > 0) {
        infoStr = redPacketModel.tip_content;
    } else {
        if (redPacketModel.type.integerValue == 1) {
            infoStr = [NSString stringWithFormat:@"%@领取了你的", redPacketModel.drawName];
        } else {
            infoStr = [NSString stringWithFormat:@"你领取了%@的", redPacketModel.drawName];
        }
    }
    _titleLabel.text = infoStr;
    _redIconImageView.image = [UIImage imageNamed:@"chats_redPsmall_icon"];
    
    CGSize size = [infoStr wl_sizeWithFont:UIFontBoldMake(11) constrainedToWidth:DEVICE_WIDTH - 20];
    
    [_titleLabel sizeToFit];
    [_redIconImageView sizeToFit];
    [_redBtn sizeToFit];
    
    CGFloat backWith = _titleLabel.width + _redBtn.width + _redIconImageView.width + 30.f;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(backWith , 18));
        make.centerX.mas_equalTo(self.baseContentView);
        make.centerY.mas_equalTo(self.baseContentView);
    }];
    
    [_redIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).mas_offset(10.f);
        make.centerY.mas_equalTo(self.backView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.redIconImageView.mas_right).mas_offset(5.f);
        make.centerY.mas_equalTo(self.redIconImageView);
    }];
    
    [_redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
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
    return CGSizeMake(DEVICE_WIDTH, model.isDisplayMessageTime ? 78.f : 48.f);
}

@end
