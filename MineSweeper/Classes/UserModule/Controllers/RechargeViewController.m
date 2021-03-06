//
//  RechargeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RechargeViewController.h"
#import "AXWebViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"
#import "LWLoginTextFieldView.h"

#import "PayWebViewController.h"

#import "UserModelClient.h"

#import <AlipaySDK/AlipaySDK.h>

@interface RechargeViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) LWLoginTextFieldView *moenyTxtView;
@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) UIView *moenyTypeView;
@property (nonatomic, strong) QMUILabel *payLabel;
@property (nonatomic, strong) QMUILabel *payMomeyLabel;
@property (nonatomic, strong) QMUILabel *payMomeyUnitLabel;
@property (nonatomic, strong) QMUIFillButton *payBtn;
// 金额选择
@property (nonatomic, strong) QMUIFloatLayoutView *moneyLayoutView;
@property (nonatomic, strong) NSArray<NSString *> *moneyTitleArray;
@property (nonatomic, strong) NSArray<NSNumber *> *moneyArray;

@property (nonatomic, strong) QMUIFillButton *selectMoneyBtn;
@property (nonatomic, assign) float payMoney;

@property (nonatomic, strong) RETableViewItem *balancePayItem;
@property (nonatomic, strong) RETableViewItem *aliPayItem;

@property (nonatomic, strong) UITableView *tableView;
// 选中的支付方式 1:余额支付  2：支付宝支付
@property (nonatomic, assign) NSInteger selectPayType;

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation RechargeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.webView.delegate = nil;
}

- (NSString *)title {
    return @"充值";
}

