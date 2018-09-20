//
//  ChatInfoViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/19.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatInfoViewController.h"

#import "RETableViewManager.h"
#import "RETableViewItem.h"

#import "UserItemCollectionViewCell.h"

@interface ChatInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation ChatInfoViewController

- (NSString *)title {
    return @"聊天详情";
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
    
//    CGFloat moreHeight = 55.f;
//    CGFloat headerHeight = _userArray.count > 4 ? 180.f : 90.f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 110.f)];
    //    headerView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = headerView;
    
//    UIButton *lookMoreUserBtn = [[UIButton alloc] init];
//    [lookMoreUserBtn setTitle:@"查看更多群成员>" forState:UIControlStateNormal];
//    [lookMoreUserBtn setTitleColor:WLColoerRGB(102.f) forState:UIControlStateNormal];
//    lookMoreUserBtn.titleLabel.font = WLFONT(15);
//    [lookMoreUserBtn addTarget:self action:@selector(lookMoreUserBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:lookMoreUserBtn];
//    //    [lookMoreUserBtn wl_setDebug:YES];
//    [lookMoreUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, moreHeight));
//        make.top.mas_equalTo(headerHeight);
//        make.centerX.mas_equalTo(headerView);
//    }];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(DEVICE_WIDTH/5.f, 90.f);
    
    //2.初始化collectionView
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., DEVICE_WIDTH, 110.f) collectionViewLayout:layout];
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
    
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0., DEVICE_WIDTH, 74.f)];
//    footerView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = footerView;
//
//    QMUIFillButton *quitBtn = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
//    [quitBtn setTitle:@"退出群聊" forState:UIControlStateNormal];
//    quitBtn.titleLabel.font = WLFONT(18);
//    [quitBtn addTarget:self action:@selector(quitBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [quitBtn setCornerRadius:5.f];
//    [footerView addSubview:quitBtn];
//    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(13.f);
//        make.left.mas_equalTo(10.f);
//        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20.f, 44.f));
//    }];
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
    REBoolItem *notDisturbItem = [REBoolItem itemWithTitle:@"消息免打扰" value:YES switchValueChangeHandler:^(REBoolItem *item) {
        
    }];
    [section addItem:notDisturbItem];
    REBoolItem *topItem = [REBoolItem itemWithTitle:@"回话置顶" value:YES switchValueChangeHandler:^(REBoolItem *item) {
        
    }];
    [section addItem:topItem];
    REBoolItem *rejectItem = [REBoolItem itemWithTitle:@"屏蔽好友" value:YES switchValueChangeHandler:^(REBoolItem *item) {
        
    }];
    [section addItem:rejectItem];
    
    RETableViewSection *section2 = [RETableViewSection section];
    section2.headerHeight = 5.f;
    section2.footerHeight = 0.f;
    [self.manager addSection:section2];
    
    RETableViewItem *chatHistoryItem = [RETableViewItem itemWithTitle:@"查找聊天记录" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    chatHistoryItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section2 addItem:chatHistoryItem];
    
    RETableViewItem *clearChatHistoryItem = [RETableViewItem itemWithTitle:@"清除聊天记录" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    clearChatHistoryItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section2 addItem:clearChatHistoryItem];
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
    return 1 + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserItemCollectionViewCell *cell = (UserItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"user_item_cell" forIndexPath:indexPath];
    
    if (indexPath.row == 2) {
        cell.logoImageView.image = [UIImage imageNamed:@"redP_head_img"];
    } else {
        cell.logoImageView.image = [UIImage imageNamed:@"redP_head_img"];
        cell.titleLabel.text = @"dd";
    }
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(DEVICE_WIDTH / 5.f, 90.f);
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
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


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
}

#pragma mark - Private
// 提醒退出登录
- (void)quitBtn:(UIButton *)sender {
    
}

// 查看更多用户
- (void)lookMoreUserBtn:(UIButton *)sender {
    
}

@end
