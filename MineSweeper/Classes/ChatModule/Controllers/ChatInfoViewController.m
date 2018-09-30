//
//  ChatInfoViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatInfoViewController.h"
#import "UserInfoViewController.h"
#import "ChatHistoryMessageSearchViewController.h"


#import "RETableViewManager.h"
#import "RETableViewItem.h"

#import "UserItemCollectionViewCell.h"

#import "ImModelClient.h"

#define kHeaderHeight 110.f

@interface ChatInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) RETableViewManager *manager;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
//@property (nonatomic, strong) UIButton *lookMoreUserBtn;

@property (nonatomic, strong) REBoolItem *notDisturbItem;
@property (nonatomic, strong) REBoolItem *topItem;
//@property (nonatomic, strong) REBoolItem *rejectItem;

@property (nonatomic, strong) RETableViewItem *chatHistoryItem;
@property (nonatomic, strong) RETableViewItem *clearChatHistoryItem;

@end

@implementation ChatInfoViewController

- (NSString *)title {
    return @"聊天详情";
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableHeaderInfo];
    [self addTableViewCell];
    
    [kNSNotification addObserver:self selector:@selector(loadData) name:@"kUserChatInfoChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadData {
    WEAKSELF
    [ImModelClient getImChatInfoWithParams:@{@"fuid": @(_uid.integerValue)} Success:^(id resultInfo) {
        weakSelf.friendModel = [IFriendModel modelWithDictionary:resultInfo];
        [weakSelf updateUI];
    } Failed:^(NSError *error) {
        
    }];
}

- (void)updateUI {
    _notDisturbItem.value = _friendModel.not_disturb.boolValue;
    _topItem.value = _friendModel.is_top.boolValue;
//    _rejectItem.value = _friendModel.is_top.boolValue;
    [self.tableView reloadData];
    
    [_mainCollectionView reloadData];
}

- (void)addTableHeaderInfo {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, kHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
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
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemSpaceWith, 0., DEVICE_WIDTH - itemSpaceWith * 2.f, kHeaderHeight) collectionViewLayout:layout];
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
    self.mainCollectionView = mainCollectionView;
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
    REBoolItem *notDisturbItem = [REBoolItem itemWithTitle:@"消息免打扰" value:_friendModel.not_disturb.boolValue switchValueChangeHandler:^(REBoolItem *item) {
        [weakSelf changeNotDisturb:item];
    }];
    [section addItem:notDisturbItem];
    self.notDisturbItem = notDisturbItem;
    
    REBoolItem *topItem = [REBoolItem itemWithTitle:@"会话置顶" value:_friendModel.is_top.boolValue switchValueChangeHandler:^(REBoolItem *item) {
        [weakSelf changeChatTop:item];
    }];
    [section addItem:topItem];
    self.topItem = topItem;
    
//    REBoolItem *rejectItem = [REBoolItem itemWithTitle:@"屏蔽好友" value:YES switchValueChangeHandler:^(REBoolItem *item) {
//        // 加黑名单
//        [weakSelf changeChatReject:item];
//    }];
//    [section addItem:rejectItem];
//    self.rejectItem = rejectItem;
    
    RETableViewSection *section2 = [RETableViewSection section];
    section2.headerHeight = 5.f;
    section2.footerHeight = 0.f;
    [self.manager addSection:section2];
    
    RETableViewItem *chatHistoryItem = [RETableViewItem itemWithTitle:@"查找聊天记录" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf searchChatHistory];
    }];
    chatHistoryItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section2 addItem:chatHistoryItem];
    
    RETableViewItem *clearChatHistoryItem = [RETableViewItem itemWithTitle:@"清除聊天记录" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [weakSelf clearChatMessageAlert];
    }];
    clearChatHistoryItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section2 addItem:clearChatHistoryItem];
}

// 搜索聊天历史
- (void)searchChatHistory {
    ChatHistoryMessageSearchViewController *vc = [[ChatHistoryMessageSearchViewController alloc] initWithStyle:UITableViewStylePlain ChatHistoryType:ChatHistoryTypePrivate];
    vc.targetId = _uid;
    [self.navigationController pushViewController:vc animated:YES];
}

