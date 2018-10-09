//
//  AddCardViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/8.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "AddCardViewController.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"

#import "RETableViewManager.h"

#import "LWCardTextView.h"

@interface AddCardViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@property (nonatomic, strong) LWCardTextView *userTxtView;
@property (nonatomic, strong) LWCardTextView *cardTxtView;
@property (nonatomic, strong) LWCardTextView *cardTypeTxtView;

@property (nonatomic, strong) QMUITextField *pwdTextField;
@property (nonatomic, strong) QMUIModalPresentationViewController *payModalViewController;

@end

@implementation AddCardViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title {
    return @"添加银行卡";
}

- (void)initSubviews {
    [super initSubviews];
    [self addSubViews];
    //    [self addConstrainsForSubviews];
    
//    [self addTableViewCell];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

- (void)addSubViews {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 231.f)];
    self.tableView.tableHeaderView = headerView;
    
    QMUILabel *idLabel = [[QMUILabel alloc] init];
    idLabel.font = UIFontMake(12);
    idLabel.textColor = WLColoerRGB(153.f);
    idLabel.text = @"请绑定持卡人本人的银行卡";
    [headerView addSubview:idLabel];
    [idLabel sizeToFit];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15.f);
    }];

//    LWLoginTextFieldView *userTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
//    userTxtView.titleLabel.text = @"持卡人";
//    userTxtView.textField.placeholder = @"姓名";
//    [headerView addSubview:userTxtView];

    LWCardTextView *userTxtView = [[LWCardTextView alloc] initWithType:LWCardTextViewTypeDefault];
    userTxtView.titleLabel.text = @"持卡人";
    userTxtView.textField.placeholder = @"姓名";
    [headerView addSubview:userTxtView];
    self.userTxtView = userTxtView;
    [userTxtView wl_setBorderWidth:.8f color:WLColoerRGB(242.f)];
    [userTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44.f));
        make.top.mas_equalTo(idLabel.mas_bottom).mas_offset(10.f);
        make.centerX.mas_equalTo(headerView);
    }];
    
    LWCardTextView *cardTxtView = [[LWCardTextView alloc] initWithType:LWCardTextViewTypeCardNO];
    cardTxtView.textField.placeholder = @"银行卡号";
    [headerView addSubview:cardTxtView];
    self.cardTxtView = cardTxtView;
//    [cardTxtView setQmui_borderColor: WLColoerRGB(242.f)];
//    [cardTxtView setQmui_borderWidth:.8f];
//    [cardTxtView setQmui_borderPosition:QMUIBorderViewPositionBottom];
    [cardTxtView wl_setBorderWidth:.8f color:WLColoerRGB(242.f)];
    [cardTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44.f));
        make.top.mas_equalTo(userTxtView.mas_bottom).mas_offset(-0.8f);
        make.centerX.mas_equalTo(headerView);
    }];
    
//
//    LWLoginTextFieldView *cardTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
//    cardTxtView.titleLabel.text = @"卡号";
//    cardTxtView.textField.placeholder = @"银行卡号";
//    [headerView addSubview:cardTxtView];
//    [cardTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(userTxtView);
//        make.top.mas_equalTo(userTxtView.mas_bottom);
//        make.centerX.mas_equalTo(headerView);
//    }];
//
//    LWLoginTextFieldView *cardTypeTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypePhone];
//    cardTypeTxtView.titleLabel.text = @"开户行";
//    cardTypeTxtView.textField.placeholder = @"开户银行";
    LWCardTextView *cardTypeTxtView = [[LWCardTextView alloc] initWithType:LWCardTextViewTypeDefault];
    cardTypeTxtView.titleLabel.text = @"开户行";
    cardTypeTxtView.textField.placeholder = @"开户银行";
    [headerView addSubview:cardTypeTxtView];
    self.cardTypeTxtView = cardTypeTxtView;
//    [cardTypeTxtView setQmui_borderColor: WLColoerRGB(242.f)];
//    [cardTypeTxtView setQmui_borderWidth:.8f];
//    [cardTypeTxtView setQmui_borderPosition:QMUIBorderViewPositionBottom];
    [cardTypeTxtView wl_setBorderWidth:.8f color:WLColoerRGB(242.f)];
    [cardTypeTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(userTxtView);
        make.top.mas_equalTo(cardTxtView.mas_bottom).mas_offset(-0.8f);
        make.centerX.mas_equalTo(headerView);
    }];
    
    // 添加银行卡
    QMUIFillButton *bindBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    bindBtn.titleLabel.font = UIFontMake(18);
