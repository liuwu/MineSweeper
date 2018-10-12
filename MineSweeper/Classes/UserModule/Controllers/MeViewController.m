//
//  MeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MeViewController.h"
#import "MyRecommendViewController.h"
#import "WallentViewController.h"
#import "PosterViewController.h"
#import "WithdrawViewController.h"
#import "SettingViewController.h"
#import "MyInfoViewController.h"
#import "RechargeViewController.h"
#import "TransferViewController.h"
#import "FriendListViewController.h"
#import "InviteRecommendViewController.h"
#import "UserInfoViewController.h"
#import "MessageNotifiListViewController.h"
#import "ChatViewController.h"
#import "MyCardViewController.h"
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

#import "SWQRCode.h"

#import "AXWebViewController.h"
#import <AXPracticalHUD/AXPracticalHUD.h>
#import "QDUIHelper.h"

#import "RETableViewManager.h"

#import "UserModelClient.h"
#import "IUserInfoModel.h"
#import "IUserQrCodeModel.h"
#import "ICityModel.h"
#import "IPosterModel.h"

#import "WLRongCloudDataSource.h"

@interface MeViewController ()<WKScriptMessageHandler>

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) QMUIButton *nameBtn;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) UIView *qrUserCodeView;
@property (nonatomic, strong) UIImage *codeImage;
@property (nonatomic, strong) QMUIModalPresentationViewController *modalViewController;

@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) QMUILabel *qrNameLabel;
@property (nonatomic, strong) QMUILabel *nickNameLabel;
@property (nonatomic, strong) QMUILabel *qrIdLabel;
@property (nonatomic, strong) IUserQrCodeModel *userQrCodeModel;

@property (nonatomic, strong) IPosterModel *posterModel;

@property (nonatomic, strong) RETableViewItem *commendItem;
@property (nonatomic, strong) RETableViewItem *cardItem;

@property (nonatomic, strong) WKWebViewConfiguration *configuration;
@property (nonatomic, strong) WKUserContentController *userContentController;

@end

@implementation MeViewController
@synthesize modalViewController;

- (NSString *)title {
    return @"我的";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // //这里需要注意，前面增加过的方法一定要remove掉。
    if (_userContentController) {
        [_userContentController removeScriptMessageHandlerForName:@"dialog"];
    }
}

- (void)initSubviews {
    [super initSubviews];
    [self getLoginUserInfo];
    [self addNavBarItem];
    [self addHeaderView];
    [self addTableViewCell];
    
    [kNSNotification addObserver:self selector:@selector(userLoginSuccess) name:@"kUserLoginSuccess" object:nil];
    [kNSNotification addObserver:self selector:@selector(userLoginSuccess) name:@"kNickNameChanged" object:nil];
    [kNSNotification addObserver:self selector:@selector(userLoginSuccess) name:@"kUserInfoChanged" object:nil];
    [self loadCityData];
}

// 用户登录成功
- (void)userLoginSuccess {
    [self getLoginUserInfo];
}

- (void)getLoginUserInfo {
//    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [UserModelClient getUserInfoWithParams:nil
                                   Success:^(id resultInfo) {
//                                       [WLHUDView hiddenHud];
                                       [weakSelf.tableView.mj_header endRefreshing];
                                       [weakSelf.tableView.mj_footer endRefreshing];
                                       IUserInfoModel *userInfoModel = [IUserInfoModel modelWithDictionary:resultInfo];
                                       configTool.userInfoModel = userInfoModel;
                                       [RCDDataSource refreshLogUserInfoCache:userInfoModel];
                                       [weakSelf reloadUI];
                                   } Failed:^(NSError *error) {
//                                       [WLHUDView hiddenHud];
                                       [weakSelf.tableView.mj_header endRefreshing];
                                       [weakSelf.tableView.mj_footer endRefreshing];
                                   }];
}

- (void)reloadUI {
    [_logoImageView setImageWithURL:[NSURL URLWithString:configTool.userInfoModel.avatar]
                  placeholderImage:nil];
    [_nameBtn setTitle:configTool.userInfoModel.nickname forState:UIControlStateNormal];
    _idLabel.text = [NSString stringWithFormat:@"ID：%@", configTool.userInfoModel.uid.stringValue];
    _momeyLabel.text = configTool.userInfoModel.balance;
    _commendItem.detailLabelText = configTool.userInfoModel.invite_code;
    [_commendItem reloadRowWithAnimation:UITableViewRowAnimationNone];
}

