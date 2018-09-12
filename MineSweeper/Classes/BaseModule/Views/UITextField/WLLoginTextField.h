//
//  WLLoginTextField.h
//  WLAlertController
//
//  Created by dong on 2018/7/17.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WLLoginTextFieldType)
{
    WLLoginTextFieldTypeDefault,
    WLLoginTextFieldTypePassword,
    WLLoginTextFieldTypePhone,
};

@interface WLLoginTextField : UIView

@property (nonatomic, copy, readonly) NSString *areaCode;
@property (nonatomic, strong) UITextField *textField;

//type为WLLoginTextFieldTypePhone时有用
@property (nonatomic, copy,readonly) NSString *phone;

@property (nonatomic, copy) void (^areaChangedBlock)(NSString *areaCode);

- (instancetype)initWithTextFieldType:(WLLoginTextFieldType)textFieldType;
- (void)showPhoneNumberSaved;

@end
