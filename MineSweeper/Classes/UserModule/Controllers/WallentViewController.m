//
//  WallentViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "WallentViewController.h"
#import "HMSegmentedControl.h"

#import "GridTableViewCell.h"

#import "UserModelClient.h"
#import "IWallentModel.h"

@interface WallentViewController ()

@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) QMUILabel *balanceMomeyLabel;

@property (nonatomic) NSInteger selectType;
@property (nonatomic) NSInteger page;

@property (nonatomic, strong) IWallentModel *wallentModel;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation WallentViewController

- (NSString *)title {
    return @"资金记录";
}

- (void)initSubviews {
    [super initSubviews];
    self.selectType = 1;
    self.page = 1;
    self.datasource = [NSMutableArray array];
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
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginPullUpRefreshingNew)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 108.f)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    // 用户信息
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, headerView.width, 64.f)];
    userView.backgroundColor = UIColorMake(254.f, 72.f, 30.f);
    [headerView addSubview:userView];
    
    NSArray<NSString *> *titles = @[@"充值记录", @"转账记录", @"提现记录", @"支付记录"];
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    segmentedControl.frame = CGRectMake(0, userView.bottom, headerView.width, 44.f);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    // 滑块高度控制
    segmentedControl.selectionIndicatorHeight = 3.f;
    segmentedControl.selectionIndicatorColor = UIColorMake(254.f, 72.f, 30.f);
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    // 设置默认字体颜色
    segmentedControl.titleTextAttributes = @{NSFontAttributeName : UIFontMake(14.f),
                                              NSForegroundColorAttributeName : WLColoerRGB(153.f),
                                              };
    // 选中颜色
    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName :  UIFontBoldMake(14.f),
                                                      NSForegroundColorAttributeName : UIColorMake(254.f, 72.f, 30.f),
                                                      };
    // 底部滑块的宽度控制
    segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0.f, 10.f, 0.f, 20.f);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:segmentedControl];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_bg_img"]];
    [userView addSubview:bgImg];
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
    [userView addSubview:momeyTitleLabel];
    [momeyTitleLabel sizeToFit];
    [momeyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6.f);
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
    }];
    
    // 总收益
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"0.00";
    momeyLabel.font = UIFontMake(25);
    momeyLabel.textColor = [UIColor whiteColor];
    [userView addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    [momeyLabel sizeToFit];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.top.mas_equalTo(momeyTitleLabel.bottom + kWL_NormalMarginWidth_10);
    }];
    
    // 不可用余额
//    QMUILabel *balanceTitleLabel = [[QMUILabel alloc] init];
//    balanceTitleLabel.text = @"不可用余额(元)";
//    balanceTitleLabel.font = UIFontMake(12);
//    balanceTitleLabel.textColor = [UIColor whiteColor];
//    [userView addSubview:balanceTitleLabel];
//    [balanceTitleLabel sizeToFit];
//    [balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(momeyTitleLabel);
//        make.left.mas_equalTo(headerView.centerX);
//    }];
//
//    // 不可用余额
//    QMUILabel *balanceMomeyLabel = [[QMUILabel alloc] init];
//    balanceMomeyLabel.text = @"0.00";
//    balanceMomeyLabel.font = UIFontMake(25);
//    balanceMomeyLabel.textColor = [UIColor whiteColor];
//    [userView addSubview:balanceMomeyLabel];
//    self.balanceMomeyLabel = balanceMomeyLabel;
//    [balanceMomeyLabel sizeToFit];
//    [balanceMomeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(balanceTitleLabel);
//        make.centerY.mas_equalTo(momeyLabel);
//    }];
    
     [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    [self hideEmptyView];
    NSDictionary *params = @{@"type" : [NSNumber numberWithInteger:_selectType],
                             @"p": [NSNumber numberWithInteger:_page]
                             };
    WEAKSELF
    [UserModelClient getWallentWithParams:params Success:^(id resultInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        IWallentModel *model = [IWallentModel modelWithDictionary:resultInfo];
        weakSelf.wallentModel = model;
        [weakSelf reloadUI];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)reloadUI {
    if (_wallentModel.list > 0) {
        [self.datasource addObjectsFromArray:_wallentModel.list];
    }
    if (_datasource.count == 0) {
        [self showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
    }
    _momeyLabel.text = _wallentModel.balance;
    _balanceMomeyLabel.text = _wallentModel.frozen;
    [self.tableView reloadData];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wallent_cell"];
    if (!cell) {
        cell = [[GridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallent_cell"];
    }
    if (indexPath.section == 0) {
//        if (!cell) {
//            cell = [[GridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallent_cell" gridTitles:@[@"时间", @"金额", @"状态"]];
//        }
        cell.titleColor = UIColorMake(254,72,30);
        cell.titleFont = UIFontMake(14.f);
        cell.gridTitles = @[@"时间", @"金额", @"状态"];
    } else {
        IWallentHistoryModel *model = _datasource[indexPath.row];
        cell.titleColor = WLColoerRGB(51.f);
        cell.titleFont = UIFontMake(13.f);
        cell.gridTitles = @[model.add_time ? : @"", model.money ? : @"", model.pay_title ? : @""];
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = WLColoerRGB(250.f);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - private
// 下拉刷新
- (void)beginPullDownRefreshingNew {
    self.page = 1;
    self.datasource = [NSMutableArray array];
    [self loadData];
}

// 上拉加载更多
- (void)beginPullUpRefreshingNew {
    self.page++;
    [self loadData];
}

// 分隔栏切换
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    DLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    self.selectType = segmentedControl.selectedSegmentIndex + 1;
//    self.page = 1;
    [self.tableView.mj_header beginRefreshing];

//    [self loadData];
}

@end
