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

///引入地图功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <RongIMKit/RongIMKit.h>
#import "WLRongCloudDataSource.h"

#import "LoginModuleClient.h"
#import "ImModelClient.h"
#import "IRcToken.h"

#import "WLLocationManager.h"

#import "RCRedPacketMessage.h"
#import "RCRedPacketGetMessage.h"

#import <AlipaySDK/AlipaySDK.h>

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,BMKGeneralDelegate,JPUSHRegisterDelegate>

@property (nonatomic, strong) NavViewController *loginNav;
@property (nonatomic, strong) MainViewController *mainVc;

@end

@implementation AppDelegate
BMKMapManager* _mapManager;
single_implementation(AppDelegate);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [self setupUIStyle];
    [self initRongIM];
    
    [self jpushAPNs];
    [self initJpushInfo:launchOptions];
    
    [configTool initLoginUserInfo];
    [self setupNetworkingInfo];
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:loginVC];
//    self.window.rootViewController = nav;
    [self checkLoginStatus];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    return YES;
}

- (void)jpushAPNs {
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
}

// 处理极光推送的自定义消息内容
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    // 获取推送的内容
    NSString *content = [userInfo valueForKey:@"content"];
    // 获取推送的 messageID（
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
    // 获取用户自定义参数
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    // 根据自定义 key 获取自定义的 value
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的 Extras 附加字段，key 是自己定义的
    
}

- (void)initJpushInfo:(NSDictionary *)launchOptions {
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"bd96ffe71538380bdb293d6e"
                          channel:@"appstore"
                 apsForProduction:0 //0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。
            advertisingIdentifier:advertisingId];
}

// 注册 APNs 成功并上报 DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

// 实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// 添加处理 APNs 通知回调方法
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self setIconBadgeNumber];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self setIconBadgeNumber];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //添加聊天用户改变监听
    [kNSNotification postNotificationName:kWL_ChatMsgNumChangedNotification object:nil];
    [kNSNotification postNotificationName:@"kCheckVersion" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self setIconBadgeNumber];
}

// 设置所有未读数角标
- (void)setIconBadgeNumber {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger unreadMsgCount = 0;
        if (configTool.loginUser) {
            unreadMsgCount += [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
    });
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"sourceApplication:%@", url);
    if ([url.scheme isEqualToString:@"AlipayMineSweeper"]) {
        NSString *user_id = [self getAliPayUserId:url.absoluteString];
        NSLog(@"AliPay user_id:%@",url.query);
        if (user_id) {
            [kNSNotification postNotificationName:@"kAliPayUserId" object:user_id];
        }
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"openURL:%@",url);
//    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//         NSLog(@"result = %@",resultDic);
//    }];
    if ([url.scheme isEqualToString:@"AlipayMineSweeper"]) {
        // AlipayMineSweeper://safepay/?%7B%22memo%22:%7B%22result%22:%22success=true&result_code=200&app_id=2018063060556036&auth_code=5429bdde54b444ad9a78235a80edUX43&scope=kuaijie&alipay_open_id=20880084727651257014501641111643&user_id=2088802664730435&target_id=725%22,%22ResultStatus%22:%229000%22,%22memo%22:%22%22%7D,%22requestType%22:%22safepay%22%7D
        NSString *user_id = [self getAliPayUserId:url.absoluteString];
        if (user_id) {
            [kNSNotification postNotificationName:@"kAliPayUserId" object:user_id];
        }
        NSLog(@"AliPay user_id:%@",url.query);
//        NSRange range = [str1 rangeOfString:str2];
        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:[NSURL URLWithString:url.absoluteString] standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
    }
    return YES;
}

- (NSString *)getAliPayUserId:(NSString *)url {
    NSArray *resultArr = [url componentsSeparatedByString:@"&"];
    if (resultArr.count <6) {
        return nil;
    }
    NSString *userIdStr = resultArr[6];
    NSArray *userIdArrays = [userIdStr componentsSeparatedByString:@"="];
    NSString *user_id = userIdArrays[1];
    return user_id;
}

#pragma mark - RCIMConnectionStatusDelegate
/**
 *  网络状态变化。
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        /** 用户账户在其他设备登录，本机会被踢掉线。*/
        NSString *alertMessage = @"您的账号长时间未登录或在其他设备上登录";
        [self logoutWithErrormsg:alertMessage];
    }
    DLog(@"onRCIMConnectionStatusChanged -- : %ld",(long)status);
}

