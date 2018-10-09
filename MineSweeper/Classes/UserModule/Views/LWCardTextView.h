//
//  LWCardTextView.h
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LWCardTextViewType)
{
    LWCardTextViewTypeDefault, // 默认
    LWCardTextViewTypeCardNO, //卡号
};


@interface LWCardTextView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *number;

// 类型是LWLoginTextFieldTypeMoney时，设置的
@property (nonatomic, strong) QMUILabel *titleLabel;

- (instancetype)initWithType:(LWCardTextViewType)type;

@end
