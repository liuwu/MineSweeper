//
//  ChatGroupDetailViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatGroupDetailViewController.h"
#import "ChatGourpNameViewController.h"
#import "ChatGroupNoteInfoViewController.h"
#import "UserInfoViewController.h"
#import "ChatGroupRemarkViewController.h"
#import "FriendListViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

#import "UserItemCollectionViewCell.h"

#import "ImGroupModelClient.h"

#define kMoreHeight 55.f

@interface ChatGroupDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) RETableViewManager *manager;
//@property (nonatomic, strong) NSArray<NSString *> *userArray;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UIButton *lookMoreUserBtn;

@property (nonatomic, strong) RETableViewItem *nameItem;
@property (nonatomic, strong) RETableViewItem *noteItem;
@property (nonatomic, strong) RETableViewItem *cartItem;
@property (nonatomic, strong) REBoolItem *notDisturbItem;
@property (nonatomic, strong) REBoolItem *topItem;
@property (nonatomic, strong) QMUIFillButton *quitBtn;

@end

@implementation ChatGroupDetailViewController

- (NSString *)title {
    return @"聊天详情";
}

- (void)initSubviews {
    [super initSubviews];
//    self.userArray = @[@"1小尹", @"2小尹ddd", @"3小尹asa", @"4小尹dfdf", @"5小尹dfdfdfdfdf", @"4小尹dfdf", @"4小尹dfdf"];
    [self addTableHeaderInfo];
    [self addTableViewCell];
//    [self loadData];
    
    if (_groupDetailInfo.type.integerValue == 1) {
        // 游戏群组，无法修改
        _nameItem.accessoryType = UITableViewCellAccessoryNone;
        _nameItem.enabled = NO;
        
        _noteItem.accessoryType = UITableViewCellAccessoryNone;
        _noteItem.enabled = NO;
        
        _quitBtn.hidden = YES;
    } else {
        if (_groupDetailInfo._uid.integerValue != configTool.userInfoModel.userId.integerValue) {
            // 游戏群组，无法修改
            _nameItem.accessoryType = UITableViewCellAccessoryNone;
            _nameItem.enabled = NO;
            
            _noteItem.accessoryType = UITableViewCellAccessoryNone;
            _noteItem.enabled = NO;
        }
    }
    
    [kNSNotification addObserver:self selector:@selector(loadData) name:@"kGroupInfoChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 获取群主信息接口
- (void)loadData {
//    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [ImGroupModelClient getImGroupInfoWithParams:@{@"id" : [NSNumber numberWithInteger:_groupId.integerValue]}
                                         Success:^(id resultInfo) {
//                                             [WLHUDView hiddenHud];
                                             self.groupDetailInfo = [IGroupDetailInfo modelWithDictionary:resultInfo];
                                             [weakSelf updateUI];
                                         } Failed:^(NSError *error) {
//                                             [WLHUDView hiddenHud];
                                         }];
}

- (void)updateUI {
    _nameItem.detailLabelText = _groupDetailInfo.title;
    _noteItem.detailLabelText = _groupDetailInfo.notice;
    _cartItem.detailLabelText = _groupDetailInfo.remark;
    _notDisturbItem.value = _groupDetailInfo.not_disturb.boolValue;
    _topItem.value = _groupDetailInfo.is_top.boolValue;
    
    [self.tableView reloadData];
    

//    CGFloat headerHeight = _groupDetailInfo.member_list.count > 4 ? 180.f : 90.f;
//    _mainCollectionView.height = headerHeight + kMoreHeight;
//    _headerView.height = headerHeight + kMoreHeight;
//    _lookMoreUserBtn.top = headerHeight;
//    [_lookMoreUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, kMoreHeight));
//        make.top.mas_equalTo(headerHeight);
//        make.centerX.mas_equalTo(self.headerView);
//    }];
//    self.tableView.tableHeaderView.height = headerHeight + kMoreHeight;
    [_mainCollectionView reloadData];
}

- (void)addTableHeaderInfo {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
//    CGFloat headerHeight = _userArray.count > 4 ? 180.f : 90.f;
    CGFloat headerHeight = 90;
    if (_groupDetailInfo.type.integerValue == 1) {
        // 游戏群组，无法修改
        headerHeight = _groupDetailInfo.member_list.count > 5 ? 180.f : 90.f;
    } else {
        if (_groupDetailInfo._uid.integerValue != configTool.userInfoModel.userId.integerValue) {
            headerHeight = _groupDetailInfo.member_list.count > 5 ? 180.f : 90.f;
        } else {
            headerHeight = _groupDetailInfo.member_list.count > 4 ? 180.f : 90.f;
        }
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, headerHeight + kMoreHeight)];
    //    headerView.backgroundColor = [UIColor redColor];
//    [headerView wl_setDebug:YES];
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    UIButton *lookMoreUserBtn = [[UIButton alloc] init];
    [lookMoreUserBtn setTitle:@"查看更多群成员>" forState:UIControlStateNormal];
    [lookMoreUserBtn setTitleColor:WLColoerRGB(102.f) forState:UIControlStateNormal];
    lookMoreUserBtn.titleLabel.font = WLFONT(15);
    [lookMoreUserBtn addTarget:self action:@selector(lookMoreUserBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:lookMoreUserBtn];
    self.lookMoreUserBtn = lookMoreUserBtn;
//    [lookMoreUserBtn wl_setDebug:YES];
    [_lookMoreUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, kMoreHeight));
        make.top.mas_equalTo(headerHeight);
        make.centerX.mas_equalTo(headerView);
    }];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
