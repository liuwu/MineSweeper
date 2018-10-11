//
//  WithdrawViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "WithdrawViewController.h"
#import "MyCardViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"
#import "IWallentInfoModel.h"

#import <AlipaySDK/AlipaySDK.h>

@interface WithdrawViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) LWLoginTextFieldView *moenyTxtView;
@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) LWLoginTextFieldView *typeTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *typeCardTxtView;
@property (nonatomic, strong) QMUILabel *aboutLabel;
@property (nonatomic, strong) QMUIFillButton *withdrawBtn;

@property (nonatomic, strong) QMUITextField *pwdTextField;
@property (nonatomic, strong) QMUIModalPresentationViewController *payModalViewController;

@property (nonatomic, strong) IWallentInfoModel *wallentInfoModel;
@property (nonatomic, strong) NSString *payPwd;

@property (nonatomic, assign) NSInteger selectType;// 1:支付宝 2：银行卡
@property (nonatomic, strong) ICardModel *selectCardModel;//选中的银行卡

@end

@implementation WithdrawViewController

- (NSString *)title {
    return @"提现";
}

- (void)initSubviews {
    [super initSubviews];
    self.selectType = 1;
    [self addViews];
    [self addViewConstraints];
    [self loadData];
    
    [kNSNotification addObserver:self selector:@selector(alipayUserId:) name:@"kAliPayUserId" object:nil];
    //添加单击手势
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        [[self.view wl_findFirstResponder] resignFirstResponder];
//    }];
//    [self.view addGestureRecognizer:tap];
}

- (void)loadData {
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [UserModelClient withdrawInfoWithParams:nil Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        weakSelf.wallentInfoModel = [IWallentInfoModel modelWithDictionary:resultInfo];
        [weakSelf updateUi];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

- (void)updateUi {
    if (_wallentInfoModel.bank_card.account && _wallentInfoModel.bank_card.bank_adress.length > 0) {
        self.selectCardModel = _wallentInfoModel.bank_card;
        _typeCardTxtView.textField.text = [NSString stringWithFormat:@"%@（%@）", _selectCardModel.bank_adress, [_selectCardModel.account substringFromIndex:(_selectCardModel.account.length - 4)]];
    }
    _momeyLabel.text = [NSString stringWithFormat:@"我的余额：￥%@　可提现：￥%@", _wallentInfoModel.balance, _wallentInfoModel.enbale_balance.stringValue];
    _aboutLabel.text = [NSString stringWithFormat:@"提现说明：%@", _wallentInfoModel.info];
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
    
    // 转账金额
    LWLoginTextFieldView *moenyTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeMoney];
    moenyTxtView.titleLabel.text = @"提现金额";
//    moenyTxtView.isChangeBorder = NO;
    [self.view addSubview:moenyTxtView];
    self.moenyTxtView = moenyTxtView;
    [moenyTxtView.textField becomeFirstResponder];
    
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"我的余额：￥0.00　可提现：￥0.00";
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
    WEAKSELF
    [typeTxtView bk_whenTapped:^{
        [weakSelf checkSelectStatus:1];
    }];
    
    // 提现类型金额
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 137.f, 20.f)];
    iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_card"]];
    iconView.frame = CGRectMake(0.f, 0.f, 20.f, 20.f);
    [leftView addSubview:iconView];
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.text = @"提现到银行卡";
    titleLabel.font = UIFontMake(15);
    titleLabel.textColor = WLColoerRGB(51.f);
    titleLabel.frame = CGRectMake(25.f, 0.f, 110.f, 20.f);
    [leftView addSubview:titleLabel];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    [rightView addSubview:backView];
    [backView sizeToFit];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightView);
        make.left.mas_equalTo(rightView);
    }];
    
    LWLoginTextFieldView *typeCardTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeDefault];
    typeCardTxtView.textField.enabled = NO;
//    typeCardTxtView.textField.text = @"提现到银行卡";
    typeCardTxtView.textField.font = UIFontMake(12);
    typeCardTxtView.textField.textColor = WLColoerRGB(102.f);
    typeCardTxtView.textField.textAlignment = NSTextAlignmentRight;
    typeCardTxtView.textField.leftView = leftView;
    typeCardTxtView.textField.leftViewMode = UITextFieldViewModeAlways;
    typeCardTxtView.textField.rightView = rightView;
    typeCardTxtView.textField.rightViewMode = UITextFieldViewModeAlways;
