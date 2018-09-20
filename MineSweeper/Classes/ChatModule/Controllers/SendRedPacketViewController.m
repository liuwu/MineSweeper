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

@interface SendRedPacketViewController ()

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
    
}

@end