//    layout.itemSize =CGSizeMake((DEVICE_WIDTH - 30.f )/5.f, 90.f);
    layout.itemSize =CGSizeMake(50.f, 90.f);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置边距
    layout.minimumLineSpacing = 0;//(DEVICE_WIDTH - 250) / 4.f;
    CGFloat itemSpaceWith = (DEVICE_WIDTH - 250) / 6.f;
    layout.minimumInteritemSpacing = itemSpaceWith;
//    layout.minimumLineSpacing = (DEVICE_WIDTH - kWL_NormalMarginWidth_15 * 2.f - layout.itemSize.width) / 4.f;//每个相邻layout的上下
//    layout.minimumInteritemSpacing = (ScreenWidth - kWL_NormalMarginWidth_15 * 2.f - layout.itemSize.width) / 4;//每个相邻layout的左右
    // 移动方向的设置
    
    //2.初始化collectionView
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemSpaceWith, 0., DEVICE_WIDTH - itemSpaceWith * 2.f, headerHeight) collectionViewLayout:layout];
    mainCollectionView.scrollEnabled = NO;
    [headerView addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [mainCollectionView registerClass:[UserItemCollectionViewCell class] forCellWithReuseIdentifier:@"user_item_cell"];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    //    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
//    [mainCollectionView wl_setDebug:YES];
    self.mainCollectionView = mainCollectionView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 74.f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    QMUIFillButton *quitBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    if (_groupDetailInfo.is_exist.integerValue == 1) {
        [quitBtn setTitle:@"退出群聊" forState:UIControlStateNormal];
    } else {
        [quitBtn setTitle:@"加入群聊" forState:UIControlStateNormal];
    }
    quitBtn.titleLabel.font = WLFONT(18);
    [quitBtn addTarget:self action:@selector(quitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setCornerRadius:5.f];
    [footerView addSubview:quitBtn];
    self.quitBtn = quitBtn;
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13.f);
        make.left.mas_equalTo(10.f);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
    }];
}

