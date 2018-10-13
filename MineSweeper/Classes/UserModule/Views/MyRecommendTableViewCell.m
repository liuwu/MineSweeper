//
//  MyRecommendTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MyRecommendTableViewCell.h"

@interface MyRecommendTableViewCell()

@property (nonatomic, strong) QMUILabel *titleLabel1;
@property (nonatomic, strong) QMUILabel *titleLabel2;
@property (nonatomic, strong) QMUILabel *titleLabel3;
@property (nonatomic, strong) QMUILabel *titleLabel4;

@end

@implementation MyRecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
    }
    return self;
}

// 添加页面内容
- (void)addSubViews {
    QMUILabel *titleLabel1 = [[QMUILabel alloc] init];
    titleLabel1.font = UIFontMake(13.f);
    titleLabel1.textColor = WLColoerRGB(51.f);
    titleLabel1.numberOfLines = 0;
    // 居中设置
    titleLabel1.adjustsFontSizeToFitWidth = YES;
    titleLabel1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    // 控制文本内部宽度，让时间换行
    titleLabel1.contentEdgeInsets = UIEdgeInsetsMake(10, 18.f, 10.f, 18.f);
    [self.contentView addSubview:titleLabel1];
    self.titleLabel1 = titleLabel1;
    
    CGFloat width = DEVICE_WIDTH / 4.f;
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, self.contentView.height));
        make.left.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    QMUILabel *titleLabel2 = [[QMUILabel alloc] init];
    titleLabel2.font = UIFontMake(13.f);
    titleLabel2.textColor = WLColoerRGB(51.f);
    titleLabel2.numberOfLines = 0;
    // 居中设置
    titleLabel2.adjustsFontSizeToFitWidth = YES;
    titleLabel2.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    // 控制文本内部宽度，让时间换行
    titleLabel1.contentEdgeInsets = UIEdgeInsetsMake(10, 18.f, 10.f, 18.f);
    [self.contentView addSubview:titleLabel2];
    self.titleLabel2 = titleLabel2;
    
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel1);
        make.left.mas_equalTo(self.titleLabel1.mas_right);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    QMUILabel *titleLabel3 = [[QMUILabel alloc] init];
    titleLabel3.font = UIFontMake(13.f);
    titleLabel3.textColor = WLColoerRGB(51.f);
    titleLabel3.numberOfLines = 0;
    // 居中设置
    titleLabel3.adjustsFontSizeToFitWidth = YES;
    titleLabel3.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    // 控制文本内部宽度，让时间换行
    titleLabel3.contentEdgeInsets = UIEdgeInsetsMake(10, 18.f, 10.f, 18.f);
    [self.contentView addSubview:titleLabel3];
    self.titleLabel3 = titleLabel3;
    
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel1);
        make.left.mas_equalTo(self.titleLabel2.mas_right);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    QMUILabel *titleLabel4 = [[QMUILabel alloc] init];
    titleLabel4.font = UIFontMake(13.f);
    titleLabel4.textColor = WLColoerRGB(51.f);
    titleLabel4.numberOfLines = 0;
    // 居中设置
    titleLabel4.adjustsFontSizeToFitWidth = YES;
    titleLabel4.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    // 控制文本内部宽度，让时间换行
    titleLabel4.contentEdgeInsets = UIEdgeInsetsMake(10, 18.f, 10.f, 18.f);
    [self.contentView addSubview:titleLabel4];
    self.titleLabel4 = titleLabel4;
    
    [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(self.titleLabel1);
        make.width.mas_equalTo(120.f);
        make.height.mas_equalTo(self.contentView.height);
        make.left.mas_equalTo(self.titleLabel3.mas_right).mas_offset((width - 120.f) / 2.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView1.backgroundColor = WLColoerRGB(242.f);
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(.6f, self.contentView.height));
        make.left.mas_equalTo(self.titleLabel1.mas_right);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView2.backgroundColor = WLColoerRGB(242.f);
    [self.contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(.6f, self.contentView.height));
        make.left.mas_equalTo(self.titleLabel2.mas_right);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView3.backgroundColor = WLColoerRGB(242.f);
    [self.contentView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(.6f, self.contentView.height));
        make.left.mas_equalTo(self.titleLabel3.mas_right);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
//    lineView.backgroundColor = WLColoerRGB(242.f);
//    [self.contentView addSubview:lineView];
//    self.lineView = lineView;
//
//    self.lineView.frame = CGRectMake(0.f, self.contentView.size.height - .6f, DEVICE_WIDTH, .6f);
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _titleLabel1.font =  _titleFont;
    _titleLabel2.font =  _titleFont;
    _titleLabel3.font =  _titleFont;
    _titleLabel4.font =  _titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel1.textColor =  _titleColor;
    _titleLabel2.textColor = _titleColor;
    _titleLabel3.textColor = _titleColor;
    _titleLabel4.textColor = _titleColor;
}

- (void)setGridTitles:(NSArray<NSString *> *)gridTitles {
    _gridTitles = gridTitles;
    
    _titleLabel1.text = _gridTitles[0];
    _titleLabel2.text = _gridTitles[1];
    _titleLabel3.text = _gridTitles[2];
    _titleLabel4.text = _gridTitles[3];
}

@end
