//
//  RedPacketHistoryViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "RedPacketHistoryViewController.h"
#import "SendRedPacketViewController.h"

#import "BaseTableViewCell.h"

@interface RedPacketHistoryViewController ()

@property (nonatomic, strong) QMUILabel *momeyLabel;

@end

@implementation RedPacketHistoryViewController

- (NSString *)title {
    return @"红包记录";
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
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 64.f)];
    headerView.backgroundColor = UIColorMake(254.f, 72.f, 30.f);
//    [headerView wl_setDebug:YES];
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"mine_bg_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    bgImg.backgroundColor = [UIColor clearColor];
    [headerView addSubview:bgImg];
//    [bgImg wl_setDebug:YES];
    [bgImg sizeToFit];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(headerView);
        make.width.mas_equalTo(headerView.width - 30.f);
        make.right.mas_equalTo(headerView);
        make.bottom.mas_equalTo(headerView);
    }];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [logoImgView wl_setCornerRadius:22.f];
    [headerView addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
        make.top.mas_equalTo(headerView).mas_offset(10.f);
        make.left.mas_equalTo(headerView).mas_offset(15.f);
    }];
    
    // 总收益标题
    QMUILabel *momeyTitleLabel = [[QMUILabel alloc] init];
    momeyTitleLabel.text = @"张三共收到26个红包,共计";
    momeyTitleLabel.font = UIFontMake(12);
    momeyTitleLabel.textColor = [UIColor whiteColor];
    //    momeyTitleLabel.canPerformCopyAction = YES;
    [headerView addSubview:momeyTitleLabel];
    [momeyTitleLabel sizeToFit];
    [momeyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoImgView);
        make.left.mas_equalTo(logoImgView.mas_right).mas_offset(kWL_NormalMarginWidth_10);
    }];

    // 总收益
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"1354.23";
    momeyLabel.font = UIFontMake(21);
    momeyLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
    [momeyLabel sizeToFit];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(momeyTitleLabel);
        make.top.mas_equalTo(momeyTitleLabel.mas_bottom).mas_offset(3.f);
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
    return 1.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"red_packet_history_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"red_packet_history_list_cell"];
    }
    cell.showBottomLine = YES;
    //    cell.imageView.image = [UIImage imageNamed:@"game_group_icon"];
    cell.textLabel.text = @"小尹子";
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    cell.detailTextLabel.text = @"10-12 12:12";
    cell.detailTextLabel.textColor = WLColoerRGB(102.f);
    cell.detailTextLabel.font = UIFontMake(14.f);
    
    QMUILabel *moenyLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(0., 0., 60.f, cell.height)];
    moenyLabel.font = UIFontMake(15);
    moenyLabel.textColor = WLColoerRGB(51.f);
    moenyLabel.text = @"1.12元";
    cell.accessoryView = moenyLabel;
    
    // resetc
//    cell.imageView.image = [UIImage imageWithColor:[UIColor whiteColor]];
//    cell.imageView.size = CGSizeMake(5, 10);
//    cell.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
//    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
//    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
//    [cell.imageView wl_setDebug:YES];
//    [cell.textLabel wl_setDebug:YES];
    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cell.accessoryEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    [cell updateCellAppearanceWithIndexPath:indexPath];
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
    return 69.f;
}

#pragma mark - Private
// 右侧导航按钮点击
- (void)rightBarButtonItemClicked {
    SendRedPacketViewController *vc = [[SendRedPacketViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
