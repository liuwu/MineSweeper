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
#import "AppDelegate.h"

#import "UserModelClient.h"
#import "ISafeIndexModel.h"

#import "WLRequestManager.h"

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
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadData {
    [UserModelClient getUserSafeIndexWithParams:nil Success:^(id resultInfo) {
        configTool.safeIdexModel = [ISafeIndexModel modelWithDictionary:resultInfo];
    } Failed:^(NSError *error) {
        
    }];
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
    currentVersionItem.detailLabelText = [NSString stringWithFormat:@"V%@", kAppVersion];
    currentVersionItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:currentVersionItem];
    
    RETableViewItem *clearCacheItem = [RETableViewItem itemWithTitle:@"清理缓存" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [weakSelf clearCacheAlert];
    }];
    clearCacheItem.titleLabelTextColor = UIColorMake(254,72,30);
    clearCacheItem.titleLabelTextFont = UIFontMake(15.f);
    clearCacheItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:clearCacheItem];
    
    RETableViewItem *clearChatHisotryItem = [RETableViewItem itemWithTitle:@"清理所有聊天记录" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [weakSelf deleteAllChatListAlert];
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

- (void)deleteAllChatListAlert {
    WEAKSELF
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf deleteAllChatList];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"将删除所有个人和群的聊天记录" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (void)deleteAllChatList {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    BOOL success = [[RCIMClient sharedRCIMClient] clearConversations:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    if (success) {
        [WLHUDView showSuccessHUD:@"清理完成"];
    } else{
        [WLHUDView showErrorHUD:@"清理失败，请重试"];
    }
}

- (void)clearCacheAlert {
    WEAKSELF
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf clearCache];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"是否清理缓存？" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

//清理缓存
- (void)clearCache {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    /// 清除用户信息缓存
    [[RCIM sharedRCIM] clearUserInfoCache];
    [[RCIM sharedRCIM] clearGroupInfoCache];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //这里清除 Library/Caches 里的所有文件，融云的缓存文件及图片存放在 Library/Caches/RongCloud 下
        NSString *cachPath =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });
}

- (void)clearCacheSuccess {
     [WLHUDView showSuccessHUD:@"清理完成"];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"缓存清理成功！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil, nil];
//    [alertView show];
}

#pragma mark - Private
// 提醒退出登录
- (void)alertLogout {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        DLog(@"取消");
    }];
    WEAKSELF
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"退出登录" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        DLog(@"退出登录");
        // 取消所有接口请求
        [[WLRequestManager sharedInstance] cancelAllRequests];
        // 设置登录用户信息
        [NSUserDefaults setObject:nil forKey:kWLLoginUserIdKey];
//        [kNSNotification postNotificationName:@"kRefreshFriendList" object:nil];
        [kNSNotification postNotificationName:@"kUserLogout" object:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        [[AppDelegate sharedAppDelegate] checkLoginStatus];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:@"确认退出？" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

@end
