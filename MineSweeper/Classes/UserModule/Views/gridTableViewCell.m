//
//  GridTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/17.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "GridTableViewCell.h"

@interface GridTableViewCell()

//@property (nonatomic, strong) QMUIGridView *gridView;

@property (nonatomic, strong) QMUILabel *titleLabel1;
@property (nonatomic, strong) QMUILabel *titleLabel2;
@property (nonatomic, strong) QMUILabel *titleLabel3;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation GridTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier gridTitles:(NSArray<NSString *> *)gridTitles {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.gridTitles = gridTitles;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self addSubViews];
//    }
//    return self;
//}

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
//    QMUIGridView *gridView = [[QMUIGridView alloc] init];
//    gridView.columnCount = self.gridTitles.count;
//    gridView.rowHeight = 44.f;
//    gridView.separatorWidth = PixelOne;
//    gridView.separatorColor = UIColorSeparator;
//    gridView.separatorDashed = NO;
//    [self.contentView addSubview:gridView];
//    self.gridView = gridView;
//    [_gridView wl_setDebug:YES];
//    [gridView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.contentView);
//    }];
    
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
//    [titleLabel1 wl_setDebug:YES];
    
    CGFloat width = DEVICE_WIDTH / 3.f;
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(width, self.contentView.height));
        make.width.mas_equalTo(120.f);
        make.height.mas_equalTo(self.contentView.height);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset((width - 120) / 2.f);
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
        make.size.mas_equalTo(CGSizeMake(width, self.contentView.height));
        make.centerX.mas_equalTo(self.contentView);
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
        make.size.mas_equalTo(CGSizeMake(width, self.contentView.height));
        make.right.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView1.backgroundColor = WLColoerRGB(242.f);
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(.6f, self.contentView.height));
        make.right.mas_equalTo(self.titleLabel2.mas_left);
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
    
//    for (NSInteger i = 0; i < 3; i++) {
//        QMUILabel *momeyLabel = [[QMUILabel alloc] init];
//        momeyLabel.text = self.gridTitles[i];
//        momeyLabel.font = UIFontMake(13.f);
//        momeyLabel.textColor = WLColoerRGB(51.f);
//        momeyLabel.numberOfLines = 0;
//        // 居中设置
//        momeyLabel.adjustsFontSizeToFitWidth = YES;
//        momeyLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        momeyLabel.textAlignment = NSTextAlignmentCenter;
//        // 控制文本内部宽度，让时间换行
//        momeyLabel.contentEdgeInsets = UIEdgeInsetsMake(10, 18.f, 10.f, 18.f);
//        momeyLabel.tag = 100+i;
//        [_gridView addSubview:momeyLabel];
//                [momeyLabel wl_setDebug:YES];
//    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = WLColoerRGB(242.f);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    self.lineView.frame = CGRectMake(0.f, self.contentView.size.height - .6f, DEVICE_WIDTH, .6f);
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _titleLabel1.font =  _titleFont;
    _titleLabel2.font =  _titleFont;
    _titleLabel3.font =  _titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel1.textColor =  _titleColor;
    _titleLabel2.textColor = _titleColor;
    _titleLabel3.textColor = _titleColor;
}

- (void)setGridTitles:(NSArray<NSString *> *)gridTitles {
    _gridTitles = gridTitles;
    
    _titleLabel1.text = _gridTitles[0];
    _titleLabel2.text = _gridTitles[1];
    _titleLabel3.text = _gridTitles[2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
