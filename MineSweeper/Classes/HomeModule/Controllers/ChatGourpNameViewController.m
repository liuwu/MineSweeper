//
//  ChatGourpNameViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/20.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatGourpNameViewController.h"

#import "LWLoginTextFieldView.h"

#import "ImGroupModelClient.h"

@interface ChatGourpNameViewController ()

@property (nonatomic, strong) LWLoginTextFieldView *nameTxtView;

@end

@implementation ChatGourpNameViewController

- (NSString *)title {
    return @"群名称";
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
    
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"保存" target:self action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    LWLoginTextFieldView *nameTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeDefault];
    nameTxtView.backgroundColor = [UIColor whiteColor];
    nameTxtView.textField.text = _groupDetailInfo.title;// @"群名称";
    nameTxtView.selectBorderColor = [UIColor whiteColor];
    [nameTxtView wl_setCornerRadius:0.f];
    [self.view addSubview:nameTxtView];
    self.nameTxtView = nameTxtView;
//    [nameTxtView.textField becomeFirstResponder];
    
//    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
//    loginBtn.titleLabel.font = WLFONT(18);
//    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [loginBtn setTitle:@"修改" forState:UIControlStateNormal];
//    [loginBtn setCornerRadius:5.f];
//    [self.view addSubview:loginBtn];
//    self.loginBtn = loginBtn;
    
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
    [_nameTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self qmui_navigationBarMaxYInViewCoordinator]);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(DEVICE_WIDTH);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
}

#pragma mark - Private
- (void)rightBarButtonItemClicked {
    if (_nameTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入群公告"];
    }
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    NSDictionary *params = @{@"id": @(_groupDetailInfo.groupId.integerValue),
                             @"title" : _nameTxtView.textField.text.wl_trimWhitespaceAndNewlines
                             };
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [ImGroupModelClient setImGroupTitleWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"保存成功"];
        [kNSNotification postNotificationName:@"kGroupInfoChanged" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

@end