// 清除聊天记录
- (void)clearChatMessageAlert {
    WEAKSELF
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf clearChatMessage];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定清除聊天记录？" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

// 清除聊天记录
- (void)clearChatMessage {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    BOOL success = [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:_uid];
    if (success) {
        [WLHUDView showSuccessHUD:@"清除完成"];
    } else {
        [WLHUDView hiddenHud];
    }
//    [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_PRIVATE targetId:_uid success:^{
//        [WLHUDView showSuccessHUD:@"清除完成"];
//    } error:^(RCErrorCode status) {
//        [WLHUDView hiddenHud];
//    }];
}


- (void)changeChatReject:(REBoolItem *)item {
    if (!item.value) {
        // 移除黑名单
        [[RCIMClient sharedRCIMClient] removeFromBlacklist:_uid success:^{
            
        } error:^(RCErrorCode status) {
            
        }];
        
    } else {
        // 加入黑名单
        [[RCIMClient sharedRCIMClient] addToBlacklist:_uid
                                              success:^{
                                                  
                                              } error:^(RCErrorCode status) {
                                                  
                                              }];
    }
}

// 设置置顶
- (void)changeChatTop:(REBoolItem *)item {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    if (!item.value) {
        // 取消置顶
        [ImModelClient setImChatCancelIsTopWithParams:@{@"fuid" : _uid} Success:^(id resultInfo) {
            [weakSelf changeChatTopInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
        }];
    } else {
        // 开启置顶
        [ImModelClient setImChatIsTopWithParams:@{@"fuid" : _uid} Success:^(id resultInfo) {
            [weakSelf changeChatTopInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
        }];
    }
}

- (void)changeChatTopInfo:(REBoolItem *)item {
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:_uid isTop:item.value];
    _friendModel.is_top = [@(item.value) stringValue];
    item.value = !item.value;
//    [item reloadRowWithAnimation:UITableViewRowAnimationNone];
}

// 设置免打扰
- (void)changeNotDisturb:(REBoolItem *)item {
    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    if (!item.value) {
        // 取消免打扰
        [ImModelClient setImChatCancelNotDisturbWithParams:@{@"fuid" : _uid} Success:^(id resultInfo) {
            [weakSelf changeNotDisurbInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
        }];
    } else {
        // 开启免打扰
        [ImModelClient setImChatNotDisturbWithParams:@{@"fuid" : _uid} Success:^(id resultInfo) {
            [weakSelf changeNotDisurbInfo:item];
            [WLHUDView hiddenHud];
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
        }];
    }
}

- (void)changeNotDisurbInfo:(REBoolItem *)item {
//    [WLHUDView showHUDWithStr:@"" dim:YES];
    WEAKSELF
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE
                                                            targetId:_uid
                                                           isBlocked:item.value
                                                             success:^(RCConversationNotificationStatus nStatus) {
//                                                                 [WLHUDView hiddenHud];
                                                                 weakSelf.friendModel.not_disturb = [@(item.value) stringValue];
                                                                 item.value = !item.value;
//                                                                 [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                                             } error:^(RCErrorCode status) {
//                                                                 [WLHUDView hiddenHud];
                                                                 [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                                             }];
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
    return 1;// + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserItemCollectionViewCell *cell = (UserItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"user_item_cell" forIndexPath:indexPath];
    
//    if (indexPath.row == 1) {
//        cell.logoImageView.image = [UIImage imageNamed:@"chatDetail_icon_add"];
//    } else {
        cell.titleLabel.text = _friendModel.nickname;// _userArray[indexPath.row];
        [cell.logoImageView setImageWithURL:[NSURL URLWithString:_friendModel.avatar]
                                placeholder:[UIImage imageNamed:@"game_friend_icon"]
                                    options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                                 completion:nil];
//    }
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50.f, 90.f);
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    NSString *msg = cell.botlabel.text;
    //    NSLog(@"%@",msg);
    DLog(@"didSelectItemAtIndexPath：");
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.userId = _friendModel.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
// 提醒退出登录
- (void)quitBtn:(UIButton *)sender {
    
}

// 查看更多用户
- (void)lookMoreUserBtn:(UIButton *)sender {
    
}

@end
