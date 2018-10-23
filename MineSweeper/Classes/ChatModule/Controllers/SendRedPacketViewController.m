//
//  SendRedPacketViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SendRedPacketViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"
#import "LWLoginTextFieldView.h"

#import "ImModelClient.h"
#import "RCRedPacketMessage.h"
#import "IRedPacketResultModel.h"
#import "UserModelClient.h"

@interface SendRedPacketViewController ()<QMUIModalPresentationViewControllerDelegate>

@property (nonatomic, strong) LWLoginTextFieldView *moenyTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *packetNountTxtView;
@property (nonatomic, strong) QMUILabel *userCountLabel;
@property (nonatomic, strong) LWLoginTextFieldView *mineCountTxtView;
@property (nonatomic, strong) QMUIFillButton *sendBtn;

@property (nonatomic, strong) QMUITextField *pwdTextField;
@property (nonatomic, strong) QMUIModalPresentationViewController *payModalViewController;

@end

@implementation SendRedPacketViewController

- (NSString *)title {
    return @"发红包";
}

- (void)initSubviews {
    [super initSubviews];
    [self addViews];
    [self addViewConstraints];
    
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
    
    // 金额
    LWLoginTextFieldView *moenyTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeMoney];
    moenyTxtView.titleLabel.text = @"请输入红包总金额";
    [self.view addSubview:moenyTxtView];
    self.moenyTxtView = moenyTxtView;
    [moenyTxtView.textField becomeFirstResponder];
    
    // 红包个数
    LWLoginTextFieldView *packetNountTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeMoney];
    packetNountTxtView.titleLabel.text = @"红包个数";
    packetNountTxtView.subTitleLabel.text = @"个";
    packetNountTxtView.textField.text = @"7";
    packetNountTxtView.textField.enabled = NO;
    packetNountTxtView.textField.placeholder = @"填写个数";
    packetNountTxtView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:packetNountTxtView];
    self.packetNountTxtView = packetNountTxtView;
    
    QMUILabel *userCountLabel = [[QMUILabel alloc] init];
    userCountLabel.text = @"群组共5人";
    userCountLabel.font = UIFontMake(12);
    userCountLabel.textColor = WLColoerRGB(153.f);
    [self.view addSubview:userCountLabel];
    self.userCountLabel = userCountLabel;
    
    // 雷数
    LWLoginTextFieldView *mineCountTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeMoney];
    mineCountTxtView.titleLabel.text = @"雷数";
    mineCountTxtView.subTitleLabel.text = @"个";
    mineCountTxtView.textField.placeholder = @"填写个数";
    mineCountTxtView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:mineCountTxtView];
    self.mineCountTxtView = mineCountTxtView;
    
    // 发送
    QMUIFillButton *sendBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [sendBtn setTitle:@"塞进红包" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = WLFONT(18);
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setCornerRadius:5.f];
    [self.view addSubview:sendBtn];
    self.sendBtn = sendBtn;
}

// 添加页面view布局控制
- (void)addViewConstraints {
    [_moenyTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DEVICE_WIDTH - 20.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo([self qmui_navigationBarMaxYInViewCoordinator] + 10.f);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [_packetNountTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.moenyTxtView);
        make.centerX.mas_equalTo(self.moenyTxtView);
        make.top.mas_equalTo(self.moenyTxtView.mas_bottom).mas_offset(10.f);
    }];
    
    [_userCountLabel sizeToFit];
    [_userCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.packetNountTxtView).offset(7.f);
        make.top.mas_equalTo(self.packetNountTxtView.mas_bottom).offset(8.f);
    }];
    
    [_mineCountTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.packetNountTxtView.mas_bottom).offset(30.f);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(self.moenyTxtView);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mineCountTxtView.mas_bottom).offset(20.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalButtonHeight);
    }];
}

#pragma mark - private
// 发送
- (void)sendBtnClicked:(UIButton *)sender {
    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入红包金额"];
        return;
    }
    if (_packetNountTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入红包个数"];
        return;
    }
    if (_mineCountTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入雷数"];
        return;
    }
    
//    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.floatValue == 0) {
//        [WLHUDView showOnlyTextHUD:@"红包金额大于0元"];
//        return;
//    }
    if (_packetNountTxtView.textField.text.wl_trimWhitespaceAndNewlines.integerValue == 0) {
        [WLHUDView showOnlyTextHUD:@"红包个数大于0个"];
        return;
    }
    [self sendPacket];
//    WEAKSELF
//    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
//    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"发送" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
//        [weakSelf sendPacket];
//    }];
//    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定发送？" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
//    [alertController addAction:action1];
//    [alertController addAction:action2];
//    [alertController showWithAnimated:YES];
    
}

