//
//  MyRecommendTableViewCell.h
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MyRecommendTableViewCell : BaseTableViewCell

// 文本内容
@property (nonatomic, strong) NSArray<NSString *> *gridTitles;

@property (nonatomic, copy) UIColor *titleColor;

@property (nonatomic, copy) UIFont *titleFont;


@end
