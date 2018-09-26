//
//  WLChatLocationViewController.h
//  Welian
//
//  Created by dong on 15/10/22.
//  Copyright © 2015年 chuansongmen. All rights reserved.
//

//#import "BasicViewController.h"
#import "QDCommonViewController.h"

typedef void (^SendLocationMsgeBlock)(RCLocationMessage *locMessage);

@interface WLChatLocationViewController : QDCommonViewController// BasicViewController

- (instancetype)initWithSendLocationMsgeBlock:(SendLocationMsgeBlock)locMesgBlcok;

@end
