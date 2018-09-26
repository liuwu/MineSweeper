//
//  ActivityMapViewController.h
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "QDCommonViewController.h"

@interface ActivityMapViewController : QDCommonViewController

- (instancetype)initWithRCLocationMsg:(RCLocationMessage *)locationMsg;

- (instancetype)initWithAddress:(NSString *)address city:(NSString *)city;

@end