- (void)sendPacket {
    if (configTool.userInfoModel.is_secret_free.integerValue == 1) {
        // 免密下注
        [self payBtnClicked:nil];
    } else {
        [self inputPayPwd:_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines];
    }
}

// 设置免密下注
- (void)setFreeChip:(UISwitch *)item {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    NSDictionary *params = @{@"is_secret_free" : [NSNumber numberWithBool:item.on]};
    [UserModelClient setSecretFreeWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"已设置"];
        configTool.userInfoModel.is_secret_free = @(item.on).stringValue;
        //        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
    } Failed:^(NSError *error) {
        item.on = !item.on;
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
    
}

// 输入支付密码
- (void)inputPayPwd:(NSString *)money {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 234.f)];
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
    
    UISwitch *pwdSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    pwdSwitch.on = configTool.userInfoModel.is_secret_free.boolValue;
    [pwdSwitch addTarget:self action:@selector(setFreeChip:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:pwdSwitch];
    [pwdSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(60, 44.f));
        make.top.mas_equalTo(pwdTextField.mas_bottom).mas_offset(5.f);
        make.right.mas_equalTo(pwdTextField);
    }];
    
    QMUILabel *pwdLabel = [[QMUILabel alloc] init];
    pwdLabel.font = UIFontMake(14);
    pwdLabel.textColor = WLColoerRGB(51.f);
    pwdLabel.text = @"免密下注";
    [contentView addSubview:pwdLabel];
//    [pwdLabel sizeToFit];
    [pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pwdSwitch);
        make.right.mas_equalTo(pwdSwitch.mas_left).mas_offset(-5.f);
    }];

    QMUIFillButton *payBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = WLFONT(14);
    [payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setCornerRadius:5.f];
    [contentView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(115.f, 36.f));
        make.left.mas_equalTo(pwdTextField);
        make.top.mas_equalTo(pwdSwitch.mas_bottom).mas_offset(10.f);
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
        make.top.mas_equalTo(pwdSwitch.mas_bottom).mas_offset(10.f);
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
    [_payModalViewController hideWithAnimated:YES completion:nil];
    NSDictionary *noParams = @{@"group_id" : [NSNumber numberWithInteger:_groupId.integerValue],
                               @"money" : [NSNumber numberWithFloat:_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.floatValue],
                               @"num" : [NSNumber numberWithInteger:_packetNountTxtView.textField.text.wl_trimWhitespaceAndNewlines.integerValue],
                               @"thunder" : [NSNumber numberWithInteger:_mineCountTxtView.textField.text.wl_trimWhitespaceAndNewlines.integerValue]};
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:noParams];
    if (configTool.userInfoModel.is_secret_free.integerValue == 0) {
        [params setObject:_pwdTextField.text.wl_trimWhitespaceAndNewlines forKey:@"password"];
    }
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [ImModelClient imSendRedpackWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"发送成功"];
        IRedPacketResultModel *packModel = [IRedPacketResultModel modelWithDictionary:resultInfo];
        [weakSelf sendImMessage:packModel];
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

- (void)sendImMessage:(IRedPacketResultModel *)packModel {
    // 构建消息的内容，这里以文本消息为例。
    RCRedPacketMessage *msg = [[RCRedPacketMessage alloc] init];
    RCUserInfo *senderUserInfo = [[RCUserInfo alloc] initWithUserId:configTool.userInfoModel.userId
                                                               name:configTool.userInfoModel.nickname
                                                           portrait:configTool.userInfoModel.avatar];
    msg.senderUserInfo = senderUserInfo;
    msg.pack_id = packModel.packet_id;
    msg.title = packModel.title;
    msg.total_money = _moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines;
    msg.num = _packetNountTxtView.textField.text.wl_trimWhitespaceAndNewlines;
    msg.thunder = _mineCountTxtView.textField.text.wl_trimWhitespaceAndNewlines;
    msg.uid = @(configTool.loginUser.uid.integerValue);
    msg.avatar = configTool.userInfoModel.avatar;
    msg.name = configTool.userInfoModel.nickname;
//    [self sendMessage:msg pushContent:@"hahha"];
//    RCTextMessage *testMessage = [RCTextMessage messageWithContent:@"test"];
    // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
//    WEAKSELF
    RCMessage *sendMsg = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_GROUP
                                                targetId:_groupId
                                              sentStatus:SentStatus_SENT
                                                 content:msg];
    
    if (_sendRedPacketBlock) {
        _sendRedPacketBlock(sendMsg);
    }
    
//    [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP
//                          targetId:_groupId
//                           content:msg
//                       pushContent:nil
//                          pushData:nil
//                           success:^(long messageId) {
//                               DLog(@"发送成功。当前消息ID：%ld", messageId);
//                           } error:^(RCErrorCode nErrorCode, long messageId) {
//                               DLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, nErrorCode);
//                           }];
}

@end
