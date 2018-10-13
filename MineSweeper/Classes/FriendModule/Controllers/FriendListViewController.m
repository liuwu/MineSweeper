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
#import "ChatViewController.h"
#import "MessageNotifiListViewController.h"

#import "UserInfoViewController.h"
#import "ChatInfoViewController.h"

#import "QMUISearchBar.h"
#import "BaseTableViewCell.h"
#import "BaseImageTableViewCell.h"

#import "DSectionIndexItemView.h"
#import "DSectionIndexView.h"

#import "FriendModelClient.h"
#import "IFriendModel.h"

#import "ImGroupModelClient.h"

@interface FriendListViewController ()<DSectionIndexViewDelegate,DSectionIndexViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) QMUISearchBar *searchBar;
@property (nonatomic, strong) DSectionIndexView *sectionIndexView;
@property (nonatomic, strong) NSArray<NSString *> *iconArray;
@property (nonatomic, strong) NSArray<NSString *> *iconTitleArray;

@property (nonatomic, strong) UIBarButtonItem *rightBtnItem;

@property (nonatomic, strong) NSArray *datasouce;
@property (nonatomic, strong) NSArray *allKeys;
@property (nonatomic, strong) NSMutableDictionary *friendDict;

@property (nonatomic, strong) NSMutableArray *filterArray;//搜索出来的数据数组
@property (nonatomic, strong) NSArray *filterAllKeys;
@property (nonatomic, strong) NSMutableDictionary *filterFriendDict;

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, strong) NSMutableArray *selectChatArray;

@property(nonatomic, strong) QMUIPopupMenuView *popupByWindow;


@end

@implementation FriendListViewController

- (NSString *)title {
    switch (_frindListType) {
        case FriendListTypeForTransfer:
            return @"转账";
            break;
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
            return @"选择联系人";
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
    [self addViews];
    [self loadData];
    
    [kNSNotification addObserver:self selector:@selector(loadData) name:@"kRefreshFriendList" object:nil];
    // 监听新好友添加
    [kNSNotification addObserver:self selector:@selector(updateNewFriendBadge) name:@"kNewFriendRequest" object:nil];
}

- (void)updateNewFriendBadge {
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat minY = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat viewportHeight = CGRectGetHeight(self.view.bounds) - minY;
    CGFloat sectionHeight = viewportHeight / 3.0;
    
    [self.popupByWindow layoutWithTargetView:self.navigationItem.rightBarButtonItem.customView];// 相对于 button2 布局
//
//    // 在横竖屏旋转时，viewDidLayoutSubviews 这个时机还无法获取到正确的 navigationItem 的 frame，所以直接隐藏掉
//    if (self.popupAtBarButtonItem.isShowing) {
//        [self.popupAtBarButtonItem hideWithAnimated:NO];
//    }
}

- (void)addViews {
    self.iconArray = @[@"game_friend_icon", @"game_group_icon"];
    self.iconTitleArray = @[@"新朋友", @"群聊"];
    
//    self.tableView.backgroundColor = WLColoerRGB(248.f);
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
        UIBarButtonItem *leftBtnItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"home_notice_btn"] target:self action:@selector(leftBtnItemClicked)];
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        
        UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"common_addFriend_icon_normal"] target:self action:@selector(rightBtnItemClicked)];
        self.navigationItem.rightBarButtonItem = rightBtnItem;
        
        // 使用方法 2，以 UIWindow 的形式显示到界面上，这种无需默认隐藏，也无需 add 到某个 UIView 上
        self.popupByWindow = [[QMUIPopupMenuView alloc] init];
        self.popupByWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        self.popupByWindow.maskViewBackgroundColor = [UIColor clearColor];//UIColorMaskWhite;// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
        self.popupByWindow.maximumWidth = 120;
        self.popupByWindow.shouldShowItemSeparator = YES;
        self.popupByWindow.arrowSize = CGSizeMake(10, 8);
