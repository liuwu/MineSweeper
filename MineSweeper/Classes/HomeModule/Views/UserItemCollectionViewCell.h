//
//  UserItemCollectionViewCell.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IFriendModel.h"

@interface UserItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) QMUILabel *titleLabel;

@property (nonatomic, strong) IFriendModel *friendModel;

@end