#pragma mark - RCIMReceiveMessageDelegate
/**
 接收消息到消息后执行。
 @param message 接收到的消息。
 @param left    剩余消息数.
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    //通知通知列表页面刷新数据
    dispatch_sync(dispatch_get_main_queue(), ^{
        //处理好友请求
        if ([message.content isMemberOfClass:[RCRedPacketMessage class]]) {
            // 红包消息
            
        }
        if ([message.content isMemberOfClass:[RCRedPacketGetMessage class]]) {
            // 红包被领域消息
            
        }
        if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
            // 好友请求消息
            
        }
        
//        if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
//            NSAssert(message.conversationType == ConversationType_SYSTEM, @"好友消息要发系统消息！！！");
//            RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
//            if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId .length ==0) {
//                return;
//            }
//            NSString *reqestType = [[_contactNotificationMsg.extra wl_jsonValueDecoded] objectForKey:@"type"];
////            if ([reqestType isEqualToString:@"friendAdd"]) {
////                // 别人同意添加我为好友，直接加入好友列表
////                NSDictionary *friendUserDict = [[_contactNotificationMsg.extra wl_jsonValueDecoded] objectForKey:@"data"];
////                WLUserModel *userModel = [WLUserModel modelWithDictionary:friendUserDict];
////                userModel.friendship = @(1);
////                // 异步保存用户信息
////                [[WLUserDataCenter sharedInstance] saveUserWithInfo:userModel isAsync:YES];
////            }else if ([reqestType isEqualToString:@"friendRequest"]) {
////                //保存新的好友的数量
////                [[WLSystemDataCenter sharedInstance] saveNewFriendCountWithInfo:1];
////            }
//        }else if ([message.content isMemberOfClass:[WLSystemPushMessage class]]){
//            //change by liuwu | 2015.11.16 | V2.6:添加通知消息类型
////            WLSystemPushMessage *sysPushMsg = (WLSystemPushMessage *)message.content;
////            if (sysPushMsg.type.integerValue == 17) {
////                // 读写数据库 请放到主线程
////                NSDictionary *extraDic = [sysPushMsg.wl_info wl_jsonValueDecoded];
////                NSInteger investorauthInt = [extraDic[@"investorauth"] integerValue];
////                NSString *authmsgStr = extraDic[@"authmsg"];// 认证失败会有 authmsg值
////                if (investorauthInt == -1){ // 认证失败
////                    [[WLUserDataCenter sharedInstance] updateLoginUserInvestorAuthMsgInfo:authmsgStr.length ? authmsgStr : @""];
////                }
////                [[WLUserDataCenter sharedInstance] updateLoginUserInvestorauthInfo:extraDic[@"investorauth"]];
////            }
//            //保存系统消息
//            WLPushMessageModel *model = [[WLSystemDataCenter sharedInstance] savePushMessageInfoWith:sysPushMsg rcmessageid:@(message.messageId)];
//            if (model) {
//                //通知通知列表页面刷新数据
//                [kNSNotification postNotificationName:@"PushInfoHasNewMsg" object:nil userInfo:@{@"pushMsgInfo": model}];
//            }
//        }else if ([message.content isMemberOfClass:[WLHiddenMessage class]]){
//            WLHiddenMessage *hiddenMsg = (WLHiddenMessage *)message.content;
//            [self addLocalNotification:hiddenMsg];
//        }else if ([message.content isMemberOfClass:[WLDynamicMessage class]]) {
//            [[WLMessageDataCenter sharedInstance] saveHomePushMessageWithInfo:[message.content modelToJSONObject] rcmessageid:@(message.messageId)];
//        } else if ([message.content isMemberOfClass:[RCCommandMessage class]]) {
//            NSDictionary *contentDic = [message.content modelToJSONObject];
//            if ([contentDic[@"name"] isEqualToString:KWL_BindWxGift]) {
//                NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[contentDic[@"data"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//                //绑定微信有礼
//                if (data && [data isKindOfClass:[NSDictionary class]]) {
//                    NSString *key = [KWL_BindWxGift stringByAppendingString:configTool.loginUser.uid.stringValue];
//                    [NSUserDefaults setObject:data forKey:key];
//                }
//            }
//        }
        if (left == 0) {
            [self setIconBadgeNumber];
            //添加聊天用户改变监听
            [kNSNotification postNotificationName:kWL_ChatMsgNumChangedNotification object:nil];
        }
    });
    DLog(@"onRCIMReceiveMessage ---- %d",left);
}

#pragma mark - 融云 关闭小灰条通知栏提示
/**
 *  当App处于后台时，接收到消息并弹出本地通知的回调方法
 *  收到消息Notifiction处理。用户可以自定义通知，不实现SDK会处理。
 *
 *  @param message    收到的消息实体。
 *  @param senderName 发送者的名字
 *
 *  @return 返回NO，SDK处理通知；返回YES，App自定义通知栏，SDK不再展现通知。
 
 @discussion 如果您设置了IMKit消息监听之后，当App处于后台，收到消息时弹出本地通知之前，会执行此方法。
 如果App没有实现此方法，SDK会弹出默认的本地通知提示。
 流程：
 SDK接收到消息 -> App处于后台状态 -> 通过用户/群组/群名片信息提供者获取消息的用户/群组/群名片信息
 -> 用户/群组信息为空 -> 不弹出本地通知
 -> 用户/群组信息存在 -> 回调此方法准备弹出本地通知 -> App实现并返回YES        -> SDK不再弹出此消息的本地通知
 -> App未实现此方法或者返回NO -> SDK弹出默认的本地通知提示
 
 */
