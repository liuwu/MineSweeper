//
//  NewFriendListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "NewFriendListViewController.h"

#import "BaseTableViewCell.h"

@interface NewFriendListViewController ()

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
    return 5.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"new_friend_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"new_friend_list_cell"];
    }
    cell.showBottomLine = YES;
    cell.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
    cell.textLabel.text = @"小尹子";
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    cell.detailTextLabel.text = @"我是尹子";
    cell.detailTextLabel.textColor = WLColoerRGB(102.f);
    cell.detailTextLabel.font = UIFontMake(14.f);
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 120.f, cell.height)];
//    rightView.backgroundColor = [UIColor lightGrayColor];
    cell.accessoryView = rightView;
    
    // 同意
    QMUIFillButton *agreeBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGreen];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = WLFONT(12);
    [agreeBtn addTarget:self action:@selector(agreeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setCornerRadius:12.f];
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
    [rightView addSubview:rejectBtn];
    [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(agreeBtn.mas_left).offset(-10.f);
        make.centerY.mas_equalTo(rightView);
        make.width.mas_equalTo(50.f);
        make.height.mas_equalTo(24.f);
    }];
    
    // 已拒绝
//    QMUIFillButton *rejectedBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGray];
//    [rejectedBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
//    rejectedBtn.titleLabel.font = WLFONT(12);
//    rejectedBtn.enabled = NO;
//    [rejectedBtn setCornerRadius:12.f];
//    [rightView addSubview:rejectedBtn];
//    [rejectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(rightView);
//        make.centerY.mas_equalTo(rightView);
//        make.width.mas_equalTo(60.f);
//        make.height.mas_equalTo(24.f);
//    }];
    
    // reset
    cell.imageEdgeInsets = UIEdgeInsetsZero;
    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    
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
    
}

// 拒绝
- (void)rejectBtnClicked:(UIButton *)sender {
    
}

@end
