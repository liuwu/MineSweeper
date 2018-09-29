//
//  UserInfoViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "UserInfoViewController.h"
#import "FriendRquestViewController.h"
#import "ChatViewController.h"
#import "UserInfoChangeViewController.h"
#import "FriendRquestViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

#import "FriendModelClient.h"
#import "IFriendDetailInfoModel.h"

@interface UserInfoViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) QMUILabel *nickNameLabel;
@property (nonatomic, strong) QMUILabel *idLabel;

@property (nonatomic, strong) QMUIFillButton *sendBtn;
@property (nonatomic, strong) QMUIFillButton *deleteBtn;

@property (nonatomic, strong) IFriendDetailInfoModel *userModel;

@property (nonatomic, strong) RETableViewItem *nameItem;

@end

@implementation UserInfoViewController
- (NSString *)title {
    return @"详细资料";
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableHeaderInfo];
    [self addTableViewCell];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadData {
//    NSDictionary *params = @{@"uid" : _friendModel.uid};
    NSDictionary *params = @{@"uid" : _userId};
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    [FriendModelClient getImMemberInfoWithParams:params Success:^(id resultInfo) {
        [WLHUDView hiddenHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.userModel = [IFriendDetailInfoModel modelWithDictionary:resultInfo];
        [weakSelf updateUI];
//        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)updateUI {
    [_logoImageView setImageWithURL:[NSURL URLWithString:_userModel.avatar]
                        placeholder:[UIImage imageNamed:@"redP_head_img"]
                            options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur
                         completion:nil];
    _iconImageView.image = [_userModel getLoginUserSex];
    _nameLabel.text = _userModel.nickname;
    _nickNameLabel.text = [NSString stringWithFormat:@"昵称：%@", _userModel.nickname];
    _idLabel.text = [NSString stringWithFormat:@"ID：%@", _userModel.id_num.stringValue] ;
    if (_userModel.uid.integerValue == configTool.loginUser.uid.integerValue) {
        _sendBtn.hidden = YES;
        _deleteBtn.hidden = YES;
    }
    if (_userModel.is_friend.intValue == 0) {
        [_sendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        _deleteBtn.hidden = YES;
    }
    if (_userModel.is_friend.intValue == 1) {
        [_sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
        _deleteBtn.hidden = NO;
//        [self addTableViewCell];
//        _nameItem.cellHeight = 0.f;/
//        _nameItem.cellHeight
        _nameItem.detailLabelText = _userModel.remark;
        [_nameItem reloadRowWithAnimation:UITableViewRowAnimationNone];
    }
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
    [logoImageView wl_setCornerRadius:27.5f];
    [headerView addSubview:logoImageView];
    self.logoImageView = logoImageView;
//    [logoImageView wl_setDebug:YES];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
        make.left.mas_equalTo(10.f);
        make.centerY.mas_equalTo(headerView);
    }];
    
    QMUILabel *nameLabel = [[QMUILabel alloc] init];
    nameLabel.font = UIFontMake(15);
    nameLabel.textColor = WLColoerRGB(51.f);
    nameLabel.text = @"";
    [headerView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel sizeToFit];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoImageView.mas_right).mas_offset(11.f);
        make.top.mas_equalTo(logoImageView);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0., 10.f, 13.f)];
    iconImageView.image = [UIImage imageNamed:@"icon_female_nor"];
    [headerView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).mas_offset(3.f);
        make.centerY.mas_equalTo(nameLabel);
    }];
    
    QMUILabel *nickNameLabel = [[QMUILabel alloc] init];
    nickNameLabel.font = UIFontMake(11);
    nickNameLabel.textColor = WLColoerRGB(153.f);
    nickNameLabel.text = @"昵称：";
    [headerView addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    [nickNameLabel sizeToFit];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(1.f);
    }];

    QMUILabel *idLabel = [[QMUILabel alloc] init];
    idLabel.font = UIFontMake(11);
    idLabel.textColor = WLColoerRGB(153.f);
    idLabel.text = @"ID:";
    [headerView addSubview:idLabel];
    self.idLabel = idLabel;
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
    self.sendBtn = sendBtn;
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.f);
        make.centerX.mas_equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
    }];
    
    QMUIFillButton *deleteBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorWhite];
    [deleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = WLFONT(18);
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setCornerRadius:5.f];
    deleteBtn.hidden = YES;
    [footerView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
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
        if (weakSelf.userModel.is_friend.intValue == 1) {
            UserInfoChangeViewController *vc = [[UserInfoChangeViewController alloc] initWithUserInfoChangeType:UserInfoChangeTypeSetFriendRemark];
            vc.uid = weakSelf.userId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    nameItem.selectionStyle = UITableViewCellSelectionStyleNone;
//    nameItem.detailLabelText = _userModel.remark;
    [section addItem:nameItem];
    self.nameItem = nameItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
// 发消息
- (void)sendBtn:(UIButton *)sender {
    // 非好友
    if (_userModel.is_friend.intValue == 0) {
        // 添加好友
        FriendRquestViewController *vc = [[FriendRquestViewController alloc] init];
        vc.uid = _userModel.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 好友
    if (_userModel.is_friend.intValue == 1) {
//        [kNSNotification postNotificationName:@"kFriendChat" object:nil];
        ChatViewController *vc = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_userModel.uid];
        [self.navigationController pushViewController:vc animated:YES];
        
//        [kNSNotification postNotificationName:@"kFriendChat" object:nil];
//        [kNSNotification postNotificationName:kWL_ChangeTapToChatList object:nil];
        //进入好友请求页面
//        ChatViewController *vc = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_userModel.uid];
//        [self.window.rootViewController presentViewController:[[NavViewController alloc] initWithRootViewController:friendVC] animated:YES completion:nil];
//
    }
    
    
}

// 删除好友
- (void)deleteBtnClicked:(UIButton *)sender {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (void)deleteFriend {
    [WLHUDView showHUDWithStr:@"删除中..." dim:YES];
    WEAKSELF
    [FriendModelClient deleteImFriendWithParams:@{@"fuid" : [NSNumber numberWithInteger:_userModel.uid.integerValue]} Success:^(id resultInfo) {
        [kNSNotification postNotificationName:@"kRefreshFriendList" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
}

@end
