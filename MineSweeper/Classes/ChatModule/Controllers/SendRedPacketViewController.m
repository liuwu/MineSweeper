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

@interface SendRedPacketViewController ()<QMUIModalPresentationViewControllerDelegate>

@property (nonatomic, strong) LWLoginTextFieldView *moenyTxtView;
@property (nonatomic, strong) LWLoginTextFieldView *packetNountTxtView;
@property (nonatomic, strong) QMUILabel *userCountLabel;
@property (nonatomic, strong) LWLoginTextFieldView *mineCountTxtView;
@property (nonatomic, strong) QMUIFillButton *sendBtn;

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
    packetNountTxtView.textField.placeholder = @"填写个数";
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
    [self showOpenPacket];
}

// 打开红包页面
- (void)showOpenPacket {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"openRedP_redP_img"]];
    //    contentView.backgroundColor = UIColorWhite;
    [contentView addSubview:bgView];
    [bgView sizeToFit];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.centerY.mas_equalTo(contentView);
    }];
    
    QMUILabel *nameLabel = [[QMUILabel alloc] init];
    nameLabel.font = UIFontMake(15);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"你抢到了";
    [contentView addSubview:nameLabel];
    //    self.idLabel = nameLabel;
    [nameLabel sizeToFit];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(bgView.mas_top).mas_offset(165.f);
    }];
    
    QMUILabel *moneyLabel = [[QMUILabel alloc] init];
    moneyLabel.font = UIFontMake(30);
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.attributedText = [NSString wl_getAttributedInfoString:@"2.00元"
                                                 searchStr:@"元"
                                                     color:[UIColor whiteColor]
                                                      font:UIFontMake(10.f)] ;
    [contentView addSubview:moneyLabel];
    [moneyLabel sizeToFit];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(8.f);
    }];
    
    UIButton *lookMoreBtn = [[UIButton alloc] init];
    [lookMoreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [lookMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lookMoreBtn.titleLabel.font = WLFONT(14);
    [lookMoreBtn addTarget:self action:@selector(lookMoreBtnClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:lookMoreBtn];
    [lookMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200.f);
        make.height.mas_equalTo(44.f);
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(moneyLabel.mas_bottom).mas_offset(-5.f);
    }];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    modalViewController.contentView = contentView;
//    modalViewController.delegate = self;
    [modalViewController showWithAnimated:YES completion:nil];
}

//- (BOOL)shouldHideModalPresentationViewController:(QMUIModalPresentationViewController *)controller {
//     DLog(@"shouldHideModalPresentationViewController --------");
//
//    return NO;
//}

- (void)lookMoreBtnClickedBtn:(UIButton *)sender {
    DLog(@"lookMoreBtnClickedBtn --------");
}

@end