//    typeCardTxtView.subTitleLabel.text = @"";
    [self.view addSubview:typeCardTxtView];
    self.typeCardTxtView = typeCardTxtView;
    [typeCardTxtView bk_whenTapped:^{
        [weakSelf checkSelectStatus:2];
    }];
    
    QMUILabel *aboutLabel = [[QMUILabel alloc] init];
    aboutLabel.text = @"提现说明：";
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
    
    // 默认选中
    [weakSelf checkSelectStatus:_selectType];
}

- (void)checkSelectStatus:(NSInteger)type {
    _selectType = type;
    if (_selectType == 1) {
        // 支付宝
        [_typeTxtView wl_setBorderWidth:.8f color:WLRGB(254.f, 72.f, 30.f)];
        [_typeCardTxtView wl_setBorderWidth:.8f color:WLColoerRGB(242.f)];
    }
    if (_selectType == 2) {
        // 银行卡
        MyCardViewController *vc = [[MyCardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if (_selectCardModel) {
            [_typeTxtView wl_setBorderWidth:.8f color:WLColoerRGB(242.f)];
            [_typeCardTxtView wl_setBorderWidth:.8f color:WLRGB(254.f, 72.f, 30.f)];
        }
        WEAKSELF
        [vc setCardSelectBlock:^(ICardModel *cardModel) {
            [weakSelf updateSelectCardType:cardModel];
        }];
    }
}

- (void)updateSelectCardType:(ICardModel *)cardModel {
    self.selectCardModel = cardModel;
    if (_selectCardModel) {
        [_typeTxtView wl_setBorderWidth:.8f color:WLColoerRGB(242.f)];
        [_typeCardTxtView wl_setBorderWidth:.8f color:WLRGB(254.f, 72.f, 30.f)];
        
        _typeCardTxtView.textField.text = [NSString stringWithFormat:@"%@（%@）", _selectCardModel.bank_adress, [_selectCardModel.account substringFromIndex:(cardModel.account.length - 4)]];
    } else {
        _selectType = 1;
        [self checkSelectStatus:_selectType];
    }
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
    
    [_typeCardTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.typeTxtView);
        make.centerX.mas_equalTo(self.typeTxtView);
        make.top.mas_equalTo(self.typeTxtView.mas_bottom).offset(15.f);
    }];
    
    [_aboutLabel sizeToFit];
    [_aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.momeyLabel);
        make.top.mas_equalTo(self.typeCardTxtView.mas_bottom).offset(8.f);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeCardTxtView.mas_bottom).offset(39.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalButtonHeight);
    }];
}

#pragma mark - private
// 立即提现按钮点击
- (void)withdrawBtnClicked:(UIButton *)sender {
    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入提现金额"];
        return;
    }
    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.floatValue == 0) {
        [WLHUDView showOnlyTextHUD:@"提现金额大于0元"];
        return;
    }
    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.floatValue > _wallentInfoModel.enbale_balance.floatValue) {
        [WLHUDView showOnlyTextHUD:[NSString stringWithFormat:@"提现金额不能大于%@",_wallentInfoModel.enbale_balance.stringValue]];
        return;
    }
    
    [self inputPayPwd:_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines];
}

