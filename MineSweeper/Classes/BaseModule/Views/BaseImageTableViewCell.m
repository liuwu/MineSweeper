//
//  BaseImageTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/27.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseImageTableViewCell.h"

@implementation BaseImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = CGSizeMake(40.f, 40.f);
    self.imageView.left = 10.f;
    //    self.textLabel.left = self.imageView.right + 10.f;
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
