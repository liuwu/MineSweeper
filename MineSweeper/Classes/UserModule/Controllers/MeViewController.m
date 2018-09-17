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
#import "TOWebViewController.h"

#import "RETableViewManager.h"

@interface MeViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation MeViewController

- (NSString *)title {
    return @"我的";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

- (void)initSubviews {
    [super initSubviews];
    [self addNavBarItem];
    [self addHeaderView];
    [self addTableViewCell];
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
    [logoImageView wl_setCornerRadius:15.f];
    [userView addSubview:logoImageView];
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
    [nameBtn setTitle:@"尚软科技" forState:UIControlStateNormal];
    nameBtn.titleLabel.font = UIFontMake(14.f);
//    nameBtn.qmui_borderPosition = QMUIViewBorderPositionTop | QMUIViewBorderPositionBottom;
    [userView addSubview:nameBtn];
    
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
    momeyLabel.text = @"25,684.65";
    momeyLabel.font = UIFontMake(25);
    momeyLabel.textColor = UIColorMake(254,72,30);
    [wallentView addSubview:momeyLabel];
    [momeyLabel sizeToFit];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_20);
        make.top.mas_equalTo(42.f);
    }];
    
//    CALayer *separatorLayer = [CALayer qmui_separatorLayer];
//    separatorLayer.frame = CGRectMake(kWL_NormalMarginWidth_20, 80.f, wallentView.width - kWL_NormalMarginWidth_20 * 2.f, 1.f);
////    separatorLayer.size = CGSizeMake(wallentView.width - kWL_NormalMarginWidth_20 * 2.f, PixelOne);
//    [wallentView.layer addSublayer:separatorLayer];
    
    // 转账按钮
    QMUIButton *transferBtn = [QDUIHelper generateLightBorderedButton];
    [transferBtn setTitle:@"转账" forState:UIControlStateNormal];
    [transferBtn setTitleColor:UIColorMake(254,72,30) forState:UIControlStateNormal];
    transferBtn.titleLabel.font = UIFontMake(12.f);
    transferBtn.layer.borderColor = UIColorMake(254,72,30).CGColor;
    transferBtn.backgroundColor = [UIColor whiteColor];
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
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [wallentView addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
        make.right.bottom.mas_equalTo(wallentView).mas_offset(-kWL_NormalMarginWidth_20);
    }];
    
    // 取现按钮
    QMUIButton *cashBtn = [QDUIHelper generateDarkFilledButton];
    [cashBtn setTitle:@"取现" forState:UIControlStateNormal];
    cashBtn.titleLabel.font = UIFontMake(12.f);
    cashBtn.backgroundColor = [UIColor blackColor];
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
    RETableViewSection *section = [RETableViewSection section];
    RETableViewItem *commendItem = [RETableViewItem itemWithTitle:@"我的推荐" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        MyRecommendViewController *myRecommedVc = [[MyRecommendViewController alloc] init];
        [self.navigationController pushViewController:myRecommedVc animated:YES];
    }];
    commendItem.image = [UIImage imageNamed:@"mine_recommend_icon"];
    [section addItem:commendItem];
    RETableViewItem *promotionPosterItem = [RETableViewItem itemWithTitle:@"推广海报" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        PosterViewController *posterVc = [[PosterViewController alloc] init];
        [self.navigationController pushViewController:posterVc animated:YES];
    }];
    promotionPosterItem.image = [UIImage imageNamed:@"mine_share_icon"];
    [section addItem:promotionPosterItem];
    RETableViewItem *lotteryItem = [RETableViewItem itemWithTitle:@"抽奖" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:@"http://www.baidu.com/"];
        webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
        webVC.title = @"抽奖";
        webVC.showPageTitles = NO;
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    lotteryItem.image = [UIImage imageNamed:@"mine_award_icon"];
    [section addItem:lotteryItem];
    RETableViewItem *customerServiceItem = [RETableViewItem itemWithTitle:@"客服中心" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    customerServiceItem.image = [UIImage imageNamed:@"mine_service_icon"];
    [section addItem:customerServiceItem];
    [self.manager addSection:section];
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
// 消息按钮点击
- (void)leftBarButtonItemClicked {
    
}

// 设置按钮点击
- (void)rightBarButtonItemClicked {
    SettingViewController *settingVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    TransferViewController *wallentVc = [[TransferViewController alloc] init];
    [self.navigationController pushViewController:wallentVc animated:YES];
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







@end
