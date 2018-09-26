//
//  SmsLoginViewController.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "BaseViewController.h"
#import "QDCommonViewController.h"

typedef NS_ENUM(NSInteger, UseType)
{
    UseTypeSMS,
    UseTypeRegist,
    UseTypeForget,
    UseTypeRestPwd,
};

@interface SmsLoginViewController : QDCommonViewController//BaseViewController

@property (nonatomic, assign) UseType useType;

- (instancetype)initWithUseType:(UseType)useType;

@end
