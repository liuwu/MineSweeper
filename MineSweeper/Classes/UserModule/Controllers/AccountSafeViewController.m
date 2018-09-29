//
//  AccountSafeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "SetPayPwdViewController.h"
#import "ChangePhoneViewController.h"
#import "SmsLoginViewController.h"
#import "RestPayPwdViewController.h"
#import "ChangePayPwdViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

#import "UserModelClient.h"

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
    
    WEAKSELF
    RETableViewItem *phoneItem = [RETableViewItem itemWithTitle:@"手机号" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [section addItem:phoneItem];

    RETableViewItem *loginPwdItem = [RETableViewItem itemWithTitle:@"登录密码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        SmsLoginViewController *vc = [[SmsLoginViewController alloc] initWithUseType:UseTypeRestPwd];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [section addItem:loginPwdItem];
    
    RETableViewItem *payPwdItem = [RETableViewItem itemWithTitle:@"支付密码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        if (configTool.safeIdexModel.is_set_deal_password.integerValue == 0) {
            SetPayPwdViewController *setPayVc = [[SetPayPwdViewController alloc] init];
            [weakSelf.navigationController pushViewController:setPayVc animated:YES];
        }
        if (configTool.safeIdexModel.is_set_deal_password.integerValue == 1) {
            ChangePayPwdViewController *vc = [[ChangePayPwdViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    [section addItem:payPwdItem];
    
    REBoolItem *freeChipItem = [REBoolItem itemWithTitle:@"免密下注" value:configTool.userInfoModel.is_secret_free.boolValue switchValueChangeHandler:^(REBoolItem *item) {
        [weakSelf setFreeChip:item];
    }];
    [section addItem:freeChipItem];
}

- (void)setFreeChip:(REBoolItem *)item {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    NSDictionary *params = @{@"is_secret_free" : [NSNumber numberWithBool:item.value]};
    [UserModelClient setSecretFreeWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"已设置"];
        configTool.userInfoModel.is_secret_free = @(item.value).stringValue;
        item.value = !item.value;
//        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
    
}

@end
