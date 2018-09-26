//
//  RCRedPacketMessage.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/25.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RCRedPacketMessage.h"

@implementation RCRedPacketMessage


/*!
 返回消息的存储策略
 
 @return 消息的存储策略
 @discussion 指明此消息类型在本地是否存储、是否计入未读消息数。
 */
+(RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

#pragma mark - RCMessageCoding delegate methods
-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setValue:self.avatar forKey:@"avatar"];
    [dataDict setValue:self.commentid forKey:@"commentid"];
//    [dataDict setValue:self.created forKey:@"created"];
//    [dataDict setValue:self.feedcontent forKey:@"feedcontent"];
//    [dataDict setValue:self.feedid forKey:@"feedid"];
//    [dataDict setValue:self.feedpic forKey:@"feedpic"];
//    [dataDict setValue:self.msg forKey:@"msg"];
    [dataDict setValue:self.name forKey:@"name"];
//    [dataDict setValue:self.type forKey:@"type"];
    [dataDict setValue:self.uid forKey:@"uid"];
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
        self.avatar = json[@"avatar"];
        self.commentid = json[@"commentid"];
        self.name = json[@"name"];
        self.uid = json[@"uid"];
    }
}


+(NSString *)getObjectName {
    return RCRedPacketMessageTypeIdentifier;
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
    return @"红包消息";
}

@end
