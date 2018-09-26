//
//  FriendListViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "FriendListViewController.h"
#import "NewFriendListViewController.h"
#import "GroupListViewController.h"
#import "SearchFriendViewController.h"
#import "TransferViewController.h"

#import "UserInfoViewController.h"
#import "ChatInfoViewController.h"

#import "QMUISearchBar.h"
#import "BaseTableViewCell.h"

#import "DSectionIndexItemView.h"
#import "DSectionIndexView.h"

#import "FriendModelClient.h"
#import "IFriendModel.h"

@interface FriendListViewController ()<DSectionIndexViewDelegate,DSectionIndexViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) DSectionIndexView *sectionIndexView;
@property (nonatomic, strong) NSArray<NSString *> *iconArray;
@property (nonatomic, strong) NSArray<NSString *> *iconTitleArray;

@property (nonatomic, strong) NSArray *datasouce;


@end

@implementation FriendListViewController

- (NSString *)title {
    switch (_frindListType) {
        case FriendListTypeForTransfer:
            return @"转账";
            break;
        default:
            return @"通讯录";
            break;
    }
}

- (instancetype)initWithFriendListType:(FriendListType)frindListType {
    self.frindListType = frindListType;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initSubviews {
    [super initSubviews];
    // 显示自带的searchbar
//    self.shouldShowSearchBar = YES;
    
    self.iconArray = @[@"game_friend_icon", @"game_group_icon"];
    self.iconTitleArray = @[@"新朋友", @"群聊"];
    
    self.tableView.backgroundColor = WLColoerRGB(248.f);
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        // 更改索引的背景颜色
        self.tableView.sectionIndexBackgroundColor = [UIColor redColor];//WLColoerRGB(153.f);
        // 更改索引的文字颜色
        self.tableView.sectionIndexColor = UIColorMake(133,144,166);
    }
//    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];//设置选中时，索引背景颜色
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];//设置默认时，索引的背景颜色
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshingNew)];
    
    if (_frindListType == FriendListTypeNormal) {
        UIBarButtonItem *leftBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"home_notice_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(leftBtnItemClicked)];
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        
        UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:[[UIImage imageNamed:@"common_addFriend_icon_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] target:self action:@selector(rightBtnItemClicked)];
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    
    QMUISearchBar *searchBar = [[QMUISearchBar alloc] qmui_initWithSize:CGSizeMake(DEVICE_WIDTH, 44.f)];
    searchBar.delegate = self;
//    searchBar.showsCancelButton = YES;
    self.tableView.tableHeaderView = searchBar;
    
    // 索引控件
    DSectionIndexView *sectionIndexView = [[DSectionIndexView alloc] init];
    sectionIndexView.backgroundColor = WLColoerRGB(230.f);
    sectionIndexView.dataSource = self;
    sectionIndexView.delegate = self;
    sectionIndexView.isShowCallout = NO;
    sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    sectionIndexView.calloutMargin = 100.f;
    sectionIndexView.fixedItemHeight = 15.f;
    sectionIndexView.layer.cornerRadius = 9.f;
    sectionIndexView.alpha = 0.6f;
    
    [self.view addSubview:sectionIndexView];
    self.sectionIndexView = sectionIndexView;
    
    [self.sectionIndexView reloadItemViews];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    WEAKSELF
    [FriendModelClient getImFriendListWithParams:nil Success:^(id resultInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.datasouce = [NSArray modelArrayWithClass:[IFriendModel class] json:resultInfo];
        [weakSelf.tableView reloadData];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma make - UISearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    searchBar.showsCancelButton = NO;
    
}

#pragma make - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[self.view wl_findFirstResponder] resignFirstResponder];
}

#pragma mark - getter & setter
#define kSectionIndexWidth 19.f
#define kSectionIndexHeight 340.f
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _sectionIndexView.frame = CGRectMake(CGRectGetWidth(self.tableView.frame) - kSectionIndexWidth -6.f, (CGRectGetHeight(self.tableView.frame) - kSectionIndexHeight)/2, kSectionIndexWidth, kSectionIndexHeight);
    [_sectionIndexView setBackgroundViewFrame];
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView {
    return 18;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section {
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = @"A";
    itemView.titleLabel.font = UIFontMake(10.f);
    itemView.titleLabel.textColor = WLColoerRGB(51.f);///UIColorMake(133,144,166);
    itemView.titleLabel.highlightedTextColor = UIColorMake(254,72,30);
    //    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    //    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return itemView;
}

// 显示居中的放大效果
//- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section {
//    UILabel *label = [[UILabel alloc] init];
//
//    label.frame = CGRectMake(0, 0, 80, 80);
//
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor redColor];
//    label.font = [UIFont boldSystemFontOfSize:36];
//    label.text = @"A";
//    label.textAlignment = NSTextAlignmentCenter;
//
//    [label.layer setCornerRadius:label.frame.size.width/2];
//    [label.layer setBorderColor:UIColorMake(254,72,30).CGColor];
//    [label.layer setBorderWidth:3.0f];
//    [label.layer setShadowColor:UIColorMake(254,72,30).CGColor];
//    [label.layer setShadowOpacity:0.8];
//    [label.layer setShadowRadius:5.0];
//    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
//
//    return label;
//}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section {
    return @"AA";
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section {
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView qmui_scrollToRowFittingOffsetY:10 atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] animated:YES];
}

#pragma mark - UITableView Datasource & Delegate
// 点击索引事件
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    if (index == 0) {
//        [self.tableView setContentOffset:CGPointMake(0, -64)];
//        return NSNotFound;
//    }else{
//        return index-1;
//    }
//}
//
//- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (self.searchBar.text.length) {
//        return nil;
//    }else{
//        return @[@"A", @"B", @"C", @"D", @"E", @"F"];
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (_frindListType) {
        case FriendListTypeForTransfer:
            return 1.f;
            break;
        default:
            return 2.f;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_frindListType) {
        case FriendListTypeForTransfer:
            return _datasouce.count;
            break;
        default: {
            if (section == 0) {
                return _iconArray.count;
            }
            return _datasouce.count;
        }
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend_list_cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend_list_cell"];
    }
    cell.showBottomLine = YES;
    
    switch (_frindListType) {
        case FriendListTypeForTransfer:
            {
                cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(30, 30) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
                IFriendModel *model = _datasouce[indexPath.row];
                cell.textLabel.text = model.nickname;// @"小尹子";
            }
            break;
        default:
        {
            if (indexPath.section == 0) {
                cell.imageView.image = [UIImage imageNamed:_iconArray[indexPath.row]];
                cell.textLabel.text = _iconTitleArray[indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(30, 30) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
                IFriendModel *model = _datasouce[indexPath.row];
                cell.textLabel.text = model.nickname;// @"小尹子";
            }
        }
            break;
    }
    
    
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    
    // reset
    cell.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    switch (_frindListType) {
        case FriendListTypeForTransfer:
        {
            //转账
            IFriendModel *model = _datasouce[indexPath.row];
            if (!model) {
                return;
            }
            TransferViewController *vc = [[TransferViewController alloc] init];
            vc.friendModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {
            if (indexPath.section == 0 && indexPath.row == 0) {
                NewFriendListViewController *newFriendVc = [[NewFriendListViewController alloc] init];
                [self.navigationController pushViewController:newFriendVc animated:YES];
                return;
            }
            if (indexPath.section == 0 && indexPath.row == 1) {
                GroupListViewController *groupListVc = [[GroupListViewController alloc] init];
                [self.navigationController pushViewController:groupListVc animated:YES];
                return;
            }
            
            UserInfoViewController *userInfoVc = [[UserInfoViewController alloc] init];
//            userInfoVc.friendModel = _datasouce[indexPath.row];
            IFriendModel *model = _datasouce[indexPath.row];
            userInfoVc.userId = model.uid.stringValue;
            [self.navigationController pushViewController:userInfoVc animated:YES];
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return kNoteHeight + kBannerHeight;
    if (section == 0) {
        return 10.f;
    }
    return 28.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

#pragma mark - Private
- (void)leftBtnItemClicked {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    NewFriendListViewController *newFriendVc = [[NewFriendListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:newFriendVc animated:YES];
}

// 右侧按钮点击
- (void)rightBtnItemClicked {
    [[self.view wl_findFirstResponder] resignFirstResponder];
//    ChatInfoViewController *vc = [[ChatInfoViewController alloc] init];
    SearchFriendViewController *vc = [[SearchFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    [self loadData];
}



@end