- (void)addHeaderView {
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 210.f)];
    headerView.backgroundColor = UIColorMake(249.f, 245.f, 244.f);
    self.headerView = headerView;
    self.tableView.tableHeaderView = _headerView;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = UIColorMake(254.f, 72.f, 30.f);
    [headerView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(122.f);
        make.width.mas_equalTo(headerView);
    }];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"mine_bg_img"] qmui_imageWithClippedCornerRadius:15.f]];
    [topView addSubview:bgImg];
    [bgImg sizeToFit];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView);
        make.bottom.mas_equalTo(topView);
    }];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectZero];
    userView.backgroundColor = [UIColor clearColor];
    [topView addSubview:userView];
//    [userView wl_setDebug:YES];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(topView);
        make.height.mas_equalTo(50.f);
        make.centerX.mas_equalTo(topView);
        make.top.mas_equalTo(topView);
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    logoImageView.image = [UIImage imageNamed:@"mine_award_icon"];
    logoImageView.backgroundColor = [UIColor whiteColor];
    [logoImageView setImageWithURL:[NSURL URLWithString:configTool.userInfoModel.avatar]
                  placeholderImage:nil];
    [logoImageView wl_setCornerRadius:15.f];
    [userView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWL_NormalIconSmallWidth, kWL_NormalIconSmallWidth));
        make.left.mas_equalTo(kWL_NormalMarginWidth_17);
        make.centerY.mas_equalTo(userView);
    }];
    
    // 图片+文字按钮
    QMUIButton *nameBtn = [[QMUIButton alloc] init];
    nameBtn.tintColorAdjustsTitleAndImage = [UIColor whiteColor];// [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    nameBtn.imagePosition = QMUIButtonImagePositionRight;// 将图片位置改为在文字上方
    nameBtn.spacingBetweenImageAndTitle = 7;
    [nameBtn setImage:UIImageMake(@"common_qrCode_icon") forState:UIControlStateNormal];
    [nameBtn setTitle:configTool.userInfoModel.mobile forState:UIControlStateNormal];
    nameBtn.titleLabel.font = UIFontMake(14.f);
//    nameBtn.qmui_borderPosition = QMUIViewBorderPositionTop | QMUIViewBorderPositionBottom;
    [nameBtn addTarget:self action:@selector(nameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:nameBtn];
    self.nameBtn = nameBtn;
    
    [nameBtn sizeToFit];
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoImageView.mas_right).mas_offset(7.f);
        make.top.mas_equalTo(logoImageView);
    }];
    
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.textColor = [UIColor whiteColor];
    idLabel.font = UIFontMake(11.f);
    idLabel.text = @"ID:16854587";
    [userView addSubview:idLabel];
    self.idLabel = idLabel;
    [idLabel sizeToFit];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameBtn);
        make.bottom.mas_equalTo(logoImageView);
    }];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setTitle:@"个人资料 >" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    infoBtn.titleLabel.font = UIFontMake(12.f);
    [infoBtn addTarget:self action:@selector(infoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:infoBtn];
    [infoBtn sizeToFit];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(userView).mas_offset(-15.f);
        make.centerY.mas_equalTo(userView);
        make.top.mas_equalTo(userView.mas_top).mas_offset(5.f);
        make.bottom.mas_equalTo(userView.mas_bottom).mas_offset(-5.f);
    }];
    
    UIView *wallentView = [[UIView alloc] initWithFrame:CGRectZero];
    wallentView.backgroundColor = [UIColor whiteColor];
    wallentView.layer.cornerRadius = 10.f;
    [headerView addSubview:wallentView];
    wallentView.layer.shadowColor = UIColorMake(254.f, 72.f, 30.f).CGColor;
    wallentView.layer.shadowOffset = CGSizeMake(0, 3);
    wallentView.layer.shadowRadius = 10.f;
    wallentView.layer.shadowOpacity = .1f;
    [wallentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_15);
        make.right.mas_equalTo(headerView).mas_offset(-kWL_NormalMarginWidth_15);
        make.top.mas_equalTo(50.f);
        make.bottom.mas_equalTo(headerView);
    }];
    
    QMUILabel *momeyTitleLabel = [[QMUILabel alloc] init];
    momeyTitleLabel.text = @"我的钱包(元)";
    momeyTitleLabel.font = UIFontMake(12);
    momeyTitleLabel.textColor = WLColoerRGB(51.f);
