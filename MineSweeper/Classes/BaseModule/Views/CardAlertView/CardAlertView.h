//
//  CardAlertView.h
//  Welian
//
//  Created by weLian on 15/3/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardStatuModel;

typedef void(^sendCardSuccessBlock)(NSString *text, CardStatuModel *cardModel);
@interface CardAlertView : UIView

@property (strong,nonatomic) sendCardSuccessBlock sendSuccessBlock;

//设置输入框默认输入信息
@property (strong,nonatomic) NSString *noteInfo;

- (instancetype)initWithCardModel:(CardStatuModel *)cardModel;

//显示
- (void)show;

@end
