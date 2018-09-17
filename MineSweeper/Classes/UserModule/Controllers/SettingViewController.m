//
//  SettingViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountSafeViewController.h"
#import "NewMessageSetViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

@interface SettingViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation SettingViewController

- (NSString *)title {
    return @"设置";
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableViewCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    section.footerHeight = 10.f;
    [self.manager addSection:section];
    
    WEAKSELF
    RETableViewItem *accountSafeItem = [RETableViewItem itemWithTitle:@"账号安全" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        AccountSafeViewController *vc = [[AccountSafeViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [section addItem:accountSafeItem];
    RETableViewItem *newMessageItem = [RETableViewItem itemWithTitle:@"新消息通知" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        NewMessageSetViewController *vc = [[NewMessageSetViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [section addItem:newMessageItem];
    RETableViewItem *currentVersionItem = [RETableViewItem itemWithTitle:@"当前版本" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    currentVersionItem.style = UITableViewCellStyleValue1;
    currentVersionItem.detailLabelText = @"V1.0";
    currentVersionItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:currentVersionItem];
    
    RETableViewItem *clearCacheItem = [RETableViewItem itemWithTitle:@"清理缓存" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    clearCacheItem.titleLabelTextColor = UIColorMake(254,72,30);
    clearCacheItem.titleLabelTextFont = UIFontMake(15.f);
    clearCacheItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:clearCacheItem];
    
    RETableViewItem *clearChatHisotryItem = [RETableViewItem itemWithTitle:@"清理所有聊天记录" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
    }];
    clearChatHisotryItem.titleLabelTextColor = UIColorMake(254,72,30);
    clearChatHisotryItem.titleLabelTextFont = UIFontMake(15.f);
    clearChatHisotryItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:clearChatHisotryItem];
    
    RETableViewSection *section2 = [RETableViewSection section];
    section.headerHeight = 0.f;
    section.footerHeight = 0.f;
    [self.manager addSection:section2];
    
    RETableViewItem *logoutItem = [RETableViewItem itemWithTitle:@"退出登录" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
//        item.title = @"Pressed!";
//        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        [weakSelf alertLogout];
    }];
    logoutItem.textAlignment = NSTextAlignmentCenter;
    logoutItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section2 addItem:logoutItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
// 提醒退出登录
- (void)alertLogout {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        DLog(@"取消");
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"退出登录" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        DLog(@"退出登录");
        
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:@"确认退出？" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
//    QMUIVisualEffectView *visualEffectView = [[QMUIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    visualEffectView.foregroundColor = UIColorMakeWithRGBA(255, 255, 255, .6);// 一般用默认值就行，不用主动去改，这里只是为了展示用法
//    alertController.mainVisualEffectView = visualEffectView;// 这个负责上半部分的磨砂
//
//    visualEffectView = [[QMUIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    visualEffectView.foregroundColor = UIColorMakeWithRGBA(255, 255, 255, .6);// 一般用默认值就行，不用主动去改，这里只是为了展示用法
//    alertController.cancelButtonVisualEffectView = visualEffectView;// 这个负责取消按钮的磨砂
//    alertController.sheetHeaderBackgroundColor = nil;
//    alertController.sheetButtonBackgroundColor = nil;
    [alertController showWithAnimated:YES];
}

@end