//    momeyTitleLabel.canPerformCopyAction = YES;
    [wallentView addSubview:momeyTitleLabel];
    [momeyTitleLabel sizeToFit];
    
    [momeyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kWL_NormalMarginWidth_20);
    }];
    
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = configTool.userInfoModel.balance;
    momeyLabel.font = UIFontMake(25);
    momeyLabel.textColor = UIColorMake(254,72,30);
    [wallentView addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    [momeyLabel sizeToFit];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_20);
        make.top.mas_equalTo(42.f);
    }];
    
    // 转账按钮
    QMUIButton *transferBtn = [QDUIHelper generateLightBorderedButton];
    [transferBtn setTitle:@"转账" forState:UIControlStateNormal];
    [transferBtn setTitleColor:UIColorMake(254,72,30) forState:UIControlStateNormal];
    transferBtn.titleLabel.font = UIFontMake(12.f);
    transferBtn.layer.borderColor = UIColorMake(254,72,30).CGColor;
    transferBtn.backgroundColor = [UIColor whiteColor];
    [transferBtn wl_setCornerRadius:15.f];
//    transferBtn.highlightedBackgroundColor = [UIColorMake(254,72,30) qmui_transitionToColor:UIColorWhite progress:.75];// 高亮时的背景色
//    transferBtn.highlightedBorderColor = [transferBtn.backgroundColor qmui_transitionToColor:UIColorMake(254,72,30) progress:.9];// 高亮时的边框颜色
    [transferBtn addTarget:self action:@selector(transferBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [wallentView addSubview:transferBtn];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
        make.left.mas_equalTo(20.f);
        make.bottom.mas_equalTo(wallentView).mas_offset(-kWL_NormalMarginWidth_20);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = WLColoerRGB(242.f);
    [wallentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_20);
        make.right.mas_equalTo(wallentView).mas_offset(-kWL_NormalMarginWidth_20);
        make.bottom.mas_equalTo(transferBtn.mas_top).mas_offset(-kWL_NormalMarginWidth_10);
        make.height.mas_equalTo(1.f);
    }];
    
    // 充值按钮
    QMUIButton *rechargeBtn = [QDUIHelper generateDarkFilledButton];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = UIFontMake(12.f);
    rechargeBtn.backgroundColor = UIColorMake(254,72,30);
    [rechargeBtn wl_setCornerRadius:15.f];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [wallentView addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
        make.right.bottom.mas_equalTo(wallentView).mas_offset(-kWL_NormalMarginWidth_20);
    }];
    
    // 取现按钮
    QMUIButton *cashBtn = [QDUIHelper generateDarkFilledButton];
    [cashBtn setTitle:@"提现" forState:UIControlStateNormal];
    cashBtn.titleLabel.font = UIFontMake(12.f);
    cashBtn.backgroundColor = [UIColor blackColor];
    [cashBtn wl_setCornerRadius:15.f];
    [cashBtn addTarget:self action:@selector(cashBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [wallentView addSubview:cashBtn];
    [cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
        make.right.mas_equalTo(rechargeBtn.mas_left).mas_offset(-kWL_NormalMarginWidth_15);
        make.centerY.mas_equalTo(rechargeBtn);
    }];
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn setTitle:@"资金记录 >" forState:UIControlStateNormal];
    [historyBtn setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    historyBtn.titleLabel.font = UIFontMake(12.f);
    [historyBtn addTarget:self action:@selector(wallentClicked:) forControlEvents:UIControlEventTouchUpInside];
    [wallentView addSubview:historyBtn];
//    [historyBtn wl_setDebug:YES];
    
    [historyBtn sizeToFit];
    [historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wallentView).mas_offset(-kWL_NormalMarginWidth_20);
        make.height.mas_equalTo(50.f);
        make.centerY.mas_equalTo(momeyLabel);
    }];
}

// 添加nav头部按钮
- (void)addNavBarItem {
    UIBarButtonItem *leftBtnItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"home_notice_btn"] target:self action:@selector(leftBarButtonItemClicked)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"mine_setting_btn"] target:self action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

