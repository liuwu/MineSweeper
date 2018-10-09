//
//  MyCardViewCell.h
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ICardModel.h"

@interface MyCardViewCell : BaseTableViewCell

@property (nonatomic, strong) ICardModel *cardModel;

@end
