//
//  ChangePayPwdViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChangePayPwdViewController.h"
#import "RestPayPwdViewController.h"

#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"

@interface ChangePayPwdViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *pwdTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *pwdNewTxtView;
@property (nonatomic, strong) QMUIFillButton *loginBtn;
@property (nonatomic, strong) QMUIFillButton *forgetBtn;

@end

@implementation ChangePayPwdViewController

- (NSString *)title {
    return @"支付密码修改";
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
    
    LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
    pwdTxtView.textField.placeholder = @"旧支付密码";
    [self.view addSubview:pwdTxtView];
    self.pwdTxtView = pwdTxtView;
    
    LWLoginTextFieldView *pwdNewTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
    pwdNewTxtView.textField.placeholder = @"新支付密码";
    [self.view addSubview:pwdNewTxtView];
    self.pwdNewTxtView = pwdNewTxtView;
    
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"修改" forState:UIControlStateNormal];
    [loginBtn setCornerRadius:5.f];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    QMUIFillButton *forgetBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorWhite];
    forgetBtn.titleLabel.font = WLFONT(14);
    [forgetBtn addTarget:self action:@selector(forgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitle:@"忘记支付密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:WLColoerRGB(153.f) forState:UIControlStateNormal];
//    [forgetBtn setCornerRadius:5.f];/
    forgetBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:forgetBtn];
    self.forgetBtn = forgetBtn;
    
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
    [_pwdTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.qmui_navigationBarMaxYInViewCoordinator + kWL_NormalMarginWidth_14);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_pwdNewTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.pwdTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pwdTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.pwdNewTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pwdNewTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
    
    [_forgetBtn sizeToFit];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(<#CGFloat width#>, <#CGFloat height#>));
        make.right.mas_equalTo(self.loginBtn);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
}

#pragma mark - Private
// 修改支付密码
- (void)didClickLoginBtn:(UIButton *)sender {
    if (_pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入旧支付密码"];
        return;
    }
    if (_pwdNewTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入新支付密码"];
        return;
    }
    [[self.view wl_findFirstResponder] resignFirstResponder];
    NSDictionary *params = @{@"password" : _pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"new_password" : _pwdNewTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"new_repassword" : _pwdNewTxtView.textField.text.wl_trimWhitespaceAndNewlines
                             };
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient changePayPwdWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"设置成功"];
        weakSelf.pwdTxtView.textField.text = @"";
        weakSelf.pwdNewTxtView.textField.text = @"";
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

- (void)forgetBtnClicked:(UIButton *)sender {
    RestPayPwdViewController *vc = [[RestPayPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
