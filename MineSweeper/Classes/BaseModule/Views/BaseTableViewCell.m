//
//  BaseTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/17.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
    }
    return self;
}

// 添加页面内容
- (void)addSubViews {    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = WLColoerRGB(242.f);
    lineView.hidden = YES;
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lineView.hidden = !_showBottomLine;
    _lineView.frame = CGRectMake(0.f, self.contentView.size.height - .6f, DEVICE_WIDTH, .6f);
//    self.imageView.size = CGSizeMake(40.f, 40.f);
//    self.imageView.left = 10.f;
//    self.textLabel.left = self.imageView.right + 10.f;
}

@end
