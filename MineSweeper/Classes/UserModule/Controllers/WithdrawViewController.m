//
//  WithdrawViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "WithdrawViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"
#import "LWLoginTextFieldView.h"

@interface WithdrawViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) LWLoginTextFieldView *moenyTxtView;
@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) LWLoginTextFieldView *typeTxtView;
@property (nonatomic, strong) QMUILabel *aboutLabel;
@property (nonatomic, strong) QMUIFillButton *withdrawBtn;

@end

@implementation WithdrawViewController

- (NSString *)title {
    return @"提现";
}

- (void)initSubviews {
    [super initSubviews];
    [self addViews];
    [self addViewConstraints];
    
    //添加单击手势
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [[self.view wl_findFirstResponder] resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
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
    
    // 转账金额
    LWLoginTextFieldView *moenyTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeMoney];
    moenyTxtView.titleLabel.text = @"提现金额";
    [self.view addSubview:moenyTxtView];
    self.moenyTxtView = moenyTxtView;
    [moenyTxtView.textField becomeFirstResponder];
    
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"我的余额：￥200.00　可提现：￥180.00";
    momeyLabel.font = UIFontMake(12);
    momeyLabel.textColor = WLColoerRGB(153.f);
    [self.view addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    
    // 提现类型金额
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 25.f, 20.f)];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"withdraw_ali_icon"]];
    iconView.frame = CGRectMake(0.f, 0.f, 20.f, 20.f);
    [leftView addSubview:iconView];
    
    LWLoginTextFieldView *typeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeDefault];
    typeTxtView.textField.enabled = NO;
    typeTxtView.textField.text = @"提现到支付宝";
    typeTxtView.textField.leftView = leftView;
    typeTxtView.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:typeTxtView];
    self.typeTxtView = typeTxtView;
    
    QMUILabel *aboutLabel = [[QMUILabel alloc] init];
    aboutLabel.text = @"提现说明：xxxxxxxx";
    aboutLabel.font = UIFontMake(12);
    aboutLabel.textColor = WLColoerRGB(153.f);
    [self.view addSubview:aboutLabel];
    self.aboutLabel = aboutLabel;
    
    // 立即转账
    QMUIFillButton *withdrawBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [withdrawBtn setTitle:@"立即提现" forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = WLFONT(18);
    [withdrawBtn addTarget:self action:@selector(withdrawBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [withdrawBtn setCornerRadius:5.f];
    [self.view addSubview:withdrawBtn];
    self.withdrawBtn = withdrawBtn;
}

// 添加页面view布局控制
- (void)addViewConstraints {
    [_moenyTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self qmui_navigationBarMaxYInViewCoordinator] + 17.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_momeyLabel sizeToFit];
    [_momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_20);
        make.top.mas_equalTo(self.moenyTxtView.mas_bottom).offset(8.f);
    }];
    
    [_typeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.moenyTxtView);
        make.centerX.mas_equalTo(self.moenyTxtView);
        make.top.mas_equalTo(self.moenyTxtView.mas_bottom).offset(29.f);
    }];
    
    [_aboutLabel sizeToFit];
    [_aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.momeyLabel);
        make.top.mas_equalTo(self.typeTxtView.mas_bottom).offset(8.f);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeTxtView.mas_bottom).offset(39.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalButtonHeight);
    }];
}

#pragma mark - private
// 立即提现按钮点击
- (void)withdrawBtnClicked:(UIButton *)sender {
    
}

@end
