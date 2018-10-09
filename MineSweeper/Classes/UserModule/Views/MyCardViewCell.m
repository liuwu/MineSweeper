//
//  MyCardViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MyCardViewCell.h"

@interface MyCardViewCell()

@property (nonatomic, strong) QMUILabel *titleLabel1;
@property (nonatomic, strong) QMUILabel *titleLabel2;
@property (nonatomic, strong) QMUILabel *titleLabel3;
@property (nonatomic, strong) QMUILabel *titleLabel4;

@end

@implementation MyCardViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectZero];
//    infoView.backgroundColor = UIColorMake(254,72,30);
    [self.contentView addSubview:infoView];
    [infoView wl_setWLRadius:WLRadiusMake(10.f, 10.f, 0.f, 0.f) withBackgroundColor:UIColorMake(254,72,30)];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DEVICE_WIDTH - 20.f);
        make.height.mas_equalTo(self.contentView.mas_height).mas_offset(-10);
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
    }];
    
    QMUILabel *titleLabel1 = [[QMUILabel alloc] init];
    titleLabel1.font = UIFontMake(12.f);
    titleLabel1.textColor = [UIColor whiteColor];
    [infoView addSubview:titleLabel1];
    self.titleLabel1 = titleLabel1;
    [titleLabel1 sizeToFit];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(infoView.mas_left).mas_offset(25.f);
        make.top.mas_equalTo(infoView.mas_top).mas_offset(15.f);
    }];
    
    QMUILabel *titleLabel2 = [[QMUILabel alloc] init];
    titleLabel2.font = UIFontMake(9.f);
    titleLabel2.textColor = [UIColor whiteColor];
    [infoView addSubview:titleLabel2];
    self.titleLabel2 = titleLabel2;
    [titleLabel2 sizeToFit];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel1.mas_right).mas_offset(15.f);
        make.bottom.mas_equalTo(titleLabel1.mas_bottom);
    }];
    
    QMUILabel *titleLabel3 = [[QMUILabel alloc] init];
    titleLabel3.font = UIFontMake(15.f);
    titleLabel3.textColor = [UIColor whiteColor];
    [infoView addSubview:titleLabel3];
    self.titleLabel3 = titleLabel3;
//    [titleLabel3 wl_setDebug:YES];
    
    QMUILabel *titleLabel4 = [[QMUILabel alloc] init];
    titleLabel4.font = UIFontMake(15.f);
    titleLabel4.textColor = [UIColor whiteColor];
    [infoView addSubview:titleLabel4];
    self.titleLabel4 = titleLabel4;
//    [titleLabel4 wl_setDebug:YES];
    [titleLabel4 sizeToFit];
    [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel3.mas_right);
        make.bottom.mas_equalTo(infoView.mas_bottom).mas_offset(-15.f);
    }];
    
    [titleLabel3 sizeToFit];
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(infoView.mas_left).mas_offset(25.f);
        make.centerY.mas_equalTo(titleLabel4).mas_offset(2);
    }];
}

- (void)setCardModel:(ICardModel *)cardModel {
    _cardModel = cardModel;
    
    _titleLabel1.text = cardModel.bank_adress;
    _titleLabel2.text = cardModel.type;
    _titleLabel3.text = @"****　****　****　";//[NSString stringWithFormat:@"****　****　****　%@", [cardModel.account substringFromIndex:(cardModel.account.length - 4)]];
    _titleLabel4.text = [cardModel.account substringFromIndex:(cardModel.account.length - 4)];
    
}



@end
