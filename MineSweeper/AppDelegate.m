//
//  AppDelegate.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/10.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NavViewController.h"
#import "MainViewController.h"
#import "QMUIConfigurationTemplate.h"
#import "QDCommonUI.h"
#import "QDUIHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
single_implementation(AppDelegate);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [self setupNetworkingInfo];
    [self setupUIStyle];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    return YES;
}

/// 设置网络库相关信息
- (void)setupNetworkingInfo {
    WLNetWorkingProcessFilter *filter = [[WLNetWorkingProcessFilter alloc] init];
    [WLNetwokingConfig sharedInstance].processRule = filter;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/// 统一设置UI样式
- (void)setupUIStyle {
    
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];
    // 预加载 QQ 表情，避免第一次使用时卡顿
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [QDUIHelper qmuiEmotions];
    });
    
    // 启动QMUI的配置模板
//    [QMUIConfigurationTemplate setupConfigurationTemplate];
    // 将全局的控件样式渲染出来
//    [QMUIConfigurationManager renderGlobalAppearances];
    
    // 设置BarButtonItem
//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class], [UINavigationBar class]]] setTitleTextAttributes:@{NSFontAttributeName:WLFONT(14), NSForegroundColorAttributeName:WLColoerRGB(51.f)} forState:UIControlStateNormal];
    // navBar设置
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:WLFONT(18), NSForegroundColorAttributeName:WLColoerRGB(51.f)}];
    
    //设置整个项目的item状态
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:WLFONT(14), NSForegroundColorAttributeName: WLColoerRGB(51.f)} forState:UIControlStateNormal];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:WLFONT(14), NSForegroundColorAttributeName: WLColoerRGB(51.f)} forState:UIControlStateHighlighted];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:WLFONT(14), NSForegroundColorAttributeName: WLColoerRGB(51.f)} forState:UIControlStateSelected];
    
    [UITextField appearance].tintColor = WLColoerRGB(255.f);
}

#pragma mark - 退出登录
- (void)logoutWithErrormsg:(NSString *)errormsg {
    [LGAlertView removeAlertViews];
    [self.window endEditing:YES];
    
}

#pragma mark - 登录成功
- (void)loginSucceed {
    MainViewController *mainVc = [[MainViewController alloc] init];
    self.window.rootViewController = mainVc;
    
//    [WLSystemManager init3DTouchActionShow:YES];
//    // 初始化登录用户信息
//    [self initLoginUserInfo];
//    // 获取所有好友
//    [self loadMyAllFriends];
//    // 注册APNS
//    [self registerRemoteNotification];
//    [self connectRCIM];
//    [self setQYUserInfo];
//    // 上报设备信息
//    [WLLoginModuleClient updateclientID];
//    // 从本地数据 读取自定义消息
//    [[WLChatProjectManager sharedInstance] initDataBaseComplete];
//    /// 上报定位
//    [self getCityLocationInfo];
//    [self getV5AccountJWTWithSessionId];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kWLUserLoginNotification object:nil];
}


@end
