//
//  NewFriendListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "NewFriendListViewController.h"

#import "BaseTableViewCell.h"

#import "FriendModelClient.h"
#import "IFriendRequestModel.h"

@interface NewFriendListViewController ()

@property (nonatomic, strong) NSArray *datasource;

@end

@implementation NewFriendListViewController

- (NSString *)title {
    return @"新朋友";
}

- (void)initSubviews {
    [super initSubviews];
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    [self loadData];
}

- (void)loadData {
    [self hideEmptyView];
    WEAKSELF
    [FriendModelClient getImFriendRequestListWithParams:nil Success:^(id resultInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.datasource = [NSArray modelArrayWithClass:[IFriendRequestModel class] json:resultInfo];
        if (weakSelf.datasource.count == 0) {
            [weakSelf showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
        }
        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _datasouce.count;
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"new_friend_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"new_friend_list_cell"];
    }
    cell.showBottomLine = YES;
    IFriendRequestModel *model = _datasource[indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
    cell.imageView.size = CGSizeMake(40.f, 40.f);
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
                            options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur|YYWebImageOptionIgnorePlaceHolder completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                cell.imageView.image = [image qmui_imageWithClippedCornerRadius:20.f];
                            }];
    [cell.imageView wl_setCornerRadius:20.f];
    cell.textLabel.text = model.fnickname;// @"小尹子";
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    cell.detailTextLabel.text = model.message;// @"我是尹子";
    cell.detailTextLabel.textColor = WLColoerRGB(102.f);
    cell.detailTextLabel.font = UIFontMake(14.f);
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 120.f, cell.height)];
//    rightView.backgroundColor = [UIColor lightGrayColor];
    cell.accessoryView = rightView;
    
    if (model.status.intValue == 0) {
        // 同意
        QMUIFillButton *agreeBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGreen];
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        agreeBtn.titleLabel.font = WLFONT(12);
        [agreeBtn addTarget:self action:@selector(agreeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [agreeBtn setCornerRadius:12.f];
        agreeBtn.tag = indexPath.row;
        [rightView addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightView);
            make.centerY.mas_equalTo(rightView);
            make.width.mas_equalTo(50.f);
            make.height.mas_equalTo(24.f);
        }];
        
        // 拒绝
        QMUIFillButton *rejectBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
        [rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        rejectBtn.titleLabel.font = WLFONT(12);
        [rejectBtn addTarget:self action:@selector(rejectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rejectBtn setCornerRadius:12.f];
        rejectBtn.tag = indexPath.row;
        [rightView addSubview:rejectBtn];
        [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(agreeBtn.mas_left).offset(-10.f);
            make.centerY.mas_equalTo(rightView);
            make.width.mas_equalTo(50.f);
            make.height.mas_equalTo(24.f);
        }];
    } else {
        // 已拒绝
        QMUIFillButton *rejectedBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGray];
        if (model.status.intValue == 1) {
            [rejectedBtn setTitle:@"已同意" forState:UIControlStateNormal];
        }
        if (model.status.intValue == 2) {
            [rejectedBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        }
        rejectedBtn.titleLabel.font = WLFONT(12);
        rejectedBtn.enabled = NO;
        [rejectedBtn setCornerRadius:12.f];
        [rightView addSubview:rejectedBtn];
        [rejectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightView);
            make.centerY.mas_equalTo(rightView);
            make.width.mas_equalTo(60.f);
            make.height.mas_equalTo(24.f);
        }];
    }
    
    // reset
//    cell.imageEdgeInsets = UIEdgeInsetsZero;
//    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
//    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
//    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    
    cell.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cell.accessoryEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [cell updateCellAppearanceWithIndexPath:indexPath];
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
    return 69.f;
}

#pragma mark - private
// 同意
- (void)agreeBtnClicked:(UIButton *)sender {
    IFriendRequestModel *model = _datasource[sender.tag];
    NSDictionary *params = @{@"fuid" : [NSNumber numberWithInteger:model.fuid.integerValue]};
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [FriendModelClient acceptImFriendRequestWithParams:params Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:weakSelf.datasource];
        model.status = @"1";
        model.status_title = @"已同意";
        [dataArray replaceObjectAtIndex:sender.tag withObject:model];
        [kNSNotification postNotificationName:@"kRefreshFriendList" object:nil];
        weakSelf.datasource = dataArray;
        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

// 拒绝
- (void)rejectBtnClicked:(UIButton *)sender {
    IFriendRequestModel *model = _datasource[sender.tag];
    NSDictionary *params = @{@"fuid" : [NSNumber numberWithInteger:model.fuid.integerValue]};
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [FriendModelClient rejectImFriendRequestWithParams:params Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:weakSelf.datasource];
        model.status = @"2";
        model.status_title = @"已拒绝";
        [dataArray replaceObjectAtIndex:sender.tag withObject:model];
        weakSelf.datasource = dataArray;
        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [self loadData];
}

@end