//        self.popupByWindow.separatorInset = UIEdgeInsetsMake(0, self.popupByWindow.padding.left, 0, self.popupByWindow.padding.right);
        self.popupByWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
//            aItem.button.highlightedBackgroundColor = [[QDThemeManager sharedInstance].currentTheme.themeTintColor colorWithAlphaComponent:.2];
            aItem.button.tintColorAdjustsTitleAndImage = WLColoerRGB(51.f);
            aItem.button.titleLabel.font = UIFontMake(15.f);
        };
        WEAKSELF
        QMUIPopupMenuButtonItem *addItem = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"添加好友" handler:^(QMUIPopupMenuButtonItem *aItem) {
            [aItem.menuView hideWithAnimated:YES];
            [weakSelf searchFriendToAdd];
        }];
        addItem.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [addItem.button setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
        addItem.button.titleLabel.font = UIFontMake(15.f);
        QMUIPopupMenuButtonItem *createGroupItem = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"创建群组" handler:^(QMUIPopupMenuButtonItem *aItem) {
            [aItem.menuView hideWithAnimated:YES];
            [weakSelf createGroup];
        }];
        createGroupItem.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [createGroupItem.button setTitleColor:WLColoerRGB(51.f) forState:UIControlStateNormal];
        createGroupItem.button.titleLabel.font = UIFontMake(15.f);
        self.popupByWindow.items = @[addItem, createGroupItem];
        self.popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
//            [weakSelf.button2 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
        };
    }
    if (_frindListType == FriendListTypeForGroupChat||_frindListType == FriendListTypeForGroupChatAddFriend) {
        [self.tableView setEditing:YES animated:YES];
        self.tableView.allowsMultipleSelection = YES;
        self.selectChatArray = [NSMutableArray array];
        UIBarButtonItem *rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"确定" target:self action:@selector(rightBtnItemClicked)];
        self.rightBtnItem = rightBtnItem;
        self.navigationItem.rightBarButtonItem = rightBtnItem;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    QMUISearchBar *searchBar = [[QMUISearchBar alloc] qmui_initWithSize:CGSizeMake(DEVICE_WIDTH, 44.f)];
    searchBar.delegate = self;
    self.searchBar = searchBar;
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
    [self hideEmptyView];
    WEAKSELF
    [FriendModelClient getImFriendListWithParams:nil Success:^(id resultInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.datasouce = [NSArray modelArrayWithClass:[IFriendModel class] json:resultInfo];
        if (weakSelf.datasouce.count == 0) {
            [weakSelf showEmptyViewWithText:@"暂无数据" detailText:@"" buttonTitle:nil buttonAction:NULL];
        }
        [weakSelf makeUserArrayDic];
    } Failed:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)makeUserArrayDic {
//    self.datasouce = [self.datasouce sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return [[obj1 firstPinyin] localizedCompare:[obj2 firstPinyin]];
//    }];
    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
    NSMutableArray *array;
    for (IFriendModel *model in _datasouce) {
        BOOL hasKey = [friendDict bk_any:^BOOL(id key, id obj) {
            return [key isEqualToString:model.firstPinyin];
        }];
        if (!hasKey) {
            array = [NSMutableArray array];
            [array addObject:model];
            [friendDict setObject:array forKey:model.firstPinyin];
        } else {
            array = [friendDict objectForKey:model.firstPinyin];
            [array addObject:model];
            [friendDict setObject:array forKey:model.firstPinyin];
        }
    }
    self.allKeys = [[friendDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 localizedCompare:obj2];
    }];
    self.friendDict = friendDict;
    [self.tableView reloadData];
    [self.sectionIndexView reloadItemViews];