// 输入支付密码
- (void)inputPayPwd:(NSString *)money {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 189.f)];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView wl_setCornerRadius:5.f];
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.font = UIFontMake(17);
    titleLabel.textColor = WLColoerRGB(51.f);
    titleLabel.text = @"支付";
    [contentView addSubview:titleLabel];
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(contentView).mas_offset(16.f);
    }];
    
    QMUILabel *moneyLabel = [[QMUILabel alloc] init];
    moneyLabel.font = UIFontMake(17);
    moneyLabel.textColor = WLColoerRGB(51.f);
    moneyLabel.text = [NSString stringWithFormat:@"%@元", money];
    [contentView addSubview:moneyLabel];
    //    self.idLabel = nameLabel;
    [moneyLabel sizeToFit];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(15.f);
    }];
    
    QMUITextField *pwdTextField = [[QMUITextField alloc] init];
    pwdTextField.placeholder = @"输入支付密码";
    pwdTextField.placeholderColor = WLColoerRGB(153.f);
    pwdTextField.font = UIFontMake(14.f);
    pwdTextField.textColor = WLColoerRGB(51.f);
    pwdTextField.secureTextEntry = YES;
    pwdTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [contentView addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    [pwdTextField wl_setCornerRadius:5.f];
    [pwdTextField wl_setBorderWidth:1.f color:WLColoerRGB(242.f)];
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240.f, 36.f));
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(moneyLabel.mas_bottom).mas_offset(15.f);
    }];
    
    QMUIFillButton *payBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [payBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    payBtn.titleLabel.font = WLFONT(14);
    [payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setCornerRadius:5.f];
    [contentView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(115.f, 36.f));
        make.left.mas_equalTo(pwdTextField);
        make.top.mas_equalTo(pwdTextField.mas_bottom).mas_offset(15.f);
    }];
    
    QMUIFillButton *cancelBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGray];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = WLFONT(14);
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setCornerRadius:5.f];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(payBtn);
        make.right.mas_equalTo(pwdTextField);
        make.top.mas_equalTo(pwdTextField.mas_bottom).mas_offset(15.f);
    }];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    modalViewController.contentView = contentView;
    modalViewController.modal = YES;
    //    modalViewController.delegate = self;
    [modalViewController showWithAnimated:YES completion:nil];
    self.payModalViewController =  modalViewController;
}

// 确认支付
- (void)payBtnClicked:(UIButton *)sender {
    WEAKSELF
    [_payModalViewController hideWithAnimated:YES completion:^(BOOL finished) {
        [weakSelf payTypeSelect];
    }];
}

- (void)payTypeSelect {
    // 钱包 - 提现 - 支付宝授权登录
    [WLHUDView showHUDWithStr:@"提现中..." dim:YES];
    if (_selectType == 1) {
        //支付宝
        NSDictionary *params = @{@"password" : _pwdTextField.text.wl_trimWhitespaceAndNewlines,
                                 @"money" : [NSNumber numberWithFloat:_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.floatValue]};
//        WEAKSELF
        [UserModelClient aliPayLoginWithParams:params Success:^(id resultInfo) {
            [[AlipaySDK defaultService] auth_V2WithInfo:resultInfo fromScheme:@"AlipayMineSweeper" callback:^(NSDictionary *resultDic) {
                DLog(@"auth_V2WithInfo:%@", resultDic);
            }];
        } Failed:^(NSError *error) {
            if (error.localizedDescription.length > 0) {
                [WLHUDView showErrorHUD:error.localizedDescription];
            } else {
                [WLHUDView hiddenHud];
            }
        }];
    }
    if (_selectType == 2) {
        // 银行卡 user_id：银行卡id
        if (_selectCardModel) {
            [self withdrawData:_selectCardModel.cardId];
        }
    }
}

// 获取到支付宝支付信息
- (void)alipayUserId:(NSNotification *)notification {
    NSString *user_id = [notification object];//通过这个获取到传递的对象
    [self withdrawData:user_id];
}

// 提现
- (void)withdrawData:(NSString *)userId {
    NSDictionary *params = @{@"user_id" : userId,
                             @"password" : _pwdTextField.text.wl_trimWhitespaceAndNewlines,
                             @"money" : [NSNumber numberWithFloat:_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.floatValue],
                             @"pay_type" : _selectType == 1 ? @(10) : @(20)
                             };
    WEAKSELF
    [UserModelClient withdrawWallentWithParams:params Success:^(id resultInfo) {
        [kNSNotification postNotificationName:@"kUserInfoChanged" object:nil];
        weakSelf.moenyTxtView.textField.text = @"";
        [WLHUDView showSuccessHUD:@"提现成功"];
        [weakSelf reloadData];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}

- (void)reloadData {
    WEAKSELF
    [UserModelClient withdrawInfoWithParams:nil Success:^(id resultInfo) {
        weakSelf.wallentInfoModel = [IWallentInfoModel modelWithDictionary:resultInfo];
        [weakSelf updateUi];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

// 取消支付
- (void)cancelBtnClicked:(UIButton *)sender {
    [_payModalViewController hideWithAnimated:YES completion:nil];
    
}

@end
