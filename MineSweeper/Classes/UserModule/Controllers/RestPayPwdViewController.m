//
//  RestPayPwdViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RestPayPwdViewController.h"
#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"

@interface RestPayPwdViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *phoneTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *vcodeTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *pwdTxtView;
@property (nonatomic, strong) QMUIFillButton *loginBtn;

@end

@implementation RestPayPwdViewController

- (NSString *)title {
    return @"重置支付密码";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    //    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)initSubviews {
    [super initSubviews];
    [self addSubviews];
    [self addConstrainsForSubviews];
}

#pragma mark setup
// 添加页面UI组件
- (void)addSubviews {
    self.view.backgroundColor = WLColoerRGB(248.f);
    
    LWLoginTextFieldView *phoneTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    [self.view addSubview:phoneTxtView];
    self.phoneTxtView = phoneTxtView;
    [phoneTxtView.textField becomeFirstResponder];
    
    LWLoginTextFieldView *vcodeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeVcode];
    [vcodeTxtView.rightButton addTarget:self action:@selector(getVcode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vcodeTxtView];
    self.vcodeTxtView = vcodeTxtView;
    
    LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
    pwdTxtView.textField.placeholder = @"新支付密码";
    [self.view addSubview:pwdTxtView];
    self.pwdTxtView = pwdTxtView;
    
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"修改" forState:UIControlStateNormal];
    [loginBtn setCornerRadius:5.f];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    //添加单击手势
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        [[self.view wl_findFirstResponder] resignFirstResponder];
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
        make.top.mas_equalTo(self.view).offset(self.qmui_navigationBarMaxYInViewCoordinator + kWL_NormalMarginWidth_14);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_vcodeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.phoneTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.phoneTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_pwdTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.phoneTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.vcodeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.phoneTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pwdTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
}

#pragma mark - Private
// 获取验证码
- (void)getVcode {
//    if (_phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
//        [WLHUDView showOnlyTextHUD:@"请输入手机号"];
//        return;
//    }
//    if (_phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
//        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
//        return;
//    }
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient forgetPayPwdVcodeWithParams:nil Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"验证码已发送"];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

// 重置支付密码
- (void)didClickLoginBtn:(UIButton *)sender {
    if (_vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入验证码"];
        return;
    }
    if (_pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入新支付密码"];
        return;
    }
    [[self.view wl_findFirstResponder] resignFirstResponder];
    [self changePayPwd];
//    WEAKSELF
    // 校验验证码
//    [UserModelClient forgetPayCheckVcodeWithParams:@{@"code" : _vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines} Success:^(id resultInfo) {
//        [weakSelf changePayPwd];
//    } Failed:^(NSError *error) {
//
//    }];
}

- (void)changePayPwd {
    NSDictionary *params = @{
                             @"code" : _vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"password": _pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines
                             };
    
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient resetPayPwdWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"设置成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

@end
