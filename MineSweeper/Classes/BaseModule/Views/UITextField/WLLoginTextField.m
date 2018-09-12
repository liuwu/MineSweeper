//
//  WLLoginTextField.m
//  WLAlertController
//
//  Created by dong on 2018/7/17.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import "WLLoginTextField.h"
#import "UITextField+Limit.h"

@interface WLLoginTextField ()

@property (nonatomic, assign) WLLoginTextFieldType textFieldType;
@property (nonatomic, strong) UIButton *areaCodeButton;
@property (nonatomic, strong) UIButton *plaintextButton;

@property (nonatomic, copy, readwrite) NSString *areaCode;

@end

@implementation WLLoginTextField

- (instancetype)initWithTextFieldType:(WLLoginTextFieldType)textFieldType {
    _textFieldType = textFieldType;
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.areaCode = @"+86";
        [self setQmui_borderPosition:QMUIBorderViewPositionBottom];
        self.textField = [[UITextField alloc] init];
        self.textField.enablesReturnKeyAutomatically = YES;
        self.textField.textColor = UIColor.wl_Hex333333;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:self.textField];
        self.textField.font = WLFONT(16);
        switch (_textFieldType) {
            case WLLoginTextFieldTypePhone:{
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
                self.textField.placeholder = @"请输入手机号";
                self.textField.limitMaxCount = 11;
                
                self.areaCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.areaCodeButton setTitle:self.areaCode forState:UIControlStateNormal];
                [self.areaCodeButton setTitleColor:[UIColor wl_hex0F6EF4] forState:UIControlStateNormal];
                self.areaCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.areaCodeButton addTarget:self action:@selector(codeSelect) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.areaCodeButton];
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = [UIColor wl_HexE5E5E5];
                [self addSubview:lineView];
                
                [self.areaCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(self);
                    make.width.mas_equalTo(52.f);
                }];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.areaCodeButton.mas_right);
                    make.top.equalTo(self).offset(14.f);
                    make.bottom.equalTo(self).offset(-14.f);
                    make.width.mas_equalTo(CGFloatFromPixel(1));
                }];
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lineView.mas_right).offset(16.f);
                    make.right.top.bottom.equalTo(self);
                }];
            }
                break;
            case WLLoginTextFieldTypePassword:{
                self.textField.secureTextEntry = YES;
                self.textField.keyboardType = UIKeyboardTypeASCIICapable;
                self.textField.placeholder = @"请输入6-18位登录密码";
                self.textField.limitMaxCount = 18;
                self.textField.returnKeyType = UIReturnKeyGo;
                
                self.plaintextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                UIImage *visualImage = [WLDicHQFontImage iconWithName:@"invisual" fontSize:18 color:UIColor.wl_HexCCCCCC];
                [self.plaintextButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                self.plaintextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.plaintextButton.adjustsImageWhenHighlighted = NO;
                [self.plaintextButton addTarget:self action:@selector(passwordTextFieldPlaintext) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.plaintextButton];
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(self);
                    make.right.equalTo(self.plaintextButton.mas_left);
                }];
                [self.plaintextButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-5.f);
                    make.top.bottom.equalTo(self);
                    make.width.mas_equalTo(30.f);
                }];
            }
                break;
            default:{
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self);
                }];
            }
                break;
        }
    }
    return self;
}

- (void)passwordTextFieldPlaintext {
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    if (self.textField.secureTextEntry) {
        [self.plaintextButton setImage:[UIImage imageNamed:@"password_icon_Cansee_nor"] forState:UIControlStateNormal];
    }else {
        [self.plaintextButton setImage:[UIImage imageNamed:@"password_icon_Notvisible_nor"] forState:UIControlStateNormal];
    }
}

- (void)showPhoneNumberSaved {
    NSString *mobile = @"";
    NSString *code   = @"";
    if ([GetLastLoginMobile wl_containsString:@"-"]) {
        NSArray *array = [GetLastLoginMobile componentsSeparatedByString:@"-"];
        if (array.count == 2) {
            code = [NSString stringWithFormat:@"+%@",array[0]];
            mobile = array[1];
        }else {
            code = @"+86";
            mobile = GetLastLoginMobile;
        }
    } else {
        code = @"+86";
        mobile = GetLastLoginMobile;
    }
    self.areaCode = code;
    self.textField.text = mobile;
}

- (void)setAreaCode:(NSString *)areaCode {
    _areaCode = areaCode;
    [self.areaCodeButton setTitle:self.areaCode forState:UIControlStateNormal];
    if ([areaCode isEqualToString:@"+86"]) {
        self.textField.limitMaxCount = 11;
    }else{
        self.textField.limitMaxCount = NSIntegerMax;
    }
    if (self.areaChangedBlock) {
        self.areaChangedBlock(areaCode);
    }
}

- (NSString *)phone {
    if (self.textFieldType == WLLoginTextFieldTypePhone) {
        NSMutableString *codeStr = [NSMutableString stringWithString:self.areaCode];
        [codeStr deleteCharactersInRange:[codeStr rangeOfString:@"+"]];
        NSString *phone = [self.areaCode isEqualToString:@"+86"] ? [self.textField.text wl_trimWhitespaceAndNewlines] : [NSString stringWithFormat:@"%@-%@",codeStr, [self.textField.text wl_trimWhitespaceAndNewlines]];
        return phone;
    }
    return nil;
}

@end
