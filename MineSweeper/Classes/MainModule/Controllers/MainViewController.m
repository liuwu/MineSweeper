//
//  MainViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/11.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "MainViewController.h"
#import "NavViewController.h"
#import "HomeViewController.h"
#import "ChatListViewController.h"
#import "FriendListViewController.h"
#import "MeViewController.h"

@interface WLTabar : UITabBar


@end

@implementation WLTabar {
    UIEdgeInsets _oldSafeAreaInsets;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _oldSafeAreaInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _oldSafeAreaInsets = UIEdgeInsetsZero;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    if (!UIEdgeInsetsEqualToEdgeInsets(_oldSafeAreaInsets, self.safeAreaInsets)) {
        [self invalidateIntrinsicContentSize];
        if (self.superview) {
            [self.superview setNeedsLayout];
            [self.superview layoutSubviews];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    if (@available(iOS 11.0, *)) {
        float bottomInset = self.safeAreaInsets.bottom;
        if (bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90)) {
            size.height += bottomInset;
        }
    }
    return size;
}

- (void)setFrame:(CGRect)frame {
    if (self.superview) {
        if (frame.origin.y + frame.size.height != self.superview.frame.size.height) {
            frame.origin.y = self.superview.frame.size.height - frame.size.height;
        }
    }
    [super setFrame:frame];
}

@end

@interface MainViewController ()<UINavigationControllerDelegate,UITabBarControllerDelegate>

@property (weak,nonatomic) UITabBarItem *normalItem;

@property (weak,nonatomic) UITabBarItem *homeItem;
@property (weak,nonatomic) UITabBarItem *chatItem;
@property (weak,nonatomic) UITabBarItem *FriendItem;
@property (weak,nonatomic) UITabBarItem *meItem;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WLColoerRGB(255.f)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:WLColoerRGB(255.f)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    // 设置ui相关信息
    [self setupUIInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置ui相关信息
- (void)setupUIInfo {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self.tabBar.layer setLayerShadow:WLRGBA(60, 60, 60, 0.1) offset:CGSizeMake(0, -1.f) radius:3];
    if (iPhoneX) {
        WLTabar *baseTabBar = [[WLTabar alloc] init];
        baseTabBar.backgroundColor = [UIColor whiteColor];
        [baseTabBar.layer setLayerShadow:WLRGBA(60, 60, 60, 0.1) offset:CGSizeMake(0, -1.f) radius:3];
        [self setValue:baseTabBar forKey:@"tabBar"];
    }
}

#pragma mark – Private methods
/// 设置页面UI
- (void)setupMainUI{
    NavViewController *homeNav = [self tabBarChildController:[HomeViewController class] title:@"首页" imageName:@"common_addressBook_icon"];
    NavViewController *chatNav = [self tabBarChildController:[ChatListViewController class] title:@"消息" imageName:@"common_chat_icon_normal"];
    NavViewController *friendItem = [self tabBarChildController:[FriendListViewController class] title:@"通讯录" imageName:@"common_group_icon_normal"];
    NavViewController *meNav = [self tabBarChildController:[MeViewController class] title:@"我的" imageName:@"common_mine_icon_normal"];
    
    self.viewControllers = @[homeNav,chatNav,friendItem,meNav];
    self.chatItem = chatNav.tabBarItem;
    self.homeItem = homeNav.tabBarItem;
    self.meItem = meNav.tabBarItem;
    self.FriendItem = friendItem.tabBarItem;
    
    self.normalItem = self.homeItem;
    self.selectedIndex = 0;
    /// 耗时：10.859000
    [self updataItembadge];
//    if (![NSUserDefaults boolForKey:MeTtemRedDotKey] && configTool.loginUser.isLogin) {
//        [self.tabBar showBadgeOnItemIndex:3 itemNums:4];
//    }
}

#pragma mark – Event response
// 根据更新信息设置 提示角标
- (void)updataItembadge {
//    WLUserDetailInfoModel *userM = configTool.loginUser;
//    if (!userM) {
//        _chatMessageItem.badgeValue = nil;
//        _meItem.badgeValue = nil;
//        return;
//    }
    
    NSInteger messageCount = 0;
//    if (userM.investorauth.integerValue == 1) {
//        messageCount += [[WLChatListDataCenter sharedInstance] getChatUnreadMessageCountWithTargetId:ProjectInboxTargetID];
//    }else {
//        messageCount += [[WLChatListDataCenter sharedInstance] getChatUnreadMessageCountWithTargetId:ProjectFeedBackTargetID];
//    }
    _chatItem.badgeValue = messageCount>0?[NSString stringWithFormat:@"%lu",(unsigned long)messageCount]:nil;
}

//所有的属性都使用getter和setter
#pragma mark – Getters and Setters
- (NavViewController *)tabBarChildController:(Class)controllerClass title:(NSString *)title imageName:(NSString *)imageName {
    UIViewController *controller = [[controllerClass alloc] init];
    NavViewController *navController = [[NavViewController alloc] initWithRootViewController:controller];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage wl_imageNameAlwaysOriginal:imageName] selectedImage:[UIImage wl_imageNameAlwaysOriginal:[imageName stringByAppendingString:@"_active"]]];
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :WLRGB(254.f, 72.f, 30.f),NSFontAttributeName:WLFONT(10)} forState:UIControlStateSelected];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor wl_HexBDBDBD],NSFontAttributeName:WLFONT(10)} forState:UIControlStateNormal];
    
    navController.tabBarItem = tabBarItem;
    return navController;
}

#pragma mark – UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    if (_normalItem == _findItem && item == _findItem) {
//        NavViewController *homeNav = self.viewControllers[1];
//        WLHomePageController *homeVC = homeNav.viewControllers[0];
//        [homeVC tableviewbeginRefreshing];
//    }
//    if (item == _meItem && ![NSUserDefaults boolForKey:MeTtemRedDotKey] && configTool.loginUser.isLogin) {
//        [NSUserDefaults setBool:YES forKey:MeTtemRedDotKey];
//        [self.tabBar hideBadgeOnItemIndex:3];
//    }
    _normalItem = item;
}

#pragma mark – UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (_normalItem == _homeItem) {
        return YES;
    }else {
//        return [WLAccessControlPresenter perfectLoginAndInformation:^BOOL(BOOL haveLoginUser) {
//            return YES;
//        } haveJWT:^BOOL(BOOL needBandPhone, BOOL needComplete) {
//            return YES;
//        }];
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

@end