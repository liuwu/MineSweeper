//
//  SearchFriendViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "FriendRquestViewController.h"
#import "UserInfoViewController.h"

#import "RETableViewManager.h"
#import "RETableViewSection.h"
#import "RETableViewItem.h"

#import "FriendModelClient.h"

#import "SWQRCode.h"

@interface SearchFriendViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation SearchFriendViewController

- (NSString *)title {
    return @"新朋友";
}

- (void)initSubviews {
    [super initSubviews];
    
    self.shouldShowSearchBar = YES;
    self.searchBar.delegate = self;
    
    [self addViews];
   
}

- (void)addViews {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    // 显示自定义分割线
    self.manager.showBottomLine = YES;
    // 隐藏默认分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    self.view.backgroundColor = WLColoerRGB(248.f);
    
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 10.f;
    section.footerHeight = 0.f;
    [self.manager addSection:section];
    
    WEAKSELF
    RETableViewItem *scanItem = [RETableViewItem itemWithTitle:@"扫一扫" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf scanQrCode];
    }];
    scanItem.image = [UIImage imageNamed:@"game_friend_icon"];
    [section addItem:scanItem];
}

// 扫描二维码
- (void)scanQrCode {
    SWQRCodeConfig *config = [[SWQRCodeConfig alloc] init];
    config.scannerType = SWScannerTypeBoth;
    WEAKSELF
    SWQRCodeViewController *qrcodeVC = [[SWQRCodeViewController alloc] initWithScanBlock:^(NSString *scanValue) {
        [weakSelf toUserInfoView:scanValue];
    }];
    qrcodeVC.codeConfig = config;
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

- (void)toUserInfoView:(NSString *)uid {
    if (uid.length > 0) {
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        vc.userId = uid;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UISearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    if (searchBar.text.wl_trimWhitespaceAndNewlines.length != 11) {
        [WLHUDView showOnlyTextHUD:@"请输入正确的手机号"];
        return;
    }
    WEAKSELF
    [WLHUDView showHUDWithStr:@"搜索中..." dim:YES];
    [FriendModelClient getImMemberSearchWithParams:@{@"mobile" : searchBar.text.wl_trimWhitespaceAndNewlines}
                                           Success:^(id resultInfo) {
                                               [WLHUDView hiddenHud];
//                                               FriendRquestViewController *vc = [[FriendRquestViewController alloc] init];
//                                               vc.uid = resultInfo[@"id"];
                                               UserInfoViewController *vc = [[UserInfoViewController alloc] init];
                                               vc.userId = resultInfo[@"id"];
                                               vc.hidesBottomBarWhenPushed = YES;
                                               [weakSelf.navigationController pushViewController:vc animated:YES];
                                           } Failed:^(NSError *error) {
                                               if (error.localizedDescription.length > 0) {
                                                   [WLHUDView showErrorHUD:error.localizedDescription];
                                               } else {
                                                   [WLHUDView hiddenHud];
                                               }
                                           }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
