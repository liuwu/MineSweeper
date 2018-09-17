//
//  GridTableViewCell.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/17.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridTableViewCell : UITableViewCell

// 文本内容
@property (nonatomic, strong) NSArray<NSString *> *gridTitles;

@property (nonatomic, copy) UIColor *titleColor;

@property (nonatomic, copy) UIFont *titleFont;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier gridTitles:(NSArray<NSString *> *)gridTitles;

@end
