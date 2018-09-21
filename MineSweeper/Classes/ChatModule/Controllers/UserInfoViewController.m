//
//  UserInfoViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "UserInfoViewController.h"
#import "FriendRquestViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

@interface UserInfoViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation UserInfoViewController
- (NSString *)title {
    return @"详细资料";
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableHeaderInfo];
    [self addTableViewCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableHeaderInfo {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 81.f)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0., 55.f, 55.f)];
    logoImageView.image = [UIImage imageNamed:@"redP_head_img"];
    [headerView addSubview:logoImageView];
//    [logoImageView wl_setDebug:YES];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.centerY.mas_equalTo(headerView);
    }];
    
    QMUILabel *nameLabel = [[QMUILabel alloc] init];
    nameLabel.font = UIFontMake(15);
    nameLabel.textColor = WLColoerRGB(51.f);
    nameLabel.text = @"小银子";
    [headerView addSubview:nameLabel];
//    self.idLabel = nameLabel;
    [nameLabel sizeToFit];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoImageView.mas_right).mas_offset(11.f);
        make.top.mas_equalTo(logoImageView);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0., 10.f, 13.f)];
    iconImageView.image = [UIImage imageNamed:@"icon_female_nor"];
    [headerView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right);
        make.centerY.mas_equalTo(nameLabel);
    }];
    
    QMUILabel *nickNameLabel = [[QMUILabel alloc] init];
    nickNameLabel.font = UIFontMake(11);
    nickNameLabel.textColor = WLColoerRGB(153.f);
    nickNameLabel.text = @"昵称：尹。。";
    [headerView addSubview:nickNameLabel];
//    self.idLabel = idLabel;
    [nickNameLabel sizeToFit];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(1.f);
    }];

    QMUILabel *idLabel = [[QMUILabel alloc] init];
    idLabel.font = UIFontMake(11);
    idLabel.textColor = WLColoerRGB(153.f);
    idLabel.text = @"ID:16854587";
    [headerView addSubview:idLabel];
//    self.idLabel = idLabel;
    [idLabel sizeToFit];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nickNameLabel);
        make.top.mas_equalTo(nickNameLabel.mas_bottom).mas_offset(3.f);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 200.f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
//    [footerView wl_setDebug:YES];
    
    QMUIFillButton *sendBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = WLFONT(18);
    [sendBtn addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setCornerRadius:5.f];
    [footerView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.f);
        make.centerX.mas_equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
    }];
    
    QMUIFillButton *deleteBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorWhite];
    [deleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = WLFONT(18);
    [deleteBtn addTarget:self action:@selector(quitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setCornerRadius:5.f];
    [footerView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sendBtn.mas_bottom).mas_offset(10.f);
        make.centerX.mas_equalTo(footerView);
        make.size.mas_equalTo(sendBtn);
    }];
}

// 添加表格内容
- (void)addTableViewCell {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    // 显示自定义分割线
    self.manager.showBottomLine = YES;
    
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 5.f;
    section.footerHeight = 20.f;
    [self.manager addSection:section];
    
    WEAKSELF
    RETableViewItem *nameItem = [RETableViewItem itemWithTitle:@"设置备注" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    nameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:nameItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
// 提醒退出登录
- (void)quitBtn:(UIButton *)sender {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        DLog(@"取消");
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"退出群聊" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        DLog(@"退出登录");
        
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:@"确认退出群聊？" preferredStyle:QMUIAlertControllerStyleActionSheet];
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
// 发消息
- (void)sendBtn:(UIButton *)sender {
    FriendRquestViewController *vc = [[FriendRquestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 查看更多用户
- (void)lookMoreUserBtn:(UIButton *)sender {
    
}

@end
