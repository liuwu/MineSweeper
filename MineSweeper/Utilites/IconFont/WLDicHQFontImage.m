//
//  WLDicHQFontImage.m
//  ddssds
//
//  Created by 丁彦鹏 on 2018/1/12.
//  Copyright © 2018年 丁彦鹏. All rights reserved.
//

#import "WLDicHQFontImage.h"


@interface WLDicHQFontImage()
@end

@implementation WLDicHQFontImage

static NSDictionary *_dic;


+ (NSDictionary*)IconDictionary
{
    return [self dic];
}

+ (NSDictionary *)dic {
    if (!_dic) {
        _dic = @{@"visual":@"\U0000e68d",
                 @"invisual":@"\U0000e68e",
                 @"get_coupon":@"\U0000e67d",
                 @"inputBar_emoji":@"\U0000e675",
                 @"inputBar_keyboard":@"\U0000e674",
                 @"inputBar_topic":@"\U0000e67e",
                 @"inputBar_photo":@"\U0000e67c",
                 @"inputBar_camera":@"\U0000e676",
                 @"certified_investor_s":@"\U0000e670",
                 @"add_project_s":@"\U0000e66d",
                 @"make_post_s":@"\U0000e66e",
                 @"guide":@"\U0000e671",
                 @"orderItem":@"\U0000e659",
                 @"play3":@"\U0000e655",
                 @"projectDetail":@"\U0000e686",
                 @"userinfo":@"\U0000e641",
                 @"share":@"\U0000e640",
                 @"joinGroupChat":@"\U0000e63f",
                 @"makeFriend":@"\U0000e63b",
                 @"myGroupChat":@"\U0000e630",
                 @"organizeGroupChat":@"\U0000e62f",
                 @"scan":@"\U0000e62e",
                 @"like":@"\U0000e625",
                 @"comment":@"\U0000e624",
                 @"transport":@"\U0000e623",
                 @"edit":@"\U0000e63d",
                 @"more":@"\U0000e62d",
                 @"readed":@"\U0000e638",
                 @"makeMoreFriends":@"\U0000e635",
                 @"businessCard":@"\U0000e636",
                 @"download":@"\U0000e628",
                 @"downloaded":@"\U0000e634",
                 @"search":@"\U0000e63a",
                 @"delete":@"\U0000e63e",
                 @"message":@"\U0000e639",
                 @"postFeed":@"\U0000e637",
                 @"back":@"\U0000e633",
                 @"scanscan":@"\U0000e632",
                 @"collected":@"\U0000e62c",
                 @"collecte":@"\U0000e62b",
                 @"qrcode":@"\U0000e62a",
                 @"authenticate":@"\U0000e629",
                 @"createProject":@"\U0000e627",
                 @"close":@"\U0000e63c",
                 @"close2":@"\U0000e64a",
                 @"about":@"\U0000e64c",
                 @"play2":@"\U0000e64b",
                 @"stop2":@"\U0000e647",
                 @"play":@"\U0000e645",
                 @"stop":@"\U0000e649",
                 @"next":@"\U0000e644",
                 @"last":@"\U0000e642",
                 @"lock":@"\U0000e643",
                 @"down":@"\U0000e648",
                 @"liancoin":@"\U0000e646",
                 @"push":@"\U0000e64d",
                 @"lessonItem":@"\U0000e64e",
                 @"lessonArticle":@"\U0000e64f",
                 @"ticket":@"\U0000e651",
                 @"projectDetailXingbiaoSel":@"\U0000e688",
                 @"projectDetailXingbiao":@"\U0000e687",
                 @"codeLogin":@"\U0000e690",
                 @"passwordLogin":@"\U0000e682",
                 @"weChatLogin":@"\U0000e685",
                 @"inputVisible":@"\U0000e68d",
                 @"inputInvisible":@"\U0000e68e",
                 @"inputClear":@"\U0000e68f",
                 @"horn":@"\U0000e6b3",
                 @"quickReplyKeyboard":@"\U0000e68a",
                 @"quickReplySet":@"\U0000e689",
                 @"microphone":@"\U0000e68b",
                 @"keyboard_s":@"\U0000e674",
                 @"emoj_s":@"\U0000e675",
                 @"web_link":@"\U0000e668",
                 @"refresh":@"\U0000e6b2",
                 @"shaixuan":@"\U0000e692",
                 };
    }
    return _dic;
}

@end
