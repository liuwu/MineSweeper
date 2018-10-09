//
//  MyCardViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/8.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MyCardViewController.h"
#import "AddCardViewController.h"

#import "UserModelClient.h"

@interface MyCardViewController ()

@end

@implementation MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title {
    return @"我的银行卡";
}

- (void)initSubviews {
    [super initSubviews];
    [self addSubViews];
//    [self addConstrainsForSubviews];
}

- (void)addSubViews {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 80.f)];
    self.tableView.tableHeaderView = headerView;
    
    // 添加银行卡
    QMUIFillButton *addCardBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorWhite];
    [addCardBtn setTitle:@"+ 添加银行卡" forState:UIControlStateNormal];
    addCardBtn.titleLabel.font = UIFontMake(15);
//    [addCardBtn setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
    [addCardBtn addTarget:self action:@selector(addCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addCardBtn setCornerRadius:5.f];
    [headerView addSubview:addCardBtn];
    [addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
        make.centerY.mas_equalTo(headerView);
        make.centerX.mas_equalTo(headerView);
    }];
}

#pragma mark - Private
- (void)initData {
    [UserModelClient getBankCardListWithParams:nil Success:^(id resultInfo) {
        
    } Failed:^(NSError *error) {
        
    }];
    
    NSDictionary *params = @{@"id" : @(1)};
    [UserModelClient delBankCardListWithParams:params Success:^(id resultInfo) {
        
    } Failed:^(NSError *error) {
        
    }];
}


- (void)addCardBtnClicked:(UIButton *)sender {
    AddCardViewController *vc = [[AddCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
