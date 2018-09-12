//
//  LWLoginTextFieldView.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/12.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "LWLoginTextFieldView.h"
#import "UITextField+Limit.h"

@interface LWLoginTextFieldView()

@property (nonatomic, assign) LWLoginTextFieldType textFieldType;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

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
        self.isChangeBorder = YES;
        [self setQmui_borderPosition:QMUIBorderViewPositionBottom];
        self.textField = [[UITextField alloc] init];
        self.textField.enablesReturnKeyAutomatically = YES;
        self.textField.textColor = UIColor.wl_Hex333333;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:self.textField];
        self.textField.font = WLFONT(16);
        switch (_textFieldType) {
            case LWLoginTextFieldTypePhone:{
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
                self.textField.placeholder = @"请输入手机号";
                self.textField.limitMaxCount = 11;
                
//                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(lineView.mas_right).offset(16.f);
//                    make.right.top.bottom.equalTo(self);
//                }];
            }
                break;
            case LWLoginTextFieldTypePassword:{
                self.textField.secureTextEntry = YES;
                self.textField.keyboardType = UIKeyboardTypeASCIICapable;
                self.textField.placeholder = @"请输入6-18位登录密码";
                self.textField.limitMaxCount = 18;
                self.textField.returnKeyType = UIReturnKeyGo;
                
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                UIImage *visualImage = [WLDicHQFontImage iconWithName:@"invisual" fontSize:18 color:UIColor.wl_HexCCCCCC];
                [rightButton setImage:[UIImage imageNamed:@"password_icon_Cansee_nor"] forState:UIControlStateNormal];
                rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                rightButton.adjustsImageWhenHighlighted = NO;
                [rightButton addTarget:self action:@selector(passwordTextFieldPlaintext) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:rightButton];
                self.rightButton = rightButton;
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(self);
                    make.right.equalTo(rightButton.mas_left);
                }];
                [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
        //添加通知监听文本状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;
}

- (void)passwordTextFieldPlaintext {
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    if (self.textField.secureTextEntry) {
        [self.rightButton setImage:[UIImage imageNamed:@"password_icon_Cansee_nor"] forState:UIControlStateNormal];
    }else {
        [self.rightButton setImage:[UIImage imageNamed:@"password_icon_Notvisible_nor"] forState:UIControlStateNormal];
    }
}

- (NSString *)phone {
    if (self.textFieldType == LWLoginTextFieldTypePhone) {
        return [self.textField.text wl_trimWhitespaceAndNewlines];
    }
    return nil;
}

- (void)textBeginEditing:(NSNotification*)note {
    if (_isChangeBorder==NO)return;
    [self changBorderwithNote:note];
    
}

- (void)textDidEndEditing:(NSNotification*)note {
    if (_isChangeBorder==NO)return;
    [self changBorderwithNote:note];
}

- (void)textDidChange:(NSNotification*)note {
    [self changBorderwithNote:note];
}


- (void)setPlaceholder:(NSString *)placeholder {
//    [super setPlaceholder:placeholder];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:_placeholderColor}];
    
}

- (void)changBorderwithNote:(NSNotification*)editing {
    if (![editing.object isEqual:self])return;
    if ([editing.name isEqualToString:UITextFieldTextDidBeginEditingNotification]) {
        self.layer.borderColor=_selectBorderColor.CGColor;
//        _leftIconBtn.selected=YES;
        
    }else if ([editing.name isEqualToString:UITextFieldTextDidEndEditingNotification]) {
        self.layer.borderColor=_defaultBorderColor.CGColor;
//        _leftIconBtn.selected=NO;
        
    }
//    else if ([editing.name isEqualToString:UITextFieldTextDidChangeNotification]) {
//        if (self.maxTextLength!=0) {
////            if (self.text.length >self.maxTextLength) {
////                [self judemaxText];
////            }
//        }
//    }
    
}

@end