// 添加表格内容
- (void)addTableViewCell {
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    // 显示自定义分割线
    self.manager.showBottomLine = YES;
    
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 5.f;
    section.footerHeight = 0.f;
    [self.manager addSection:section];
    
    WEAKSELF
    RETableViewItem *nameItem = [RETableViewItem itemWithTitle:@"群名称" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        if (weakSelf.groupDetailInfo.type.integerValue == 1) {
            
        } else {
            if (weakSelf.groupDetailInfo._uid.integerValue == configTool.userInfoModel.userId.integerValue) {
                [weakSelf changeGroupName:item];
            }
        }
    }];
    nameItem.style = UITableViewCellStyleValue1;
    nameItem.detailLabelText = _groupDetailInfo.title;// @"5-10 赔率1.5倍  群组";
    nameItem.titleDetailTextColor = WLColoerRGB(102.f);
    nameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:nameItem];
    self.nameItem = nameItem;
    
    RETableViewItem *noteItem = [RETableViewItem itemWithTitle:@"群公告" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        if (weakSelf.groupDetailInfo.type.integerValue == 1) {
            
        } else {
            if (weakSelf.groupDetailInfo._uid.integerValue == configTool.userInfoModel.userId.integerValue) {
                [weakSelf changeGroupNotice:item];
            }
        }
    }];
    noteItem.style = UITableViewCellStyleSubtitle;
    noteItem.detailLabelText = _groupDetailInfo.notice ? : @"暂无";// @"温馨和谐文明真诚不欢迎广告！！的朋友你见或者不见我?我就在那这里的朋友你见或者不见我?我就在那里不悲不喜真诚我.见或者不见我?我就在那里不悲不喜真诚";
    noteItem.titleDetailTextFont = UIFontMake(12.f);
    noteItem.titleDetailTextColor = WLColoerRGB(102.f);
    noteItem.showTitleDetailTextNumberOfLine = YES;
    noteItem.selectionStyle = UITableViewCellSelectionStyleNone;
    noteItem.cellHeight = 79.f;
    [section addItem:noteItem];
    self.noteItem = noteItem;
    
    RETableViewSection *sectio2 = [RETableViewSection section];
    sectio2.headerHeight = 5.f;
    sectio2.footerHeight = 0.f;
    [self.manager addSection:sectio2];
    
    RETableViewItem *cartItem = [RETableViewItem itemWithTitle:@"我的群名片" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf changeMyCard:item];
    }];
    cartItem.style = UITableViewCellStyleValue1;
    cartItem.detailLabelText = _groupDetailInfo.remark;// @"陈敏";
    cartItem.titleDetailTextColor = WLColoerRGB(102.f);
    cartItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [sectio2 addItem:cartItem];
    self.cartItem = cartItem;
    
    RETableViewSection *section3 = [RETableViewSection section];
    section3.headerHeight = 5.f;
    section3.footerHeight = 0.f;
    [self.manager addSection:section3];
    
    REBoolItem *notDisturbItem = [REBoolItem itemWithTitle:@"消息免打扰" value:_groupDetailInfo.not_disturb.boolValue switchValueChangeHandler:^(REBoolItem *item) {
        [weakSelf changeMsgDisturb:item];
    }];
    [section3 addItem:notDisturbItem];
    self.notDisturbItem = notDisturbItem;
    
    REBoolItem *topItem = [REBoolItem itemWithTitle:@"会话置顶" value:_groupDetailInfo.is_top.boolValue switchValueChangeHandler:^(REBoolItem *item) {
        [weakSelf changeChatTop:item];
    }];
    [section3 addItem:topItem];
    self.topItem = topItem;
    
    RETableViewSection *section4 = [RETableViewSection section];
    section4.headerHeight = 5.f;
    section4.footerHeight = 0.f;
    [self.manager addSection:section4];
    
    RETableViewItem *chatHistoryItem = [RETableViewItem itemWithTitle:@"查找聊天记录" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    chatHistoryItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section4 addItem:chatHistoryItem];
    
    RETableViewItem *clearChatHistoryItem = [RETableViewItem itemWithTitle:@"清除聊天记录" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    clearChatHistoryItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section4 addItem:clearChatHistoryItem];
}

