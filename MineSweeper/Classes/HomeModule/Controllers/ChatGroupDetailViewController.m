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
    _noteItem.detailLabelText = _groupDetailInfo.remark;
    _cartItem.detailLabelText = _groupDetailInfo.remark;
    _notDisturbItem.value = _groupDetailInfo.not_disturb.boolValue;
    _topItem.value = _groupDetailInfo.is_top.boolValue;

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
    CGFloat headerHeight = _groupDetailInfo.member_list.count > 4 ? 180.f : 90.f;
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
    [quitBtn setTitle:@"退出群聊" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = WLFONT(18);
    [quitBtn addTarget:self action:@selector(quitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setCornerRadius:5.f];
    [footerView addSubview:quitBtn];
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
        ChatGourpNameViewController *vc = [[ChatGourpNameViewController alloc] init];
        vc.groupDetailInfo = weakSelf.groupDetailInfo;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    nameItem.style = UITableViewCellStyleValue1;
    nameItem.detailLabelText = _groupDetailInfo.title;// @"5-10 赔率1.5倍  群组";
    nameItem.titleDetailTextColor = WLColoerRGB(102.f);
    nameItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:nameItem];
    self.nameItem = nameItem;
    
    RETableViewItem *noteItem = [RETableViewItem itemWithTitle:@"群公告" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        ChatGroupNoteInfoViewController *vc = [[ChatGroupNoteInfoViewController alloc] init];
        vc.groupDetailInfo = weakSelf.groupDetailInfo;
        [weakSelf.navigationController pushViewController:vc animated:YES];
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
    
    REBoolItem *topItem = [REBoolItem itemWithTitle:@"回话置顶" value:_groupDetailInfo.is_top.boolValue switchValueChangeHandler:^(REBoolItem *item) {
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
    if (item.value) {
        // 关闭打扰
        [ImGroupModelClient cancelImGroupNotDisturbWithParams:@{@"id":@(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
            [WLHUDView hiddenHud];
            weakSelf.groupDetailInfo.not_disturb = @(!item.value).stringValue;
            item.value = !item.value;
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
        }];
    } else {
        // 开启免打扰
        [ImGroupModelClient setImGroupNotDisturbWithParams:@{@"id":@(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
            [WLHUDView hiddenHud];
            weakSelf.groupDetailInfo.not_disturb = @(!item.value).stringValue;
            item.value = !item.value;
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];
        }];
    }
    [item reloadRowWithAnimation:UITableViewRowAnimationNone];
}

// 修改聊天置顶状态
- (void)changeChatTop:(REBoolItem *)item {
    
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
    return _groupDetailInfo.member_list.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserItemCollectionViewCell *cell = (UserItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"user_item_cell" forIndexPath:indexPath];
    
    if (indexPath.row == _groupDetailInfo.member_list.count) {
        cell.logoImageView.image = [UIImage imageNamed:@"chatDetail_icon_add"];
    } else {
        IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
        cell.logoImageView.image = [UIImage imageNamed:@"redP_head_img"];
        cell.titleLabel.text = model.nickname;// _userArray[indexPath.row];
        [cell.logoImageView setImageWithURL:[NSURL URLWithString:model.avatar]
                                placeholder:nil
                                    options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur|YYWebImageOptionUseNSURLCache
                                 completion:nil];
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
    IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.userId = model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
// 提醒退出登录
- (void)quitBtn:(UIButton *)sender {
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

- (void)quit {
    [ImGroupModelClient setImGroupQuitWithParams:@{@"id" : @(_groupDetailInfo.groupId.integerValue)} Success:^(id resultInfo) {
        
    } Failed:^(NSError *error) {
        
    }];
}

// 查看更多用户
- (void)lookMoreUserBtn:(UIButton *)sender {
    
}

@end