//
//  RedPacketViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RedPacketHistoryViewController.h"

#import "BaseTableViewCell.h"
#import "NSString+WLAdd.h"

@interface RedPacketViewController ()

@end

@implementation RedPacketViewController

- (NSString *)title {
    return @"红包";
}

- (void)initSubviews {
    [super initSubviews];
    
    UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"红包记录"
                                                                 target:self
                                                                 action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
     [self addHeaderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 添加头部信息
- (void)addHeaderView {
    self.view.backgroundColor = UIColorMake(254,72,30);
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 162.f)];
    headerView.backgroundColor = WLColoerRGB(248.f);
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redP_bar_img"]];
    [headerView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 32.f));
        make.top.mas_equalTo(headerView);
        make.centerX.mas_equalTo(headerView);
    }];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redP_head_img"]];
    bgView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
        make.centerX.mas_equalTo(headerView);
        make.top.mas_equalTo(headerView).mas_offset(10.f);
    }];

    // 总收益标题
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.text = @"来自 张三 的红包";
    titleLabel.font = UIFontMake(14);
    titleLabel.textColor = WLColoerRGB(51.f);
    [headerView addSubview:titleLabel];
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoImgView.mas_bottom).mas_offset(11.f);
        make.centerX.mas_equalTo(headerView);
    }];
    
    // 时间
    QMUILabel *timeLabel = [[QMUILabel alloc] init];
    timeLabel.text = @"15-9";
    timeLabel.font = UIFontMake(12);
    timeLabel.textColor = WLColoerRGB(51.f);
    [headerView addSubview:timeLabel];
    [timeLabel sizeToFit];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10.f);
        make.centerX.mas_equalTo(headerView);
    }];

    // 总收益
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"1.35";
    momeyLabel.font = UIFontMake(40);
    momeyLabel.textColor = WLColoerRGB(51.f);
    [headerView addSubview:momeyLabel];
//    self.momeyLabel = momeyLabel;
    [momeyLabel sizeToFit];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView);
        make.top.mas_equalTo(timeLabel.mas_bottom).mas_offset(3.f);
    }];

//    // 今日收益标题
//    QMUILabel *todayTitleLabel = [[QMUILabel alloc] init];
//    todayTitleLabel.text = @"今日收益(元)";
//    todayTitleLabel.font = UIFontMake(12);
//    todayTitleLabel.textColor = [UIColor whiteColor];
//    [headerView addSubview:todayTitleLabel];
//    [todayTitleLabel sizeToFit];
//    [todayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(momeyTitleLabel);
//        make.left.mas_equalTo(headerView.centerX);
//    }];
//
//    // 今日收益
//    QMUILabel *todayMomeyLabel = [[QMUILabel alloc] init];
//    todayMomeyLabel.text = @"+177.00";
//    todayMomeyLabel.font = UIFontMake(25);
//    todayMomeyLabel.textColor = [UIColor whiteColor];
//    [headerView addSubview:todayMomeyLabel];
//    self.todayMomeyLabel = todayMomeyLabel;
//    [todayMomeyLabel sizeToFit];
//    [todayMomeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(todayTitleLabel);
//        make.centerY.mas_equalTo(momeyLabel);
//    }];
    
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
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"red_packet_list_cell"];
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"red_packet_list_cell"];
        } else {
             cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"red_packet_list_cell"];
        }
    }
    if (indexPath.section == 0) {
        cell.textLabel.attributedText = [NSString wl_getAttributedInfoString:@"5个红包共10.00元"
                                                                   searchStr:@"10.00"
                                                                       color:UIColorMake(203,52,36)
                                                                        font:UIFontMake(14.f)];
        cell.textLabel.textColor = WLColoerRGB(153.f);
        cell.textLabel.font = UIFontMake(14.f);
        cell.imageEdgeInsets = UIEdgeInsetsZero;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"game_group_icon"];
        cell.textLabel.text = @"小尹子";
        cell.textLabel.textColor = WLColoerRGB(51.f);
        cell.textLabel.font = UIFontMake(15.f);
        cell.detailTextLabel.text = @"10-12 12:12";
        cell.detailTextLabel.textColor = WLColoerRGB(102.f);
        cell.detailTextLabel.font = UIFontMake(14.f);
        
        QMUILabel *moenyLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(0., 0., 60.f, cell.height)];
        moenyLabel.font = UIFontMake(15);
        moenyLabel.textColor = UIColorMake(203,52,36);
        moenyLabel.text = @"1.12元";
        cell.accessoryView = moenyLabel;
        
        // reset
//        cell.imageEdgeInsets = UIEdgeInsetsZero;
//        cell.textLabelEdgeInsets = UIEdgeInsetsZero;
//        cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
//        cell.accessoryEdgeInsets = UIEdgeInsetsZero;
        cell.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        cell.accessoryEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
        [cell updateCellAppearanceWithIndexPath:indexPath];
    }
    cell.showBottomLine = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 30.f;
    }
    return 69.f;
}

#pragma mark - Private
// 右侧导航按钮点击
- (void)rightBarButtonItemClicked {
    RedPacketHistoryViewController *vc = [[RedPacketHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