//    DLog(@"----- >%@", describe(friendDict));
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
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            if (self.searchBar.text.length) {
                return _filterAllKeys.count;
            } else {
                return _allKeys.count;
            }
            break;
        default:
            if (self.searchBar.text.length) {
                return _filterAllKeys.count + 1;
            } else {
                return _allKeys.count + 1;
            }
            break;
    }
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section {
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            if (self.searchBar.text.length) {
                itemView.titleLabel.text = _filterAllKeys[section];
            } else {
                itemView.titleLabel.text = _allKeys[section];
            }
            break;
        default:
            if (self.searchBar.text.length) {
                itemView.titleLabel.text = section == 0 ? @"#" : _filterAllKeys[section - 1];
            } else {
                itemView.titleLabel.text = section == 0 ? @"#" : _allKeys[section - 1];
            }
            break;
    }
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
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            if (self.searchBar.text.length) {
                return _filterAllKeys[section];
            } else {
                return _allKeys[section];
            }
            break;
        default:
            if (self.searchBar.text.length) {
                return section == 0 ? @"#" : _filterAllKeys[section - 1];
            } else {
                return section == 0 ? @"#" : _allKeys[section - 1];
            }
            break;
    }
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
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            if (self.searchBar.text.length) {
                return _filterAllKeys.count;
            } else {
                return _allKeys.count;
            }
            break;
        default:
            if (self.searchBar.text.length) {
                return _filterAllKeys.count + 1;
            } else {
                return _allKeys.count + 1;
            }
            break;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, DEVICE_WIDTH, 28.f)];
    headerView.backgroundColor = WLColoerRGB(248.f);
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    
    titleLabel.font = UIFontMake(12);
    titleLabel.textColor = UIColorMake(133,144,166);
    [headerView addSubview:titleLabel];
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            if (self.searchBar.text.length) {
                titleLabel.text = _filterAllKeys[section];
            } else {
                titleLabel.text = _allKeys[section];
            }
            break;
        default:
            if (self.searchBar.text.length) {
                if (section > 0) {
                    titleLabel.text = _filterAllKeys[section - 1];
                }
            } else {
                if (section > 0) {
                    titleLabel.text = _allKeys[section - 1];
                }
            }
            break;
    }
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.centerY.mas_equalTo(headerView);
    }];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            if (self.searchBar.text.length) {
                return [[_filterFriendDict objectForKey:_filterAllKeys[section]] count];
            } else {
                return [[_friendDict objectForKey:_allKeys[section]] count];
            }
            break;
        default: {
            if (self.searchBar.text.length) {
                if (section == 0) {
                    return _iconArray.count;
                }
                return [[_filterFriendDict objectForKey:_filterAllKeys[section - 1]] count];
            } else {
                if (section == 0) {
                    return _iconArray.count;
                }
                return [[_friendDict objectForKey:_allKeys[section - 1]] count];// _datasouce.count;
            }
        }
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend_list_cell"];
    if (!cell) {
        cell = [[BaseImageTableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:@"friend_list_cell"];
    }
    cell.showBottomLine = YES;
    cell.showBadge = NO;
//    if (!(_frindListType == FriendListTypeForGroupChat && _frindListType == FriendListTypeForGroupChatAddFriend)) {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            {
//                cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(30, 30) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
                IFriendModel *model = nil;
                if (self.searchBar.text.length) {
                    model = [[_filterFriendDict objectForKey:_filterAllKeys[indexPath.section]] objectAtIndex:indexPath.row];
//                    cell.textLabel.text = model.nickname;// @"小尹子";
                    cell.friendModel = model;
                    
                } else {
                    model = [[_friendDict objectForKey:_allKeys[indexPath.section]] objectAtIndex:indexPath.row];
                    cell.friendModel = model;
//                    cell.textLabel.text = model.nickname;// @"小尹子";
                }
                if (_frindListType == FriendListTypeForGroupChatAddFriend) {
                    BOOL selected = [_groupDetailInfo.member_list bk_any:^BOOL(id obj) {
                        return [[obj uid] integerValue] == model.uid.integerValue;
                    }];
                    if (selected) {
                        [cell setSelected:YES animated:YES];
                        cell.enabled = NO;
                    }else {
                        [cell setSelected:NO animated:YES];
                    }
                }
            }
            break;
        default:
        {
            if (indexPath.section == 0) {
                cell.imageView.image = [UIImage imageNamed:_iconArray[indexPath.row]];
                cell.textLabel.text = _iconTitleArray[indexPath.row];
                NSInteger count = [NSUserDefaults intForKey:@"kNewFriendRequest"];
                if (indexPath.row == 0) {
                    NSString *newCount = [NSString stringWithFormat:@"%ld",count];
                    if (count > 0) {
                        cell.showBadge = YES;
                        cell.detailTextLabel.text = newCount;
                        cell.detailTextLabel.font = UIFontMake(16.f);
//                        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
                        cell.detailTextLabel.textColor = [UIColor whiteColor];// UIColorMake(254.f, 72.f, 30.f);
//                        cell.detailTextLabel.backgroundColor = [UIColor redColor];
//                        cell.detailTextLabel.size = CGSizeMake(20, 20);
//                        [cell.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
//                        }];
                        [cell.detailTextLabel wl_setCornerRadius:10.f withImage:[UIImage imageWithColor:[UIColor redColor]]];
                    } else {
                        cell.showBadge = NO;
                        cell.detailTextLabel.text = @"";
                    }
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
//                cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(30, 30) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
                if (self.searchBar.text.length) {
                    IFriendModel *model = [[_filterFriendDict objectForKey:_filterAllKeys[indexPath.section - 1]] objectAtIndex:indexPath.row];
                    cell.friendModel = model;
//                    cell.textLabel.text = model.nickname;// @"小尹子";
//                    [cell.imageView setImageWithURL:[NSURL URLWithString:@"https://test.cnsunrun.com/saoleiapp/Uploads/Avatar/000/00/07/34_avatar_big.jpg?time=1538019638"]
//                                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
//                                            options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur|YYWebImageOptionIgnorePlaceHolder
//                                         completion:nil];
                } else {
                    IFriendModel *model = [[_friendDict objectForKey:_allKeys[indexPath.section - 1]] objectAtIndex:indexPath.row];
                    cell.friendModel = model;
//                    cell.textLabel.text = model.nickname;// @"小尹子";
//                    [cell.imageView setImageWithURL:[NSURL URLWithString:@"https://test.cnsunrun.com/saoleiapp/Uploads/Avatar/000/00/07/34_avatar_big.jpg?time=1538019638"]
//                                        placeholder:[UIImage imageNamed:@"game_friend_icon"]
//                                            options:YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur|YYWebImageOptionIgnorePlaceHolder
//                                         completion:nil];
                }
            }
        }
            break;
    }
    
    
    cell.textLabel.textColor = WLColoerRGB(51.f);
    cell.textLabel.font = UIFontMake(15.f);
    
    // reset
