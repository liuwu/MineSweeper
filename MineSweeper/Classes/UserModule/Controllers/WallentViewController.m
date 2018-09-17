//
//  WallentViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "WallentViewController.h"

@interface WallentViewController ()

@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) QMUILabel *balanceMomeyLabel;

@end

@implementation WallentViewController

- (NSString *)title {
    return @"资金记录";
}

- (void)initSubviews {
    [super initSubviews];
    [self addHeaderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加头部信息
- (void)addHeaderView {
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 64.f)];
    headerView.backgroundColor = UIColorMake(254.f, 72.f, 30.f);
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_bg_img"]];
    [headerView addSubview:bgImg];
    [bgImg sizeToFit];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(headerView);
        make.width.mas_equalTo(headerView.width - 30.f);
        make.right.mas_equalTo(headerView);
        make.bottom.mas_equalTo(headerView);
    }];
    
    // 总收益标题
    QMUILabel *momeyTitleLabel = [[QMUILabel alloc] init];
    momeyTitleLabel.text = @"我的钱包(元)";
    momeyTitleLabel.font = UIFontMake(12);
    momeyTitleLabel.textColor = [UIColor whiteColor];
    //    momeyTitleLabel.canPerformCopyAction = YES;
    [headerView addSubview:momeyTitleLabel];
    [momeyTitleLabel sizeToFit];
    [momeyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
    }];
    
    // 总收益
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"25,684.65";
    momeyLabel.font = UIFontMake(25);
    momeyLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    [momeyLabel sizeToFit];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.top.mas_equalTo(momeyTitleLabel.bottom + kWL_NormalMarginWidth_10);
    }];
    
    // 不可用余额
    QMUILabel *balanceTitleLabel = [[QMUILabel alloc] init];
    balanceTitleLabel.text = @"不可用余额(元)";
    balanceTitleLabel.font = UIFontMake(12);
    balanceTitleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:balanceTitleLabel];
    [balanceTitleLabel sizeToFit];
    [balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(momeyTitleLabel);
        make.left.mas_equalTo(headerView.centerX);
    }];
    
    // 不可用余额
    QMUILabel *balanceMomeyLabel = [[QMUILabel alloc] init];
    balanceMomeyLabel.text = @"1240.00";
    balanceMomeyLabel.font = UIFontMake(25);
    balanceMomeyLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:balanceMomeyLabel];
    self.balanceMomeyLabel = balanceMomeyLabel;
    [balanceMomeyLabel sizeToFit];
    [balanceMomeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(balanceTitleLabel);
        make.centerY.mas_equalTo(momeyLabel);
    }];
    
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

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message_notifi_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message_notifi_cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return kNoteHeight + kBannerHeight;
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - private
// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