- (BOOL)onRCIMCustomLocalNotification:(RCMessage*)message withSenderName:(NSString *)senderName {
    NSLog(@"onRCIMCustomLocalNotification %@",message);
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        return YES;
    }
    //特殊处理 friendAdd类型 不谈通知 否则会出现2个通知
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *msg = (RCContactNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:@"friendRequest"]) {
//            NSDictionary *friendUserDict = [[msg.extra wl_jsonValueDecoded] objectForKey:@"data"];
//            WLUserModel *userModel = [WLUserModel modelWithDictionary:friendUserDict];
//            [self addLocalNotificationWithAlertBody:[NSString stringWithFormat:@"%@：添加好友请求",userModel.name] userInfo:nil];
        }
        return YES;
    }
    
//    if ([message.content isMemberOfClass:[WLHiddenMessage class]]) {
//        return YES;
//    }
//    if ([message.content isMemberOfClass:[WLDynamicMessage class]]) {
//        return YES;
//    }
    return NO;
}
/**
 *  当App处于前台时，接收到消息并播放提示音的回调方法
 *  收到消息铃声处理。用户可以自定义新消息铃声，不实现SDK会处理。
 *
 *  @param message 收到的消息实体。
 *
 *  @return 返回NO，SDK处理铃声；返回YES，App自定义通知音，SDK不再播放铃音。
 
 @discussion 到消息时播放提示音之前，会执行此方法。
 如果App没有实现此方法，SDK会播放默认的提示音。
 流程：
 SDK接收到消息 -> App处于前台状态 -> 回调此方法准备播放提示音 -> App实现并返回YES        -> SDK针对此消息不再播放提示音
 -> App未实现此方法或者返回NO -> SDK会播放默认的提示音
 
 */
- (BOOL)onRCIMCustomAlertSound:(RCMessage*)message {
    return YES;
}



#pragma mark - Private
// 初始化融云信息
- (void)initRongIM {
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:[WLServiceInfo sharedServiceInfo].rongCloudAppKey];
    //状态监听
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    // 注册自定义消息
    // 注册自定义红包消息
    [[RCIM sharedRCIM] registerMessageType:[RCRedPacketMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCRedPacketGetMessage class]];
    
    //设置头像形状
    CGSize iconSize = CGSizeMake(36, 36);
    [RCIM sharedRCIM].globalConversationPortraitSize = iconSize;
    [RCIM sharedRCIM].globalMessagePortraitSize = iconSize;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = NO;
    //用于返回用户的信息
    // 设置用户信息提供者。
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    // 正在输入的状态提示
    [RCIM sharedRCIM].enableTypingStatus = YES;
    // 将用户信息和群组信息在本地持久化存储
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    // 开启消息@提醒功能
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor wl_hex0F6EF4];
    // 开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
}

