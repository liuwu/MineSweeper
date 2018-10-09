//
//  MyCardViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/10/8.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SLCommonGroupListViewController.h"

#import "ICardModel.h"

typedef void (^MyCardSelectedBlock)(ICardModel *cardModel);

@interface MyCardViewController : SLCommonGroupListViewController

@property (nonatomic, copy) MyCardSelectedBlock cardSelectBlock;

@end
