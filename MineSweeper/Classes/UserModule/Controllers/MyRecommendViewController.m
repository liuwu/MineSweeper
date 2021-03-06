//
//  MyRecommendViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MyRecommendViewController.h"
#import "RecommendListViewController.h"

//#import "GridTableViewCell.h"
#import "MyRecommendTableViewCell.h"

#import "UserModelClient.h"
#import "IRecommendModel.h"
#import "IRecommendInfoModel.h"

@interface MyRecommendViewController ()

@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) QMUILabel *todayMomeyLabel;
@property (nonatomic, strong) NSArray *datasource;

@end

@implementation MyRecommendViewController

- (NSString *)title {
    return @"我的推荐";
}

- (void)initSubviews {
    [super initSubviews];
    
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"推荐列表"
                                                                 target:self
                                                                 action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addHeaderView];
    [self loadData];
}

- (void)loadData {
    [self hideEmptyView];
    WEAKSELF
    [UserModelClient getRecommoneListWithParams:nil Success:^(id resultInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        IRecommendModel *model = [IRecommendModel modelWithDictionary:resultInfo];
        [weakSelf loadUI:model];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadUI:(IRecommendModel *)model {
    self.momeyLabel.text = model.total_money;
    self.todayMomeyLabel.text = model.today_total_money;
    self.datasource = model.list;
    if (self.datasource.count == 0) {
        [self showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
    }
    [self.tableView reloadData];
}

// 添加头部信息
- (void)addHeaderView {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    //上提加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginPullUpRefreshingNew)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
    
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
    momeyTitleLabel.text = @"我的总收益(元)";
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
    momeyLabel.text = @"0.00";
    momeyLabel.font = UIFontMake(25);
    momeyLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    [momeyLabel sizeToFit];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWL_NormalMarginWidth_10);
        make.top.mas_equalTo(momeyTitleLabel.bottom + kWL_NormalMarginWidth_10);
    }];
    
    // 今日收益标题
    QMUILabel *todayTitleLabel = [[QMUILabel alloc] init];
    todayTitleLabel.text = @"今日收益(元)";
    todayTitleLabel.font = UIFontMake(12);
    todayTitleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:todayTitleLabel];
    [todayTitleLabel sizeToFit];
    [todayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(momeyTitleLabel);
        make.left.mas_equalTo(headerView.centerX);
    }];
    
    // 今日收益
    QMUILabel *todayMomeyLabel = [[QMUILabel alloc] init];
    todayMomeyLabel.text = @"0.00";
    todayMomeyLabel.font = UIFontMake(25);
    todayMomeyLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:todayMomeyLabel];
    self.todayMomeyLabel = todayMomeyLabel;
    [todayMomeyLabel sizeToFit];
    [todayMomeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(todayTitleLabel);
        make.centerY.mas_equalTo(momeyLabel);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    MyRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"my_recommend_cell"];
    if (!cell) {
        cell = [[MyRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"my_recommend_cell"];
    }
    if (indexPath.section == 0) {
        cell.titleColor = UIColorMake(254,72,30);
        cell.titleFont = UIFontMake(14.f);
        cell.gridTitles = @[@"昵称", @"金额(元)", @"级别", @"时间"];
    } else {
        IRecommendInfoModel *model = _datasource[indexPath.row];
        cell.titleColor = WLColoerRGB(51.f);
        cell.titleFont = UIFontMake(13.f);
        cell.gridTitles = @[model.from_nickname ? : @"", model.total_money ? : @"", model.level ? : @"", model.add_time ? : @""];
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

#pragma mark - Private
// 右侧导航按钮点击
- (void)rightBarButtonItemClicked {
    RecommendListViewController *recommendListVc = [[RecommendListViewController alloc] initWithDistance:1 memberId:configTool.loginUser.uid.integerValue];
    [self.navigationController pushViewController:recommendListVc animated:YES];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    
    [self loadData];
}

// 上拉刷新
- (void)beginPullUpRefreshingNew {
    [self loadData];
}

@end