// 添加表格内容
- (void)addTableViewCell {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    WEAKSELF
    RETableViewSection *section = [RETableViewSection section];
    RETableViewItem *commendItem = [RETableViewItem itemWithTitle:@"我的推荐" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        if (configTool.userInfoModel.is_enroller.intValue == 0) {
            InviteRecommendViewController *vc = [[InviteRecommendViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        // 1 直接我的推广页面   0填写邀请码
        if (configTool.userInfoModel.is_enroller.intValue == 1) {
            MyRecommendViewController *myRecommedVc = [[MyRecommendViewController alloc] init];
            [weakSelf.navigationController pushViewController:myRecommedVc animated:YES];
        }
    }];
    commendItem.style = UITableViewCellStyleValue1;
    commendItem.detailLabelText = configTool.userInfoModel.invite_code;
    commendItem.titleDetailTextColor = WLColoerRGB(153.f);
    commendItem.titleDetailTextFont = UIFontMake(15.f);
    commendItem.image = [UIImage imageNamed:@"mine_recommend_icon"];
    [section addItem:commendItem];
    self.commendItem = commendItem;
    
    RETableViewItem *cardItem = [RETableViewItem itemWithTitle:@"我的银行卡" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        MyCardViewController *vc = [[MyCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    cardItem.style = UITableViewCellStyleValue1;
//    cardItem.detailLabelText = configTool.userInfoModel.invite_code;
    cardItem.titleDetailTextColor = WLColoerRGB(153.f);
    cardItem.titleDetailTextFont = UIFontMake(15.f);
    cardItem.image = [UIImage imageNamed:@"mine_card"];
    [section addItem:cardItem];
    self.cardItem = cardItem;
    
    RETableViewItem *promotionPosterItem = [RETableViewItem itemWithTitle:@"推广海报" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf poster:item];
    }];
    promotionPosterItem.image = [UIImage imageNamed:@"mine_share_icon"];
    [section addItem:promotionPosterItem];
    RETableViewItem *lotteryItem = [RETableViewItem itemWithTitle:@"抽奖" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf lottery:item];
        
        // 加载显示pdf文件
//        AXWebViewController *webVC = [[AXWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://restest.welian.com/onmy1492081266459.pdf"]];
//        webVC.title = @"Swift.pdf";
//        webVC.showsToolBar = NO;
//        if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
//            webVC.webView.allowsLinkPreview = YES;
//        }
//        [self.navigationController pushViewController:webVC animated:YES];
    }];
    lotteryItem.image = [UIImage imageNamed:@"mine_award_icon"];
    [section addItem:lotteryItem];
    
    RETableViewItem *customerServiceItem = [RETableViewItem itemWithTitle:@"客服中心" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf customerService];
    }];
    customerServiceItem.image = [UIImage imageNamed:@"mine_service_icon"];
    [section addItem:customerServiceItem];
    [self.manager addSection:section];
}

