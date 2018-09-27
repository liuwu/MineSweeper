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

#import "LoginModuleClient.h"
#import "ILoginUserModel.h"

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
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (void)initSubviews {
    // 子类重写
    [super initSubviews];
    [self addSubviews];
    [self addConstrainsForSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addSubviews];
//    [self addConstrainsForSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setup
// 添加页面UI组件
- (void)addSubviews {
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"注册" target:self action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:self
//                                                                             action:@selector(rightBarButtonItemClicked)];
//
    LWLoginTextFieldView *phoneTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    phoneTxtView.textField.text = [NSUserDefaults stringForKey:kWLLastLoginUserPhoneKey];
    [self.view addSubview:phoneTxtView];
    self.phoneTxtView = phoneTxtView;
    [phoneTxtView.textField becomeFirstResponder];
    
    LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
    [self.view addSubview:pwdTxtView];
    self.pwdTxtView = pwdTxtView;
    
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setCornerRadius:5.f];
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
    
    //添加单击手势
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//         [[self.view wl_findFirstResponder] resignFirstResponder];
//    }];
//    [self.view addGestureRecognizer:tap];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

// 布局控制
- (void)addConstrainsForSubviews {
    
    [_phoneTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(kWL_NormalMarginWidth_14);
        } else {
            make.top.mas_equalTo(self.view.mas_top).offset(kWL_NormalMarginWidth_14);
        }
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
   
    if (self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    if (self.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入密码"];
        return;
    }
    NSDictionary *params = @{
                             @"username" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"password" : self.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines
                             };
    WEAKSELF
    [LoginModuleClient loginByPwdWithParams:params
                                Success:^(id resultInfo) {
                                    // 设置登录用户信息
                                    [configTool initLoginUser:resultInfo];
                                    [NSUserDefaults setString:weakSelf.pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines forKey:[NSString stringWithFormat:@"%@%@", configTool.loginUser.uid, configTool.loginUser.mobile]];
                                    weakSelf.pwdTxtView.textField.text = @"";
                                    [kNSNotification postNotificationName:@"kRefreshFriendList" object:nil];
                                } Failed:^(NSError *error) {
                                    
                                }];
}

// 短信登录按钮点击
- (void)didSmsLoginBtn:(UIButton *)sender {
    SmsLoginViewController *smsLoginVc = [[SmsLoginViewController alloc] initWithUseType:UseTypeSMS];
    [self.navigationController pushViewController:smsLoginVc animated:YES];
}

// 忘记密码按钮点击
- (void)didForgetBtn:(UIButton *)sender {
    SmsLoginViewController *smsLoginVc = [[SmsLoginViewController alloc] initWithUseType:UseTypeForget];
    [self.navigationController pushViewController:smsLoginVc animated:YES];
}

// 右侧导航按钮点击
- (void)rightBarButtonItemClicked {
    SmsLoginViewController *smsLoginVc = [[SmsLoginViewController alloc] initWithUseType:UseTypeRegist];
    [self.navigationController pushViewController:smsLoginVc animated:YES];
}






@end
