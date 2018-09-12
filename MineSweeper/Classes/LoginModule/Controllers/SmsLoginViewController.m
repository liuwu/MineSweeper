//
//  SmsLoginViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SmsLoginViewController.h"
#import "LWLoginTextField.h"

@interface SmsLoginViewController ()

@property (nonatomic, strong) LWLoginTextField *phoneTxt;
@property (nonatomic, strong) LWLoginTextField *imageVcodeTxt;
@property (nonatomic, strong) LWLoginTextField *vcodeTxt;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *pwdLoginBtn;

@end

@implementation SmsLoginViewController

- (NSString *)title {
    return @"短信登录";
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
    LWLoginTextField *phoneTxt = [[LWLoginTextField alloc] init];
    phoneTxt.selectBorderColor = WLRGB(254.f, 72.f, 30.f);
    phoneTxt.placeholderColor = WLColoerRGB(51.f);
    phoneTxt.defaultBorderColor = WLColoerRGB(242.f);
    phoneTxt.backgroundColor = WLColoerRGB(255.f);
    phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    phoneTxt.placeholder = @"手机号";
    phoneTxt.font = WLFONT(15);
    [self.view addSubview:phoneTxt];
    self.phoneTxt = phoneTxt;
     [_phoneTxt becomeFirstResponder];
    
    LWLoginTextField *imageVcodeTxt = [[LWLoginTextField alloc] init];
    imageVcodeTxt.selectBorderColor = WLRGB(254.f, 72.f, 30.f);
    imageVcodeTxt.placeholderColor = WLColoerRGB(51.f);
    imageVcodeTxt.defaultBorderColor = WLColoerRGB(242.f);
    imageVcodeTxt.keyboardType = UIKeyboardTypeASCIICapable;
    imageVcodeTxt.placeholder = @"图形验证码";
    imageVcodeTxt.font = WLFONT(15);
    imageVcodeTxt.backgroundColor = WLColoerRGB(255.f);
    [self.view addSubview:imageVcodeTxt];
    self.imageVcodeTxt = imageVcodeTxt;
    
    LWLoginTextField *vcodeTxt = [[LWLoginTextField alloc] init];
    vcodeTxt.selectBorderColor = WLRGB(254.f, 72.f, 30.f);
    vcodeTxt.placeholderColor = WLColoerRGB(51.f);
    vcodeTxt.defaultBorderColor = WLColoerRGB(242.f);
    vcodeTxt.keyboardType = UIKeyboardTypeASCIICapable;
    vcodeTxt.placeholder = @"验证码";
    vcodeTxt.font = WLFONT(15);
    vcodeTxt.backgroundColor = WLColoerRGB(255.f);
    [self.view addSubview:vcodeTxt];
    self.vcodeTxt = vcodeTxt;
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn wl_setBackgroundColor:WLRGB(249.f, 75.f, 44.f) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn wl_setCornerRadius:4];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIButton *pwdLoginBtn = [[UIButton alloc] init];
    [pwdLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    [pwdLoginBtn setTitleColor:WLRGB(249.f, 75.f, 44.f) forState:UIControlStateNormal];
    pwdLoginBtn.titleLabel.font = WLFONT(14);
    [pwdLoginBtn addTarget:self action:@selector(didPwdLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pwdLoginBtn];
    self.pwdLoginBtn = pwdLoginBtn;
}

// 布局控制
- (void)addConstrainsForSubviews {
    [_phoneTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kWL_NormalMarginWidth_14);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_imageVcodeTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneTxt);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.phoneTxt.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_vcodeTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneTxt);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.imageVcodeTxt.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneTxt);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.vcodeTxt.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
    
    [_pwdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.loginBtn);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kWL_NormalMarginWidth_15);
    }];
}

#pragma mark - Private
// 登录按钮点击
- (void)didClickLoginBtn:(UIButton *)sender {
    
}

// 密码登录按钮点击
- (void)didPwdLoginBtn:(UIButton *)sender {
    
}

@end