//    cell.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didSelectRowAtIndexPath------");
    [[self.view wl_findFirstResponder] resignFirstResponder];
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        {
            [self updateDataWithTableview:tableView];
        }
            break;
        case FriendListTypeForTransfer:
        {
            //转账
            IFriendModel *model = nil;
            if (self.searchBar.text.length) {
                 model = [[_filterFriendDict objectForKey:_filterAllKeys[indexPath.section]] objectAtIndex:indexPath.row];
            } else {
                model = [[_friendDict objectForKey:_allKeys[indexPath.section]] objectAtIndex:indexPath.row];
            }
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
                // 更新当前新好友数量
                [NSUserDefaults setInteger:0 forKey:@"kNewFriendRequest"];
                [kNSNotification postNotificationName:@"kNewFriendRequest" object:nil];
//                [self updateNewFriendBadge];
                return;
            }
            if (indexPath.section == 0 && indexPath.row == 1) {
                GroupListViewController *groupListVc = [[GroupListViewController alloc] init];
                [self.navigationController pushViewController:groupListVc animated:YES];
                return;
            }
            
            UserInfoViewController *userInfoVc = [[UserInfoViewController alloc] init];
            IFriendModel *model = nil;
            if (self.searchBar.text.length) {
                model = [[_filterFriendDict objectForKey:_filterAllKeys[indexPath.section - 1]] objectAtIndex:indexPath.row];
            } else {
                model = [[_friendDict objectForKey:_allKeys[indexPath.section - 1]] objectAtIndex:indexPath.row];
            }
            userInfoVc.userId = model.uid;
            [self.navigationController pushViewController:userInfoVc animated:YES];
        }
            break;
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (_frindListType) {
//        case FriendListTypeForGroupChatAddFriend:
//        case FriendListTypeForGroupChat:
//        {
//            IFriendModel *model = nil;
//            if (self.searchBar.text.length) {
//                model = [[_filterFriendDict objectForKey:_filterAllKeys[indexPath.section]] objectAtIndex:indexPath.row];
//            } else {
//                model = [[_friendDict objectForKey:_allKeys[indexPath.section]] objectAtIndex:indexPath.row];
//            }
//            if (_frindListType != FriendListTypeForTransfer) {
//                BOOL selected = [_groupDetailInfo.member_list bk_any:^BOOL(id obj) {
//                    return [[obj uid] integerValue] == model.uid.integerValue;
//                }];
//                return !selected;
//            } else {
//                return YES;
//            }
//        }
//            break;
//        default:
//        {
//            return NO;
//        }
//            break;
//    }
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updateDataWithTableview:tableView];
}