- (void)customerService {
    if (configTool.userInfoModel.customer_id.length > 0) {
        ChatViewController *vc = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:configTool.userInfoModel.customer_id];
        vc.title = configTool.userInfoModel.customer_name;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 推广海报
- (void)poster:(RETableViewItem *)item {
    if (_posterModel) {
        [self toPosterView];
    } else {
        [WLHUDView showHUDWithStr:@"" dim:YES];
        WEAKSELF
        [UserModelClient getPosterWithParams:nil Success:^(id resultInfo) {
            [WLHUDView hiddenHud];
            weakSelf.posterModel = [IPosterModel modelWithDictionary:resultInfo];
            [self toPosterView];
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
        }];
    }
}

- (void)toPosterView {
    PosterViewController *posterVc = [[PosterViewController alloc] init];
    posterVc.posterModel = _posterModel;
    [self.navigationController pushViewController:posterVc animated:YES];
}

// 抽奖
- (void)lottery:(RETableViewItem *)item {
    NSString *urlStr = [NSString stringWithFormat:@"https:/test.cnsunrun.com/saoleiapp/App/User/LuckDraw/index?member_id=%@", configTool.loginUser.uid];
    //配置环境
    if (!_configuration) {
        self.configuration = [[WKWebViewConfiguration alloc]init];
    }
    if (!_userContentController) {
         self.userContentController = [[WKUserContentController alloc]init];
    }
    _configuration.userContentController = _userContentController;
    // 添加注册方法
    [_userContentController addScriptMessageHandler:self name:@"dialog"];
    //    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:urlStr];
    AXWebViewController *webVC = [[AXWebViewController alloc] initWithURL:[NSURL URLWithString:urlStr] configuration:_configuration];
    webVC.showsToolBar = NO;
    webVC.title = @"抽奖";
    // webVC.showsNavigationCloseBarButtonItem = NO;
    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
        webVC.webView.allowsLinkPreview = YES;
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    // name:dialog\\n body:{"status":1,"title":"恭喜您抽中6.66元!","ran":18,"onceran":120}
    DLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    if ([message.name isEqualToString:@"dialog"]) {
        NSDictionary *dataInfo = [message.body jsonValueDecoded];
        if ([dataInfo[@"status"] integerValue] == 0) {
            NSString *title = dataInfo[@"title"];
            if (title.length > 0) {
                [WLHUDView showErrorHUD:title];
            } else {
                [WLHUDView showErrorHUD:@"出错了，请重试"];
            }
        } else {
            NSString *title = dataInfo[@"title"];
            if ([title containsString:@"再接再厉"]) {
                // not Wing
            } else {
                // wing
                [self showSuccessAlert:title];
            }
        }
    }
}

- (void)showSuccessAlert:(NSString *)title {
    if (title.length == 0) {
        return;
    }
    //    WEAKSELF
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
       
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    //    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

#pragma mark - QMUINavigationControllerDelegate
// 设置是否允许自定义
- (BOOL)shouldSetStatusBarStyleLight {
    return YES;
}

// 设置导航栏的背景图
- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:UIColorMake(254.f, 72.f, 30.f)];
}

// 设置导航栏底部的分隔线图片
- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorMake(254.f, 72.f, 30.f)];
}

// nav中的baritem的颜色
- (UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];//WLRGB(254.f, 72.f, 30.f);
}

// nav标题颜色
- (UIColor *)titleViewTintColor {
    return [UIColor whiteColor];
}

#pragma mark - private
// 获取城市数据
- (void)loadCityData {
    if (!configTool.allCityDic || !configTool.provinceArray) {
        [UserModelClient getSystemCityListWithParams:nil Success:^(id resultInfo) {
            NSArray *allCitys = [NSArray modelArrayWithClass:[ICityModel class] json:resultInfo];
            NSMutableArray *provinceArray = [NSMutableArray array];
            for (ICityModel *cityModel in allCitys) {
                if (cityModel.pid.integerValue == 0) {
                    [provinceArray addObject:cityModel];
                }
            }
            NSMutableDictionary *allCityDic = [NSMutableDictionary dictionary];
            for (ICityModel *cityModel in provinceArray) {
                NSArray *citys = [allCitys bk_select:^BOOL(id obj) {
                    return ([[(ICityModel *)obj pid] integerValue] == cityModel.cid.integerValue);
                }];
                if (citys.count > 0) {
                    [allCityDic setValue:citys forKey:cityModel.cid];
                }
            }
            configTool.provinceArray = provinceArray;
            configTool.allCityDic = allCityDic;
        } Failed:^(NSError *error) {
            
        }];
    }
}

// 消息按钮点击
- (void)leftBarButtonItemClicked {
    // 有使用配置表的时候，最简单的代码就只是控制显隐即可，没使用配置表的话，还需要设置其他的属性才能使红点样式正确，具体请看 UIBarButton+QMUIBadge.h 注释
    self.navigationItem.leftBarButtonItem.qmui_shouldShowUpdatesIndicator = NO;
    
    MessageNotifiListViewController *messageNotifiVc = [[MessageNotifiListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:messageNotifiVc animated:YES];
}

// 设置按钮点击
- (void)rightBarButtonItemClicked {
    SettingViewController *settingVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self getLoginUserInfo];
}

// 资金记录点击
- (void)wallentClicked:(UIButton *)sender {
    WallentViewController *wallentVc = [[WallentViewController alloc] init];
    [self.navigationController pushViewController:wallentVc animated:YES];
}