- (void)initSubviews {
    [super initSubviews];
    self.moneyTitleArray = @[@"50元", @"100元", @"200元", @"500元", @"1000元", @"2000元"];
    self.moneyArray = @[@50, @100, @200, @500, @1000, @2000];
    self.selectPayType = 1;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
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

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    textField.text = @"";
//    // 把旧的选中的按钮设置为未选中的颜色
//    if (self.selectMoneyBtn != nil) {
//        self.selectMoneyBtn.titleTextColor = UIColorMake(254,72,30);
//        self.selectMoneyBtn.fillColor = FillButtonColorWhite;
//    }
//    self.payMoney = 0.f;
//    self.payMomeyLabel.text = @"0";
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    self.payMomeyLabel.text = textField.text;
//    self.payMoney = [self.payMomeyLabel.text floatValue];
//}

// 添加表格内容
- (void)addViews {
    self.view.backgroundColor = WLColoerRGB(248.f);
    
    // 充值金额
    LWLoginTextFieldView *moenyTxtView = [[LWLoginTextFieldView alloc] initWithTextFieldType:LWLoginTextFieldTypeMoney];
    moenyTxtView.titleLabel.text = @"充值金额";
    moenyTxtView.textField.delegate = self;
    [self.view addSubview:moenyTxtView];
    self.moenyTxtView = moenyTxtView;
//    [moenyTxtView.textField becomeFirstResponder];
    WEAKSELF
    
    [moenyTxtView.textField setBk_didBeginEditingBlock:^(UITextField *textField) {
        textField.text = @"";
        // 把旧的选中的按钮设置为未选中的颜色
        if (weakSelf.selectMoneyBtn != nil) {
            weakSelf.selectMoneyBtn.titleTextColor = UIColorMake(254,72,30);
            weakSelf.selectMoneyBtn.fillColor = FillButtonColorWhite;
        }
        weakSelf.payMoney = 0.f;
        weakSelf.payMomeyLabel.text = @"0";
    }];

    [moenyTxtView.textField setBk_didEndEditingBlock:^(UITextField *textField) {
        weakSelf.payMomeyLabel.text = textField.text;
        weakSelf.payMoney = [weakSelf.payMomeyLabel.text floatValue];
    }];
    
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"或选择充值金额";
    momeyLabel.font = UIFontMake(12);
    momeyLabel.textColor = WLColoerRGB(153.f);
    [self.view addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    
    UIView *moenyTypeView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:moenyTypeView];
    self.moenyTypeView = moenyTypeView;
//    [moenyTypeView wl_setDebug:YES];
    
    QMUIFloatLayoutView *moneyLayoutView = [[QMUIFloatLayoutView alloc] init];
    moneyLayoutView.padding = UIEdgeInsetsMake(0, 10, 10, 0);
    moneyLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
    moneyLayoutView.minimumItemSize = CGSizeMake(112, 44.f);// 以2个字的按钮作为最小宽度
//    moneyLayoutView.layer.borderWidth = PixelOne;
//    moneyLayoutView.layer.borderColor = UIColorSeparator.CGColor;
//    moneyLayoutView.layer.cornerRadius = 5.f;
    [moenyTypeView addSubview:moneyLayoutView];
    self.moneyLayoutView = moneyLayoutView;
    
    for (NSInteger i = 0; i < _moneyTitleArray.count; i++) {
        QMUIFillButton *momeyBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorWhite];
        momeyBtn.tag = i;
        [momeyBtn setTitle:_moneyTitleArray[i] forState:UIControlStateNormal];
        momeyBtn.titleLabel.font = UIFontMake(15);
//        button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
        momeyBtn.cornerRadius = 5.f;
        momeyBtn.titleTextColor = UIColorMake(254,72,30);
        [momeyBtn addTarget:self action:@selector(momeyBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.moneyLayoutView addSubview:momeyBtn];
    }
    
    QMUILabel *payLabel = [[QMUILabel alloc] init];
    payLabel.text = @"实付金额";
    payLabel.font = UIFontMake(12);
    payLabel.textColor = WLColoerRGB(51.f);
    [self.view addSubview:payLabel];
    self.payLabel = payLabel;
    
    QMUILabel *payMomeyLabel = [[QMUILabel alloc] init];
    payMomeyLabel.text = @"0";
    payMomeyLabel.font = UIFontBoldMake(30.f);
    payMomeyLabel.textColor = UIColorMake(254,72,30);
    [self.view addSubview:payMomeyLabel];
    self.payMomeyLabel = payMomeyLabel;
    
    QMUILabel *payMomeyUnitLabel = [[QMUILabel alloc] init];
    payMomeyUnitLabel.text = @"元";
    payMomeyUnitLabel.font = UIFontMake(12.f);
    payMomeyUnitLabel.textColor = UIColorMake(254,72,30);
    [self.view addSubview:payMomeyUnitLabel];
    self.payMomeyUnitLabel = payMomeyUnitLabel;
    
    // 立即转账
    QMUIFillButton *payBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = WLFONT(18);
    [payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.cornerRadius = 5.f;
    [self.view addSubview:payBtn];
    self.payBtn = payBtn;
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
        make.top.mas_equalTo(self.moenyTxtView.mas_bottom).offset(kWL_NormalMarginWidth_11);
    }];
    
    [_moenyTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(98.f);
        make.top.mas_equalTo(self.moenyTxtView.mas_bottom).offset(39.f);
    }];
    
    [_moneyLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.moenyTypeView);
    }];
    
    [_payLabel sizeToFit];
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.momeyLabel);
        make.top.mas_equalTo(self.moenyTypeView.mas_bottom).offset(15.f);
    }];
    
    [_payMomeyLabel sizeToFit];
    [_payMomeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.momeyLabel);
        make.top.mas_equalTo(self.payLabel.mas_bottom).offset(10.f);
    }];
    
    [_payMomeyUnitLabel sizeToFit];
    [_payMomeyUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payMomeyLabel.mas_right);
        make.bottom.mas_equalTo(self.payMomeyLabel.mas_bottom).offset(-5.f);
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.payMomeyLabel.mas_bottom).offset(21.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.right.mas_equalTo(self.view).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(kWL_NormalButtonHeight);
    }];
}


#pragma mark -
#pragma mark   ============== webview相关 回调及加载 ==============
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //新版本的H5拦截支付对老版本的获取订单串和订单支付接口进行合并，推荐使用该接口
//    __weak PayWebViewController* wself = self;
    @weakify(self);
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[request.URL absoluteString] fromScheme:@"AlipayPayMineSweeper" callback:^(NSDictionary *result) {
        @strongify(self);
        // 处理支付结果
        DLog(@"支付结果 ------ %@", result);
        // isProcessUrlPay 代表 支付宝已经处理该URL
        if ([result[@"isProcessUrlPay"] boolValue]) {
            dispatch_async_on_main_queue(^{
                NSInteger resultCode = [result[@"resultCode"] integerValue];
                [self showSuccess:resultCode];
            });
            // returnUrl 代表 第三方App需要跳转的成功页URL
            //            NSString* urlStr = result[@"returnUrl"];
            //            [wself loadWithUrlStr:urlStr];
        }
    }];
    
    if (isIntercepted) {
        return NO;
    }
    return YES;
}

