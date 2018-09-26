//
//  TransferViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "TransferViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"
#import "LWLoginTextFieldView.h"

#import "UserModelClient.h"

@interface TransferViewController ()

@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) QMUIButton *nameBtn;
@property (nonatomic, strong) QMUILabel *idLabel;
@property (nonatomic, strong) LWLoginTextFieldView *moenyTxtView;
@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) QMUIFillButton *transferBtn;

@end

@implementation TransferViewController

- (NSString *)title {
    return @"转账";
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
    
    // 用户信息
    UIView *userView = [[UIView alloc] initWithFrame:CGRectZero];
    userView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userView];
    self.userView = userView;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    logoImageView.image = [[UIImage imageNamed:@"mine_award_icon"] qmui_imageWithClippedCornerRadius:15.f];
    [logoImageView setImageWithURL:[NSURL URLWithString:_friendModel.avatar] placeholder:[[UIImage imageNamed:@"mine_award_icon"] qmui_imageWithClippedCornerRadius:15.f] options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur completion:nil];
    logoImageView.backgroundColor = [UIColor redColor];
    [logoImageView wl_setCornerRadius:15.f];
    [userView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    // 图片+文字按钮
    QMUIButton *nameBtn = [[QMUIButton alloc] init];
    nameBtn.tintColorAdjustsTitleAndImage = WLColoerRGB(51.f);
    nameBtn.imagePosition = QMUIButtonImagePositionRight;// 将图片位置改为在文字上方
//    nameBtn.spacingBetweenImageAndTitle = 7;
//    [nameBtn setImage:UIImageMake(@"common_qrCode_icon") forState:UIControlStateNormal];
    [nameBtn setTitle:_friendModel.nickname forState:UIControlStateNormal];
    nameBtn.titleLabel.font = UIFontMake(12.f);
    //    nameBtn.qmui_borderPosition = QMUIViewBorderPositionTop | QMUIViewBorderPositionBottom;
    [userView addSubview:nameBtn];
    self.nameBtn = nameBtn;
    
    QMUILabel *idLabel = [[QMUILabel alloc] init];
    idLabel.font = UIFontMake(12);
    idLabel.textColor = WLColoerRGB(153.f);
    idLabel.text = @"ID:16854587";
    [userView addSubview:idLabel];
    self.idLabel = idLabel;
    
    // 转账金额
    LWLoginTextFieldView *moenyTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeMoney];
    [self.view addSubview:moenyTxtView];
    self.moenyTxtView = moenyTxtView;
    [moenyTxtView.textField becomeFirstResponder];
    
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"我的余额：￥200.00";
    momeyLabel.font = UIFontMake(12);
    momeyLabel.textColor = WLColoerRGB(153.f);
    [self.view addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    
    // 立即转账
    QMUIFillButton *transferBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [transferBtn setTitle:@"立即转账" forState:UIControlStateNormal];
    transferBtn.titleLabel.font = WLFONT(18);
    [transferBtn addTarget:self action:@selector(transferBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [transferBtn setCornerRadius:5.f];
    [self.view addSubview:transferBtn];
    self.transferBtn = transferBtn;
}

// 添加页面view布局控制
- (void)addViewConstraints {
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo([self qmui_navigationBarMaxYInViewCoordinator]);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWL_NormalIconSmallWidth, kWL_NormalIconSmallWidth));
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.centerY.mas_equalTo(self.userView);
    }];
    
    [_nameBtn sizeToFit];
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(7.f);
        make.top.mas_equalTo(self.logoImageView.mas_top).offset(2.f);
    }];
    
    [_idLabel sizeToFit];
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameBtn);
        make.bottom.mas_equalTo(self.logoImageView);
    }];
    
    [_moenyTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userView.mas_bottom).offset(11.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalTextFieldHeight);
    }];
    
    [_momeyLabel sizeToFit];
    [_momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_20);
        make.top.mas_equalTo(self.moenyTxtView.mas_bottom).offset(8.f);
    }];
    
    [_transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moenyTxtView.mas_bottom).offset(39.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalButtonHeight);
    }];
}

#pragma mark - private
// 立即转账按钮点击
- (void)transferBtnClicked:(UIButton *)sender {
    WEAKSELF
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf sendTransfer];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定进行转账？" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

// 发送转账
- (void)sendTransfer {
    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入转账金额"];
        return;
    }
    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.floatValue == 0) {
        [WLHUDView showOnlyTextHUD:@"转账金额必须大于0"];
        return;
    }
    
    NSDictionary *params = @{
                             @"uid" : [NSNumber numberWithInteger:_friendModel.uid.integerValue],
                             @"money" : [NSNumber numberWithFloat:[_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines floatValue]]
                             };
    [WLHUDView showHUDWithStr:@"转账中..." dim:YES];
    [UserModelClient transferWallentWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:resultInfo];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

@end