- (void)updateDataWithTableview:(UITableView *)tableView {
    NSArray *indexpaths = [tableView indexPathsForSelectedRows];
    NSMutableArray *selectedItems = [NSMutableArray new];
    self.selectChatArray = [NSMutableArray array];
    for (NSIndexPath *indexpath in indexpaths) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexpath];
        [selectedItems addObject:cell.textLabel.text];
        
        IFriendModel *model = nil;
        if (self.searchBar.text.length) {
            model = [[_filterFriendDict objectForKey:_filterAllKeys[indexpath.section]] objectAtIndex:indexpath.row];
        } else {
            model = [[_friendDict objectForKey:_allKeys[indexpath.section]] objectAtIndex:indexpath.row];
        }
        if (model) {
            [self.selectChatArray addObject:model];
        }
    }
    if (_selectChatArray.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:[NSString stringWithFormat:@"(%lu)确定", _selectChatArray.count] target:self action:@selector(rightBtnItemClicked)];
        self.navigationItem.rightBarButtonItem = _rightBtnItem;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.rightBtnItem = [UIBarButtonItem qmui_itemWithTitle:@"确定" target:self action:@selector(rightBtnItemClicked)];
        self.navigationItem.rightBarButtonItem = _rightBtnItem;
    }
    NSString *title = [selectedItems componentsJoinedByString:@"、"];
    self.groupName = title.length < 10 ? title : [title substringToIndex:10];
    DLog(@"选中的内日： %@", [selectedItems componentsJoinedByString:@";"]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    return kNoteHeight + kBannerHeight;
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        case FriendListTypeForGroupChat:
        case FriendListTypeForTransfer:
            return 28.f;
            break;
        default: {
            if (section == 0) {
                return 10.f;
            }
            return 28.f;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

#pragma mark - 搜索本地好友
///现在来实现当搜索文本改变时的回调函数。这个方法使用谓词进行比较，并讲匹配结果赋给searchResults数组:
- (void)filterContentForSearchText:(NSString*)searchText {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"nickname contains[cd] %@",searchText];
    NSMutableArray *filterArray = [NSMutableArray array];
    if (_datasouce.count > 0) {
        [filterArray addObjectsFromArray:[self.datasouce filteredArrayUsingPredicate:pre]];
    }
    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
    NSMutableArray *array;
    for (IFriendModel *model in filterArray) {
        BOOL hasKey = [friendDict bk_any:^BOOL(id key, id obj) {
            return [key isEqualToString:model.firstPinyin];
        }];
        if (!hasKey) {
            array = [NSMutableArray array];
            [array addObject:model];
            [friendDict setObject:array forKey:model.firstPinyin];
        } else {
            array = [friendDict objectForKey:model.firstPinyin];
            [array addObject:model];
            [friendDict setObject:array forKey:model.firstPinyin];
        }
    }
    self.filterAllKeys = [[friendDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 localizedCompare:obj2];
    }];
    self.filterFriendDict = friendDict;
    [self.tableView reloadData];
    [self.sectionIndexView reloadItemViews];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.filterAllKeys = [NSMutableArray array];
    [self.filterFriendDict removeAllObjects];
    [self filterContentForSearchText:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.filterArray removeAllObjects];
    [searchBar setText:nil];
//    [self updataFootView];
    [self.tableView reloadData];
}

