//
//  LWLoginTextFieldView.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/12.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "LWLoginTextFieldView.h"
#import "UITextField+Limit.h"

@interface LWLoginTextFieldView()<UITextFieldDelegate>

@property (nonatomic, assign) LWLoginTextFieldType textFieldType;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *leftView;

@end

@implementation LWLoginTextFieldView

- (instancetype)initWithTextFieldType:(LWLoginTextFieldType)textFieldType {
    _textFieldType = textFieldType;
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化默认状态
        self.backgroundColor = [UIColor whiteColor];
        self.selectBorderColor = WLRGB(254.f, 72.f, 30.f);//默认选中颜色
        self.placeholderColor = WLColoerRGB(51.f);//默认提醒颜色
        self.defaultBorderColor = WLColoerRGB(242.f);//默认边框颜色
        self.isChangeBorder = YES;
        [self wl_setCornerRadius:5.f];
        [self wl_setBorderWidth:0.8f color:WLColoerRGB(242.f)];
//        [self setQmui_borderColor:WLColoerRGB(242.f)];
//        [self setQmui_borderWidth:1.f];
//        [self setQmui_borderPosition:QMUIBorderViewPositionBottom];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = [UIColor clearColor];
        [self addSubview:leftView];
        self.leftView = leftView;
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kWL_NormalMarginWidth_10);
            make.height.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.enablesReturnKeyAutomatically = YES;
        textField.textColor =  WLColoerRGB(51.f);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = WLFONT(15);
        textField.backgroundColor = WLColoerRGB(255.f);
        textField.delegate = self;
        [self addSubview:textField];
        self.textField = textField;
        
        switch (_textFieldType) {
            case LWLoginTextFieldTypePhone:{
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                _textField.placeholder = @"手机号";
                _textField.limitMaxCount = 11;
                
                [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self);
                    make.top.bottom.mas_equalTo(self);
                    make.width.mas_equalTo(0);
                }];
                
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.leftView.mas_right);
                    make.width.mas_equalTo(self.mas_width).offset(-kWL_NormalMarginWidth_10);
                    make.top.bottom.mas_equalTo(self);
                }];
            }
                break;
            case LWLoginTextFieldTypePassword:{
                _textField.secureTextEntry = YES;
                _textField.keyboardType = UIKeyboardTypeASCIICapable;
                _textField.placeholder = @"密码";
//                _textField.limitMaxCount = 18;
                _textField.returnKeyType = UIReturnKeyGo;
                
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                //                UIImage *visualImage = [WLDicHQFontImage iconWithName:@"invisual" fontSize:18 color:UIColor.wl_HexCCCCCC];
                [rightButton setImage:[UIImage imageNamed:@"password_icon_Cansee_nor"] forState:UIControlStateNormal];
                rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                rightButton.adjustsImageWhenHighlighted = NO;
                [rightButton addTarget:self action:@selector(passwordTextFieldPlaintext) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:rightButton];
                self.rightButton = rightButton;
//                [rightButton wl_setDebug:YES];
                
                [_rightButton sizeToFit];
                [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self).offset(-kWL_NormalMarginWidth_10);
                    make.top.bottom.mas_equalTo(self);
                    make.width.mas_equalTo(kWL_NormalMarginWidth_20);
                }];
                
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.leftView.mas_right);
                    make.right.mas_equalTo(self.rightButton.mas_left);
                    make.top.bottom.mas_equalTo(self);
                }];
            }
                break;
            case LWLoginTextFieldTypeImageVcode:{
                _textField.secureTextEntry = YES;
                _textField.keyboardType = UIKeyboardTypeASCIICapable;
                _textField.placeholder = @"图形验证码";
                _textField.returnKeyType = UIReturnKeyGo;
                
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightButton setImage:[UIImage imageNamed:@"password_icon_Cansee_nor"] forState:UIControlStateNormal];
                rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                rightButton.adjustsImageWhenHighlighted = NO;
                [rightButton addTarget:self action:@selector(passwordTextFieldPlaintext) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:rightButton];
                self.rightButton = rightButton;
                
                [_rightButton sizeToFit];
                [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self).offset(-kWL_NormalMarginWidth_10);
                    make.top.bottom.mas_equalTo(self);
                    make.width.mas_equalTo(kWL_NormalMarginWidth_20);
                }];
                
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.leftView.mas_right);
                    make.right.mas_equalTo(self.rightButton.mas_left);
                    make.top.bottom.mas_equalTo(self);
                }];
            }
                break;
            case LWLoginTextFieldTypeVcode:{
                _textField.secureTextEntry = YES;
                _textField.keyboardType = UIKeyboardTypeASCIICapable;
                _textField.placeholder = @"验证码";
                _textField.returnKeyType = UIReturnKeyGo;
                
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [rightButton setTitleColor:WLRGB(254.f, 72.f, 30.f) forState:UIControlStateNormal];
                rightButton.titleLabel.font = WLFONT(15);
//                rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                rightButton.adjustsImageWhenHighlighted = NO;
                [rightButton addTarget:self action:@selector(getVcode) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:rightButton];
                self.rightButton = rightButton;
//                [rightButton wl_setDebug:YES];
                
                [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self).offset(-kWL_NormalMarginWidth_10);
                    make.top.bottom.mas_equalTo(self);
                    make.width.mas_equalTo(80.f);
                }];
                
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.leftView.mas_right);
                    make.right.mas_equalTo(self.rightButton.mas_left);
                    make.top.bottom.mas_equalTo(self);
                }];
            }
                break;
            default:{
                [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self);
                    make.top.bottom.mas_equalTo(self);
                    make.width.mas_equalTo(0);
                }];
                
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.leftView.mas_right);
                    make.width.mas_equalTo(self.mas_width).offset(-kWL_NormalMarginWidth_10);
                    make.top.bottom.mas_equalTo(self);
                }];
            }
                break;
        }
    }
    return self;
}

// 改变按钮图标
- (void)passwordTextFieldPlaintext {
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    if (self.textField.secureTextEntry) {
        [self.rightButton setImage:[UIImage imageNamed:@"password_icon_Cansee_nor"] forState:UIControlStateNormal];
    }else {
        [self.rightButton setImage:[UIImage imageNamed:@"password_icon_Notvisible_nor"] forState:UIControlStateNormal];
    }
}

// 获取验证码
- (void)getVcode {
    
}

- (NSString *)phone {
    if (self.textFieldType == LWLoginTextFieldTypePhone) {
        return [self.textField.text wl_trimWhitespaceAndNewlines];
    }
    return nil;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self wl_setBorderWidth:0.8f color:_selectBorderColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self wl_setBorderWidth:0.8f color:_defaultBorderColor];
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:_placeholderColor}];
}

@end