// 修改消息是否免打扰
- (void)changeMsgDisturb:(REBoolItem *)item {
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    if (!item.value) {
        // 关闭打扰
        [ImGroupModelClient cancelImGroupNotDisturbWithParams:@{@"id":@(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
            [weakSelf changeNotDisurbInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            if (error.localizedDescription.length > 0) {
                [WLHUDView showErrorHUD:error.localizedDescription];
            } else {
                [WLHUDView hiddenHud];
            }
        }];
    } else {
        // 开启免打扰
        [ImGroupModelClient setImGroupNotDisturbWithParams:@{@"id":@(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
            [weakSelf changeNotDisurbInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            if (error.localizedDescription.length > 0) {
                [WLHUDView showErrorHUD:error.localizedDescription];
            } else {
                [WLHUDView hiddenHud];
            }
        }];
    }
}

// 免打扰设置
- (void)changeNotDisurbInfo:(REBoolItem *)item {
    //    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
//    [[RCIM sharedRCIM] setConversationNotificationStatus]
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP
                                                            targetId:_groupDetailInfo.groupId
                                                           isBlocked:item.value
                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                 //                                                                 [WLHUDView hiddenHud];
                                                                 weakSelf.groupDetailInfo.not_disturb = [@(item.value) stringValue];
                                                                 item.value = !item.value;
//                                                                 [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                                             } error:^(RCErrorCode status) {
                                                                 //                                                                 [WLHUDView hiddenHud];
                                                                 [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                                             }];
}

// 修改聊天置顶状态
- (void)changeChatTop:(REBoolItem *)item {
    WEAKSELF
    [WLHUDView showHUDWithStr:@"" dim:YES];
    if (!item.value) {
        // 取消置顶
        [ImGroupModelClient setImGroupCancelIsTopWithParams:@{@"id":@(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
            [weakSelf changeChatTopInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            if (error.localizedDescription.length > 0) {
                [WLHUDView showErrorHUD:error.localizedDescription];
            } else {
                [WLHUDView hiddenHud];
            }
        }];
    } else {
        // 置顶
        [ImGroupModelClient setImGroupIsTopWithParams:@{@"id":@(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
            [weakSelf changeChatTopInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            if (error.localizedDescription.length > 0) {
                [WLHUDView showErrorHUD:error.localizedDescription];
            } else {
                [WLHUDView hiddenHud];
            }
        }];
    }
}

// 置顶修改
- (void)changeChatTopInfo:(REBoolItem *)item {
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:_groupDetailInfo.groupId isTop:item.value];
    self.groupDetailInfo.not_disturb = @(item.value).stringValue;
    item.value = !item.value;
//    [item reloadRowWithAnimation:UITableViewRowAnimationNone];
}

// 修改群名称
- (void)changeGroupName:(RETableViewItem *)item {
    ChatGourpNameViewController *vc = [[ChatGourpNameViewController alloc] init];
    vc.groupDetailInfo = _groupDetailInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

// 修改群公告
- (void)changeGroupNotice:(RETableViewItem *)item {
    ChatGroupNoteInfoViewController *vc = [[ChatGroupNoteInfoViewController alloc] init];
    vc.groupDetailInfo = _groupDetailInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

// 修改我的群名片
- (void)changeMyCard:(RETableViewItem *)item {
    ChatGroupRemarkViewController *vc = [[ChatGroupRemarkViewController alloc] init];
    vc.groupDetailInfo = _groupDetailInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_groupDetailInfo.type.integerValue == 1) {
        // 游戏群组，无法修改
        return _groupDetailInfo.member_list.count;
    } else {
        if (_groupDetailInfo._uid.integerValue == configTool.userInfoModel.userId.integerValue) {
            return _groupDetailInfo.member_list.count + 1;
        } else {
            return _groupDetailInfo.member_list.count ;
        }
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserItemCollectionViewCell *cell = (UserItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"user_item_cell" forIndexPath:indexPath];
    
    if (_groupDetailInfo.type.integerValue == 1) {
        // 游戏群组，无法修改
        IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
        cell.friendModel = model;
    } else {
        if (_groupDetailInfo._uid.integerValue == configTool.userInfoModel.userId.integerValue) {
            if (indexPath.row == _groupDetailInfo.member_list.count) {
                cell.logoImageView.image = [UIImage imageNamed:@"chatDetail_icon_add"];
            } else {
                IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
                cell.friendModel = model;
            }
        } else {
            IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
            cell.friendModel = model;
        }
    }
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50.f, 90.f);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
////设置每个item水平间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}


//设置每个item垂直间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
//    headerView.backgroundColor =[UIColor grayColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
//    label.text = @"这是collectionView的头部";
//    label.font = [UIFont systemFontOfSize:20];
//    [headerView addSubview:label];
//    return headerView;
//}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    NSString *msg = cell.botlabel.text;
//    NSLog(@"%@",msg);
    DLog(@"didSelectItemAtIndexPath：");
    if (_groupDetailInfo.type.integerValue == 0 || _groupDetailInfo._uid.integerValue == configTool.userInfoModel.userId.integerValue) {
        if (indexPath.row == _groupDetailInfo.member_list.count) {
            FriendListViewController *vc = [[FriendListViewController alloc] initWithFriendListType:FriendListTypeForGroupChatAddFriend];
            vc.groupDetailInfo = _groupDetailInfo;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.userId = model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
// 提醒退出登录
- (void)quitBtnClicked:(UIButton *)sender {
    if (_groupDetailInfo.is_exist.integerValue == 1) {
        // 退出
        WEAKSELF
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            DLog(@"取消");
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"退出群聊" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            DLog(@"退出群聊");
            [weakSelf quit];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:@"确认退出群聊？" preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    } else {
        // 加入
        WEAKSELF
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            DLog(@"取消");
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"加入群聊" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            DLog(@"加入群聊");
            [weakSelf join];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:@"确认加入当前群组？" preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    }
}

- (void)quit {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [ImGroupModelClient setImGroupQuitWithParams:@{@"id" : @(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"退出成功"];
        [kNSNotification postNotificationName:@"kGroupInfoChanged" object:nil];
        [weakSelf.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}

- (void)join {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    NSDictionary *params = @{@"id" : @(_groupDetailInfo.groupId.integerValue),
                             @"fuid" : @[configTool.loginUser.uid]
                             };
    [ImGroupModelClient setImGroupJoinWithParams:params Success:^(id resultInfo) {
        [WLHUDView showSuccessHUD:@"加入成功"];
        [kNSNotification postNotificationName:@"kGroupInfoChanged" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
}

// 查看更多用户
- (void)lookMoreUserBtn:(UIButton *)sender {
    
}

@end
