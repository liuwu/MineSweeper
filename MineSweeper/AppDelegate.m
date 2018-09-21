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

#import <RongIMKit/RongIMKit.h>
#import "WLRongCloudDataSource.h"

@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>

@end

@implementation AppDelegate
single_implementation(AppDelegate);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [self setupNetworkingInfo];
    [self setupUIStyle];
    [self initRongIM];
    
    
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    return YES;
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
//        if (left == 0) {
//            //添加聊天用户改变监听
//            [kNSNotification postNotificationName:kWL_ChatMsgNumChangedNotification object:nil];
//        }
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
            NSDictionary *friendUserDict = [[msg.extra wl_jsonValueDecoded] objectForKey:@"data"];
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
    //    [[RCIM sharedRCIM] registerMessageType:[CustomCardMessage class]];
    //    [[RCIM sharedRCIM] registerMessageType:[WLSystemPushMessage class]];
    //    [[RCIM sharedRCIM] registerMessageType:[WLCardListMessage class]];
    //    [[RCIM sharedRCIM] registerMessageType:[WLHiddenMessage class]];
    //    [[RCIM sharedRCIM] registerMessageType:[WLFriendRequestMessage class]];
    //    [[RCIM sharedRCIM] registerMessageType:[WLPayRemindMessage class]];
    //    [[RCIM sharedRCIM] registerMessageType:[WLDynamicMessage class]];
    
    //设置头像形状
    CGSize iconSize = CGSizeMake(45, 45);
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

/// 连接融云
- (void)connectRCIM {
//    if (_rcConnectCount > krcConnectCount) return;
//    _rcConnectCount++;
//    if (!configTool.loginUser) return;
    NSString *token = @"";// configTool.loginUser.rongToken;
//    if (configTool.loginUser.uid.integerValue == 0) return;
    if (token.length){
        [self connectRCIMWithToken:token];
    }else{ // token为空
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
    }
}

- (void)connectRCIMWithToken:(NSString *)token {
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //保存默认用户
//        WLUserDetailInfoModel *loginUser = configTool.loginUser;
//        RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:loginUser.name portrait:loginUser.avatar];
//        [[RCIM sharedRCIM] setCurrentUserInfo:_currentUserInfo];
//        self->_rcConnectCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:kWL_ChatMsgNumChangedNotification object:nil];
        DLog(@"++++++++++++++++++++++++++++++++++++++++++++++链接融云服务器成功++++++++++++++++++++++++++++++++++++");
    } error:^(RCConnectErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"融云连接错误===%ld",(long)status);
        });
    } tokenIncorrect:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"融云token错误或者过期。需要重新换取token");
            [[RCIM sharedRCIM] disconnect:NO];
//            configTool.loginUser.rongToken = @"";
            [self connectRCIM];
        });
    }];
}


@end
