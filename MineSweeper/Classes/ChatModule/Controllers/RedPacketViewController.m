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
#import "BaseImageTableViewCell.h"

#import "NSString+WLAdd.h"

#import "ImModelClient.h"
#import "IRedPacketResultModel.h"

@interface RedPacketViewController ()

@property (nonatomic, strong) IRedPacketResultModel *model;

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) QMUILabel *titleLabel;
@property (nonatomic, strong) QMUILabel *timeLabel;
@property (nonatomic, strong) QMUILabel *momeyLabel;
@property (nonatomic, strong) UIImageView *thunderView;

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
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadData {
    if (!_packetId) {
        return;
    }
    WEAKSELF
    [ImModelClient getImRedpackHistoryWithParams:@{@"id" : [NSNumber numberWithInteger:_packetId.integerValue]} Success:^(id resultInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        self.model = [IRedPacketResultModel modelWithDictionary:resultInfo];
        [weakSelf updateUI];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)updateUI {
    _titleLabel.text = [NSString stringWithFormat:@"来自 %@ 的红包", _model.nickname];
    _timeLabel.text = _model.title;
    _momeyLabel.text = _model.grab_money;
    BOOL isLooked = [NSUserDefaults boolForKey:_packetId];
    if (!isLooked) {
        _thunderView.hidden = !_model.is_thunder.boolValue;
        [NSUserDefaults setBool:YES forKey:_packetId];
    } else {
        _thunderView.hidden = YES;
    }
    
    WEAKSELF
    [_logoImgView setImageWithURL:[NSURL URLWithString:_model.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             if (image) {
                                 weakSelf.logoImgView.image = [image qmui_imageWithClippedCornerRadius:22.f];
                             }else {
                                 weakSelf.logoImgView.image = [UIImage imageNamed:@"game_friend_icon"];
                             }
                         }];
    
    [self.tableView reloadData];
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
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_friend_icon"]];
    bgView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:logoImgView];
    [logoImgView wl_setCornerRadius:22.f];
    self.logoImgView = logoImgView;
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
        make.centerX.mas_equalTo(headerView);
        make.top.mas_equalTo(headerView).mas_offset(10.f);
    }];

    // 总收益标题
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
//    titleLabel.text = @"来自 张三 的红包";
    titleLabel.font = UIFontMake(14);
    titleLabel.textColor = WLColoerRGB(51.f);
    [headerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoImgView.mas_bottom).mas_offset(11.f);
        make.centerX.mas_equalTo(headerView);
    }];
    
    // 时间
    QMUILabel *timeLabel = [[QMUILabel alloc] init];
//    timeLabel.text = @"15-9";
    timeLabel.font = UIFontMake(12);
    timeLabel.textColor = WLColoerRGB(51.f);
    [headerView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel sizeToFit];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10.f);
        make.centerX.mas_equalTo(headerView);
    }];

    // 总收益
    QMUILabel *momeyLabel = [[QMUILabel alloc] init];
    momeyLabel.text = @"0.00";
    momeyLabel.font = UIFontMake(40);
    momeyLabel.textColor = WLColoerRGB(51.f);
    [headerView addSubview:momeyLabel];
    self.momeyLabel = momeyLabel;
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
    
    UIImageView *thunderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_image"]];
    thunderView.hidden = YES;
    [self.tableView addSubview:thunderView];
    self.thunderView = thunderView;
//    [thunderView wl_setDebug:YES];
    [thunderView sizeToFit];
    [thunderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 32.f));
        make.top.mas_equalTo(150.f);
        make.centerX.mas_equalTo(self.tableView);
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
    return _model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"red_packet_list_cell"];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"red_packet_list_cell"];
        }
        NSString *titleStr = [NSString stringWithFormat:@"%@个红包共%@元",_model.num,_model.total_money];
        cell.textLabel.attributedText = [NSString wl_getAttributedInfoString:titleStr
                                                                   searchStr:_model.total_money
                                                                       color:UIColorMake(203,52,36)
                                                                        font:UIFontMake(14.f)];
        cell.textLabel.textColor = WLColoerRGB(153.f);
        cell.textLabel.font = UIFontMake(14.f);
        cell.imageEdgeInsets = UIEdgeInsetsZero;
        cell.showBottomLine = YES;
        return cell;
    } else {
        BaseImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"red_packet_list_cell"];
        if (!cell) {
            cell = [[BaseImageTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"red_packet_list_cell"];
        }
        cell.showBottomLine = YES;
        IRedPacektMemberModel *model = _model.list[indexPath.row];
        cell.redPacketMemberModel = model;
        QMUILabel *moenyLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(0., 0., 60.f, cell.height)];
        moenyLabel.font = UIFontMake(15);
        moenyLabel.textColor = UIColorMake(203,52,36);
        moenyLabel.text = [NSString stringWithFormat:@"%@元",model.money];// @"1.12元";
        [moenyLabel sizeToFit];
        cell.accessoryView = moenyLabel;
        
        // reset
        //        cell.imageEdgeInsets = UIEdgeInsetsZero;
        //        cell.textLabelEdgeInsets = UIEdgeInsetsZero;
        //        cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
        //        cell.accessoryEdgeInsets = UIEdgeInsetsZero;
        //        cell.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        //        cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        //        cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        cell.accessoryEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        [cell updateCellAppearanceWithIndexPath:indexPath];
        return cell;
    }
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
    [self loadData];
}

@end
