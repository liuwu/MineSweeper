//
//  CustomCardMessage.h
//  Welian
//
//  Created by dong on 15/6/16.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define WLCustomCardMessageTypeIdentifier @"WL:CardMsg"

@interface CustomCardMessage : RCMessageContent <RCMessageContentView>

@property (nonatomic, strong) NSDictionary *fromuser;

@property (nonatomic, strong) NSDictionary *card;

@property (nonatomic, strong) NSString *touser;

@property (nonatomic, strong) NSString *msg;


/**  活动文案   */
@property (nonatomic, strong) NSString *system_notice_content;


@end
