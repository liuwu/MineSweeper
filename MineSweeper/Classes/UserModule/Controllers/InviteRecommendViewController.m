//
//  InviteRecommendViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "InviteRecommendViewController.h"

#import "LWLoginTextField.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"

@interface InviteRecommendViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *codeTxtView;
@property (nonatomic, strong) QMUIFillButton *loginBtn;

@end

@implementation InviteRecommendViewController

- (NSString *)title {
    return @"填写邀请码";
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
    
    LWLoginTextFieldView *codeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeInvest];
    [self.view addSubview:codeTxtView];
    self.codeTxtView = codeTxtView;
    [codeTxtView.textField becomeFirstResponder];
    
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    loginBtn.titleLabel.font = WLFONT(18);
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setCornerRadius:5.f];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

// 布局控制
- (void)addConstrainsForSubviews {
    [_codeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(self.qmui_navigationBarMaxYInViewCoordinator + kWL_NormalMarginWidth_14);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH - kWL_NormalMarginWidth_10 * 2.f);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.codeTxtView);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.codeTxtView.mas_bottom).offset(kWL_NormalMarginWidth_20);
    }];
}

#pragma mark - Private
// 登录按钮点击
- (void)didClickLoginBtn:(UIButton *)sender {
    if (_codeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入邀请码"];
        return;
    }
    NSDictionary *params = @{@"invite_code" : _codeTxtView.textField.text.wl_trimWhitespaceAndNewlines};
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [UserModelClient setInviteCodeWithParams:params Success:^(id resultInfo) {
        [kNSNotification postNotificationName:@"kUserInfoChanged" object:nil];
        if (!resultInfo) {
            [WLHUDView showSuccessHUD:resultInfo];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
//        [WLHUDView hiddenHud];
    }];
}

@end