- (void)showSuccess:(NSInteger)resultCode {
//    9000——订单支付成功8000——正在处理中4000——订单支付失败5000——重复请求6001——用户中途取消6002——网络连接出错
    if (resultCode == 9000) {
        _moenyTxtView.textField.text = @"";
        _payMoney = 0.f;
        _payMomeyLabel.text = @"0";
        
        [WLHUDView showSuccessHUD:@"充值成功"];
    } else {
        [WLHUDView showErrorHUD:@"充值失败，请重试"];
    }
}

- (void)loadWithUrlStr:(NSString*)urlStr {
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
}

#pragma mark - private
// 立即充值按钮点击
- (void)payBtnClicked:(UIButton *)sender {
    if (_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines.length == 0) {
        [WLHUDView showOnlyTextHUD:@"请输入充值金额"];
        return;
    }
    if ([_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines floatValue] == 0) {
        [WLHUDView showOnlyTextHUD:@"充值金额大于0"];
        return;
    }
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    NSDictionary *params = @{@"money": [NSNumber numberWithFloat:[_moenyTxtView.textField.text.wl_trimWhitespaceAndNewlines floatValue]],
                             @"pay_method" : @2
                             };
    [WLHUDView showHUDWithStr:@"充值中..." dim:YES];
    WEAKSELF
    [UserModelClient rechargeWallentWithParams:params Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        if ([[resultInfo objectForKey:@"url"] isKindOfClass:[NSString class]]) {
            NSString *url = [resultInfo objectForKey:@"url"];
            NSNumber *pay_type = [resultInfo objectForKey:@"pay_type"];
            if ([url length] > 0) {
                //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                if (pay_type.intValue == 0) {
                    // 当面付，webview打开url
                    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:url];
                    webVC.showsToolBar = NO;
                    webVC.title = @"充值";
                    // webVC.showsNavigationCloseBarButtonItem = NO;
                    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
                        webVC.webView.allowsLinkPreview = YES;
                    }
                    [weakSelf.navigationController pushViewController:webVC animated:YES];
//                    PayWebViewController *vc = [[PayWebViewController alloc] initWithUrl:url];
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                if (pay_type.intValue == 1) {
                    // h5 支付 https://docs.open.alipay.com/204/105695/
                    [weakSelf loadWithUrlStr:url];
                }
            }
        } else {
            [WLHUDView showErrorHUD:@"获取支付信息失败，请重试"];
        }
        // https://qr.alipay.com/bax070319pqypzwglyvq40b0
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
    
}

