//
//  GridTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/17.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "GridTableViewCell.h"

@interface GridTableViewCell()

@property (nonatomic, strong) QMUIGridView *gridView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier gridTitles:(NSArray<NSString *> *)gridTitles {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.gridTitles = gridTitles;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
    }
    return self;
}

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
    QMUIGridView *gridView = [[QMUIGridView alloc] init];
    gridView.columnCount = self.gridTitles.count;
    gridView.rowHeight = 44.f;
    gridView.separatorWidth = PixelOne;
    gridView.separatorColor = UIColorSeparator;
    gridView.separatorDashed = NO;
    [self.contentView addSubview:gridView];
    self.gridView = gridView;
//    [_gridView wl_setDebug:YES];
    
    [gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    for (NSInteger i = 0; i < self.gridTitles.count; i++) {
        QMUILabel *momeyLabel = [[QMUILabel alloc] init];
        momeyLabel.text = self.gridTitles[i];
        momeyLabel.font = UIFontMake(13.f);
        momeyLabel.textColor = WLColoerRGB(51.f);
        momeyLabel.numberOfLines = 0;
        // 居中设置
        momeyLabel.adjustsFontSizeToFitWidth = YES;
        momeyLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        momeyLabel.textAlignment = NSTextAlignmentCenter;
        // 控制文本内部宽度，让时间换行
        momeyLabel.contentEdgeInsets = UIEdgeInsetsMake(10, 19.f, 10.f, 19.f);
        momeyLabel.tag = 100+i;
        [self.gridView addSubview:momeyLabel];
        //        [momeyLabel wl_setDebug:YES];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = WLColoerRGB(242.f);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    self.lineView.frame = CGRectMake(0.f, self.contentView.size.height - .6f, DEVICE_WIDTH, .6f);
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger i = 0; i < self.gridTitles.count; i++) {
        QMUILabel *momeyLabel = [self viewWithTag:100 + i];
        momeyLabel.text = self.gridTitles[i];
        momeyLabel.font = self.titleFont;// UIFontMake(13.f);
        momeyLabel.textColor = self.titleColor;// WLColoerRGB(51.f);
    }
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
