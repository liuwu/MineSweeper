//
//  MeViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MeViewController.h"
#import "RETableViewManager.h"

@interface MeViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation MeViewController

- (NSString *)title {
    return @"我的";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

-(void)initSubviews {
    [super initSubviews];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    RETableViewSection *section = [RETableViewSection section];
    RETableViewItem *commendItem = [RETableViewItem itemWithTitle:@"我的推荐" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:commendItem];
    RETableViewItem *promotionPosterItem = [RETableViewItem itemWithTitle:@"推广海报" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:promotionPosterItem];
    RETableViewItem *lotteryItem = [RETableViewItem itemWithTitle:@"抽奖" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:lotteryItem];
    RETableViewItem *customerServiceItem = [RETableViewItem itemWithTitle:@"客服" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:customerServiceItem];
    [self.manager addSection:section];
}



@end
