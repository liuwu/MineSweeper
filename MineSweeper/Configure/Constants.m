//
//  Constants.m
//  Welian
//
//  Created by weLian on 15/4/14.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//



#pragma mark - Private Info
//------------常用的常量定义------------------
CGFloat const kWL_safeAreaHeight    = 34.f;

/// 微博工具条的高度
CGFloat const kWL_NromalToolbarHeight       = 44.f;
CGFloat const KWL_NewToobarHeight           = 22.f;
///每次页面请求的数据个数
NSInteger const kWL_NormalPageSize          = 15;
///常用TabBar高度
CGFloat const kWL_NromalTabbarHeight        = 49.0f;
///常用的NavBar高度
CGFloat const kWL_NormalNavBarHeight        = 44.f;
///常用的UITextField高度
CGFloat const kWL_NormalTextFieldHeight     = 44.f;

///常用的UIButton高度
CGFloat const kWL_NormalButtonHeight     = 44.f;

//------------ TableView 相关-------------------
///常规的Tableview的header高度
CGFloat const kWL_TableNormalHeaderHeight   = 12.f;
///常用的table的Cell高度
CGFloat const kWL_TableNormalCellHeight     = 52.f;


//------------ Margin Width 间距 ----------------
///常用的间距25.f
CGFloat const kWL_NormalMarginWidth_25      = 25.f;
///常用的间距15.f
CGFloat const kWL_NormalMarginWidth_10      = 10.f;
CGFloat const kWL_NormalMarginWidth_15      = 15.f;
CGFloat const kWL_NormalMarginWidth_14      = 14.f;
CGFloat const kWL_NormalMarginWidth_16      = 16.f;
CGFloat const kWL_NormalMarginWidth_17      = 17.f;
CGFloat const kWL_NormalMarginWidth_20      = 20.f;
CGFloat const kWL_NormalMarginWidth_23      = 23.f;
///常用的间距10.f
CGFloat const kWL_NormalMarginWidth_11      = 11.f;
CGFloat const kWL_NormalMarginWidth_12      = 12.f;


//------------ 图片相关 ----------------
/// 头像图片的尺寸
CGFloat const kWL_NormalIconSmallWidth      = 30.f;


#pragma mark 本地存储时用到的key
// 登录用户手机号
NSString *const kWLLastLoginUserPhoneKey = @"kWLLastLoginUserPhoneKey";
// 登录用户ID
NSString *const kWLLoginUserIdKey  = @"kWLLoginUserIdKey";
// 登录用户信息
NSString *const kWLLoginUserInfoKey  = @"kWLLoginUserInfoKey";
///定位的城市
NSString *const kWL_LocationCityKey                         = @"LocationCityKey";

#pragma mark - NSNotification Key
// 用户退出登录
NSString *const kWLUserLogoutNotification                       = @"kGuiUserLogoutNotification";
// 用户登录成功
NSString *const kWLUserLoginNotification                       = @"kGuiUserLoginNotification";
///同意好友请求
NSString *const kWL_AccepteFriendRequestNotification            = @"Accepte%@";
///我的好友更新通知
NSString *const kWL_UpdateAllMyFriendsNotification              = @"KupdataMyAllFriends";
///重新获取共同好友
NSString *const kWL_ReloadSameFriendNotification                = @"ReloadSameFriend";
///手机号更换成功的通知
NSString *const KWL_PhoneUpdatedNoti = @"LoginUserPhoneChangedSuccess";

//----------聊天
///聊天消息数量改变
NSString *const kWL_ChatMsgNumChangedNotification               = @"ChatMsgNumChanged";
///改变下方的tab到消息页面
NSString *const kWL_ChangeTapToChatList                         = @"ChangeTapToChatList";
///改变下方的tab到发现页面
NSString *const kWL_ChangeTapToFindVCNotification               = @"ChangeTapToFindListVC";
///更新群主聊天消息信息
NSString *const kWL_UpdateGroupChatInfoNotification             = @"UpdateGroupChatInfo";


NSString *const KWL_ZY_HideNotification = @"KWL_ZY_HideNotification";

//********************************** 阿里云服务 *************************//
NSString * const kWL_ossAccessId = @"";
NSString * const kWL_ossAccessKey = @"";
NSString * const kWL_ossEndpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
// 图片路径
NSString * const kWL_ossBucket = @"";
NSString * const kWL_ossBucketTest = @"";
// 文件路径
NSString * const kWL_ossFileBucket = @"";
NSString * const kWL_ossFileBucketTest = @"";