//    [bindBtn setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    [bindBtn addTarget:self action:@selector(bindBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bindBtn setCornerRadius:5.f];
    [headerView addSubview:bindBtn];
    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
        make.bottom.mas_equalTo(headerView);
        make.centerX.mas_equalTo(headerView);
    }];
}

// 添加表格内容
- (void)addTableViewCell {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    WEAKSELF
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"请绑定持卡人本人的银行卡"];
    
    RETextItem *commendItem = [RETextItem itemWithTitle:@"持卡人" value:nil placeholder:@"持卡人姓名"];
    commendItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    commendItem.style = UITableViewCellStyleValue1;
//    commendItem.detailLabelText = configTool.userInfoModel.invite_code;
//    commendItem.titleDetailTextColor = WLColoerRGB(153.f);
//    commendItem.titleDetailTextFont = UIFontMake(15.f);
//    commendItem.image = [UIImage imageNamed:@"mine_recommend_icon"];
    [section addItem:commendItem];
//    self.commendItem = commendItem;
    
    RECreditCardItem *cardItem = [RECreditCardItem item];
//    cardItem.style = UITableViewCellStyleValue1;
    //    cardItem.detailLabelText = configTool.userInfoModel.invite_code;
//    cardItem.titleDetailTextColor = WLColoerRGB(153.f);
//    cardItem.titleDetailTextFont = UIFontMake(15.f);
//    cardItem.image = [UIImage imageNamed:@"mine_card"];
//    cardItem.creditCardType = RECreditCardTypeUnknown;
    cardItem.title = @"卡号";
    cardItem.cvvRequired = NO;
    cardItem.keyboardAppearance = UIKeyboardAppearanceDefault;
    [section addItem:cardItem];
//    self.cardItem = cardItem;
    
    RETextItem *promotionPosterItem = [RETextItem itemWithTitle:@"开户行" value:nil placeholder:@"开户行"];
//    promotionPosterItem.image = [UIImage imageNamed:@"mine_share_icon"];
    [section addItem:promotionPosterItem];
    [self.manager addSection:section];
}


#pragma mark - Private
- (void)bindBtnClicked:(UIButton *)sender {
    if (_userTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入持卡人"];
        return;
    }
    if (_cardTxtView.number.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入卡号"];
        return;
    }
    if (_cardTypeTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入开户行"];
        return;
    }
    [self inputPayPwd:nil];
}


// 输入支付密码
- (void)inputPayPwd:(NSString *)money {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 189.f)];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView wl_setCornerRadius:5.f];
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.font = UIFontMake(17);
    titleLabel.textColor = WLColoerRGB(51.f);
    titleLabel.text = @"添加银行卡";
    [contentView addSubview:titleLabel];
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(contentView).mas_offset(16.f);
    }];
    
//    QMUILabel *moneyLabel = [[QMUILabel alloc] init];
//    moneyLabel.font = UIFontMake(17);
//    moneyLabel.textColor = WLColoerRGB(51.f);
//    moneyLabel.text = [NSString stringWithFormat:@"%@元", money];
//    [contentView addSubview:moneyLabel];
//    //    self.idLabel = nameLabel;
//    [moneyLabel sizeToFit];
//    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(contentView);
//        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(15.f);
//    }];
    
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
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(20.f);
    }];
    
    QMUIFillButton *cancelBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGray];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = WLFONT(14);
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setCornerRadius:5.f];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(115.f, 36.f));
        make.left.mas_equalTo(pwdTextField);
        make.top.mas_equalTo(pwdTextField.mas_bottom).mas_offset(15.f);
    }];
    
    QMUIFillButton *payBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [payBtn setTitle:@"确认添加" forState:UIControlStateNormal];
    payBtn.titleLabel.font = WLFONT(14);
    [payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setCornerRadius:5.f];
    [contentView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(115.f, 36.f));
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
    if (_pwdTextField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入支付密码"];
        return;
    }
    [_payModalViewController hideWithAnimated:YES completion:nil];
    
    NSDictionary *params = @{@"password" : _pwdTextField.text.wl_trimWhitespaceAndNewlines,
                             @"username" : _userTxtView.textField.text,
                             @"account" : _cardTxtView.number,
                             @"bank_adress" : _cardTypeTxtView.textField.text
                             };
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [UserModelClient addBankCardListWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"添加成功"];
        [kNSNotification postNotificationName:@"kMyCardChanged" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}

// 取消支付
- (void)cancelBtnClicked:(UIButton *)sender {
    [_payModalViewController hideWithAnimated:YES completion:nil];
    
}



@end
