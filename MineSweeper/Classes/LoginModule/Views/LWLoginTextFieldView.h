//
//  LWLoginTextFieldView.h
//  MineSweeper
//
//  Created by liuwu on 2018/9/12.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LWLoginTextFieldType)
{
    LWLoginTextFieldTypeDefault,
    LWLoginTextFieldTypePassword,
    LWLoginTextFieldTypePhone,
    LWLoginTextFieldTypeImageVcode,
    LWLoginTextFieldTypeVcode,
    LWLoginTextFieldTypeMoney,
};


@interface LWLoginTextFieldView : UIView

@property (nonatomic, strong) UITextField *textField;

// 类型是LWLoginTextFieldTypeMoney时，设置的
@property (nonatomic, strong) QMUILabel *titleLabel;
@property (nonatomic, strong) QMUILabel *subTitleLabel;

//type为WLLoginTextFieldTypePhone时有用
@property (nonatomic, copy,readonly) NSString *phone;

/**
 控制当在编辑时，是否高亮文本框的Border,默认是YES
 */
@property (nonatomic,assign) BOOL isChangeBorder;

/**默认边框颜色*/
@property (nonatomic,copy) UIColor *defaultBorderColor;
/**默认边框宽度*/
@property (nonatomic,assign) CGFloat defaultBorderWidth;
/**编辑时边框颜色*/
@property (nonatomic,copy) UIColor *selectBorderColor;
/**占位文本的颜色*/
@property (nonatomic,copy) UIColor *placeholderColor;
/**最多输入长度*/
@property (nonatomic,assign) int maxTextLength;

- (instancetype)initWithTextFieldType:(LWLoginTextFieldType)textFieldType;
//- (void)showPhoneNumberSaved;

@end
