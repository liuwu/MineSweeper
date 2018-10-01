//
//  NewMessageSetViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/15.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "NewMessageSetViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

@interface NewMessageSetViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation NewMessageSetViewController

- (NSString *)title {
    return @"新信息通知";
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
    section.footerHeight = 0.f;
    [self.manager addSection:section];
    
    REBoolItem *messageNotifyItem = [REBoolItem itemWithTitle:@"接受新消息通知" value:![RCIM sharedRCIM].disableMessageNotificaiton switchValueChangeHandler:^(REBoolItem *item) {
        [RCIM sharedRCIM].disableMessageNotificaiton = item.value;
        item.value = !item.value;
    }];
    [section addItem:messageNotifyItem];
    REBoolItem *showDetailItem = [REBoolItem itemWithTitle:@"通知显示消息详情" value:[NSUserDefaults boolForKey:@"kNotificationShowDetailInfo"] switchValueChangeHandler:^(REBoolItem *item) {
        [NSUserDefaults setBool:item.value forKey:@"kNotificationShowDetailInfo"];
        item.value = !item.value;
    }];
    [section addItem:showDetailItem];
    REBoolItem *soundItem = [REBoolItem itemWithTitle:@"声音" value:![RCIM sharedRCIM].disableMessageAlertSound switchValueChangeHandler:^(REBoolItem *item) {
        [RCIM sharedRCIM].disableMessageAlertSound = item.value;
        item.value = !item.value;
    }];
    [section addItem:soundItem];
    REBoolItem *shakeItem = [REBoolItem itemWithTitle:@"震动" value:[NSUserDefaults boolForKey:@"kAudioPlaySystemSound"] switchValueChangeHandler:^(REBoolItem *item) {
        // 调用系统震动
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        NSNotification *notifi = [[NSNotification alloc] init];
        [NSUserDefaults setBool:item.value forKey:@"kAudioPlaySystemSound"];
        item.value = !item.value;
    }];
    [section addItem:shakeItem];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
