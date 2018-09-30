//
//  RCRedPacketGetMessage.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/28.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RCRedPacketGetMessage.h"

@implementation RCRedPacketGetMessage

/*!
 返回消息的存储策略
 
 @return 消息的存储策略
 @discussion 指明此消息类型在本地是否存储、是否计入未读消息数。
 */
+(RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISPERSISTED;
}

#pragma mark - RCMessageCoding delegate methods
-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setValue:self.pack_id forKey:@"redpack_id"];
    [dataDict setValue:self.type forKey:@"type"];
    [dataDict setValue:self.tip_content forKey:@"tip_content"];
    [dataDict setValue:self.title forKey:@"title"];
    [dataDict setValue:self.total_money forKey:@"total_money"];
    [dataDict setValue:self.num forKey:@"num"];
    [dataDict setValue:self.thunder forKey:@"thunder"];
    [dataDict setValue:self.drawed forKey:@"drawed"];
    [dataDict setValue:self.drawUid forKey:@"drawUid"];
    [dataDict setValue:self.drawName forKey:@"drawName"];
    [dataDict setValue:self.money forKey:@"money"];
    [dataDict setValue:self.isLook forKey:@"isLook"];
    [dataDict setValue:self.uid forKey:@"uid"];
    [dataDict setValue:self.name forKey:@"name"];
    [dataDict setValue:self.avatar forKey:@"avatar"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    
    if (!data) return;
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    if (json) {
        self.pack_id = json[@"redpack_id"];
        self.type = json[@"type"];
        self.tip_content = json[@"tip_content"];
        self.title = json[@"title"];
        self.total_money = json[@"total_money"];
        self.num = json[@"num"];
        self.thunder = json[@"thunder"];
        self.drawed = json[@"drawed"];
        self.drawUid = json[@"drawUid"];
        self.drawName = json[@"drawName"];
        self.money = json[@"money"];
        self.isLook = json[@"isLook"];
        
        self.avatar = json[@"avatar"];
        self.name = json[@"name"];
        self.uid = json[@"uid"];
    }
}


+(NSString *)getObjectName {
    return RCRedPacketGetMessageTypeIdentifier;
}

/*!
 返回在会话列表和本地通知中显示的消息内容摘要
 
 @return 会话列表和本地通知中显示的消息内容摘要
 @discussion 如果您使用IMKit，当会话的最后一条消息为自定义消息时，需要通过此方法获取在会话列表展现的内容摘要；
 当App在后台收到消息时，需要通过此方法获取在本地通知中展现的内容摘要。
 */
- (NSString *)conversationDigest {
    //    if (self.type.integerValue == 4) {
    //        return [NSString stringWithFormat:@"%@赞了动态",self.name];
    //    }else if (self.type.integerValue == 3){
    //        return [NSString stringWithFormat:@"%@评论了动态", self.name];
    //    }
    return @"红包领取";
}

@end
