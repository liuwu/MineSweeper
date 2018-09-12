//
//  LoginViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/10.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "LoginViewController.h"
#import "SmsLoginViewController.h"

#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

#import "AppDelegate.h"

@interface LoginViewController ()


@property (nonatomic, strong) LWLoginTextFieldView *phoneTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *pwdTxtView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *smsLoginBtn;
@property (nonatomic, strong) UIButton *forgetBtn;

@end

@implementation LoginViewController

- (NSString *)title {
    return @"登录";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[YYTextKeyboardManager defaultManager] addObserver:self];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.view endEditing:YES];
//    [[YYTextKeyboardManager defaultManager] removeObserver:self];
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.alpha = 1.f;
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
    
    LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
    [self.view addSubview:pwdTxtView];
    self.pwdTxtView = pwdTxtView;
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn wl_setBackgroundColor:WLRGB(254.f, 72.f, 30.f) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn wl_setCornerRadius:5];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIButton *smsLoginBtn = [[UIButton alloc] init];
    [smsLoginBtn setTitle:@"短信登录" forState:UIControlStateNormal];
    [smsLoginBtn setTitleColor:WLRGB(254.f, 72.f, 30.f) forState:UIControlStateNormal];
    smsLoginBtn.titleLabel.font = WLFONT(14);
    [smsLoginBtn addTarget:self action:@selector(didSmsLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:smsLoginBtn];
    self.smsLoginBtn = smsLoginBtn;
    
    UIButton *forgetBtn = [[UIButton alloc] init];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:WLColoerRGB(153.f) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = WLFONT(14);
    [forgetBtn addTarget:self action:@selector(didForgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    self.forgetBtn = forgetBtn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightBarButtonItemClicked)];
    
    
//    [self.view bk_whenTapped:^{
//        [self find] resignFirstResponder];
//    }];
    
}

// 布局控制
- (void)addConstrainsForSubviews {
    
    [_phoneTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kWL_NormalMarginWidth_14);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_pwdTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.left.equalTo(self.phoneTxtView);
        make.top.mas_equalTo(self.phoneTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pwdTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
    
    [_smsLoginBtn sizeToFit];
    [_smsLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
    
    [_forgetBtn sizeToFit];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginBtn);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
}

#pragma mark - Private
// 登录按钮点击
- (void)didClickLoginBtn:(UIButton *)sender {
    [[AppDelegate sharedAppDelegate] loginSucceed];
}

// 短信登录按钮点击
- (void)didSmsLoginBtn:(UIButton *)sender {
    SmsLoginViewController *smsLoginVc = [[SmsLoginViewController alloc] init];
    smsLoginVc.useType = UseTypeSMS;
//    [self.navigationController presentViewController:smsLoginVc animated:YES completion:NULL];
    [self.navigationController pushViewController:smsLoginVc animated:YES];
}

// 短信登录按钮点击
- (void)didForgetBtn:(UIButton *)sender {
    
}

//
- (void)rightBarButtonItemClicked {
    SmsLoginViewController *smsLoginVc = [[SmsLoginViewController alloc] init];
    smsLoginVc.useType = UseTypeRegist;
    //    [self.navigationController presentViewController:smsLoginVc animated:YES completion:NULL];
    [self.navigationController pushViewController:smsLoginVc animated:YES];
}






@end