#pragma mark - Private
- (void)leftBtnItemClicked {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    // 有使用配置表的时候，最简单的代码就只是控制显隐即可，没使用配置表的话，还需要设置其他的属性才能使红点样式正确，具体请看 UIBarButton+QMUIBadge.h 注释
    self.navigationItem.leftBarButtonItem.qmui_shouldShowUpdatesIndicator = NO;
    
    MessageNotifiListViewController *messageNotifiVc = [[MessageNotifiListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:messageNotifiVc animated:YES];
}

// 右侧按钮点击
- (void)rightBtnItemClicked {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    
    switch (_frindListType) {
        case FriendListTypeForGroupChatAddFriend:
        {
            if (_selectChatArray.count == 0) {
                return;
            }
            NSMutableArray *uids = [NSMutableArray array];
            for (IFriendModel *model in _selectChatArray) {
                [uids addObject:model.uid];
            }
            NSDictionary *params = @{
                                     @"id" : _groupDetailInfo.groupId,
                                     @"fuid" : uids
                                     };
            [WLHUDView showHUDWithStr:@"" dim:YES];
            WEAKSELF
            [ImGroupModelClient setImGroupJoinWithParams:params Success:^(id resultInfo) {
                [WLHUDView showSuccessHUD:@"添加成功"];
                // 聊天信息发送改变
                [kNSNotification postNotificationName:@"kChatUserInfoChanged" object:nil];
                [kNSNotification postNotificationName:@"kGroupInfoChanged" object:nil];
                [weakSelf.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
            } Failed:^(NSError *error) {
                [WLHUDView hiddenHud];
            }];
        }
            break;
        case FriendListTypeForGroupChat:
        {
            if (_selectChatArray.count == 0) {
                return;
            }
            NSMutableArray *uids = [NSMutableArray array];
            for (IFriendModel *model in _selectChatArray) {
                [uids addObject:model.uid];
            }
            NSDictionary *params = @{
                                     @"title" : _groupName,
                                     @"fuid" : uids
                                     };
            [WLHUDView showHUDWithStr:@"" dim:YES];
            WEAKSELF
            [ImGroupModelClient setImGroupAddWithParams:params Success:^(id resultInfo) {
                [WLHUDView showSuccessHUD:@"群聊创建成功"];
                NSString *groupId = resultInfo[@"id"];
                ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:groupId];
                chatVc.title = weakSelf.groupName;// @"5-10 赔率1.5倍  群组";
                [weakSelf.navigationController pushViewController:chatVc animated:YES];
            } Failed:^(NSError *error) {
                [WLHUDView hiddenHud];
            }];
        }
            break;
            
        default:
        {
             [self.popupByWindow showWithAnimated:YES];
        }
            break;
    }
//    ChatInfoViewController *vc = [[ChatInfoViewController alloc] init];
}

// 添加好友
- (void)searchFriendToAdd {
    SearchFriendViewController *vc = [[SearchFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 创建群组
- (void)createGroup {
    FriendListViewController *vc = [[FriendListViewController alloc] initWithFriendListType:FriendListTypeForGroupChat];
    [self.navigationController pushViewController:vc animated:YES];
}

// 下拉刷新
- (void)beginPullDownRefreshingNew {
    [[self.view wl_findFirstResponder] resignFirstResponder];
    [self loadData];
}




@end
