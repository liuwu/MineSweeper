//
//  AccountSafeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "AccountSafeViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

@interface AccountSafeViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation AccountSafeViewController

- (NSString *)title {
    return @"账号安全";
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableViewCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加表格内容
- (void)addTableViewCell {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    // 显示自定义分割线
    self.manager.showBottomLine = YES;
    // 隐藏默认分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 0.f;
    section.footerHeight = 0.f;
    [self.manager addSection:section];
    
    RETableViewItem *phoneItem = [RETableViewItem itemWithTitle:@"手机号" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
       
    }];
    [section addItem:phoneItem];

    RETableViewItem *loginPwdItem = [RETableViewItem itemWithTitle:@"登录密码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:loginPwdItem];
    
    RETableViewItem *payPwdItem = [RETableViewItem itemWithTitle:@"支付密码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:payPwdItem];
    
    REBoolItem *freeChipItem = [REBoolItem itemWithTitle:@"免密下注" value:YES switchValueChangeHandler:^(REBoolItem *item) {
        
    }];
    [section addItem:freeChipItem];
}

@end