// 个人信息点击
- (void)infoBtnClicked:(UIButton *)sender {
    MyInfoViewController *wallentVc = [[MyInfoViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:wallentVc animated:YES];
}

// 转账点击
- (void)transferBtnClicked:(UIButton *)sender {
    FriendListViewController *vc = [[FriendListViewController alloc] initWithFriendListType:FriendListTypeForTransfer];
    [self.navigationController pushViewController:vc animated:YES];
}

// 充值点击
- (void)rechargeBtnClicked:(UIButton *)sender {
    RechargeViewController *wallentVc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:wallentVc animated:YES];
}

// 提现点击
- (void)cashBtnClicked:(UIButton *)sender {
    WithdrawViewController *wallentVc = [[WithdrawViewController alloc] init];
    [self.navigationController pushViewController:wallentVc animated:YES];
}

// 个人信息二维码点击
- (void)nameBtnClicked:(UIButton *)sender {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    [contentView wl_setCornerRadius:5.f];
    contentView.backgroundColor = [UIColor whiteColor];
    self.qrUserCodeView = contentView;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_friend_icon"]];
    //    contentView.backgroundColor = UIColorWhite;
    [iconImageView wl_setCornerRadius:27.5f];
    [iconImageView setImageWithURL:[NSURL URLWithString:configTool.userInfoModel.avatar]
                  placeholderImage:[UIImage imageNamed:@"game_friend_icon"]];
    [contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
        make.top.mas_equalTo(15.f);
        make.left.mas_equalTo(15.f);
    }];
    
    QMUILabel *nameLabel = [[QMUILabel alloc] init];
    nameLabel.font = UIFontBoldMake(15);
    nameLabel.textColor = WLColoerRGB(51.f);
    nameLabel.text = configTool.userInfoModel.mobile;// @"小银子";
    [contentView addSubview:nameLabel];
    self.qrNameLabel = nameLabel;
    [nameLabel sizeToFit];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_offset(11.f);
        make.top.mas_equalTo(iconImageView.mas_top).mas_offset(2.f);
    }];
    
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0., 10.f, 13.f)];
    sexImageView.image = [configTool getLoginUserSex];
    [contentView addSubview:sexImageView];
    [sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right);
        make.centerY.mas_equalTo(nameLabel);
    }];
    
    QMUILabel *nickNameLabel = [[QMUILabel alloc] init];
    nickNameLabel.font = UIFontMake(11);
    nickNameLabel.textColor = WLColoerRGB(153.f);
    nickNameLabel.text = [NSString stringWithFormat:@"昵称：%@", configTool.userInfoModel.nickname];// @"昵称：小十点多";
    [contentView addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    [nickNameLabel sizeToFit];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(3.f);
    }];
    
    QMUILabel *idLabel = [[QMUILabel alloc] init];
    idLabel.font = UIFontMake(11);
    idLabel.textColor = WLColoerRGB(153.f);
    idLabel.text = [NSString stringWithFormat:@"ID：%@", configTool.userInfoModel.uid.stringValue];
    [contentView addSubview:idLabel];
    self.qrIdLabel = idLabel;
    [idLabel sizeToFit];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nickNameLabel.mas_bottom).mas_offset(3.f);
    }];
    
    UIImageView *qrImageView = [[UIImageView alloc] init];
//    qrImageView.image = [UIImage wl_createQRImageFormString:@"哈哈哈客户库呼呼呼呼哈" sizeSquareWidth:150.f];;
    [contentView addSubview:qrImageView];
    self.qrImageView = qrImageView;
    [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150.f, 150.f));
        make.top.mas_equalTo(iconImageView.mas_bottom).mas_offset(20.f);
        make.centerX.mas_equalTo(contentView);
    }];
    
    [self getUserVcode];
    
    UIButton *saveImageBtn = [[UIButton alloc] init];
    [saveImageBtn setTitle:@"保存到手机" forState:UIControlStateNormal];
    [saveImageBtn setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    saveImageBtn.titleLabel.font = UIFontBoldMake(15);
    [saveImageBtn addTarget:self action:@selector(saveImageBtnClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:saveImageBtn];
//    [saveImageBtn wl_setDebug:YES];
    [saveImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125.f);
        make.height.mas_equalTo(44.f);
        make.left.mas_equalTo(contentView);
        make.top.mas_equalTo(256.f);
    }];
    
    UIButton *scanQrCodeBtn = [[UIButton alloc] init];
    [scanQrCodeBtn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [scanQrCodeBtn setTitleColor:UIColorMake(254,72,30) forState:UIControlStateNormal];
    scanQrCodeBtn.titleLabel.font = UIFontBoldMake(15);
    [scanQrCodeBtn addTarget:self action:@selector(scanQrCodeBtnClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:scanQrCodeBtn];
    [scanQrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125.f);
        make.height.mas_equalTo(44.f);
        make.left.mas_equalTo(saveImageBtn.mas_right);
        make.centerY.mas_equalTo(saveImageBtn);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = WLColoerRGB(222.f);
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, .8f));
        make.bottom.mas_equalTo(saveImageBtn.mas_top);
        make.left.mas_equalTo(contentView);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = WLColoerRGB(242.f);
    [contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1.f, 44.f));
        make.top.mas_equalTo(saveImageBtn);
        make.centerX.mas_equalTo(contentView);
    }];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    modalViewController.contentView = contentView;
    //    modalViewController.delegate = self;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalViewController = modalViewController;
}

