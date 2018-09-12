//
//  SmsLoginViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SmsLoginViewController.h"
#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

@interface SmsLoginViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *phoneTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *imageVcodeTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *vcodeTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *pwdTxtView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *pwdLoginBtn;

@end

@implementation SmsLoginViewController

- (NSString *)title {
    switch (_useType) {
        case UseTypeSMS:
            return @"短信登录";
            break;
        case UseTypeRegist:
            return @"注册";
            break;
        default:
            return @"";
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    [self addConstrainsForSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setup
// 添加页面UI组件
- (void)addSubviews {
    LWLoginTextFieldView *phoneTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    [self.view addSubview:phoneTxtView];
    self.phoneTxtView = phoneTxtView;
    [phoneTxtView.textField becomeFirstResponder];
    
    LWLoginTextFieldView *imageVcodeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeImageVcode];
    [self.view addSubview:imageVcodeTxtView];
    self.imageVcodeTxtView = imageVcodeTxtView;
    
    LWLoginTextFieldView *vcodeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeVcode];
    [self.view addSubview:vcodeTxtView];
    self.vcodeTxtView = vcodeTxtView;
    
    if (_useType == UseTypeRegist) {
        LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
        [self.view addSubview:pwdTxtView];
        self.pwdTxtView = pwdTxtView;
    }
    
    UIButton *loginBtn = [[UIButton alloc] init];
    switch (_useType) {
        case UseTypeSMS:
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            break;
        case UseTypeRegist:
            [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
            break;
        default:
            [loginBtn setTitle:@"" forState:UIControlStateNormal];
            break;
    }
    [loginBtn wl_setBackgroundColor:WLRGB(249.f, 75.f, 44.f) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn wl_setCornerRadius:4];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    if (_useType == UseTypeSMS) {
        UIButton *pwdLoginBtn = [[UIButton alloc] init];
        [pwdLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        [pwdLoginBtn setTitleColor:WLRGB(249.f, 75.f, 44.f) forState:UIControlStateNormal];
        pwdLoginBtn.titleLabel.font = WLFONT(14);
        [pwdLoginBtn addTarget:self action:@selector(didPwdLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pwdLoginBtn];
        self.pwdLoginBtn = pwdLoginBtn;
    }
    
}

// 布局控制
- (void)addConstrainsForSubviews {
    [_phoneTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kWL_NormalMarginWidth_14);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_imageVcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.phoneTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_vcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.imageVcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    switch (_useType) {
        case UseTypeSMS:
        {
            [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
            }];
            
            [_pwdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.loginBtn);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kWL_NormalMarginWidth_15);
            }];
        }
            break;
        case UseTypeRegist:
           {
               [_pwdTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.size.equalTo(self.phoneTxtView);
                   make.centerX.mas_equalTo(self.view);
                   make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
               }];
               
               [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.size.equalTo(self.phoneTxtView);
                   make.centerX.mas_equalTo(self.view);
                   make.top.mas_equalTo(self.pwdTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
               }];
           }
            break;
        default:
            [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.phoneTxtView);
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
            }];
            break;
    }
}

#pragma mark - Private
// 登录按钮点击
- (void)didClickLoginBtn:(UIButton *)sender {
    switch (_useType) {
        case UseTypeSMS:
            
            break;
        case UseTypeRegist:
            
            break;
        default:
            
            break;
    }
}

// 密码登录按钮点击
- (void)didPwdLoginBtn:(UIButton *)sender {
    
}

@end