/// 设置网络库相关信息
- (void)setupNetworkingInfo {
    WLNetWorkingProcessFilter *filter = [[WLNetWorkingProcessFilter alloc] init];
    [WLNetwokingConfig sharedInstance].processRule = filter;
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
    [UITextField appearance].tintColor = WLRGB(254.f, 72.f, 30.f);
//    [UITextField appearance].tintColor = WLColoerRGB(255.f);
}

// 检查登录Token已过期
- (void)checkTokenExpires {
    if (!configTool.loginUser) {
        return;
    }
    double minutes = [[configTool.loginUser.token.expires_time wl_dateFormartNormalString] minutesUntil];
    if (minutes < 10) {
        //小于半小时的，重新获取token
        NSDictionary *params = @{
                                 @"uid" : [NSNumber numberWithInteger:configTool.loginUser.uid.integerValue],
                                 @"password" : [NSUserDefaults stringForKey:[NSString stringWithFormat:@"%@%@", configTool.loginUser.uid, configTool.loginUser.mobile]],
                                 @"_password" : configTool.loginUser.password
                                 };
        WEAKSELF
        [LoginModuleClient getUserTokenWithParams:params Success:^(id resultInfo) {
            [configTool refreshLoginUserToken:resultInfo];
            [kNSNotification postNotificationName:@"kLoginUserTokenRefresh" object:nil];
            [weakSelf connectRCIM];
        } Failed:^(NSError *error) {
            [weakSelf checkTokenExpires];
//            [WLHUDView hiddenHud];
        }];
    }
}

// 检查登录的Token过期
- (void)checkRefreshToken {
    if (!configTool.loginUser.token.refresh_token) {
        return;
    }
    double minutes = [[configTool.loginUser.token.expires_time wl_dateFormartNormalString] minutesUntil];
    if (minutes < 0) {
        // 已过期，需要重新获取token
        [self checkTokenExpires];
        return;
    }
    WEAKSELF
    if (minutes < 30 && minutes > 0) {
        //小于半小时的，重新获取token
        [LoginModuleClient refreshTokenWithParams:@{@"refresh_token": configTool.loginUser.token.refresh_token} Success:^(id resultInfo) {
            [configTool refreshLoginUserToken:resultInfo];
        } Failed:^(NSError *error) {
            [weakSelf checkTokenExpires];
        }];
    }
}

// 检测登录状态
- (void)checkLoginStatus {
    if (![NSUserDefaults objectForKey:kWLLoginUserIdKey]) {
        [self logoutWithErrormsg:nil];
    } else {
        [self loginSucceed];
//        if (!_mainVc) {
//            double minutes = [[configTool.loginUser.token.expires_time wl_dateFormartNormalString] minutesUntil];
//            if (minutes < 10) {
//                WEAKSELF
//                //小于半小时的，重新获取token
//                NSDictionary *params = @{
//                                         @"uid" : [NSNumber numberWithInteger:configTool.loginUser.uid.integerValue],
//                                         @"password" : [NSUserDefaults stringForKey:[NSString stringWithFormat:@"%@%@", configTool.loginUser.uid, configTool.loginUser.mobile]],
//                                         @"_password" : configTool.loginUser.password
//                                         };
//                [LoginModuleClient getUserTokenWithParams:params Success:^(id resultInfo) {
//                    [configTool refreshLoginUserToken:resultInfo];
//                    [weakSelf loginSucceed];
//                } Failed:^(NSError *error) {
////                    [WLHUDView hiddenHud];
//                }];
//            } else {
//
//            }
//        }
    }
}

#pragma mark - 退出登录
- (void)logoutWithErrormsg:(NSString *)errormsg {
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
    // 关闭融云连接
//    [[RCIM sharedRCIM] clearUserInfoCache];
//    [[RCIM sharedRCIM] clearGroupInfoCache];
    [[RCIM sharedRCIM] disconnect:NO];
    
//    [LGAlertView removeAlertViews];
//    [self.window endEditing:YES];
    if (!_loginNav) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        self.loginNav = [[NavViewController alloc] initWithRootViewController:loginVC];
    }
    self.window.rootViewController = _loginNav;
}

#pragma mark - 登录成功
- (void)loginSucceed {
    
    [self connectRCIM];
    // 启动前，清下一下群组的缓存
    [[RCIM sharedRCIM] clearGroupInfoCache];
    
    if (!_mainVc) {
        self.mainVc = [[MainViewController alloc] init];
    }
    self.window.rootViewController = _mainVc;
    /// 上报定位
    [self getCityLocationInfo];
}

