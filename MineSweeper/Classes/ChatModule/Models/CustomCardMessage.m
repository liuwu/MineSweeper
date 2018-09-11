//
//  CustomCardMessage.m
//  Welian
//
//  Created by dong on 15/6/16.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CustomCardMessage.h"

@implementation CustomCardMessage

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark - RCMessageCoding delegate methods
-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.card forKey:@"card"];
    [dataDict setObject:self.touser forKey:@"touser"];
    [dataDict setObject:self.msg forKey:@"msg"];
    [dataDict setObject:self.fromuser forKeyedSubscript:@"fromuser"];
    [dataDict setObject:self.system_notice_content forKeyedSubscript:@"system_notice_content"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"content":[dataDict wl_jsonPrettyStringEncoded]}
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    
    if (!data) {
        return;
    }
    NSError *error = [[NSError alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    if (json) {
        NSString *contentStr = [json objectForKey:@"content"];
        NSDictionary *dataDic = [contentStr wl_jsonValueDecoded];
        if (dataDic) {
            self.card = dataDic[@"card"];
            self.touser = dataDic[@"uid"];
            self.msg = dataDic[@"msg"];
            self.fromuser = dataDic[@"fromuser"];
            self.system_notice_content = dataDic[@"system_notice_content"];
        }
    }
}


+(NSString *)getObjectName {
    return WLCustomCardMessageTypeIdentifier;
}

- (NSString *)conversationDigest
{
    NSString *chatMsg = @"";
    NSInteger cardType = [[self.card objectForKey:@"type"] integerValue];
    switch (cardType) {
//        case WLBubbleMessageCardTypeActivity://活动
//            chatMsg = @"推荐了一个同城活动";
//            break;
//        case WLBubbleMessageCardTypeProject://项目
//            chatMsg = @"推荐了一个项目";
//            break;
//        case WLBubbleMessageCardTypeWeb://网页
//            chatMsg = @"[链接]";
//            break;
//        case WLBubbleMessageCardTypeInvestorGet://索要项目
//            chatMsg = @"[项目]";
//            break;
//        case WLBubbleMessageCardTypeInvestorPost://投递项目
//            chatMsg = @"[项目]";
//            break;
//        case WLBubbleMessageCardTypeInvestorUser://用户名片卡片
//            chatMsg = @"发来一张名片";
//            break;
//        case WLBubbleMessageCardTypeCircle://圈子
//            chatMsg = @"推荐了一个圈子";
//            break;
//        case WLBubbleMessageCardTypeProjectSet://项目集
//            chatMsg = @"分享了一个项目集";
//            break;
//        case WLBubbleMessageCardTypeInvestorDetail://投资人
//            chatMsg = @"推荐了一个投资人";
//            break;
//        case WLBubbleMessageCardTypeFinaceActivity://融资活动
//            chatMsg = @"推荐了一个路演大赛";
//            break;
    
        default:
            chatMsg = @"对方刚给你发了一条消息，您当前版本无法查看，快去升级吧.";
            break;
    }
    
    if (self.system_notice_content.length > 0) {
        chatMsg = self.system_notice_content;
    }
    
    return chatMsg;;
}

@end
