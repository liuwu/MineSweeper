//
//  ChatGroupMoreUserViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/29.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatGroupMoreUserViewController.h"
#import "UserItemCollectionViewCell.h"
#import "UserInfoViewController.h"
#import "FriendListViewController.h"

#import "ImGroupModelClient.h"

@interface ChatGroupMoreUserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, assign) BOOL isIn;

@end

@implementation ChatGroupMoreUserViewController

- (NSString *)title {
    return @"群成员";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isIn = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isIn = NO;
}

- (void)initSubviews {
    [super initSubviews];
    [self addTableHeaderInfo];
//    [self addTableViewCell];
    //    [self loadData];
    
    [kNSNotification addObserver:self selector:@selector(loadData) name:@"kGroupInfoChanged" object:nil];
//    [kNSNotification addObserver:self selector:@selector(loadData) name:@"kGroupInfoChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 获取群主信息接口
- (void)loadData {
    //    [WLHUDView showHUDWithStr:@"" dim:YES];
    if (!_isIn) {
        WEAKSELF
        [ImGroupModelClient getImGroupInfoWithParams:@{@"id" : [NSNumber numberWithInteger:_groupDetailInfo.groupId.integerValue]}
                                             Success:^(id resultInfo) {
                                                 //                                             [WLHUDView hiddenHud];
                                                 weakSelf.groupDetailInfo = [IGroupDetailInfo modelWithDictionary:resultInfo];
                                                 [weakSelf.mainCollectionView reloadData];
                                             } Failed:^(NSError *error) {
                                                 //                                             [WLHUDView hiddenHud];
                                             }];
    }
   
}

// 获取群主信息接口
//- (void)loadData {
//    //    [WLHUDView showHUDWithStr:@"" dim:YES];
//    WEAKSELF
//    [ImGroupModelClient getImGroupInfoWithParams:@{@"id" : [NSNumber numberWithInteger:_groupId.integerValue]}
//                                         Success:^(id resultInfo) {
//                                             //                                             [WLHUDView hiddenHud];
//                                             self.groupDetailInfo = [IGroupDetailInfo modelWithDictionary:resultInfo];
//                                             [weakSelf updateUI];
//                                         } Failed:^(NSError *error) {
//                                             //                                             [WLHUDView hiddenHud];
//                                         }];
//}

//- (void)updateUI {
//    [_mainCollectionView reloadData];
//}

- (void)addTableHeaderInfo {
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    
    //    CGFloat headerHeight = _userArray.count > 4 ? 180.f : 90.f;
//    CGFloat headerHeight = 90;
//    if (_groupDetailInfo.type.integerValue == 1) {
//        // 游戏群组，无法修改
//        headerHeight = _groupDetailInfo.member_list.count > 5 ? 180.f : 90.f;
//    } else {
//        if (_groupDetailInfo._uid.integerValue != configTool.userInfoModel.userId.integerValue) {
//            headerHeight = _groupDetailInfo.member_list.count > 5 ? 180.f : 90.f;
//        } else {
//            headerHeight = _groupDetailInfo.member_list.count > 4 ? 180.f : 90.f;
//        }
//    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH,  self.view.height - self.qmui_navigationBarMaxYInViewCoordinator)];
    //    headerView.backgroundColor = [UIColor redColor];
    //    [headerView wl_setDebug:YES];
    self.headerView = headerView;
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
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemSpaceWith, 0., DEVICE_WIDTH - itemSpaceWith * 2.f, self.view.height - self.qmui_navigationBarMaxYInViewCoordinator) collectionViewLayout:layout];
    mainCollectionView.scrollEnabled = YES;
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
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 30.f)];
//    footerView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)deleteUserAlert:(UIButton *)btn {
    IFriendModel *model = _groupDetailInfo.member_list[btn.tag];
    // 加入
    @weakify(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"移除" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        @strongify(self);
        [self deleteUser:model index:btn.tag];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提醒" message:@"确认移除当前成员？" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action2];
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];
}

// 移除成员
- (void)deleteUser:(IFriendModel *)model index:(NSInteger)index {
    NSDictionary *params = @{@"id" : @(_groupDetailInfo.groupId.integerValue),
                             @"uid" : @[@(model.uid.integerValue)]
                             };
    [WLHUDView showHUDWithStr:@"" dim:YES];
    @weakify(self);
    [ImGroupModelClient deleteImGroupMemberWithParams:params Success:^(id resultInfo) {
        @strongify(self);
        [WLHUDView showSuccessHUD:@"移除成功"];
        [kNSNotification postNotificationName:@"kGroupInfoChanged" object:nil];
        NSMutableArray *datasource = [NSMutableArray arrayWithArray:self.groupDetailInfo.member_list];
        [datasource removeObjectAtIndex:index];
        self.groupDetailInfo.member_list = [NSArray arrayWithArray:datasource];
        [self.mainCollectionView reloadData];
    } Failed:^(NSError *error) {
        if (error.localizedDescription.length > 0) {
            [WLHUDView showErrorHUD:error.localizedDescription];
        } else {
            [WLHUDView hiddenHud];
        }
    }];
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
        cell.deleteBtn.hidden = YES;
    } else {
        if (_groupDetailInfo._uid.integerValue == configTool.userInfoModel.userId.integerValue) {
            if (indexPath.row == _groupDetailInfo.member_list.count) {
                cell.logoImageView.image = [UIImage imageNamed:@"chatDetail_icon_add"];
                cell.titleLabel.text = @"";
                cell.deleteBtn.hidden = YES;
            } else {
                IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
                cell.friendModel = model;
                cell.deleteBtn.hidden = _groupDetailInfo._uid.intValue == model.uid.intValue;
                cell.deleteBtn.tag = indexPath.row;
                [cell.deleteBtn addTarget:self action:@selector(deleteUserAlert:) forControlEvents:UIControlEventTouchUpInside];
//                @weakify(self);
//                [cell.deleteBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//                    @strongify(self);
//                    [self deleteUserAlert:model indexPath:indexPath];
//                }];
            }
        } else {
            IFriendModel *model = _groupDetailInfo.member_list[indexPath.row];
            cell.friendModel = model;
            cell.deleteBtn.hidden = YES;
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

@end
