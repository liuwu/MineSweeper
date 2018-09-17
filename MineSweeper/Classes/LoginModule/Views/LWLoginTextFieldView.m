//
//  LWLoginTextFieldView.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/12.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "LWLoginTextFieldView.h"
#import "UITextField+Limit.h"
#import <MMCaptchaView/MMCaptchaView.h>
#import "NNValidationView.h"

@interface LWLoginTextFieldView()<UITextFieldDelegate>

@property (nonatomic, assign) LWLoginTextFieldType textFieldType;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) NNValidationView *captchaView;

@property (nonatomic, assign) BOOL isHaveDian;

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
        [textField setBk_shouldReturnBlock:^BOOL(UITextField *field) {
            [field resignFirstResponder];
            return YES;
        }];
        
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
                
                NNValidationView *captchaView = [[NNValidationView alloc] initWithFrame:CGRectZero andCharCount:4 andLineCount:4];
//                captchaView.captchaFont = WLFONT(20);
                [self addSubview:captchaView];
                self.captchaView = captchaView;
                
                __weak typeof(self) weakSelf = self;
                /// 返回验证码数字
                captchaView.changeValidationCodeBlock = ^(void){
                    DLog(@"验证码被点击了：%@", weakSelf.captchaView.charString);
                };
                
//                MMCaptchaView *captchaView = [[MMCaptchaView alloc] initWithFrame:CGRectZero];
//                captchaView.captchaFont = WLFONT(20);
//                [self addSubview:captchaView];
//                [captchaView wl_setDebug:YES];
                
//                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [rightButton setImage:[UIImage imageNamed:@"password_icon_Cansee_nor"] forState:UIControlStateNormal];
//                rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//                rightButton.adjustsImageWhenHighlighted = NO;
//                [rightButton addTarget:self action:@selector(passwordTextFieldPlaintext) forControlEvents:UIControlEventTouchUpInside];
//                [self addSubview:rightButton];
//                self.rightButton = rightButton;
                
//                [_rightButton sizeToFit];
//                [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.mas_equalTo(self).offset(-kWL_NormalMarginWidth_10);
//                    make.top.bottom.mas_equalTo(self);
//                    make.width.mas_equalTo(kWL_NormalMarginWidth_20);
//                }];
                [captchaView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self).offset(-kWL_NormalMarginWidth_10);
//                    make.top.bottom.mas_equalTo(self).mas_offset(-4.f);
                    make.top.mas_equalTo(self).mas_offset(4.f);
                    make.bottom.mas_equalTo(self).mas_offset(-4.f);
                    make.width.mas_equalTo(80);
                }];
                
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.leftView.mas_right);
                    make.right.mas_equalTo(captchaView.mas_left);
                    make.top.bottom.mas_equalTo(self);
                }];
            }
                break;
            case LWLoginTextFieldTypeMoney: {
                _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                _textField.placeholder = @"0.00";
                _textField.textAlignment = NSTextAlignmentRight;
                //                _textField.limitMaxCount = 18;
                _textField.returnKeyType = UIReturnKeyGo;
                
                QMUILabel *titleLabel = [[QMUILabel alloc] init];
                titleLabel.font = UIFontMake(15.f);
                titleLabel.textColor = WLColoerRGB(51.f);
                titleLabel.text = @"转账金额";
                [self addSubview:titleLabel];
                self.titleLabel = titleLabel;
                
                QMUILabel *subTitleLabel = [[QMUILabel alloc] init];
                subTitleLabel.font = UIFontMake(15.f);
                subTitleLabel.textColor = WLColoerRGB(51.f);
                subTitleLabel.text = @"元";
                subTitleLabel.textAlignment = NSTextAlignmentRight;
                [self addSubview:subTitleLabel];
                self.subTitleLabel = subTitleLabel;
//                [subTitleLabel wl_setDebug:YES];
                
                [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(11.f);
                    make.width.mas_equalTo(80.f);
                    make.height.mas_equalTo(self);
                    make.centerY.mas_equalTo(self);
                }];
                
                [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.mas_right).offset(-11.f);
                    make.height.mas_equalTo(self);
                    make.width.mas_equalTo(20.f);
                    make.centerY.mas_equalTo(self);
                }];
                
//                [_textField wl_setDebug:YES];
                [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.titleLabel.mas_right);
                    make.right.mas_equalTo(self.subTitleLabel.mas_left);
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

//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    self.waitPayLabel.text = [NSString stringWithFormat:@"待支付¥%@ |优惠¥%@",self.totalTF.text,self.exclusiveMoneyTF.text];
    if (_textFieldType != LWLoginTextFieldTypeMoney) {
        return YES;
    }
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        _isHaveDian=NO;
    }
    if ([string length]>0) {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        //数据格式正确
        if ((single >='0' && single<='9') || single=='.') {
            //首字母不能为0和小数点
            if([textField.text length]==0) {
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                }
            }
            
            if([textField.text length]==1) {
                
                NSString *first = [textField.text substringToIndex:1];//字符串开始
                //首字母是0的时候
                if ([first isEqualToString:@"0"]) {
                    if(single == '.') {
                        _isHaveDian=YES;
                        return YES;
                    } else {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
            if (single=='.') {
                //text中还没有小数点
                if(!_isHaveDian) {
                    _isHaveDian=YES;
                    return YES;
                } else {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                //存在小数点
                if (_isHaveDian) {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    int tt=range.location-ran.location;
                    if (tt <= 2) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        } else {
            //输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
}

@end