- (void)getUserVcode {
    WEAKSELF
    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    [UserModelClient getUserQrcodeWithParams:nil Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        weakSelf.userQrCodeModel = [IUserQrCodeModel modelWithDictionary:resultInfo];
        [weakSelf updateVcodeUI];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

- (void)updateVcodeUI {
    _qrNameLabel.text =_userQrCodeModel.mobile;
    _nickNameLabel.text = [NSString stringWithFormat:@"昵称：%@", _userQrCodeModel.nickname];
    _qrIdLabel.text = [NSString stringWithFormat:@"ID：%@",_userQrCodeModel.uid];
    [self.qrImageView setImageWithURL:[NSURL URLWithString:_userQrCodeModel.qrcode] options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur];
}

// 保存图片到相册
- (void)saveImageBtnClickedBtn:(UIButton *)sender {
    [self.modalViewController hideWithAnimated:YES completion:nil];
    self.codeImage = [UIImage qmui_imageWithView:self.qrUserCodeView];
    // 保存到相册
    [self handleSaveButtonClick];
}

// 扫描二维码
- (void)scanQrCodeBtnClickedBtn:(UIButton *)sender {
    [self.modalViewController hideWithAnimated:YES completion:nil];
    SWQRCodeConfig *config = [[SWQRCodeConfig alloc] init];
    config.scannerType = SWScannerTypeBoth;
    WEAKSELF
    SWQRCodeViewController *qrcodeVC = [[SWQRCodeViewController alloc] initWithScanBlock:^(NSString *scanValue) {
        [weakSelf toUserInfoView:scanValue];
    }];
    qrcodeVC.codeConfig = config;
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

- (void)toUserInfoView:(NSString *)uid {
    if (uid.length > 0) {
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        vc.userId = uid;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 相册操作权限校验
- (void)handleSaveButtonClick {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            // requestAuthorization:(void(^)(QMUIAssetAuthorizationStatus status))handler 不在主线程执行，因此涉及 UI 相关的操作需要手工放置到主流程执行。
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == QMUIAssetAuthorizationStatusAuthorized) {
                    [self saveImageToAlbum];
                } else {
                    [QDUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
                }
            });
        }];
    } else if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotAuthorized) {
        [QDUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
    } else {
        [self saveImageToAlbum];
    }
}

// 保存图片到相册
- (void)saveImageToAlbum {
    UIImageWriteToSavedPhotosAlbum(self.codeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
//    // 显示空相册，不显示智能相册
//    [[QMUIAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:QMUIAlbumContentTypeOnlyPhoto showEmptyAlbum:YES showSmartAlbumIfSupported:NO usingBlock:^(QMUIAssetsGroup *resultAssetsGroup) {
//        if (resultAssetsGroup) {
//            QMUIImageWriteToSavedPhotosAlbumWithAlbumAssetsGroup(self.codeImage, resultAssetsGroup, ^(QMUIAsset *asset, NSError *error) {
//                if (asset) {
//                    [QMUITips showSucceed:[NSString stringWithFormat:@"已保存到相册-%@", [resultAssetsGroup name]] inView:self.navigationController.view hideAfterDelay:2];
//                }
//            });
//        }
//    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        [WLHUDView showErrorHUD:@"保存失败，请重试"];
    }else {
        [WLHUDView showSuccessHUD:@"已保存到系统相册"];
    }
}

@end
