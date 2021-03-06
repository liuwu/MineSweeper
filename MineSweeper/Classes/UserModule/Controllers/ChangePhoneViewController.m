//
//  ChangePhoneViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"

@interface ChangePhoneViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *phoneTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *vcodeTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *pwdTxtView;
@property (nonatomic, strong) QMUIFillButton *loginBtn;

@end

@implementation ChangePhoneViewController

- (NSString *)title {
    return @"变更手机";
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
    
    LWLoginTextFieldView *imageVcodeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeImageVcode];
    [self.view addSubview:imageVcodeTxtView];
    
    LWLoginTextFieldView *vcodeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeVcode];
//    [vcodeTxtView.rightButton addTarget:self action:@selector(getVcode) forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    [vcodeTxtView.rightButton addToucheHandler:^(JKCountDownButton *countDownButton, NSInteger tag) {
        @strongify(self);
        [self getVcode];
    }];
    [vcodeTxtView.rightButton didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
        NSString *title = [NSString stringWithFormat:@"获取验证码(%d)",second];
        return title;
    }];
    [vcodeTxtView.rightButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"获取验证码";
    }];
    [self.view addSubview:vcodeTxtView];
    self.vcodeTxtView = vcodeTxtView;
    
    LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
    pwdTxtView.textField.placeholder = @"新手机号";
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
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(kWL_NormalMarginWidth_14);
        } else {
            make.top.mas_equalTo(self.view.mas_top).offset(kWL_NormalMarginWidth_14);
        }
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth - kWL_NormalMarginWidth_10 * 2.f);
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
- (void)getVcode {
    if (self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }

    [WLHUDView showHUDWithStr:@"" dim:YES];
    @weakify(self);
    [UserModelClient getChangeMobileVcodeWithParams:nil Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"验证码已发送"];
        @strongify(self);
        self.vcodeTxtView.rightButton.enabled = NO;
        [self.vcodeTxtView.rightButton startWithSecond:60];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}

// 登录按钮点击
- (void)didClickLoginBtn:(UIButton *)sender {
    if (self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    if (self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入验证码"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile" : self.phoneTxtView.textField.text.wl_trimWhitespaceAndNewlines,
                             @"code" : self.vcodeTxtView.textField.text.wl_trimWhitespaceAndNewlines
                             };
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [UserModelClient changeMobileWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"修改成功"];
        weakSelf.vcodeTxtView.textField.text = @"";
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}

@end
