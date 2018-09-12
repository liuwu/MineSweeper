//
//  SmsLoginViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, UseType)
{
    UseTypeSMS,
    UseTypeRegist,
};

@interface SmsLoginViewController : BaseViewController

@property (nonatomic, assign) UseType useType;

@end
