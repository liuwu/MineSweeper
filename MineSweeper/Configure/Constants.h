//
//  Constants.h
//  Welian
//
//  Created by weLian on 15/4/14.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

/*
 第一种，使用 #define 预处理定义常量。例如：
 
 #define ANIMATION_DURATION    0.3
 
 定义一个 ANIMATION_DURATION 常量来表示 UI 动画的一个常量时间，
 这样，代码中所有使用 ANIMATION_DURATION 的地方都会被替换成 0.3，
 但是这样定义的常量无类型信息，且如果你在调试时想要查看 ANIMATION_DURATION 的值却无从下手，
 因为在预处理阶段ANIMATION_DURATION 就已经被替换了，不便于调试。因此，弃用这种方式定义常量。
 
 定义和用法说明
 static  例如：static NSString *const k3DTochScan      = @"Scan";
 // static变量属于本类，不同的类对应的是不同的对象
 // static变量同一个类所有对象中共享，只初始化一次
 const
 // static const变量同static的结论I，只是不能修改了，但是还是不同的对象
 // extern const变量只有一个对象，标准的常量的定义方法
 // extern的意思就是这个变量已经定义了，你只负责用就行了
 
 static与const组合：在每个文件都需要定义一份静态全局变量。
 extern与const组合:只需要定义一份全局变量，多个文件共享。
 */

#pragma mark - Private Info
//------------第三方key定义------------------
/// iPhone X
extern CGFloat const kWL_safeAreaHeight;

/// 微博工具条的高度
extern CGFloat const kWL_NromalToolbarHeight;
extern CGFloat const KWL_NewToobarHeight;
///每次页面请求的数据个数
extern NSInteger const kWL_NormalPageSize;
///常用TabBar高度
extern CGFloat const kWL_NromalTabbarHeight;
///常用的NavBar高度
extern CGFloat const kWL_NormalNavBarHeight;
///常用的UITextField高度
extern CGFloat const kWL_NormalTextFieldHeight;


//------------ TableView 相关-------------------
///常用的tableviewheader高度 15.f
extern CGFloat const kWL_TableNormalHeaderHeight;
///常用的table的Cell高度
extern CGFloat const kWL_TableNormalCellHeight;


//------------ Margin Width 间距 ----------------
///常用的间距25.f
extern CGFloat const kWL_NormalMarginWidth_25;
///常用的间距15.f
extern CGFloat const kWL_NormalMarginWidth_15;
extern CGFloat const kWL_NormalMarginWidth_16;
///常用的间距10.f
extern CGFloat const kWL_NormalMarginWidth_12;


//------------ 图片相关 ----------------
/// 头像图片的尺寸
extern CGFloat const kWL_NormalIconSmallWidth;

#pragma mark 本地存储时用到的key

#pragma mark - NSNotification Key
// 用户退出登录 通知
UIKIT_EXTERN NSString *const kWLUserLogoutNotification;
// 用户登录成功
extern NSString *const kWLUserLoginNotification;
///同意好友请求
extern NSString *const kWL_AccepteFriendRequestNotification;
///我的好友更新通知
extern NSString *const kWL_UpdateAllMyFriendsNotification;
///重新获取共同好友
extern NSString *const kWL_ReloadSameFriendNotification;
///手机号更换成功的通知
extern NSString *const KWL_PhoneUpdatedNoti;

//----------聊天
///聊天消息数量改变
extern NSString *const kWL_ChatMsgNumChangedNotification;
//改变下方的tab到消息页面
extern NSString *const kWL_ChangeTapToChatList;
///改变下方的tab到发现页面
extern NSString *const kWL_ChangeTapToFindVCNotification;
///更新群主聊天消息信息
extern NSString *const kWL_UpdateGroupChatInfoNotification;



// ZY_HideNotification
extern NSString *const KWL_ZY_HideNotification;




//********************************** 阿里云服务 *************************//
extern NSString * const kWL_ossAccessId;
extern NSString * const kWL_ossAccessKey;
extern NSString * const kWL_ossEndpoint;
// 图片路径
extern NSString * const kWL_ossBucket;
extern NSString * const kWL_ossBucketTest;
// 文件路径
extern NSString * const kWL_ossFileBucket;
extern NSString * const kWL_ossFileBucketTest;









