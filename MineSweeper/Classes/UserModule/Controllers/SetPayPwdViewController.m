//
//  SetPayPwdViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/18.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SetPayPwdViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"
#import "LWLoginTextFieldView.h"
#import "QMUIFillButton.h"

#import "UserModelClient.h"

@interface SetPayPwdViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *pwdTxtView;
@property (nonatomic, strong) QMUIFillButton *confirmBtn;

@end

@implementation SetPayPwdViewController

- (NSString *)title {
    return @"设置支付密码";
}

- (void)initSubviews {
    [super initSubviews];
    [self addViews];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加表格内容
- (void)addViews {
    self.view.backgroundColor = WLColoerRGB(248.f);
    
    // 密码
    LWLoginTextFieldView *pwdTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePassword];
    [self.view addSubview:pwdTxtView];
    self.pwdTxtView = pwdTxtView;
    [pwdTxtView.textField becomeFirstResponder];
    [pwdTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self qmui_navigationBarMaxYInViewCoordinator] + kWL_NormalMarginWidth_10);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    // 立即转账
    QMUIFillButton *confirmBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [confirmBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = WLFONT(18);
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.cornerRadius = 5.f;
    [self.view addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdTxtView.mas_bottom).offset(20.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalButtonHeight);
    }];
}

#pragma mark - private
// 设置支付密码
- (void)confirmBtnClicked:(UIButton *)sender {
    if (_pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入支付密码"];
        return;
    }
    [[self.view wl_findFirstResponder] resignFirstResponder];
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient setPayPwdWithParams:@{@"password": _pwdTxtView.textField.text.wl_trimWhitespaceAndNewlines} Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"设置成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

@end
