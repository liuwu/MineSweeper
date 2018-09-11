//
//  CardStatuModel.h
//  Welian
//
//  Created by dong on 15/3/9.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardStatuModel : NSObject

// cid 为0 时表示已删除
@property (nonatomic, strong) NSNumber *cid;
 //3 活动，10项目，11 网页  13 投递项目卡片 14 用户名片卡片 15 投资人索要项目卡片 16圈子  20项目集
//2.7.7.1 20 新增项目集 22 融资活动
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *subType;//  1代表转推的项目  2: 推荐的
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSNumber *relationid;

@property (nonatomic, strong) NSNumber *viewType;
@property (nonatomic, strong) NSString *welian_comment;
@property (nonatomic, strong) NSString *logo;

@end