// 支付选中支付方式页面
- (void)payTypeSelect {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, DEVICE_WIDTH, 244.f) style:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    // 显示自定义分割线
    self.manager.showBottomLine = YES;
    // 隐藏默认分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    QMUIFillButton *payBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    payBtn.frame = CGRectMake(0.f, 200.f, DEVICE_WIDTH, 44.f);
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = WLFONT(18);
    payBtn.cornerRadius = 0.f;
    [payBtn addTarget:self action:@selector(confirmPayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = payBtn;
    
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 0.f;
    section.footerHeight = 0.f;
    [self.manager addSection:section];
    
    RETableViewItem *payAmountItem = [RETableViewItem itemWithTitle:@"充值金额" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    payAmountItem.style = UITableViewCellStyleValue1;
    payAmountItem.titleLabelTextFont = UIFontMake(14.f);
    payAmountItem.detailLabelText = [NSString stringWithFormat:@"￥%@",self.payMomeyLabel.text];
    payAmountItem.titleDetailTextColor = UIColorMake(251,83,96);
    payAmountItem.selectionStyle = UITableViewCellSelectionStyleNone;
    payAmountItem.cellHeight = 45.f;
    [section addItem:payAmountItem];
    
    RETableViewItem *titleItem = [RETableViewItem itemWithTitle:@"请选中支付方式" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    //    titleItem.style = UITableViewCellStyleValue1;
    titleItem.titleLabelTextColor = WLColoerRGB(102.f);
    titleItem.titleLabelTextFont = UIFontMake(13.f);
    titleItem.selectionStyle = UITableViewCellSelectionStyleNone;
    titleItem.cellHeight = 45.f;
    [section addItem:titleItem];
    
    WEAKSELF
    RETableViewItem *balancePayItem = [RETableViewItem itemWithTitle:@"余额支付" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
        weakSelf.selectPayType = 1;
        item.accessoryView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"mine_recommend_icon"]];
        // 重新加载数据
        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        
        weakSelf.aliPayItem.accessoryView = [[UIImageView alloc] initWithImage:[[UIImage  imageNamed:@"mine_recommend_icon"] qmui_imageWithTintColor:WLColoerRGB(174.f)]];
        [weakSelf.aliPayItem reloadRowWithAnimation:UITableViewRowAnimationNone];
    }];
    balancePayItem.image = [UIImage imageNamed:@"withdraw_ali_icon"];
    balancePayItem.style = UITableViewCellStyleValue1;
    balancePayItem.detailLabelText = @"可用余额￥264.00";
    balancePayItem.titleDetailTextColor = UIColorMake(251,83,96);
    balancePayItem.titleDetailTextFont = UIFontMake(11.f);
    // 设置加亮字体
    balancePayItem.detailLabelHintColor = YES;
    balancePayItem.detailLabelHintText = @"可用余额";
    balancePayItem.titleDetailHintColor = WLColoerRGB(51.f);
    balancePayItem.selectionStyle = UITableViewCellSelectionStyleNone;
    balancePayItem.cellHeight = 55.f;
    balancePayItem.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_recommend_icon"]];
    [section addItem:balancePayItem];
    self.balancePayItem = balancePayItem;
    
    RETableViewItem *aliPayItem = [RETableViewItem itemWithTitle:@"支付宝支付" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
        weakSelf.selectPayType = 2;
        item.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_recommend_icon"]];
        // 重新加载数据
        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        weakSelf.balancePayItem.accessoryView = [[UIImageView alloc] initWithImage:[[UIImage  imageNamed:@"mine_recommend_icon"] qmui_imageWithTintColor:WLColoerRGB(174.f)]];
        [weakSelf.balancePayItem reloadRowWithAnimation:UITableViewRowAnimationNone];
    }];
    aliPayItem.accessoryView = [[UIImageView alloc] initWithImage:[[UIImage  imageNamed:@"mine_recommend_icon"] qmui_imageWithTintColor:[UIColor grayColor]]];
    aliPayItem.image = [UIImage imageNamed:@"withdraw_ali_icon"];
    aliPayItem.style = UITableViewCellStyleValue1;
    aliPayItem.selectionStyle = UITableViewCellSelectionStyleNone;
    aliPayItem.cellHeight = 55.f;
    [section addItem:aliPayItem];
    self.aliPayItem = aliPayItem;
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = self.tableView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        weakSelf.tableView.frame = CGRectSetXY(weakSelf.tableView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(weakSelf.tableView.frame)), CGRectGetHeight(containerBounds) - CGRectGetHeight(weakSelf.tableView.frame));
    };
    modalViewController.showingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void(^completion)(BOOL finished)) {
        weakSelf.tableView.frame = CGRectSetY(weakSelf.tableView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            weakSelf.tableView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    modalViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            weakSelf.tableView.frame = CGRectSetY(weakSelf.tableView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    [modalViewController showWithAnimated:YES completion:nil];
}

// 支付金额按钮选择
- (void)momeyBtnSelected:(QMUIFillButton *)sender {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    // 把旧的选中的按钮设置为未选中的颜色
    if (_selectMoneyBtn != nil) {
        _selectMoneyBtn.titleTextColor = UIColorMake(254,72,30);
        _selectMoneyBtn.fillColor = FillButtonColorWhite;
    }
    // 把当前选中的按钮设置给选中的按钮
    if (_selectMoneyBtn != sender) {
        self.selectMoneyBtn = sender;
    }
    // 设置选中颜色
    if (_selectMoneyBtn != nil) {
        _selectMoneyBtn.titleTextColor = FillButtonColorWhite;
        _selectMoneyBtn.fillColor = UIColorMake(254,72,30);
    }
    NSInteger index = sender.tag;
    
    self.payMoney = [_moneyArray[index] floatValue];
    _payMomeyLabel.text = [NSString stringWithFormat:@"%.2f", _payMoney];
    _moenyTxtView.textField.text = [NSString stringWithFormat:@"%.2f", _payMoney];
}

// 确认支付按钮点击
- (void)confirmPayBtnClicked:(UIButton *)sender {
    if (_selectPayType == 1) {
        DLog(@"余额支付");
    }
    if (_selectPayType == 2) {
        DLog(@"支付宝支付");
    }
    
}

@end