/// 上报定位
- (void)getCityLocationInfo {
    [[WLLocationManager locationManager] wl_startUpdatingLocationWithShowAlert:NO successBlock:^(BMKLocation *location) {
        //上传位置
        CLLocationCoordinate2D coord2D = location.location.coordinate;
        NSString *latitude = [NSString stringWithFormat:@"%f",coord2D.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",coord2D.longitude];
        DLog(@"-----上传经纬度成功");
    } faileBlock:^(NSError *error) {
        
    }];
    
    // 要使用百度地图，请先启动BaiduMapManager，需要获取百度appid
    _mapManager = [[BMKMapManager alloc]init];
    [_mapManager start:@"B6d899fe8925bc5cbb547eba6fc4ccca" generalDelegate:self];
}

/// 连接融云
- (void)connectRCIM {
    if (configTool.rcToken.token){
        [self connectRCIMWithToken:configTool.rcToken.token];
    } else {
        WEAKSELF
        [ImModelClient getImTokenWithParams:nil Success:^(id resultInfo) {
            IRcToken *token = [IRcToken modelWithDictionary:resultInfo];
            configTool.rcToken = token;
            [weakSelf connectRCIMWithToken:configTool.rcToken.token];
        } Failed:^(NSError *error) {
            
        }];
    }
    
//    if (!configTool.rcToken.token) return;
//    if (configTool.loginUser.uid.integerValue == 0) return;
    
    
//    if (_rcConnectCount > krcConnectCount) return;
//    _rcConnectCount++;
//    if (!configTool.loginUser) return;
//    NSString *token = @"";// configTool.loginUser.rongToken;
//    if (configTool.loginUser.uid.integerValue == 0) return;
//    if (token.length){
//        [self connectRCIMWithToken:token];
//    }else{ // token为空
//        if (!configTool.loginUser.name.length) return;  // 用户名为空，用户还未完善信息
//        [WLLoginModuleClient registerRongTokenSuccess:^(id resultInfo) {
//            if ([resultInfo isKindOfClass:[NSDictionary class]]) {
//                NSString *token = [resultInfo objectForKey:@"rong_token"];
//                if (token.length > 0) {
//                    configTool.loginUser.rongToken = token;
//                    // 保存token到本地数据库
//                    [[WLUserDataCenter sharedInstance] updateLoginUserInfoWithInfo:@{@"token":token}];
//                }
//            }
//            [self connectRCIM];
//        } Failed:^(NSError *error) {
//            [self connectRCIM];
//        }];
//    }
}

- (void)connectRCIMWithToken:(NSString *)token {
    WEAKSELF
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //保存默认用户
//        WLUserDetailInfoModel *loginUser = configTool.loginUser;
        RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:configTool.userInfoModel.nickname portrait:configTool.userInfoModel.avatar];
        [[RCIM sharedRCIM] setCurrentUserInfo:nil];
//        self->_rcConnectCount = 0;
        //添加聊天用户改变监听
        [kNSNotification postNotificationName:kWL_ChatMsgNumChangedNotification object:nil];
        DLog(@"++++++++++++++++++++++++++++++++++++++++++++++链接融云服务器成功++++++++++++++++++++++++++++++++++++");
    } error:^(RCConnectErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"融云连接错误===%ld",(long)status);
            [[RCIM sharedRCIM] disconnect:NO];
            configTool.rcToken.token = nil;
            [weakSelf checkTokenExpires];
        });
    } tokenIncorrect:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"融云token错误或者过期。需要重新换取token");
            [[RCIM sharedRCIM] disconnect:NO];
            configTool.rcToken.token = nil;
            [weakSelf checkTokenExpires];
//            configTool.loginUser.rongToken = @"";
//            WEAKSELF
//            [ImModelClient getImTokenWithParams:nil Success:^(id resultInfo) {
//                IRcToken *token = [IRcToken modelWithDictionary:resultInfo];
//                configTool.rcToken = token;
//                [weakSelf connectRCIMWithToken:configTool.rcToken.token];
////                 [weakSelf connectRCIM];
//            } Failed:^(NSError *error) {
//
//            }];
        });
    }];
}


@end
